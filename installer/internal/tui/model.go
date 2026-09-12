package tui

import (
	"fmt"
	"strings"

	"github.com/charmbracelet/bubbles/progress"
	"github.com/charmbracelet/bubbles/spinner"
	"github.com/charmbracelet/bubbles/viewport"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"

	"dotfiles-installer/internal/config"
	"dotfiles-installer/internal/installer"
)

type Step int

const (
	StepWelcome Step = iota
	StepSymlinks
	StepPackages
	StepConfirm
	StepExec
	StepDone
)

type InstallMode int

const (
	ModeFull InstallMode = iota
	ModeSymlinksOnly
	ModeCustom
)

type TaskItem struct {
	Type     string // "symlink" or "package"
	Symlink  config.SymlinkItem
	Package  config.PackageItem
}

type TaskResultMsg struct {
	Index  int
	Result installer.Result
}

type Model struct {
	// Screen dimensions
	width  int
	height int

	// Current step
	step Step

	// Configuration data
	symlinks []config.SymlinkItem
	packages []config.PackageItem
	sysInfo  installer.SystemInfo

	// Options
	mode   InstallMode
	backup bool
	dryRun bool

	// Custom selection cursors
	welcomeCursor  int
	symlinkCursor  int
	packageCursor  int

	// Execution state
	tasks       []TaskItem
	taskIndex   int
	results     []installer.Result
	aptUpdated  bool
	isExecuting bool

	// Bubbles components
	progress progress.Model
	spinner  spinner.Model
	viewport viewport.Model
}

func NewModel(dotfilesDir, homeDir string) Model {
	sysInfo := installer.DetectSystemInfo(dotfilesDir, homeDir)
	symlinks := config.GetDefaultSymlinks()
	packages := config.GetDefaultPackages()

	s := spinner.New()
	s.Spinner = spinner.Dot
	s.Style = lipgloss.NewStyle().Foreground(AccentColor)

	p := progress.New(
		progress.WithDefaultGradient(),
		progress.WithWidth(50),
		progress.WithoutPercentage(),
	)

	vp := viewport.New(70, 10)

	return Model{
		step:        StepWelcome,
		symlinks:    symlinks,
		packages:    packages,
		sysInfo:     sysInfo,
		mode:        ModeFull,
		backup:      true,
		dryRun:      false,
		spinner:     s,
		progress:    p,
		viewport:    vp,
		welcomeCursor: 0,
	}
}

func (m Model) Init() tea.Cmd {
	return m.spinner.Tick
}

func (m Model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	var cmds []tea.Cmd

	switch msg := msg.(type) {
	case tea.WindowSizeMsg:
		m.width = msg.Width
		m.height = msg.Height
		m.viewport.Width = msg.Width - 6
		m.viewport.Height = max(6, msg.Height-18)
		m.progress.Width = max(20, msg.Width-30)

	case tea.KeyMsg:
		switch msg.String() {
		case "ctrl+c":
			return m, tea.Quit
		case "q":
			if m.step != StepExec {
				return m, tea.Quit
			}
		}

		// Handle keybindings per step
		switch m.step {
		case StepWelcome:
			return m.updateWelcome(msg)
		case StepSymlinks:
			return m.updateSymlinks(msg)
		case StepPackages:
			return m.updatePackages(msg)
		case StepConfirm:
			return m.updateConfirm(msg)
		case StepDone:
			if msg.String() == "enter" || msg.String() == "q" {
				return m, tea.Quit
			}
		}

	case spinner.TickMsg:
		if m.step == StepExec {
			var cmd tea.Cmd
			m.spinner, cmd = m.spinner.Update(msg)
			cmds = append(cmds, cmd)
		}

	case TaskResultMsg:
		m.results = append(m.results, msg.Result)
		m.taskIndex++

		// Update viewport logs
		m.updateLogsViewport()

		if m.taskIndex < len(m.tasks) {
			// Execute next task
			cmds = append(cmds, m.execTaskCmd(m.taskIndex))
		} else {
			// Execution complete!
			m.step = StepDone
		}
	}

	return m, tea.Batch(cmds...)
}

func (m Model) updateWelcome(msg tea.KeyMsg) (tea.Model, tea.Cmd) {
	switch msg.String() {
	case "up", "k":
		if m.welcomeCursor > 0 {
			m.welcomeCursor--
		}
	case "down", "j":
		if m.welcomeCursor < 4 {
			m.welcomeCursor++
		}
	case "space", " ":
		// Toggle option if on option rows
		if m.welcomeCursor == 3 {
			m.backup = !m.backup
		} else if m.welcomeCursor == 4 {
			m.dryRun = !m.dryRun
		} else {
			m.mode = InstallMode(m.welcomeCursor)
		}
	case "enter":
		if m.welcomeCursor < 3 {
			m.mode = InstallMode(m.welcomeCursor)
		}
		// Apply mode selection
		m.applyModeSelections()

		if m.mode == ModeCustom {
			m.step = StepSymlinks
		} else {
			m.step = StepConfirm
		}
	}
	return m, nil
}

func (m Model) updateSymlinks(msg tea.KeyMsg) (tea.Model, tea.Cmd) {
	switch msg.String() {
	case "up", "k":
		if m.symlinkCursor > 0 {
			m.symlinkCursor--
		}
	case "down", "j":
		if m.symlinkCursor < len(m.symlinks)-1 {
			m.symlinkCursor++
		}
	case "space", " ":
		m.symlinks[m.symlinkCursor].Selected = !m.symlinks[m.symlinkCursor].Selected
	case "a":
		// Toggle all
		allSelected := true
		for _, item := range m.symlinks {
			if !item.Selected {
				allSelected = false
				break
			}
		}
		for i := range m.symlinks {
			m.symlinks[i].Selected = !allSelected
		}
	case "b":
		m.step = StepWelcome
	case "enter":
		if m.mode == ModeSymlinksOnly {
			m.step = StepConfirm
		} else {
			m.step = StepPackages
		}
	}
	return m, nil
}

func (m Model) updatePackages(msg tea.KeyMsg) (tea.Model, tea.Cmd) {
	switch msg.String() {
	case "up", "k":
		if m.packageCursor > 0 {
			m.packageCursor--
		}
	case "down", "j":
		if m.packageCursor < len(m.packages)-1 {
			m.packageCursor++
		}
	case "space", " ":
		m.packages[m.packageCursor].Selected = !m.packages[m.packageCursor].Selected
	case "a":
		// Toggle all
		allSelected := true
		for _, item := range m.packages {
			if !item.Selected {
				allSelected = false
				break
			}
		}
		for i := range m.packages {
			m.packages[i].Selected = !allSelected
		}
	case "b":
		m.step = StepSymlinks
	case "enter":
		m.step = StepConfirm
	}
	return m, nil
}

func (m Model) updateConfirm(msg tea.KeyMsg) (tea.Model, tea.Cmd) {
	switch msg.String() {
	case "b":
		if m.mode == ModeCustom {
			m.step = StepPackages
		} else {
			m.step = StepWelcome
		}
	case "enter":
		m.prepareTasks()
		m.step = StepExec
		m.taskIndex = 0
		m.results = nil
		if len(m.tasks) > 0 {
			return m, tea.Batch(m.spinner.Tick, m.execTaskCmd(0))
		} else {
			m.step = StepDone
		}
	}
	return m, nil
}

func (m *Model) applyModeSelections() {
	switch m.mode {
	case ModeFull:
		for i := range m.symlinks {
			m.symlinks[i].Selected = true
		}
		for i := range m.packages {
			m.packages[i].Selected = true
		}
	case ModeSymlinksOnly:
		for i := range m.symlinks {
			m.symlinks[i].Selected = true
		}
		for i := range m.packages {
			m.packages[i].Selected = false
		}
	case ModeCustom:
		// Keep user toggles
	}
}

func (m *Model) prepareTasks() {
	m.tasks = nil
	for _, sym := range m.symlinks {
		if sym.Selected {
			m.tasks = append(m.tasks, TaskItem{
				Type:    "symlink",
				Symlink: sym,
			})
		}
	}
	for _, pkg := range m.packages {
		if pkg.Selected {
			m.tasks = append(m.tasks, TaskItem{
				Type:    "package",
				Package: pkg,
			})
		}
	}
}

func (m Model) execTaskCmd(idx int) tea.Cmd {
	return func() tea.Msg {
		task := m.tasks[idx]
		inst := installer.NewInstaller(installer.InstallerOptions{
			DotfilesDir: m.sysInfo.DotfilesDir,
			HomeDir:     m.sysInfo.HomeDir,
			Backup:      m.backup,
			DryRun:      m.dryRun,
		})

		var res installer.Result
		if task.Type == "symlink" {
			res = inst.InstallSymlink(task.Symlink)
		} else {
			res = inst.InstallPackage(task.Package, &m.aptUpdated)
		}

		return TaskResultMsg{
			Index:  idx,
			Result: res,
		}
	}
}

func (m *Model) updateLogsViewport() {
	var sb strings.Builder
	for _, res := range m.results {
		var badge string
		switch res.Status {
		case installer.StatusSuccess:
			badge = BadgeSuccess.Render(" OK ")
		case installer.StatusSkipped:
			badge = BadgeSkipped.Render(" SKIP ")
		case installer.StatusFailed:
			badge = BadgeFailed.Render(" FAIL ")
		default:
			badge = BadgeSkipped.Render(" PEND ")
		}

		sb.WriteString(fmt.Sprintf("%s %s: %s\n", badge, KeyStyle.Render(res.Name), res.Message))
	}
	m.viewport.SetContent(sb.String())
	m.viewport.GotoBottom()
}

func (m Model) View() string {
	switch m.step {
	case StepWelcome:
		return m.viewWelcome()
	case StepSymlinks:
		return m.viewSymlinks()
	case StepPackages:
		return m.viewPackages()
	case StepConfirm:
		return m.viewConfirm()
	case StepExec:
		return m.viewExec()
	case StepDone:
		return m.viewDone()
	default:
		return "Unknown Step"
	}
}

func (m Model) viewWelcome() string {
	var sb strings.Builder

	sb.WriteString(RenderBanner(false) + "\n\n")

	modes := []struct {
		title string
		desc  string
	}{
		{"Full Installation", "Create all configuration symlinks and install all recommended packages"},
		{"Symlinks Only", "Only symlink configuration files/directories to ~/.config"},
		{"Custom Selection", "Select specific symlinks and packages to install"},
	}

	sb.WriteString(StepBadgeStyle.Render("STEP 1/3") + " " + HeaderStyle.Render("SELECT INSTALLATION MODE") + "\n\n")

	for i, md := range modes {
		prefix := "  "
		if i == m.welcomeCursor && m.mode == InstallMode(i) {
			prefix = AccentStyle.Render("● ")
		} else if i == m.welcomeCursor {
			prefix = AccentStyle.Render("❯ ")
		} else if m.mode == InstallMode(i) {
			prefix = AccentDimStyle.Render("○ ")
		}

		itemStr := fmt.Sprintf("%s%s", prefix, md.title)
		if i == m.welcomeCursor {
			sb.WriteString(SelectedStyle.Render(itemStr) + "\n")
			sb.WriteString(DescStyle.Render("└─ "+md.desc) + "\n")
		} else {
			sb.WriteString(UnselectedStyle.Render(itemStr) + "\n")
		}
	}

	sb.WriteString("\n" + StepBadgeStyle.Render("OPTIONS") + "\n")

	// Option 1: Backup
	bakPrefix := "  "
	if m.welcomeCursor == 3 {
		bakPrefix = AccentStyle.Render("❯ ")
	}
	bakCheck := "[ ]"
	if m.backup {
		bakCheck = AccentStyle.Render("[✓]")
	}
	bakLine := fmt.Sprintf("%s%s Backup existing configuration files before overwriting", bakPrefix, bakCheck)
	if m.welcomeCursor == 3 {
		sb.WriteString(SelectedStyle.Render(bakLine) + "\n")
	} else {
		sb.WriteString(UnselectedStyle.Render(bakLine) + "\n")
	}

	// Option 2: Dry Run
	dryPrefix := "  "
	if m.welcomeCursor == 4 {
		dryPrefix = AccentStyle.Render("❯ ")
	}
	dryCheck := "[ ]"
	if m.dryRun {
		dryCheck = AccentStyle.Render("[✓]")
	}
	dryLine := fmt.Sprintf("%s%s Dry Run mode (Simulate installation without modifying system)", dryPrefix, dryCheck)
	if m.welcomeCursor == 4 {
		sb.WriteString(SelectedStyle.Render(dryLine) + "\n")
	} else {
		sb.WriteString(UnselectedStyle.Render(dryLine) + "\n")
	}

	keys := [][2]string{
		{"↑/↓", "Navigate"},
		{"Space", "Select/Toggle"},
		{"Enter", "Continue"},
		{"Q", "Quit"},
	}
	sb.WriteString("\n" + RenderHelpBar(keys))

	return BoxStyle.Render(sb.String())
}

func (m Model) viewSymlinks() string {
	var sb strings.Builder

	sb.WriteString(RenderBanner(true) + "\n\n")

	sb.WriteString(StepBadgeStyle.Render("STEP 2/3") + " " + HeaderStyle.Render("SELECT CONFIGURATION SYMLINKS") + "\n\n")

	for i, item := range m.symlinks {
		prefix := "  "
		if i == m.symlinkCursor {
			prefix = AccentStyle.Render("❯ ")
		}

		chk := "[ ]"
		if item.Selected {
			chk = AccentStyle.Render("[✓]")
		}

		line := fmt.Sprintf("%s%s %s", prefix, chk, item.Name)
		if i == m.symlinkCursor {
			sb.WriteString(SelectedStyle.Render(line) + "\n")
			sb.WriteString(DescStyle.Render(fmt.Sprintf("└─ %s (~/%s)", item.Description, item.TargetRel)) + "\n")
		} else {
			sb.WriteString(UnselectedStyle.Render(line) + "\n")
		}
	}

	keys := [][2]string{
		{"↑/↓", "Navigate"},
		{"Space", "Toggle"},
		{"A", "Toggle All"},
		{"B", "Back"},
		{"Enter", "Next Step"},
	}
	sb.WriteString("\n" + RenderHelpBar(keys))

	return BoxStyle.Render(sb.String())
}

func (m Model) viewPackages() string {
	var sb strings.Builder

	sb.WriteString(RenderBanner(true) + "\n\n")

	sb.WriteString(StepBadgeStyle.Render("STEP 3/3") + " " + HeaderStyle.Render("SELECT TOOLS & PACKAGES") + "\n\n")

	currentCat := ""
	for i, item := range m.packages {
		if item.Category != currentCat {
			currentCat = item.Category
			sb.WriteString(AccentDimStyle.Render("── "+currentCat+" ──") + "\n")
		}

		prefix := "  "
		if i == m.packageCursor {
			prefix = AccentStyle.Render("❯ ")
		}

		chk := "[ ]"
		if item.Selected {
			chk = AccentStyle.Render("[✓]")
		}

		line := fmt.Sprintf("%s%s %s", prefix, chk, item.Name)
		if i == m.packageCursor {
			sb.WriteString(SelectedStyle.Render(line) + "\n")
			sb.WriteString(DescStyle.Render("└─ "+item.Description) + "\n")
		} else {
			sb.WriteString(UnselectedStyle.Render(line) + "\n")
		}
	}

	keys := [][2]string{
		{"↑/↓", "Navigate"},
		{"Space", "Toggle"},
		{"A", "Toggle All"},
		{"B", "Back"},
		{"Enter", "Review & Confirm"},
	}
	sb.WriteString("\n" + RenderHelpBar(keys))

	return BoxStyle.Render(sb.String())
}

func (m Model) viewConfirm() string {
	var sb strings.Builder

	sb.WriteString(RenderBanner(true) + "\n\n")
	sb.WriteString(HeaderStyle.Render("INSTALLATION CONFIRMATION") + "\n\n")

	symCount := 0
	for _, s := range m.symlinks {
		if s.Selected {
			symCount++
		}
	}
	pkgCount := 0
	for _, p := range m.packages {
		if p.Selected {
			pkgCount++
		}
	}

	sb.WriteString(fmt.Sprintf("%s %s\n", KeyStyle.Render("Target Home Directory:"), m.sysInfo.HomeDir))
	sb.WriteString(fmt.Sprintf("%s %s\n", KeyStyle.Render("Dotfiles Source Path: "), m.sysInfo.DotfilesDir))
	sb.WriteString(fmt.Sprintf("%s %s\n", KeyStyle.Render("Package Manager:      "), m.sysInfo.PackageManager))
	sb.WriteString(fmt.Sprintf("%s %d selected\n", KeyStyle.Render("Symlink Targets:      "), symCount))
	sb.WriteString(fmt.Sprintf("%s %d selected\n", KeyStyle.Render("Packages to Install:  "), pkgCount))
	sb.WriteString(fmt.Sprintf("%s %v\n", KeyStyle.Render("Backup Existing Files:"), m.backup))
	sb.WriteString(fmt.Sprintf("%s %v\n\n", KeyStyle.Render("Dry Run Simulation:   "), m.dryRun))

	if symCount == 0 && pkgCount == 0 {
		sb.WriteString(BadgeFailed.Render(" WARNING ") + " No items selected for installation!\n\n")
	} else {
		sb.WriteString(BadgeSuccess.Render(" READY ") + " Press [Enter] to begin installation!\n\n")
	}

	keys := [][2]string{
		{"Enter", "Start Installation"},
		{"B", "Back to Selection"},
		{"Q", "Cancel & Exit"},
	}
	sb.WriteString(RenderHelpBar(keys))

	return BoxStyle.Render(sb.String())
}

func (m Model) viewExec() string {
	var sb strings.Builder

	sb.WriteString(RenderBanner(true) + "\n\n")
	sb.WriteString(m.spinner.View() + " " + HeaderStyle.Render("INSTALLING DOTFILES & PACKAGES...") + "\n\n")

	total := len(m.tasks)
	current := m.taskIndex
	pct := 0.0
	if total > 0 {
		pct = float64(current) / float64(total)
	}

	m.progress.SetPercent(pct)
	progressBar := m.progress.ViewAs(pct)

	sb.WriteString(fmt.Sprintf("Progress: [%d/%d]  %s  %.0f%%\n\n", current, total, progressBar, pct*100))
	sb.WriteString(m.viewport.View() + "\n")

	return BoxStyle.Render(sb.String())
}

func (m Model) viewDone() string {
	var sb strings.Builder

	sb.WriteString(RenderBanner(true) + "\n\n")
	sb.WriteString(BadgeSuccess.Render(" INSTALLATION COMPLETE ") + "\n\n")

	succCount, skipCount, failCount := 0, 0, 0
	for _, r := range m.results {
		switch r.Status {
		case installer.StatusSuccess:
			succCount++
		case installer.StatusSkipped:
			skipCount++
		case installer.StatusFailed:
			failCount++
		}
	}

	sb.WriteString(fmt.Sprintf("%s %d\n", BadgeSuccess.Render(" SUCCESS "), succCount))
	sb.WriteString(fmt.Sprintf("%s %d\n", BadgeSkipped.Render(" SKIPPED "), skipCount))
	sb.WriteString(fmt.Sprintf("%s %d\n\n", BadgeFailed.Render(" FAILED  "), failCount))

	sb.WriteString(m.viewport.View() + "\n\n")

	keys := [][2]string{
		{"Enter/Q", "Exit Installer"},
	}
	sb.WriteString(RenderHelpBar(keys))

	return BoxStyle.Render(sb.String())
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}
