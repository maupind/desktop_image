## 1. BUILD ARGS
# Allows customization of the produced image by passing different build args.
ARG SOURCE_IMAGE="bazzite"
ARG SOURCE_SUFFIX="-gnome-nvidia"
ARG SOURCE_TAG="latest"

# Define the source image
FROM ghcr.io/ublue-os/${SOURCE_IMAGE}${SOURCE_SUFFIX}:${SOURCE_TAG} AS base

## Context setup with scratch for copying files and running scripts
FROM scratch AS ctx
COPY / /  # Copy everything in the current directory into the scratch context
COPY build.sh /tmp/build.sh

### 3. MODIFICATIONS
# Base image for making modifications and installing packages via build scripts.
FROM base AS modified

# Make necessary arguments available in this stage
ARG IMAGE_NAME
ARG IMAGE_VENDOR
ARG BASE_IMAGE_NAME
ARG IMAGE_FLAVOR
ARG AKMODS_FLAVOR
ARG FEDORA_MAJOR_VERSION
ARG NVIDIA_TYPE
ARG KERNEL="6.10.10-200.fc40.x86_64"
ARG UBLUE_IMAGE_TAG="latest"

# Run the build and cleanup scripts, with each command properly terminated with `&&`.
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    mkdir -p /var/lib/alternatives && \
    /tmp/build.sh && \
    /ctx/build_files/build-dx.sh && \
    mv /var/lib/alternatives /staged-alternatives && \
    /ctx/build_files/cleanup-dx.sh && \
    ostree container commit && \
    mkdir -p /var/lib && mv /staged-alternatives /var/lib/alternatives && \
    mkdir -p /var/tmp && \
    chmod -R 1777 /var/tmp
