FROM alpine:3

# Install required tools
RUN apk update && apk add --no-cache bash curl jq pandoc docker

# Create setup wrapper in container
RUN echo '#!/bin/bash' > /usr/local/bin/setup && \
    echo 'cd /workspace && ./setup.sh "$@"' >> /usr/local/bin/setup && \
    chmod +x /usr/local/bin/setup

# Create testing wrapper in container
RUN echo '#!/bin/bash' > /usr/local/bin/check && \
    echo 'cd /workspace && ./check.sh "$@"' >> /usr/local/bin/check && \
    chmod +x /usr/local/bin/check

# Create review wrapper in container
RUN echo '#!/bin/bash' > /usr/local/bin/review && \
    echo 'cd /workspace && ./review.sh "$@"' >> /usr/local/bin/review && \
    chmod +x /usr/local/bin/review

# Set working directory
WORKDIR /workspace

# Keep container running
CMD ["tail", "-f", "/dev/null"]
