FROM nvcr.io/nvidia/cudagl:11.4.1-runtime-ubuntu20.04

ARG DEBIAN_FRONTEND=noninteractive

USER root
RUN apt-get update -yq && apt-get install -yq build-essential python3 python3-venv python3-pip python3-dev libpython3-dev cmake curl && \
    echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | tee /etc/apt/sources.list.d/coral-edgetpu.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get update -yq && apt-get install -yq edgetpu-compiler fastboot udev screen nodejs \
        libcudnn8 libnvinfer8 libnvinfer-plugin8 libnvinfer-bin && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    sh -c "echo 'SUBSYSTEM==\"usb\", ATTR{idVendor}==\"0525\", MODE=\"0664\", GROUP=\"plugdev\", TAG+=\"uaccess\"' >> /etc/udev/rules.d/65-edgetpu-board.rules" && \
    ln -s /usr/lib/x86_64-linux-gnu/libnvinfer_plugin.so.8 /usr/lib/x86_64-linux-gnu/libnvinfer_plugin.so.7 && \
    ln -s /usr/lib/x86_64-linux-gnu/libnvinfer.so.8 /usr/lib/x86_64-linux-gnu/libnvinfer.so.7

# setup venv and python packages
RUN useradd -rm -p "$(openssl passwd -6 lildatamonster)" -d /home/tf -s /bin/bash -g root -G sudo,plugdev,dialout -u 1000 tf && \
    ln -s /usr/bin/python3 /usr/bin/python
SHELL ["/bin/bash", "-c"]
USER tf
WORKDIR /home/tf
COPY ./requirements.txt /
RUN python -m venv tf_env && \
    source /home/tf/tf_env/bin/activate && \
    pip install --no-cache-dir wheel setuptools && \
    pip install --no-cache-dir -r /requirements.txt && \
    jupyter lab build

# setup entrypoint
COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

CMD ["jupyter", "lab", "--ip", "0.0.0.0", "--port", "8888", "--no-browser", "--NotebookApp.token=''"]
