FROM ghcr.io/lildatamonster/docker/openvino_dev:latest

ARG DEBIAN_FRONTEND=noninteractive

# setup system packages
USER root
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
    echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | tee /etc/apt/sources.list.d/coral-edgetpu.list && \
    apt-get update -yq && apt-get install -yq edgetpu-compiler

# setup venv and python packages
USER openvino
WORKDIR /home/openvino
COPY ./requirements.txt /
RUN python -m venv openvino_env && \
    source /home/openvino/openvino_env/bin/activate && \
    pip install --no-cache-dir mendel-development-tool pycoral && \
    pip install --no-cache-dir -r /requirements.txt && \
    rm /requirements.txt && echo 'export PATH="$PATH:$HOME/.local/bin"' >> ~/.bash_profile && \
    jupyter lab build

# setup entrypoint
COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

CMD ["jupyter", "lab", "--ip", "0.0.0.0", "--allow-root"]
