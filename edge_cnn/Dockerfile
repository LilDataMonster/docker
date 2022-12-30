FROM nvcr.io/nvidia/tensorflow:22.12-tf2-py3

ARG DEBIAN_FRONTEND=noninteractive

USER root
RUN apt-get update -yq && apt-get install -yq build-essential python3 python3-venv python3-pip python3-dev libpython3-dev cmake curl && \
    echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | tee /etc/apt/sources.list.d/coral-edgetpu.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get update -yq && apt-get install -yq edgetpu-compiler fastboot udev screen nodejs && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    sh -c "echo 'SUBSYSTEM==\"usb\", ATTR{idVendor}==\"0525\", MODE=\"0664\", GROUP=\"plugdev\", TAG+=\"uaccess\"' >> /etc/udev/rules.d/65-edgetpu-board.rules"

# setup venv and python packages
COPY ./requirements.txt /
RUN pip install --no-cache-dir wheel setuptools && \
    pip install --no-cache-dir -r /requirements.txt -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html

#RUN jupyter lab build --dev-build=False

CMD ["jupyter", "lab", "--ip", "0.0.0.0", "--port", "8888", "--no-browser", "--NotebookApp.token=''"]
