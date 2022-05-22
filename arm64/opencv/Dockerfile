FROM arm64v8/ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

# setup environment
ENV LD_LIBRARY_PATH=/usr/local/lib

# install dependencies
RUN apt update -y && apt upgrade -y && \
    apt install -y python3-dev python3-numpy python3-pip libpython3-dev \
                   libopenblas-dev default-jdk libva-dev libgtk2.0-dev \
                   libtiff-dev zlib1g-dev libjpeg-dev libpng-dev \
                   libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
                   libxvidcore-dev libx264-dev \
                   ffmpeg libavfilter-extra7 \
                   libatlas3-base libatlas-base-dev libavresample-dev \
                   libgstreamer1.0-0 libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-bad1.0-dev gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-doc gstreamer1.0-tools gstreamer1.0-x gstreamer1.0-alsa gstreamer1.0-gl gstreamer1.0-gtk3 gstreamer1.0-qt5 gstreamer1.0-pulseaudio \
                   git pkg-config wget curl vim \
                   apt-utils x11-apps build-essential software-properties-common unzip \
                   libboost-all-dev libusb-1.0-0-dev libeigen3-dev libssl-dev \
                   ca-certificates libboost-regex-dev libgflags-dev nlohmann-json3-dev \
                   automake libtool autoconf libcairo2-dev libpango1.0-dev libglib2.0-dev \
                   libglew-dev libglfw3-dev libgtest-dev \
                   python3-pip python3-distutils \
                   cmake libzmq5 libzmqpp-dev && \
                   python3 -m pip install pip --upgrade && \
                   python3 -m pip install pybind11[global] numpy pytest cython google protobuf && \
    curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && apt install -y nodejs && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ARG COMPILE_THREADS=2

# download, build, and install opencv (this part is time consuming)
# added enabling of NEON for arm64
ARG OPENCV_VERSION=4.5.5
WORKDIR /repo
RUN wget -O opencv.tar.gz https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.tar.gz && \
    wget -O opencv_contrib.tar.gz https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.tar.gz && \
    tar xf opencv.tar.gz && tar xf opencv_contrib.tar.gz && rm opencv.tar.gz opencv_contrib.tar.gz && \
    mkdir -p opencv-${OPENCV_VERSION}/build && cd opencv-${OPENCV_VERSION}/build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
          -D CMAKE_INSTALL_PREFIX=/opt/opencv-${OPENCV_VERSION} \
          -D OPENCV_EXTRA_MODULES_PATH=/repo/opencv_contrib-${OPENCV_VERSION}/modules \
          -D OPENCV_ENABLE_NONFREE=ON \
          -D BUILD_TESTS=OFF \
          -D BUILD_DOCS=OFF \
          -D ENABLE_NEON=ON \
          -D PYTHON3_INCLUDE_PATH=/usr/include/python3.8 \
          -D PYTHON3_LIBRARIES=/usr/lib/*-linux-gnu/libpython3.8.so \
          -D PYTHON3_NUMPY_INCLUDE_DIRS=/usr/lib/python3/dist-packages/numpy/core/include \
          -D BUILD_OPENCV_PYTHON2=OFF \
          -D BUILD_OPENCV_PYTHON3=ON \
          -D WITH_GSTREAMER=ON \
          -D BUILD_EXAMPLES=OFF .. && \
    make -j ${COMPILE_THREADS} && make install && \
    cp lib/python3/cv2.cpython-*-linux-gnu.so /usr/lib/python3/dist-packages/ && \
    ln -s /usr/bin/python3 /usr/bin/python

ENV OpenCV_DIR=/opt/opencv-${OPENCV_VERSION}
