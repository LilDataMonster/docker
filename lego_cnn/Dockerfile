ARG UBUNTU_VERSION=20.04
ARG TZ=America/New_York

ARG CUDNN=8
ARG CUDA=11.6
FROM nvidia/cuda:${CUDA}.2-cudnn${CUDNN}-devel-ubuntu${UBUNTU_VERSION} as base
# ARCH and CUDA are specified again because the FROM directive resets ARGs
# (but their default value is retained if set previously)
ARG ARCH
ARG CUDA

# Needed for string substitution
SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -yq && apt-get install -yq \
        postgresql-client x11-apps build-essential pkg-config software-properties-common unzip curl gnupg ca-certificates libgl1-mesa-glx ffmpeg python3 python3-pip python3-dev git vim \
        libxi-dev libxxf86vm-dev libgl-dev \
        cuda-command-line-tools-${CUDA/./-} \
        libcublas-${CUDA/./-} \
        cuda-nvrtc-${CUDA/./-} \
        libcufft-${CUDA/./-} \
        libcurand-${CUDA/./-} \
        libcusolver-${CUDA/./-} \
        libcusparse-${CUDA/./-} \
        libfreetype6-dev \
        libhdf5-serial-dev \
        libzmq3-dev \
    && curl -L https://deb.nodesource.com/setup_16.x | bash \
    && apt-get update -yq \
    && apt-get install -yq \
        dh-autoreconf \
        ruby \
        ruby-dev \
        nodejs

# Install TensorRT if not building for PowerPC
# NOTE: libnvinfer uses cuda11.6 versions
ARG LIBNVINFER=8.4.1-1
ARG LIBNVINFER_MAJOR_VERSION=8
RUN [[ "${ARCH}" = "ppc64le" ]] || { apt-get update && \
        apt-get install -y --no-install-recommends libnvinfer${LIBNVINFER_MAJOR_VERSION}=${LIBNVINFER}+cuda${CUDA} \
        libnvinfer-plugin${LIBNVINFER_MAJOR_VERSION}=${LIBNVINFER}+cuda${CUDA} \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*; }


# For CUDA profiling, TensorFlow requires CUPTI.
ENV LD_LIBRARY_PATH /usr/local/cuda/extras/CUPTI/lib64:/usr/local/cuda/lib64:/usr/local/cuda-${CUDA}/lib64:$LD_LIBRARY_PATH

# Link the libcuda stub to the location where tensorflow is searching for it and reconfigure
# dynamic linker run-time bindings
RUN ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1 \
    && echo "/usr/local/cuda/lib64/stubs" > /etc/ld.so.conf.d/z-cuda-stubs.conf \
    && ldconfig

ENV LANG C.UTF-8

# Install python packages
COPY ./requirements.txt .
RUN ln -s $(which python3) /usr/local/bin/python \
    && pip install pip setuptools wheel \
    && pip install --no-cache-dir --extra-index-url https://download.pytorch.org/whl/cu113 -r requirements.txt \
    && jupyter labextension install jupyterlab-plotly@4.14.3 \
    && jupyter labextension install @jupyter-widgets/jupyterlab-manager plotlywidget@4.14.3 \
    && jupyter lab build

# Initalize/install blender
USER root
ENV USER=root
RUN echo "import blenderproc; blenderproc.init()" > /root/init_blenderproc.py && \
    blenderproc run /root/init_blenderproc.py && rm /root/init_blenderproc.py

ENV PATH=$PATH:/root/blender/blender-3.1.0-linux-x64/

#CMD ["python", "samples/lego/lego.py", "--dataset=datasets/lego", "--logs=snapshots", "--enable-augmentation", "--weights=last", "--epochs=40"]
CMD jupyter lab --allow-root --ip 0.0.0.0 --port 8080 --no-browser
