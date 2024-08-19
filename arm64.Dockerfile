FROM --platform=linux/arm64 docker.io/library/rust:1.75.0-bookworm AS builder

WORKDIR /workspace

ENV PATH="/workspace/bin:${PATH}"

# apt install build-essential git clang curl libssl-dev llvm libudev-dev make cmake protobuf-compiler pkg-config -y
# Install os deps
RUN apt update -y && \
    apt-get install -y build-essential clang cmake curl libudev-dev pkg-config protobuf-compiler && \
    rm -rf /var/lib/apt/lists/*

# # Setup rust
# RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain 1.80.0 -y
# ENV PATH="/root/.cargo/bin:${PATH}"

ARG SOLANA_VERSION=1.18.22

# Get the solana source
RUN curl https://codeload.github.com/solana-labs/solana/tar.gz/refs/tags/v$SOLANA_VERSION | tar xvz
RUN mv /workspace/solana-$SOLANA_VERSION /workspace/solana

# Build the solana-test-validator
WORKDIR /workspace/solana
RUN cargo build --bin solana-keygen --release
RUN cargo build --bin solana-test-validator --release
RUN mkdir -p /workspace/bin && \
    cp target/release/solana-keygen /workspace/bin/ && \
    cp target/release/solana-test-validator /workspace/bin/

FROM docker.io/library/debian:bookworm-slim

## Install os deps
RUN apt update && \
    apt-get install -y bzip2 && \
    rm -rf /var/lib/apt/lists/*

# Run image
COPY --from=builder /workspace/bin/* /usr/local/bin/
COPY docker-entrypoint.sh /

EXPOSE 8899 8900

ENTRYPOINT ["/docker-entrypoint.sh"]
