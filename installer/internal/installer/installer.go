package installer

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"time"

	"dotfiles-installer/internal/config"
)

type Status string

const (
	StatusPending  Status = "pending"
	StatusSuccess  Status = "success"
	StatusSkipped  Status = "skipped"
	StatusFailed   Status = "failed"
	StatusRunning  Status = "running"
)

type Result struct {
	ID        string
	Name      string
	Type      string // "symlink" or "package"
	Status    Status
	Message   string
	BackupPath string
}

type InstallerOptions struct {
	DotfilesDir string
	HomeDir     string
	Backup      bool
	DryRun      bool
	OnLog       func(Result)
}

type Installer struct {
	opts InstallerOptions
}

func NewInstaller(opts InstallerOptions) *Installer {
	return &Installer{opts: opts}
}

func (inst *Installer) InstallSymlink(item config.SymlinkItem) Result {
	res := Result{
		ID:     item.ID,
		Name:   item.Name,
		Type:   "symlink",
		Status: StatusPending,
	}

	absSource := filepath.Join(inst.opts.DotfilesDir, item.SourceRel)
	absTarget := filepath.Join(inst.opts.HomeDir, item.TargetRel)

	// Check if source exists
	if _, err := os.Stat(absSource); os.IsNotExist(err) {
		res.Status = StatusFailed
		res.Message = fmt.Sprintf("Source path does not exist: %s", absSource)
		if inst.opts.OnLog != nil {
			inst.opts.OnLog(res)
		}
		return res
	}

	// Check if target exists
	targetInfo, err := os.Lstat(absTarget)
	if err == nil {
		// Target exists
		if targetInfo.Mode()&os.ModeSymlink != 0 {
			// Is symlink
			linkDest, err := os.Readlink(absTarget)
			if err == nil && linkDest == absSource {
				res.Status = StatusSkipped
				res.Message = fmt.Sprintf("Already correctly symlinked (%s)", item.TargetRel)
				if inst.opts.OnLog != nil {
					inst.opts.OnLog(res)
				}
				return res
			}
		}

		// Target exists but is not correct link
		if inst.opts.Backup {
			timestamp := time.Now().Format("20060102_150405")
			backupPath := fmt.Sprintf("%s.bak_%s", absTarget, timestamp)
			if !inst.opts.DryRun {
				if err := os.Rename(absTarget, backupPath); err != nil {
					res.Status = StatusFailed
					res.Message = fmt.Sprintf("Failed to backup existing target: %v", err)
					if inst.opts.OnLog != nil {
						inst.opts.OnLog(res)
					}
					return res
				}
			}
			res.BackupPath = backupPath
		} else {
			if !inst.opts.DryRun {
				if err := os.RemoveAll(absTarget); err != nil {
					res.Status = StatusFailed
					res.Message = fmt.Sprintf("Failed to remove existing target: %v", err)
					if inst.opts.OnLog != nil {
						inst.opts.OnLog(res)
					}
					return res
				}
			}
		}
	}

	if inst.opts.DryRun {
		res.Status = StatusSuccess
		res.Message = fmt.Sprintf("[DRY-RUN] Would link %s -> %s", absSource, absTarget)
		if inst.opts.OnLog != nil {
			inst.opts.OnLog(res)
		}
		return res
	}

	// Ensure parent directory exists
	parentDir := filepath.Dir(absTarget)
	if err := os.MkdirAll(parentDir, 0755); err != nil {
		res.Status = StatusFailed
		res.Message = fmt.Sprintf("Failed to create parent directory: %v", err)
		if inst.opts.OnLog != nil {
			inst.opts.OnLog(res)
		}
		return res
	}

	// Create symlink
	if err := os.Symlink(absSource, absTarget); err != nil {
		res.Status = StatusFailed
		res.Message = fmt.Sprintf("Symlink creation failed: %v", err)
		if inst.opts.OnLog != nil {
			inst.opts.OnLog(res)
		}
		return res
	}

	res.Status = StatusSuccess
	if res.BackupPath != "" {
		res.Message = fmt.Sprintf("Symlink created (Backed up old target to %s)", filepath.Base(res.BackupPath))
	} else {
		res.Message = fmt.Sprintf("Symlink created (~/%s -> %s)", item.TargetRel, item.SourceRel)
	}

	if inst.opts.OnLog != nil {
		inst.opts.OnLog(res)
	}
	return res
}

func (inst *Installer) InstallPackage(pkg config.PackageItem, aptUpdated *bool) Result {
	res := Result{
		ID:     pkg.ID,
		Name:   pkg.Name,
		Type:   "package",
		Status: StatusPending,
	}

	// Check if already installed via binary check
	if pkg.BinaryCheck != "" && IsBinaryInstalled(pkg.BinaryCheck) {
		res.Status = StatusSkipped
		res.Message = fmt.Sprintf("Package '%s' already installed (%s)", pkg.Name, pkg.BinaryCheck)
		if inst.opts.OnLog != nil {
			inst.opts.OnLog(res)
		}
		return res
	}

	if inst.opts.DryRun {
		res.Status = StatusSuccess
		res.Message = fmt.Sprintf("[DRY-RUN] Would install package '%s'", pkg.Name)
		if inst.opts.OnLog != nil {
			inst.opts.OnLog(res)
		}
		return res
	}

	// Try Apt installation if available
	_, errApt := exec.LookPath("apt-get")
	if errApt == nil && len(pkg.AptPackages) > 0 {
		if aptUpdated != nil && !*aptUpdated {
			// Run apt-get update once
			updateCmd := exec.Command("sudo", "apt-get", "update", "-qq")
			_ = updateCmd.Run()
			*aptUpdated = true
		}

		args := append([]string{"apt-get", "install", "-y", "-qq"}, pkg.AptPackages...)
		cmd := exec.Command("sudo", args...)
		_, err := cmd.CombinedOutput()
		if err == nil {
			res.Status = StatusSuccess
			res.Message = fmt.Sprintf("Installed via apt (%s)", strings.Join(pkg.AptPackages, ", "))
			if inst.opts.OnLog != nil {
				inst.opts.OnLog(res)
			}
			return res
		}
	}

	// Fallback to install script if present
	if pkg.InstallScript != "" {
		cmd := exec.Command("sh", "-c", pkg.InstallScript)
		out, err := cmd.CombinedOutput()
		if err == nil {
			res.Status = StatusSuccess
			res.Message = fmt.Sprintf("Installed via script")
			if inst.opts.OnLog != nil {
				inst.opts.OnLog(res)
			}
			return res
		} else {
			res.Status = StatusFailed
			res.Message = fmt.Sprintf("Install script failed: %s", strings.TrimSpace(string(out)))
			if inst.opts.OnLog != nil {
				inst.opts.OnLog(res)
			}
			return res
		}
	}

	res.Status = StatusFailed
	res.Message = fmt.Sprintf("Could not install '%s' (no suitable package manager or script)", pkg.Name)
	if inst.opts.OnLog != nil {
		inst.opts.OnLog(res)
	}
	return res
}
