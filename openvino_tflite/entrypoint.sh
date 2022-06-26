#!/bin/bash
set -e

source /home/openvino/openvino_env/bin/activate

exec "$@"
