package ui

import (
	"fmt"
	"time"

	"github.com/briandowns/spinner"
	"github.com/fatih/color"
)

var (
	Green  = color.New(color.FgGreen, color.Bold).SprintFunc()
	Red    = color.New(color.FgRed, color.Bold).SprintFunc()
	Yellow = color.New(color.FgYellow).SprintFunc()
	Cyan   = color.New(color.FgCyan, color.Bold).SprintFunc()
	Dim    = color.New(color.Faint).SprintFunc()
)

// Spinner wraps briandowns/spinner with standard formatting.
type Spinner struct {
	sp *spinner.Spinner
}

func NewSpinner(msg string) *Spinner {
	s := spinner.New(spinner.CharSets[14], 80*time.Millisecond) // Dot spinner
	_ = s.Color("cyan")
	s.Suffix = " " + msg
	s.FinalMSG = ""
	return &Spinner{sp: s}
}

func (s *Spinner) Start() {
	if s.sp != nil {
		s.sp.Start()
	}
}

func (s *Spinner) UpdateMessage(msg string) {
	if s.sp != nil {
		s.sp.Suffix = " " + msg
	}
}

func (s *Spinner) Success(msg string) {
	if s.sp != nil {
		s.sp.Stop()
	}
	fmt.Printf("\r\033[K%s %s\n", Green("✔"), msg)
}

func (s *Spinner) Fail(msg string) {
	if s.sp != nil {
		s.sp.Stop()
	}
	fmt.Printf("\r\033[K%s %s\n", Red("✖"), msg)
}

func (s *Spinner) Warn(msg string) {
	if s.sp != nil {
		s.sp.Stop()
	}
	fmt.Printf("\r\033[K%s %s\n", Yellow("⚠"), msg)
}

func (s *Spinner) Stop() {
	if s.sp != nil {
		s.sp.Stop()
	}
}

func Warn(msg string) {
	fmt.Printf("%s %s\n", Yellow("⚠"), msg)
}

func Info(msg string) {
	fmt.Printf("%s %s\n", Cyan("ℹ"), msg)
}

func Success(msg string) {
	fmt.Printf("%s %s\n", Green("✔"), msg)
}

func Error(msg string) {
	fmt.Printf("%s %s\n", Red("✖"), msg)
}
