FROM --platform=linux/amd64 debian:bookworm-slim 
# Set the workdir to $HOME
WORKDIR /root
# Minimal deps to fetch installer (curl) and run solana-test-validator (bzip2)
RUN apt -y update && apt -y install curl bzip2
# Fetch and run the installer
RUN sh -c "$(curl -sSfL https://release.solana.com/v1.18.22/install)"
# Add active release bin to our path
ENV PATH="/root/.local/share/solana/install/active_release/bin:${PATH}"

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
