package cli_test

import (
	"bytes"
	"testing"

	"github.com/platonoff-dev/boreal/internal/cli"
)

func TestRunWritesGreeting(t *testing.T) {
	t.Parallel()

	var stdout bytes.Buffer

	err := cli.Run(&stdout)
	if err != nil {
		t.Fatalf("Run() error = %v", err)
	}

	const want = "hello from boreal\n"

	if got := stdout.String(); got != want {
		t.Fatalf("Run() output = %q, want %q", got, want)
	}
}
