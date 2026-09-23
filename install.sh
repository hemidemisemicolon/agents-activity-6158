#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "=== 1. Checking reference source files ==="
if [ ! -f "reference/version.py" ]; then
    echo "Fetching reference source files..."
    python3 fetch_source.py
else
    echo "Reference files present."
fi

echo "=== 2. Checking Python dependencies ==="
if ! python3 -c "import semver" 2>/dev/null; then
    echo "Installing requirements from requirements.txt..."
    python3 -m pip install --break-system-packages -r requirements.txt
else
    echo "Python semver package already installed."
fi

echo "=== 3. Checking Rust toolchain ==="
if [ -f "$HOME/.cargo/env" ]; then
    # shellcheck source=/dev/null
    source "$HOME/.cargo/env"
fi

if ! command -v cargo &>/dev/null; then
    echo "Rust/Cargo not found. Installing via rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
    # shellcheck source=/dev/null
    source "$HOME/.cargo/env"

    if command -v sudo &>/dev/null && [ -d "$HOME/.cargo/bin" ]; then
        echo "Creating symlinks in /usr/local/bin for global accessibility..."
        sudo ln -sf "$HOME/.cargo/bin/"* /usr/local/bin/ || true
    fi
else
    echo "Cargo is available: $(cargo --version)"
fi

echo "=== 4. Building release harness ==="
(cd rust && cargo build --release)

echo "=== Setup complete! ==="
