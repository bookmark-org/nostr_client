FROM python:3.11-slim-bullseye

# System-level base config
ENV TZ=UTC \
    LANGUAGE=en_US:en \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    PYTHONIOENCODING=UTF-8 \
    PYTHONUNBUFFERED=1 \
    DEBIAN_FRONTEND=noninteractive \
    APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1

# Install system dependencies
RUN apt-get update -qq \
    && apt-get install -qq -y build-essential libssl-dev gcc g++ pkg-config curl \
    && rm -rf /var/lib/apt/lists/*

# Install Rust and Cargo
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# Set Rust and Cargo PATH
ENV PATH="/root/.cargo/bin:${PATH}"

# Imprimir la versión de Rust y Cargo instalada
RUN rustc --version && cargo --version

# Install Nostcat (Nostr CLI)
RUN cargo install nostcat

# Create the archivebox directory
RUN mkdir /app
WORKDIR /app

# Install python server
RUN pip install Flask
COPY app.py .

ENTRYPOINT ["python3"]
CMD ["app.py"]