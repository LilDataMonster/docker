FROM nvcr.io/nvidia/tensorflow:22.06-tf2-py3

ARG DEBIAN_FRONTEND=noninteractive

USER root
RUN apt-get update -yq && apt-get install -yq build-essential python3 python3-venv python3-pip python3-dev libpython3-dev cmake curl && \
    echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | tee /etc/apt/sources.list.d/coral-edgetpu.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get update -yq && apt-get install -yq edgetpu-compiler fastboot udev screen nodejs && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN sh -c "echo 'SUBSYSTEM==\"usb\", ATTR{idVendor}==\"0525\", MODE=\"0664\", GROUP=\"plugdev\", TAG+=\"uaccess\"' >> /etc/udev/rules.d/65-edgetpu-board.rules" && \
    udevadm control --reload-rules && udevadm trigger

# setup venv and python packages
RUN useradd -rm -p "$(openssl passwd -6 lildatamonster)" -d /home/tf -s /bin/bash -g root -G sudo,plugdev,dialout -u 1000 tf
USER tf
WORKDIR /home/tf
COPY ./requirements.txt /
RUN python -m venv tf_env && \
    source /home/tf/tf_env/bin/activate && \
    pip install --no-cache-dir wheel setuptools && \
    pip install --no-cache-dir -r /requirements.txt --extra-index-url https://download.pytorch.org/whl/cu116 && \
    jupyter lab build

# setup entrypoint
COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

CMD ["jupyter", "lab", "--ip", "0.0.0.0", "--no-browser", "--NotebookApp.token='lildatamonster'"]
