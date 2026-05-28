PRE_COMMIT_VERSION := 4.6.0

.PHONY: bootstrap check clippy fmt fmt-check pre-commit test

check: fmt-check clippy test

bootstrap:
	@command -v cargo >/dev/null || { echo "missing cargo"; exit 1; }
	@command -v rustfmt >/dev/null || { echo "missing rustfmt"; exit 1; }
	@cargo clippy --version >/dev/null || { echo "missing clippy"; exit 1; }
	@command -v pre-commit >/dev/null || { echo "missing pre-commit $(PRE_COMMIT_VERSION)"; exit 1; }
	@pre-commit --version | grep -q "pre-commit $(PRE_COMMIT_VERSION)" || { pre-commit --version; echo "want pre-commit $(PRE_COMMIT_VERSION)"; exit 1; }
	@pre-commit install --install-hooks

fmt:
	@cargo fmt --all

fmt-check:
	@cargo fmt --all --check

clippy:
	@cargo clippy --all-targets --all-features -- -D warnings

pre-commit:
	@pre-commit run --all-files --show-diff-on-failure

test:
	@cargo test --all-targets --all-features
