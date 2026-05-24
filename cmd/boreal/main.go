package main

import (
	"fmt"
	"os"

	"github.com/platonoff-dev/boreal/internal/cli"
)

func main() {
	err := cli.Run(os.Stdout)
	if err != nil {
		_, _ = fmt.Fprintf(os.Stderr, "boreal: %v\n", err)

		os.Exit(1)
	}
}
