# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bookworm AS builder

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG TARGETARCH

ENV OS_ARCH="${TARGETARCH:-amd64}"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates curl
RUN --mount=type=secret,id=downloads_url,env=SECRET_DOWNLOADS_URL \
    DOWNLOADS_URL=${SECRET_DOWNLOADS_URL:-${DOWNLOADS_URL}} ; \
    mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ || exit 1 ; \
    COMPONENTS=( \
      "minio-object-browser-2.0.2-1-linux-${OS_ARCH}-debian-12" \
    ) ; \
    for COMPONENT in "${COMPONENTS[@]}"; do \
      if [ ! -f "${COMPONENT}.tar.gz" ]; then \
        curl -SsLf "https://${DOWNLOADS_URL}/${COMPONENT}.tar.gz" -O ; \
        curl -SsLf "https://${DOWNLOADS_URL}/${COMPONENT}.tar.gz.sha256" -O ; \
      fi ; \
      sha256sum -c "${COMPONENT}.tar.gz.sha256" ; \
      tar -zxf "${COMPONENT}.tar.gz" -C /opt/bitnami --strip-components=2 --no-same-owner ; \
      rm -rf "${COMPONENT}".tar.gz{,.sha256} ; \
    done
RUN uninstall_packages curl

######

FROM scratch

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG TARGETARCH

ENV OS_ARCH="${TARGETARCH:-amd64}"

LABEL com.vmware.cp.artifact.flavor="sha256:c50c90cfd9d12b445b011e6ad529f1ad3daea45c26d20b00732fae3cd71f6a83" \
      org.opencontainers.image.base.name="scratch" \
      org.opencontainers.image.created="2025-07-09T01:13:06Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.title="minio-object-browser" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="2.0.2"

COPY rootfs /
COPY --from=builder /opt/bitnami/minio-object-browser/.spdx-minio-object-browser.spdx /opt/bitnami/minio-object-browser/.spdx-minio-object-browser.spdx
COPY --from=builder /opt/bitnami/minio-object-browser/bin/console /opt/bitnami/minio-object-browser/bin/console
COPY --from=builder /opt/bitnami/minio-object-browser/licenses /opt/bitnami/minio-object-browser/licenses

ENV APP_VERSION="2.0.2" \
    BITNAMI_APP_NAME="minio-object-browser" \
    PATH="/opt/bitnami/minio-object-browser/bin:$PATH"

EXPOSE 9090

USER 1001

ENTRYPOINT [ "console" ]
