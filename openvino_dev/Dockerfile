#FROM ubuntu:20.04
FROM openvino/ubuntu20_dev

ARG DEBIAN_FRONTEND=noninteractive

# setup system packages
USER root
RUN apt-get update -yq && apt-get install -yq curl build-essential python3 python3-pip python3-dev libpython3-dev cmake curl && \
    curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && apt install -y nodejs && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    ln -s /usr/bin/python3 /usr/bin/python

# setup venv and python packages
USER openvino
WORKDIR /home/openvino
COPY ./requirements.txt /
RUN python -m venv openvino_env && \
    source /home/openvino/openvino_env/bin/activate && \
    pip install wheel && \
    pip install -r /requirements.txt --extra-index-url https://download.pytorch.org/whl/cu113 && \
    jupyter lab build

# setup entrypoint
COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

CMD ["jupyter", "lab", "--ip", "0.0.0.0", "--allow-root"]
