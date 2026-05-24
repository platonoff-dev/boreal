# boreal
A small Fly.io-style cloud runtime for launching isolated "machines" across several nodes

## Development

Run the CLI:

```bash
go run ./cmd/boreal
```

Run the full local gate:

```bash
make check
```

Install Git hooks:

```bash
make bootstrap
```

The gate is intentionally strict: `go mod tidy -diff`, `gofmt`, `go vet`, race-enabled tests, and `golangci-lint` with all non-deprecated linters enabled. The pre-commit and pre-push hooks run the same `make check` target.
