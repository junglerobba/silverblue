ARG BASE_IMAGE_REGISTRY
ARG BASE_IMAGE
ARG BASE_IMAGE_VERSION

FROM ${BASE_IMAGE_REGISTRY}/${BASE_IMAGE}:${BASE_IMAGE_VERSION}

RUN rpm-ostree install \
	steam-devices \
	niri swaybg SwayNotificationCenter \
	sway rofi-wayland

RUN rpm-ostree override remove \
	firefox \
	firefox-langpacks

RUN install -d -m 0755 /nix

COPY ./files /

RUN ostree container commit
