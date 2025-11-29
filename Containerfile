ARG BASE_IMAGE_REGISTRY
ARG BASE_IMAGE
ARG BASE_IMAGE_VERSION


FROM docker.io/nixpkgs/nix-flakes:latest as nix

COPY ./nix-installers /nix-installers
WORKDIR /nix-installers
RUN nix-build -A lix.rpm && cp -L result lix.rpm


FROM ${BASE_IMAGE_REGISTRY}/${BASE_IMAGE}:${BASE_IMAGE_VERSION}

RUN rpm-ostree install \
	steam-devices \
	niri swaybg SwayNotificationCenter \
	sway rofi-wayland

RUN rpm-ostree override remove \
	firefox \
	firefox-langpacks

COPY ./files /

RUN ostree container commit
