# boreal
A small Fly.io-style cloud runtime for launching isolated "machines" across several nodes

## Development

Run the CLI:

```bash
cargo run
```

Run the full local gate:

```bash
make check
```

Install Git hooks:

```bash
make bootstrap
```

The gate is intentionally strict: `cargo fmt --check`, `cargo clippy --all-targets --all-features -- -D warnings`, and `cargo test --all-targets --all-features`. The pre-commit and pre-push hooks run the same `make check` target.
