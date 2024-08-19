# Infrastructure for Solana test-validator

This repo contains various scripts and configurations to help run a Solana test-validator.

The idea is to setup and run a test validator on a cloud provider (e.g. AWS) as a shared resource for multiple developers to use for testing their Solana programs.

## Docker setup

### Prerequisites

- [docker](https://docs.docker.com/get-docker/)

### Build container

#### Build for `amd64`:

```sh
docker build -t tsumori-io/solana-test-validator -f amd64.Dockerfile .
```

#### Build for `arm64`:

```sh
docker build -t tsumori-io/solana-test-validator -f arm64.Dockerfile .
```

### Run stack

```sh
docker-compose up
```

