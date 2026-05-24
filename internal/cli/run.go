package cli

import (
	"fmt"
	"io"
)

const greeting = "hello from boreal"

// Run writes the Boreal greeting to stdout.
func Run(stdout io.Writer) error {
	_, err := fmt.Fprintln(stdout, greeting)
	if err != nil {
		return fmt.Errorf("write greeting: %w", err)
	}

	return nil
}
