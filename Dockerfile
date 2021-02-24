FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

ARG USERNAME=vscode
ARG UID=1000
ARG GID=${UID}

ENV HOME=/home/${USERNAME}

RUN apt update \
    && apt -y install --no-install-recommends \
    ca-certificates \
    software-properties-common \
    curl \
    locales \
    sudo \
    git

RUN add-apt-repository --enable-source --yes "ppa:marutter/rrutter4.0" \
    && add-apt-repository --enable-source --yes "ppa:c2d4u.team/c2d4u4.0+"

RUN apt update \
    && apt -y install --no-install-recommends \
    r-base \
    r-recommended \
    r-cran-formatr\
    r-cran-rmarkdown \
    r-cran-knitr \
    r-cran-tinytex \
    r-cran-tikzdevice \
    r-cran-highr \
    r-cran-rcurl

RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen en_US.utf8 \
    && /usr/sbin/update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

RUN groupadd --gid ${GID} ${USERNAME} \
    && useradd -s /bin/bash --uid ${UID} --gid ${GID} -m ${USERNAME} \
    && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME} \
    && chown ${USERNAME}:${USERNAME} ${HOME}

ENV TZ UTC

RUN sudo rm -rf /var/lib/apt/lists/* \
    && curl -fsSL https://raw.github.com/ohmybash/oh-my-bash/master/tools/install.sh | bash || true

COPY --chown=${USERNAME}:${USERNAME} ./config/.bashrc ${HOME}/.bashrc

ENV DEBIAN_FRONTEND=dialog

CMD ["bash"]