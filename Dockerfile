# syntax=docker/dockerfile:1
#
# Generalized vLLM + Transformers serving image for current open-weight
# models. Inherits the CUDA/torch/vLLM stack from the upstream vllm-openai
# image and layers on a current `transformers` (plus the `kernels` package
# vLLM's Transformers backend uses for accelerated attention/MoE ops), so
# architectures not yet natively ported into vLLM can still be served via
# `--model-impl transformers`.
#
# Dependabot bumps this tag automatically (see .github/dependabot.yml) --
# the tag must stay a literal value on this line (no ARG indirection) for
# Dependabot's docker updater to find and update it.
FROM vllm/vllm-openai:v0.28.0-cu129

COPY pyproject.toml /tmp/build/pyproject.toml
RUN pip install --no-cache-dir uv \
 && uv pip install --system --no-cache -r /tmp/build/pyproject.toml \
 && rm -rf /tmp/build

# Paired with the hf-transfer dependency in pyproject.toml.
ENV HF_HUB_ENABLE_HF_TRANSFER=1
