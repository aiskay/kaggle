FROM continuumio/miniconda3:latest
LABEL Name=kaggle-conda version=0.0.1

# install libraries
RUN apt update && \
    apt upgrade -y && \
    apt install -y --no-install-recommends \
    build-essential \
    git-all \
    zsh \
    vim \
    openssh-client \
    wget \
    unzip \
    procps \
    npm && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

ENV USER aisky
ENV ZDOTDIR /home/${USER}/.zsh
# for github ssh connection
COPY .ssh/ /home/${USER}/.ssh/

# shell settings (prezto)
SHELL [ "/bin/zsh", "-c" ]
RUN git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto" && \
    setopt EXTENDED_GLOB && \
    for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do \
        ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"; \
    done

# update conda
RUN conda update -n base -c defaults conda
# add conda-forge channel
RUN conda config --append channels conda-forge

# create env python3.9 (tensorflow does not support 3.10 yet)
RUN conda create -n python3.9 python=3.9
SHELL ["conda", "run", "-n", "python3.9", "/bin/bash", "-c"]
# install main packages seperately
RUN conda install -y \
    # from default
    numpy \
    scipy \
    pandas \
    matplotlib \
    seaborn \
    flake8 \
    # from conda-forge
    kaggle \
    jupyterlab \
    scikit-learn \
    tensorflow && \
    # others
    conda install pytorch torchvision torchaudio cpuonly -c pytorch

RUN conda install -y \
    timm \
    albumentations \
    nltk \
    tqdm && \
    conda install plotly -c plotly

# initialize conda in zsh
RUN conda init zsh

# for kaggle-api
COPY .kaggle/ /home/${USER}/.kaggle/
ENV KAGGLE_CONFIG_DIR /home/${USER}/.kaggle/