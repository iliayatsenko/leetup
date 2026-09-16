FROM alpine:3

# Install required tools
RUN apk update && apk add --no-cache bash curl jq pandoc docker

# Create setup wrapper in container
RUN echo '#!/bin/bash' > /usr/local/bin/setup && \
    echo 'cd /workspace && ./scripts/setup.sh "$@"' >> /usr/local/bin/setup && \
    chmod +x /usr/local/bin/setup

# Create testing wrapper in container
RUN echo '#!/bin/bash' > /usr/local/bin/check && \
    echo 'cd /workspace && ./scripts/check.sh "$@"' >> /usr/local/bin/check && \
    chmod +x /usr/local/bin/check

# Create debugging wrapper in container
RUN echo '#!/bin/bash' > /usr/local/bin/debug && \
    echo 'cd /workspace && ./scripts/debug.sh "$@"' >> /usr/local/bin/debug && \
    chmod +x /usr/local/bin/debug

# Create hints generation wrapper in container
RUN echo '#!/bin/bash' > /usr/local/bin/hints && \
    echo 'cd /workspace && ./scripts/hints.sh "$@"' >> /usr/local/bin/hints && \
    chmod +x /usr/local/bin/hints

# Create review wrapper in container
RUN echo '#!/bin/bash' > /usr/local/bin/review && \
    echo 'cd /workspace && ./scripts/review.sh "$@"' >> /usr/local/bin/review && \
    chmod +x /usr/local/bin/review

# Set working directory
WORKDIR /workspace

# Keep container running
CMD ["tail", "-f", "/dev/null"]
