# Infrastructure for Solana test-validator

This repo contains various scripts and configurations to help run a Solana test-validator.

The idea is to setup and run a test validator on a cloud provider (e.g. AWS) as a shared resource for multiple developers to use for testing their Solana programs.

## Docker setup

### Prerequisites

- [docker](https://docs.docker.com/get-docker/)

### Build container

#### Build for `amd64`:

```sh
docker build -t tsumori-io/solana-test-validator:latest-amd64 -f amd64.Dockerfile .
```

#### Build for `arm64`:

```sh
docker build -t tsumori-io/solana-test-validator:latest-arm64 -f arm64.Dockerfile .
```

### Pushing to ghcr

#### Re-tag images for ghcr

```sh
docker tag tsumori-io/solana-test-validator:latest-amd64 ghcr.io/tsumori-io/test-validator-infra/solana-test-validator:latest-amd64
docker tag tsumori-io/solana-test-validator:latest-arm64 ghcr.io/tsumori-io/test-validator-infra/solana-test-validator:latest-arm64
```

#### Push arch images to ghcr

```sh
docker push ghcr.io/tsumori-io/test-validator-infra/solana-test-validator:latest-amd64
docker push ghcr.io/tsumori-io/test-validator-infra/solana-test-validator:latest-arm64
```

#### Create a manifest

```sh
docker manifest create ghcr.io/tsumori-io/test-validator-infra/solana-test-validator:latest \
  ghcr.io/tsumori-io/test-validator-infra/solana-test-validator:latest-amd64 \
  ghcr.io/tsumori-io/test-validator-infra/solana-test-validator:latest-arm64
```

#### Push manifest to ghcr

```sh
docker manifest push ghcr.io/tsumori-io/test-validator-infra/solana-test-validator:latest
```

### Run stack

```sh
docker-compose up
```

## Kubernetes setup

### Prerequisites

- [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)
- [k3d](https://k3d.io/v5.7.3/) - or any other k8s cluster provider

### Create k8s cluster

```sh
k3d cluster create test --servers 1
```

### Register/import local image

```sh
k3d image import tsumori-io/solana-test-validator:latest -c test
```

### Deploy stack

```sh
kubectl apply -f k8s/stack.yml
```

### Deploy using helm

```sh
helm install solana-stack ./helm --atomic
```
