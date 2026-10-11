package installer

import (
	"fmt"
	"os"
	"path/filepath"
	"time"

	"dotfiles-installer/internal/config"
)

type SymlinkOptions struct {
	DotfilesDir string
	HomeDir     string
	Backup      bool
	DryRun      bool
	Verbose     bool
}

type SymlinkSummary struct {
	Total   int
	Linked  int
	Skipped int
	BackedUp int
	Failed  int
	Errors  []string
}

// LinkAll sets up all defined symlinks idempotently
func LinkAll(opts SymlinkOptions) SymlinkSummary {
	items := config.GetDefaultSymlinks()
	var summary SymlinkSummary
	summary.Total = len(items)

	for _, item := range items {
		absSource := filepath.Join(opts.DotfilesDir, item.SourceRel)
		absTarget := filepath.Join(opts.HomeDir, item.TargetRel)

		// Check if source exists in dotfiles repo
		if _, err := os.Stat(absSource); os.IsNotExist(err) {
			summary.Failed++
			summary.Errors = append(summary.Errors, fmt.Sprintf("%s: source not found (%s)", item.Name, absSource))
			continue
		}

		// Ensure parent directory of target exists
		parentDir := filepath.Dir(absTarget)
		if !opts.DryRun {
			if err := os.MkdirAll(parentDir, 0755); err != nil {
				summary.Failed++
				summary.Errors = append(summary.Errors, fmt.Sprintf("%s: failed to create dir %s: %v", item.Name, parentDir, err))
				continue
			}
		}

		// Check if target exists or is a symlink
		targetInfo, err := os.Lstat(absTarget)
		if err == nil {
			// If it's already a symlink pointing to our source, skip it
			if targetInfo.Mode()&os.ModeSymlink != 0 {
				linkDest, err := os.Readlink(absTarget)
				if err == nil && linkDest == absSource {
					summary.Skipped++
					continue
				}
			}

			// Exists and is not correct symlink: backup if enabled
			if opts.Backup {
				timestamp := time.Now().Format("20060102_150405")
				backupPath := fmt.Sprintf("%s.bak_%s", absTarget, timestamp)
				if !opts.DryRun {
					if err := os.Rename(absTarget, backupPath); err != nil {
						summary.Failed++
						summary.Errors = append(summary.Errors, fmt.Sprintf("%s: failed to backup %s: %v", item.Name, absTarget, err))
						continue
					}
				}
				summary.BackedUp++
			} else {
				// Remove old target without backup
				if !opts.DryRun {
					if err := os.RemoveAll(absTarget); err != nil {
						summary.Failed++
						summary.Errors = append(summary.Errors, fmt.Sprintf("%s: failed to remove old target %s: %v", item.Name, absTarget, err))
						continue
					}
				}
			}
		}

		// Create symlink
		if !opts.DryRun {
			if err := os.Symlink(absSource, absTarget); err != nil {
				summary.Failed++
				summary.Errors = append(summary.Errors, fmt.Sprintf("%s: failed to create symlink: %v", item.Name, err))
				continue
			}
		}

		summary.Linked++
	}

	return summary
}
