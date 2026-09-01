# vllm-transformers

A generalized vLLM serving image for current open-weight models. Built on
top of the upstream [`vllm/vllm-openai`](https://hub.docker.com/r/vllm/vllm-openai)
image, with a current `transformers` (plus `kernels`, `accelerate`, and
`hf-transfer`) layered on so vLLM's **Transformers backend**
(`--model-impl transformers`) can serve architectures that aren't yet
natively ported into vLLM itself.

This image carries no project-specific configuration — no baked-in weights,
no hardware assertions, no serving policy. It's the runtime; what you serve
and how is up to you.

## Usage

```bash
docker pull ghcr.io/benknoll-umn/vllm-transformers:latest

docker run --gpus all --rm -p 8000:8000 \
    -v ~/.cache/huggingface:/root/.cache/huggingface \
    ghcr.io/benknoll-umn/vllm-transformers:latest \
    serve <org/model-name> --model-impl transformers
```

## Tags

Images are built from `main` on every push and tagged with:
- a CalVer date (`YYYY.MM.DD`, e.g. `2026.09.01`) — the day it was built
- `latest`
- the short commit SHA

Pull requests build and smoke-test the image (import check only, since
GitHub-hosted runners have no GPU) but never push.

## Keeping this current

[Dependabot](.github/dependabot.yml) opens weekly PRs for three things:
the pinned base image tag in the `Dockerfile`, the pinned Python
dependencies in `pyproject.toml`, and the GitHub Actions versions in the
workflow itself.

## Versioning note

This image tracks current stable `vllm`/`transformers` releases. It does
not assert a hardware floor or a minimum library version the way a
project-specific deployment might — if you need e.g. a specific compute
capability or CUDA build guaranteed, check that yourself before serving.
