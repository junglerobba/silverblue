ARG BASE_IMAGE_REGISTRY=quay.io/fedora-ostree-desktops
ARG BASE_IMAGE=silverblue
ARG BASE_IMAGE_VERSION=42


FROM docker.io/nixpkgs/nix-flakes:latest as nix

COPY ./nix-installers /nix-installers
WORKDIR /nix-installers
RUN nix-build -A lix.rpm && cp -L result lix.rpm


FROM ${BASE_IMAGE_REGISTRY}/${BASE_IMAGE}:${BASE_IMAGE_VERSION}

COPY --from=nix /nix-installers/lix.rpm /tmp/lix.rpm
RUN rpm-ostree install \
	/tmp/lix.rpm \
	steam-devices \
	niri swaybg SwayNotificationCenter \
	sway rofi-wayland \
	&& rm /tmp/lix.rpm

RUN install -d -m 0755 /nix /nix/var/nix/daemon-socket /nix/var/nix/gcroots/per-user /nix/var/nix/profiles/per-user
RUN systemctl enable nix.mount nix-daemon.socket nix-daemon.service

RUN rpm-ostree override remove \
	firefox \
	firefox-langpacks

RUN ostree container commit
