FROM archlinux:base

# Install needed tools
RUN pacman -Sy --noconfirm \
    fzf \
    vi \
    exa \
    bat \
    feh \
    mpv \
    zathura \
    unzip \
    tar \
    file \
    grep \
    xorg-xmessage

# Create test user
RUN useradd -m francois
USER francois
WORKDIR /home/francois

# Set default editor to nano
ENV EDITOR=vi

# Create test environment
RUN mkdir -p test_env/docs test_env/images test_env/archives && \
    echo "hello world" > test_env/docs/notes.txt && \
    echo "just an image placeholder" > test_env/images/fake.png && \
    echo "some text" > test_env/archives/test.txt && \
    tar -cf test_env/archives/archive.tar -C test_env/archives test.txt && \
    touch test_env/sample1.txt test_env/sample2.md

# Shell by default
CMD [ "bash" ]

