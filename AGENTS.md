# Agent Environment Instructions

## Setup

Run `./install.sh` when setting up a fresh environment or container:
- Installs Python dependencies (`semver>=3.0.0`) from `requirements.txt`.
- Installs the Rust toolchain (`rustc`, `cargo`) via `rustup` if missing.
- Builds the Rust evaluation harness (`rust/target/release/harness`).

Run this before executing `evaluate.py` or running `agent.py`.
