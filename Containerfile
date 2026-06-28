ARG BASE_IMAGE_REGISTRY
ARG BASE_IMAGE
ARG BASE_IMAGE_VERSION

FROM fedora:${BASE_IMAGE_VERSION} as selinux

WORKDIR /selinux
COPY ./selinux /selinux

RUN dnf install -y selinux-policy-devel policycoreutils-devel && \
	make -f /usr/share/selinux/devel/Makefile nix.pp

FROM ${BASE_IMAGE_REGISTRY}/${BASE_IMAGE}:${BASE_IMAGE_VERSION}

RUN rpm-ostree install \
	nix nix-daemon \
	steam-devices \
	niri swaybg SwayNotificationCenter \
	git-credential-libsecret git-email

RUN rpm-ostree override remove \
	firefox \
	firefox-langpacks

COPY ./files /

COPY --from=selinux /selinux/nix.pp /usr/share/selinux/packages/
RUN semodule -i /usr/share/selinux/packages/nix.pp

RUN systemctl enable nix-directory.service nix.mount

RUN ostree container commit
