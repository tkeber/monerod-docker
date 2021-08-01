FROM debian:buster-slim AS downloader
ARG VERSION=v0.17.2.0

RUN apt update && apt install -y curl gpg
COPY download_binary.sh binaryfate.asc ./
RUN bash download_binary.sh $VERSION


FROM debian:buster-slim

# Add user and setup directories
RUN useradd -ms /bin/bash monero \
    && mkdir -p /home/monero/.bitmonero \
    && chown -R monero:monero /home/monero/.bitmonero
USER monero

# Switch to home directory and install newly built binary
WORKDIR /home/monero
COPY --chown=monero:monero --from=downloader /usr/local/bin/monerod /usr/local/bin/monerod

# Expose p2p and restricted RPC ports
EXPOSE 18080
EXPOSE 18089

ENTRYPOINT ["monerod"]
CMD ["--non-interactive", "--restricted-rpc", "--rpc-bind-ip=0.0.0.0", "--confirm-external-bind"]
