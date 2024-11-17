FROM mambaorg/micromamba:1.4.9
COPY --chown=$MAMBA_USER:$MAMBA_USER align-env.yaml /tmp/align-env.yaml
RUN micromamba install -y -n base -f /tmp/env.yml &&
    micromamba clean --all --yes