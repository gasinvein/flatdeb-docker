FROM godebos/debos as builder

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git

ADD patches/ /patches/

RUN git clone -b master https://gitlab.steamos.cloud/steamrt/flatdeb-steam.git /flatdeb-steam && \
    cd /flatdeb-steam && \
    git apply /patches/*.patch

FROM godebos/debos

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        binutils \
        debootstrap \
        dpkg-dev \
        flatpak \
        flatpak-builder \
        ostree \
        pigz \
        python3 \
        python3-debian \
        python3-gi \
        python3-yaml \
        systemd-container \
        time \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=builder /flatdeb-steam/flatdeb /opt/flatdeb

RUN cd /opt/flatdeb && rm -r ci t apps runtimes suites

ENTRYPOINT [ "/opt/flatdeb/run.py" ]
