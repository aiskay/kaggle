FROM condaforge/mambaforge:latest
LABEL Name=kaggle-miniconda version=0.1
# https://github.com/conda-forge/miniforge-images

# update & install packages
RUN ln -fs /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    apt update && \
    apt upgrade -y && \
    apt install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        git-all \
        less \
        npm \
        openssh-client \
        procps \
        sudo \
        unzip \
        vim \
        wget \
        zsh && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# create the user to install conda
ARG USERNAME=aisky
# should be same as the wsl user id to volume mount
ARG USER_UID=1000
ARG USER_GID=1000

RUN groupadd --gid ${USER_GID} ${USERNAME} && \
    useradd --uid ${USER_UID} --gid ${USER_GID} -o -m ${USERNAME} && \
    # add sudo support
    echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} && \
    chmod 0440 /etc/sudoers.d/${USERNAME} && \
    # add read/write permission to aisky
    chgrp -R ${USER_GID} /opt/conda && \
    chmod 775 -R /opt/conda

USER ${USERNAME}

# create conda envs
# create env python3.11 (tensorflow does not support 3.12 yet)
RUN mamba create -n py311 python=3.11 && \
    mamba install -n py311 -y \
        ipywidgets \
        jupyterlab \
        kaggle \
        lightgbm \
        matplotlib \
        nltk \
        numpy \
        optuna \
        pandas \
        polars \
        pyarrow \
        scikit-learn \
        scipy \
        seaborn \
        tqdm \
        xgboost

# create pytorch environment
RUN CONDA_OVERRIDE_CUDA="11.8" mamba create -n py311-pytorch --clone py311 && \
    mamba install -n py311-pytorch -y -c pytorch -c nvidia \
        pytorch \
        torchvision \
        torchaudio \
        pytorch-cuda=12.1 \
        albumentations \
        imgaug \
        timm

# create tensorflow environment
RUN CONDA_OVERRIDE_CUDA="11.8" mamba create -n py311-tensorflow --clone py311
# mamba install -n py311-tensorflow -y -c main "tensorflow=2.12.0=gpu_py311*"

# shell settings (prezto)
SHELL ["/bin/bash", "-c"]

# system environment variables can only be used in RUN, CMD, ENTRYPOINT
ARG HOME=/home/${USERNAME}

SHELL ["/bin/zsh", "-c"]
ENV ZDOTDIR ${HOME}/.zsh
RUN git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto" && \
    setopt EXTENDED_GLOB && \
    for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do \
        ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"; \
    done

# initialize conda in zsh
RUN mamba init zsh

# for kaggle-api
COPY .kaggle/ ${HOME}/.kaggle/
ENV KAGGLE_CONFIG_DIR ${HOME}/.kaggle/