# Ducati Monster 1100 Manual

This repository packages the Ducati Monster 1100 workshop manual as a static website and container image.

## Runtime

- Container image: `ghcr.io/suetema/manual-ducati-monster-1100`
- HTTP port: `8080`
- Site entrypoint: `/Ducati/Workshop_manual/USA/home.html`
- Root path redirects to the manual entrypoint

## Local build

```bash
docker build -t manual-ducati-monster-1100 .
docker run --rm -p 8080:8080 manual-ducati-monster-1100
```

Then open `http://localhost:8080/`.

If you use [`generate.sh`](./generate.sh), it defaults to rendering from a locally served copy at `http://127.0.0.1:8080/Ducati/Workshop_manual/USA`. Override `BASE_URL` if needed.

## Flux manifests

Kubernetes manifests for Flux live under [`deploy/flux`](./deploy/flux).

## CI/CD

The GitHub Actions workflow in [`.github/workflows/build-and-publish.yaml`](./.github/workflows/build-and-publish.yaml):

1. builds and publishes the image to GHCR
2. tags each build with a UTC timestamp plus short SHA
3. updates [`deploy/flux/deployment.yaml`](./deploy/flux/deployment.yaml) to that immutable tag
4. commits the deployment change back to `main`
