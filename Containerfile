ARG BASE_IMAGE_REGISTRY=quay.io/fedora-ostree-desktops
ARG BASE_IMAGE=kinoite
ARG BASE_IMAGE_VERSION=42
FROM ${BASE_IMAGE_REGISTRY}/${BASE_IMAGE}:${BASE_IMAGE_VERSION}

RUN rpm-ostree override remove \
	firefox \
	firefox-langpacks

RUN rpm-ostree install \
	alacritty \
	steam-devices

RUN install -d -m 0755 /nix

RUN ostree container commit
