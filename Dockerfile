FROM ubuntu:26.04@sha256:889d056d5c6c0bfb55789ff3710681d68e50713cb562d2196dc07110599c7a6f

ARG DEBIAN_FRONTEND=noninteractive

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TZ=UTC

ARG SNAPSHOT_DATE=20260801T000000Z
RUN sed -i "s|http://us.archive.ubuntu.com/ubuntu/|http://snapshot.ubuntu.com/ubuntu/${SNAPSHOT_DATE}/|g" /etc/apt/sources.list.d/ubuntu.sources \
    && sed -i "s|http://security.ubuntu.com/ubuntu/|http://snapshot.ubuntu.com/ubuntu/${SNAPSHOT_DATE}/|g" /etc/apt/sources.list.d/ubuntu.sources \
    && echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99snapshot \
    && echo 'Acquire::https::Verify-Peer "false";' >> /etc/apt/apt.conf.d/99snapshot

# ===========================================================================
# Install system toolchains
#
# Exact package versions are determined by the frozen APT snapshot.
# ===========================================================================

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        gcc \
        g++ \
        make \
        cmake \
        python3 \
        python3-pip \
        python3-venv \
        nodejs \
        npm \
        golang-go \
        openjdk-25-jdk-headless \
        pkg-config && \
    rm -rf /var/lib/apt/lists/*

# ===========================================================================
# Rust
#
# Install a specific version of rustup and a specific Rust toolchain.
# ===========================================================================

ARG RUSTUP_VERSION=1.29.1
ARG RUST_TOOLCHAIN=1.98.1

ENV RUSTUP_HOME=/opt/rustup \
    CARGO_HOME=/opt/cargo \
    PATH=/opt/cargo/bin:/opt/python-venv/bin:${PATH}

RUN curl \
        --proto '=https' \
        --tlsv1.2 \
        --fail \
        --silent \
        --show-error \
        --location \
        "https://static.rust-lang.org/rustup/archive/${RUSTUP_VERSION}/x86_64-unknown-linux-gnu/rustup-init" \
        --output /tmp/rustup-init && \
    curl \
        --proto '=https' \
        --tlsv1.2 \
        --fail \
        --silent \
        --show-error \
        --location \
        "https://static.rust-lang.org/rustup/archive/${RUSTUP_VERSION}/x86_64-unknown-linux-gnu/rustup-init.sha256" \
        --output /tmp/rustup-init.sha256 && \
    cd /tmp && \
    sha256sum --check rustup-init.sha256 && \
    chmod +x rustup-init && \
    ./rustup-init \
        -y \
        --no-modify-path \
        --profile minimal \
        --default-toolchain "${RUST_TOOLCHAIN}" && \
    rm /tmp/rustup-init /tmp/rustup-init.sha256

# Do not allow Go to silently download a different compiler/toolchain.
ENV GOTOOLCHAIN=local

# Always use the explicitly pinned Rust toolchain.
ENV RUSTUP_TOOLCHAIN=${RUST_TOOLCHAIN}

# ===========================================================================
# Python + Conan
#
# requirements.txt lives next to the Dockerfile.
#
# It contains:
#   - your Python dependencies
#   - Conan
#   - exact package versions
#   - hashes
# ===========================================================================

RUN python3 -m venv /opt/python-venv

# COPY requirements.txt /tmp/requirements.txt

# RUN python -m pip install \
#         --require-hashes \
#         -r /tmp/requirements.txt && \
#     rm /tmp/requirements.txt

RUN python -m pip install conan

# ===========================================================================
# Verify the environment
#
# This does not build application code. It merely causes image creation to
# fail immediately if one of the expected tools was not installed correctly.
# ===========================================================================

RUN set -eux; \
    java -version; \
    javac -version; \
    gcc --version | head -n 1; \
    make --version | head -n 1; \
    cmake --version | head -n 1; \
    python --version; \
    pip --version; \
    conan --version; \
    node --version; \
    npm --version; \
    go version; \
    rustup --version; \
    rustc --version; \
    cargo --version

# ===========================================================================
# Interactive development/build environment
#
# Mount the project directory at /workspace when starting the container.
# ===========================================================================

WORKDIR /workspace

CMD ["/bin/bash"]
