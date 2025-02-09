ARG UBUNTU_VERSION=20.04
ARG YA_CORE_VERSION=v0.10.0
ARG YA_WASI_VERSION=0.2.2
ARG YA_VM_VERSION=0.2.10
ARG YA_DIR_BIN=/usr/bin/
ARG YA_DIR_BIN_TMP=/golem-provider-bin/
ARG YA_DIR_PLUGINS=/lib/yagna/plugins/

FROM ubuntu:${UBUNTU_VERSION} as installer
ARG YA_CORE_VERSION
ARG YA_WASI_VERSION
ARG YA_VM_VERSION
ARG YA_DIR_BIN_TMP
ARG YA_DIR_PLUGINS
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update -q \
&& apt-get install -q -y --no-install-recommends \
    wget \
    ca-certificates \
    xz-utils \
    apt-utils \
&& mkdir -p ${YA_DIR_BIN_TMP} \
&& mkdir -p ${YA_DIR_PLUGINS} \
&& wget -q "https://github.com/golemfactory/yagna/releases/download/${YA_CORE_VERSION}/golem-provider-linux-${YA_CORE_VERSION}.tar.gz" \
&& wget -q "https://github.com/golemfactory/ya-runtime-wasi/releases/download/v${YA_WASI_VERSION}/ya-runtime-wasi-linux-v${YA_WASI_VERSION}.tar.gz" \
&& wget -q "https://github.com/golemfactory/ya-runtime-vm/releases/download/v${YA_VM_VERSION}/ya-runtime-vm-linux-v${YA_VM_VERSION}.tar.gz" \
&& tar -zxvf golem-provider-linux-${YA_CORE_VERSION}.tar.gz \
&& tar -zxvf ya-runtime-wasi-linux-v${YA_WASI_VERSION}.tar.gz \
&& tar -zxvf ya-runtime-vm-linux-v${YA_VM_VERSION}.tar.gz \
&& find golem-provider-linux-${YA_CORE_VERSION} -executable -type f -exec cp -t ${YA_DIR_BIN_TMP} {} + \
&& cp -R golem-provider-linux-${YA_CORE_VERSION}/plugins/* ${YA_DIR_PLUGINS} \
&& cp -R ya-runtime-wasi-linux-v${YA_WASI_VERSION}/* ${YA_DIR_PLUGINS} \
&& cp -R ya-runtime-vm-linux-v${YA_VM_VERSION}/* ${YA_DIR_PLUGINS}

FROM ubuntu:${UBUNTU_VERSION}
ARG YA_DIR_BIN
ARG YA_DIR_BIN_TMP
ARG YA_DIR_PLUGINS
RUN apt-get update -q \
&& apt-get install -q -y --no-install-recommends ca-certificates \
&& apt-get clean -y \
&& rm -rf /var/lib/apt/lists/*
COPY --from=installer ${YA_DIR_PLUGINS} ${YA_DIR_PLUGINS}
COPY --from=installer ${YA_DIR_BIN_TMP} ${YA_DIR_BIN}

COPY ya-provider/ /root/.local/share/ya-provider/
COPY healthcheck.sh /root/healthcheck.sh

CMD ["golemsp", "run"]
