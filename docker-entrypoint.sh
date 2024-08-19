#!/bin/sh

set -e

# ==============================================================================
#                                   Functions
# ==============================================================================

log() {
    echo "[$(date --rfc-3339=seconds)] $1"
}

# ==============================================================================

# Generate a default keypair in ~/.config/solana.id.json
if [ ! -f ~/.config/solana/id.json ]; then
    log "Generating a default keypair" 
    solana-keygen new --no-bip39-passphrase
fi

log "Starting solana-test-validator..."
exec solana-test-validator "$@"
