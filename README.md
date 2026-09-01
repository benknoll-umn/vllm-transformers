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
- a CalVer month (`YYYY.MM`, e.g. `2026.09`) — the month it was built; a second push in the same month overwrites this tag, but `latest` and the sha tag still disambiguate which build is newest
- `latest`
- the short commit SHA
- `vllm<version>-transformers<version>` (e.g. `vllm0.28.0-transformers5.16.1`) — the actual versions installed inside that image, read back from the running container after build

Pull requests build and smoke-test the image (import check only, since
GitHub-hosted runners have no GPU) but never push.

## Keeping this current

[Dependabot](.github/dependabot.yml) opens monthly PRs for three things:
the pinned base image tag in the `Dockerfile`, the pinned Python
dependencies in `pyproject.toml`, and the GitHub Actions versions in the
workflow itself. Each ecosystem is grouped, so if several dependencies in
the same ecosystem have updates in the same run, they land in one PR
instead of one per dependency.

[A workflow](.github/workflows/dependabot-auto-merge.yml) auto-approves
every Dependabot PR and auto-merges it if the highest version bump in the
PR is patch-level ([GitHub's documented pattern](https://docs.github.com/en/code-security/tutorials/secure-your-dependencies/automate-dependabot-with-actions)).
Minor/major bumps are approved but left for a manual merge. This relies on
the repo's "Allow auto-merge" setting being enabled; it does **not** set up
branch protection/required status checks, so a merge can land before the
`docker-publish` workflow finishes — add that separately if you want the
build to gate the merge.

## Versioning note

This image tracks current stable `vllm`/`transformers` releases. It does
not assert a hardware floor or a minimum library version the way a
project-specific deployment might — if you need e.g. a specific compute
capability or CUDA build guaranteed, check that yourself before serving.
