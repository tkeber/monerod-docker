FROM debian:buster-slim

# Install remaining dependencies
RUN apt-get update && apt-get install --no-install-recommends -y libnorm-dev libpgm-dev libgssapi-krb5-2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Add user and setup directories for monerod
RUN useradd -ms /bin/bash monero && mkdir -p /home/monero/.bitmonero \
    && chown -R monero:monero /home/monero/.bitmonero
USER monero

# Switch to home directory and install newly built monerod binary
WORKDIR /home/monero
COPY --chown=monero:monero monerod /usr/local/bin/monerod

# Expose p2p and restricted RPC ports
EXPOSE 18080
EXPOSE 18089

# Start monerod with required --non-interactive flag and sane defaults that are overridden by user input (if applicable)
ENTRYPOINT ["monerod"]
CMD ["--non-interactive", "--restricted-rpc", "--rpc-bind-ip=0.0.0.0", "--confirm-external-bind"]