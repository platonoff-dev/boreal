---
title: Boreal
status: planned
tags: [project, boreal, cloud-runtime, distributed-systems, linux, containers, scheduler]
created: 2026-05-01
updated: 2026-05-23
---

# Boreal

**TL;DR:** A small Fly.io-style cloud runtime for launching isolated "machines" across several nodes. Boreal is the load-bearing mega-project for the Hard Systems Generalist Roadmap — its versions v0 through v7 force the weak areas (syscalls, packet path, profiling, TCP/networking, Linux internals, storage, distributed protocols) and absorb the build tasks of milestones M5–M11.

## Why this project

Picked over five alternative mega-projects (replicated storage engine, distributed job-execution fabric, packet-path observability lab, container-runtime lab, distributed failure laboratory) because:

- It matches an existing cloud / Kubernetes background without becoming "another Kubernetes tutorial."
- It forces every weak area at once: syscalls, packet path, profiling, TCP, Linux internals, storage, and distributed protocols.
- Portfolio artifacts come out that elite infrastructure teams understand immediately.
- It supports the "hard systems generalist" identity while still specializing in distributed cloud infrastructure.
- It absorbs side labs without forcing every topic to fit.

Use Kubernetes, containerd, OCI, and *Kubernetes the Hard Way* as **references**, not as things to clone. Kubernetes documents the control-plane / worker-node component model; OCI defines low-level runtime configuration / lifecycle expectations; containerd is a useful reference for host-level container lifecycle architecture.

## Scope by version

The seven versions are the unit of progress. Each maps onto one or more roadmap milestones and its own boss fight.

### Boreal v0 — single-node process runner

- HTTP / gRPC control API.
- Host agent.
- Start / stop / list / logs for Linux processes.
- Resource metadata.
- Local SQLite metadata store.
- CI, tests, structured logs.

Maps to the 3-month starter plan and unblocks Boss Fight 2 (OS / Linux / container core).

### Boreal v1 — container runner

- Run OCI bundles through an existing runtime first.
- Image unpack / cache.
- Namespaces / cgroups / seccomp exploration.
- Basic log streaming.
- Public demo: "launch 10 isolated services on one host."

Maps to M6 (Linux internals and system programming) and Boss Fight 2.

### Boreal v2 — networking

- Per-machine network namespace.
- Bridge / NAT.
- Port publishing.
- DNS service discovery.
- tcpdump / Wireshark / eBPF packet-path writeup.

Maps to M7 (Networking: TCP, DNS, TLS, BGP/NAT, Linux packet path) and feeds Boss Fight 3 (Networking / performance / storage).

### Boreal v3 — multi-node scheduler

- Control plane + multiple agents.
- Placement rules.
- Health checks.
- Reconciliation loop.
- Node drain.
- Failure tests.

Maps to M11 (Cloud infrastructure and Kubernetes internals).

### Boreal v4 — replicated metadata

- Raft-backed metadata KV.
- Leader election.
- Log replication.
- Snapshots.
- Linearizability checks.
- Deterministic simulator.

Maps to M10 (Distributed systems) and is Boss Fight 4 (Distributed systems).

### Boreal v5 — storage volumes

- Local volume manager.
- WAL-backed metadata.
- Snapshot / restore.
- Optional mini LSM KV sidecar.

Maps to M9 (Databases and storage engines).

### Boreal v6 — observability / security / performance

- eBPF network telemetry.
- Flamegraphs.
- Benchmark suite.
- Threat model.
- mTLS.
- Seccomp profiles.
- Failure-injection dashboard.

Maps to M8 (Performance engineering) and M12 (Security for systems engineers) and supports Boss Fight 5 (Cloud platform demo).

### Boreal v7 — optional advanced extension (choose one)

- Firecracker-style microVM integration.
- WASM execution.
- Distributed persistent volumes.
- Global edge-placement simulation.
- Kubernetes CRD wrapper.

Pick **one** if any. The alternatives are tempting but mutually distracting.

## Goal

Ship a runnable cloud runtime that a senior systems engineer can clone, run, understand, and learn from. Each version is demoable and accompanied by a writeup, benchmark, and failure report.

## Current state

Planned. The 3-month starter targets Boreal v0; the 12-month plan reaches v3–v4 with the Raft simulator and packet-path lab in tow.

## Decisions

- 2026-05-01 — Single primary mega-project chosen over independent labs — concentrates work, forces every weak area, and produces a coherent portfolio story instead of scattered small repos.
- 2026-05-01 — v7 caps at one advanced extension — preventing the project from drifting into a Kubernetes clone or a multi-track research effort.
- 2026-05-01 — Use existing OCI runtime in v1 before any custom runtime work — defers the hardest Linux internals until M6 is complete.
- 2026-05-23 — Go primary, Rust slices in v5 (LSM KV sidecar) and v6 (eBPF telemetry + flamegraphs) — see [ADR-0002](adr/0002-language.md). Ships v0–v3 on the velocity track; lands Rust unsafe literacy on the surfaces that materially benefit (storage engine, kernel-adjacent perf).

## Open questions

- v4 Raft is constrained by the roadmap's must-implement-manually list — Raft election and log replication get built by hand at M10. Open question is whether Boreal v4 reuses that hand-built implementation directly, or wraps it as a library with the deterministic simulator and linearizability checker layered on top.
- How small can v0 be while still demoable and benchmarkable in under 30 minutes from `git clone`?
- Shape of the Go/Rust IPC boundary for v5 and v6 — gets its own ADR when v5 design begins.

## Links

- Hard Systems Generalist Roadmap (personal wiki)
- Milestones M0–M19 (personal wiki)
- Boss fights (personal wiki)
- Compressed plans (personal wiki)
- Design canon (personal wiki)

## Sources

- Hard Systems Generalist Curriculum (personal wiki, `raw/`)
