GOLANGCI_LINT_VERSION := 2.12.2
PRE_COMMIT_VERSION := 4.6.0

GO_PACKAGES := ./...
GO_FILES := $(shell find . -type f -name '*.go' -not -path './vendor/*')

.PHONY: bootstrap check fmt fmt-check lint lint-version pre-commit test tidy-check vet

bootstrap:
	@command -v golangci-lint >/dev/null || { echo "missing golangci-lint $(GOLANGCI_LINT_VERSION)"; exit 1; }
	@golangci-lint version | grep -q "version $(GOLANGCI_LINT_VERSION)" || { golangci-lint version; echo "want golangci-lint $(GOLANGCI_LINT_VERSION)"; exit 1; }
	@command -v pre-commit >/dev/null || { echo "missing pre-commit $(PRE_COMMIT_VERSION)"; exit 1; }
	@pre-commit --version | grep -q "pre-commit $(PRE_COMMIT_VERSION)" || { pre-commit --version; echo "want pre-commit $(PRE_COMMIT_VERSION)"; exit 1; }
	@pre-commit install --install-hooks

check: lint-version tidy-check fmt-check vet test lint

fmt:
	@gofmt -w $(GO_FILES)

fmt-check:
	@files="$$(gofmt -l $(GO_FILES))"; \
	if [ -n "$$files" ]; then \
		echo "gofmt required:"; \
		echo "$$files"; \
		exit 1; \
	fi

lint:
	@golangci-lint run --config .golangci.yml $(GO_PACKAGES)

pre-commit:
	@pre-commit run --all-files --show-diff-on-failure

test:
	@go test -race -count=1 $(GO_PACKAGES)

tidy-check:
	@go mod tidy -diff

lint-version:
	@golangci-lint version | grep -q "version $(GOLANGCI_LINT_VERSION)" || { golangci-lint version; echo "want golangci-lint $(GOLANGCI_LINT_VERSION)"; exit 1; }

vet:
	@go vet $(GO_PACKAGES)
