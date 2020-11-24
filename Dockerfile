FROM godebos/debos as builder

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    mypy \
    pycodestyle \
    pyflakes3 \
    shellcheck \
    make

RUN git clone -b master https://salsa.debian.org/smcv/flatdeb.git /opt/flatdeb && \
    cd /opt/flatdeb && \
    make check

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

COPY --from=builder /opt/flatdeb /opt/flatdeb

RUN cd /opt/flatdeb && rm -r ci t apps runtimes suites

ENTRYPOINT [ "/opt/flatdeb/run.py" ]
