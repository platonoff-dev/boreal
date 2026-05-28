---
title: ADR-0002 — Boreal implementation language
tags: [adr, boreal, language, rust]
status: accepted
created: 2026-05-23
updated: 2026-05-29
supersedes:
superseded_by:
---

# ADR-0002 — Boreal implementation language

**Status:** accepted

**Date:** 2026-05-29

## Context

Boreal is the load-bearing mega-project of the Hard Systems Generalist Roadmap and runs across seven versions, from a single-node process runner (v0) to a multi-node replicated cloud runtime with observability and security (v6/v7). The implementation language is a global decision: it sets the ecosystem for the control plane, host agent, scheduler, Raft layer, storage skeleton, networking stack, and observability pipeline.

Three forces are in play.

1. **The learning targets are protocol-level, not language-level.** Raft, WAL, scheduler invariants, packet-path reasoning, namespaces, and the OCI lifecycle are language-agnostic. The roadmap's must-implement-manually list does not pin a language.
2. **Iteration depth matters more than first-pass speed.** Per the roadmap's AI policy, the binding constraint is design judgment, not code throughput — but the roadmap's value loop is "ship v_N_, revisit v_N-k_ with the lessons v_N_ taught." That loop demands enough velocity to actually revisit. Language friction taxes the loop.
3. **Rust unsafe literacy should be amortized from v0.** v6 (eBPF telemetry, flamegraphs, threat model) and v5 (storage volumes, WAL-backed metadata, optional LSM KV) are still the strongest Rust-fit surfaces, but delaying Rust until those milestones concentrates the learning cost at exactly the point where the storage and performance work is already cognitively heavy.

The earlier hybrid decision optimized for early velocity by using Go for v0–v4 and Rust only for storage/perf slices. The project direction has changed: Boreal should now force Rust design judgment from the first executable artifact. The cost is slower early iteration, but the benefit is a single implementation language, one toolchain, and no artificial IPC boundary between ordinary control-plane code and the later systems-heavy surfaces.

## Decision

We will implement Boreal entirely in **Rust**.

Control plane, host agent, scheduler, Raft layer, networking, volume manager, storage metadata, image/bundle handling, and observability code all live in Rust crates or modules. A process boundary may still exist where it is a product/runtime boundary, but not because the repository is split across Go and Rust.

## Consequences

**Positive:**

- Rust literacy compounds from v0 instead of arriving late in v5/v6.
- The project has one toolchain, one dependency model, and one set of conventions.
- Storage, performance, and kernel-adjacent observability code no longer sit behind a language boundary from the rest of the runtime.
- v6's perf and observability story becomes honest: no GC distortion in the measured runtime.
- API boundaries become product/domain boundaries rather than Go/Rust accommodation boundaries.

**Negative:**

- v0–v3 will move slower than the earlier Go-first plan.
- Async Rust, ownership, lifetimes, trait boundaries, and error modeling can compete with the core systems lessons if scope is not kept narrow.
- The AI policy needs stricter enforcement from the start, because language unfamiliarity can turn non-target implementation details into accidental outsourcing of the learning target.

**Neutral / accepted tradeoffs:**

- v7 advanced extensions stay in Rust unless a later ADR approves a language-specific exception.
- The ecosystem story shifts from Go-native infrastructure to Rust systems infrastructure; this is acceptable for the revised project goal.

## Alternatives considered

- **Go-only across all seven versions** — rejected because it strands Rust unsafe literacy outside the mega-project and would force a separate Rust side lab, contradicting the "single mega-project absorbs the labs" decision in the [Boreal overview](../overview.md) (2026-05-01).
- **Go primary with Rust v5/v6 slices** — superseded by this ADR update. It optimized for v0–v3 velocity, but preserves a language boundary that the revised project goal no longer wants.
- **Go-only for now, defer Rust decision to v5** — rejected because the language strategy is a global property of the project and early API, error, tracing, and crate-boundary decisions should be made in the language the project will keep.

## Sources

-
