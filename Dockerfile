FROM continuumio/miniconda3:latest
LABEL Name=kaggle-conda version=0.0.1

# install libraries
RUN apt update && \
    apt upgrade -y && \
    apt install -y --no-install-recommends \
    build-essential \
    git-all \
    less \
    npm \
    openssh-client \
    procps \
    unzip \
    sudo \
    vim \
    wget \
    zsh && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# create conda envs
# (update and install should be in the same instruction not to use old cache)
RUN conda update -n base -c defaults conda && \
    # add conda-forge channel
    conda config --append channels conda-forge && \
    # create env python3.9 (tensorflow does not support 3.10 yet)
    conda create -n python3.9 python=3.9

# install packages to python3.9
SHELL ["conda", "run", "-n", "python3.9", "/bin/bash", "-c"]
RUN conda install -y \
    # from default
    flake8 \
    nltk \
    numpy \
    matplotlib \
    pandas \
    scipy \
    seaborn \
    # from conda-forge
    albumentations \
    kaggle \
    ipywidgets \
    jupyterlab \
    lightgbm \
    optuna \
    scikit-learn \
    tensorflow \
    timm && \
    # others
    conda install -y pytorch torchvision torchaudio cpuonly -c pytorch

RUN conda install -y \
    category_encoders \
    missingno \
    tqdm && \
    conda install -y plotly -c plotly

# initialize conda in zsh
SHELL [ "/bin/bash", "-c" ]
RUN conda init zsh

# create the user
ARG USERNAME=aiskay
ARG USER_UID=2000
ARG USER_GID=$USER_UID

RUN groupadd --gid ${USER_GID} ${USERNAME} && \
    useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} && \
    # Add sudo support
    echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME

USER aiskay
# system environment variables can only be used in RUN, CMD, ENTRYPOINT
ARG HOME=/home/${USERNAME}

# shell settings (prezto)
SHELL [ "/bin/zsh", "-c" ]
ENV ZDOTDIR ${HOME}/.zsh
RUN git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto" && \
    setopt EXTENDED_GLOB && \
    for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do \
        ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"; \
    done

# for kaggle-api
COPY .kaggle/ ${HOME}/.kaggle/
ENV KAGGLE_CONFIG_DIR ${HOME}/.kaggle/