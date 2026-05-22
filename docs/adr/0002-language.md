---
title: ADR-0002 — Boreal implementation language
tags: [adr, boreal, language, go, rust]
status: accepted
created: 2026-05-23
updated: 2026-05-23
supersedes:
superseded_by:
---

# ADR-0002 — Boreal implementation language

**Status:** accepted

**Date:** 2026-05-23

## Context

Boreal is the load-bearing mega-project of the Hard Systems Generalist Roadmap and runs across seven versions, from a single-node process runner (v0) to a multi-node replicated cloud runtime with observability and security (v6/v7). The implementation language is a global decision: it sets the ecosystem for the control plane, host agent, scheduler, Raft layer, storage skeleton, networking stack, and observability pipeline.

Three forces are in play.

1. **The learning targets are protocol-level, not language-level.** Raft, WAL, scheduler invariants, packet-path reasoning, namespaces, and the OCI lifecycle are language-agnostic. The roadmap's must-implement-manually list does not pin a language.
2. **Iteration depth matters more than first-pass speed.** Per the roadmap's AI policy, the binding constraint is design judgment, not code throughput — but the roadmap's value loop is "ship v_N_, revisit v_N-k_ with the lessons v_N_ taught." That loop demands enough velocity to actually revisit. Language friction taxes the loop.
3. **Rust unsafe literacy is a stretch goal** of the roadmap. v6 (eBPF telemetry, flamegraphs, threat model) and v5 (storage volumes, WAL-backed metadata, optional LSM KV sidecar) are exactly the surfaces where Rust earns its weight: storage engines and kernel-adjacent perf code are where GC-managed runtimes both distort measurement and forfeit ergonomic gains. Elsewhere — control plane, agent, scheduler reconciliation, gRPC surface — the Rust tax buys little.

The user already has senior-level Go fluency and a Kubernetes/cloud background, so Go for the control plane and agent ships v0–v3 fast and keeps the project legible to its reference ecosystem (containerd, OCI, K8s). The hybrid keeps the *whole* project under the "single mega-project" frame established in the [Boreal overview](../overview.md) without spawning a separate Rust side lab.

## Decision

We will implement Boreal primarily in **Go**, with **two Rust subsystems**:

- **v5 — mini LSM KV sidecar**: implemented in Rust, exposed to the Go control plane as a separate process behind a small RPC/Unix-socket boundary.
- **v6 — eBPF telemetry and flamegraph pipeline**: implemented in Rust (aya or libbpf-rs), invoked by the Go agent as a sidecar or library binding.

All other components — control plane, host agent, scheduler, Raft layer (v4), networking (v2), volume manager skeleton (v5), and image/bundle handling (v1) — are Go. The FFI/IPC boundary between Go and the Rust slices is itself a design artifact and gets its own ADR when v5 design begins.

## Consequences

**Positive:**

- v0–v3 ship on the velocity track, maximizing the number of "revisit-and-learn" cycles before the roadmap's mid-phase boss fights.
- Rust unsafe literacy lands on material that materially benefits from it (storage engine, kernel-adjacent perf), rather than being grafted onto control-plane code where the gain is marginal.
- The project keeps a single mega-project shape — no separate Rust side lab — preserving the portfolio-coherence rationale in the [Boreal overview](../overview.md).
- v6's perf and observability story becomes honest: no GC distortion in the part of the system most likely to be measured.
- The Go/Rust IPC boundary becomes its own design artifact, feeding M17 (Software design and code craft) and M18 (Systems design patterns).

**Negative:**

- Two-language CI, two toolchains, two dependency-management surfaces. Build complexity grows mid-project (v5/v6), not at v0.
- The FFI/IPC boundary is design surface that would not exist in a single-language project, and a poorly designed boundary will leak through the v5 storage and v6 observability stories.
- Rust ramp-up cost is deferred, not eliminated; it concentrates around M9/M8 (already cognitively heavy milestones) instead of being amortized from v0.
- AI-paired implementation per the AI policy will need stricter scoping in Rust slices, because the unfamiliar language invites cheating in the must-implement-manually areas.

**Neutral / accepted tradeoffs:**

- Some idiomatic patterns will be re-implemented twice (logging conventions, metric naming, error taxonomies) across the language boundary.
- v7 advanced extensions can be in either language; the choice is deferred until v7's scope is picked.
- The ecosystem story shifts slightly toward "polyglot infrastructure project" rather than "pure Go infrastructure project" — a wash for the target audience (senior infrastructure engineers).

## Alternatives considered

- **Go-only across all seven versions** — rejected because it strands the Rust unsafe literacy stretch goal outside the mega-project and would force a separate Rust side lab, contradicting the "single mega-project absorbs the labs" decision in the [Boreal overview](../overview.md) (2026-05-01).
- **Rust-only across all seven versions** — rejected because language friction on async-Rust and lifetimes would compete for bandwidth with the actual learning targets (Raft, packet path, scheduler invariants), and the AI policy's allowance for AI-paired non-learning-target code becomes a leak under a steep language curve.
- **Go-only for now, defer Rust decision to v5** — rejected because the language strategy is a global property of the project and pinning it now lets v0–v4 design choices (RPC framing, error taxonomy, observability conventions) be made with the future Go/Rust boundary already in view; pushing the decision to v5 risks designing v0–v4 in a way that's hostile to the eventual boundary.
- **Hybrid with only one Rust slice (v6 only)** — rejected because v5 storage work is the canonical Rust-fit milestone (M9) and skipping it would leave Rust touching only kernel-adjacent code, narrowing the unsafe-literacy surface to a single track.

## Sources

-
