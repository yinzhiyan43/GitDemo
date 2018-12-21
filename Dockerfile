FROM nvidia/cuda:8.0-cudnn5-devel-ubuntu16.04 

# start with the nvidia container for cuda 8 with cudnn 5

LABEL maintainer "Woody Fang <yinzhiyan43@163.com>"

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install wget unzip lsof apt-utils lsb-core -y
RUN apt-get install libatlas-base-dev -y
RUN apt-get install libopencv-dev python-opencv python-pip -y   
RUN apt-get install build-essential
RUN apt-get install cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
RUN apt-get install python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev
RUN apt-get install git

RUN mkdir /openpose

RUN cd /openpose

RUN git clone https://github.com/opencv/opencv.git
RUN git clone https://github.com/opencv/opencv_contrib.git
RUN git clone https://github.com/yinzhiyan43/openpose.git

RUN cd /openpose/opencv
RUN git checkout 3.4

RUN cd /openpose/opencv_contrib
RUN git checkout 3.4

RUN cd /openpose/opencv
RUN mkdir build
RUN cd build
RUN cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/usr/local -D OPENCV_EXTRA_MODULES_PATH=/openpose/opencv_contrib/modules ..
RUN make -j
RUN make install

RUN cd /openpose/openpose



WORKDIR openpose
RUN sed -i 's/\<sudo chmod +x $1\>//g' ubuntu/install_caffe_and_openpose_if_cuda8.sh; \
    sed -i 's/\<sudo chmod +x $1\>//g' ubuntu/install_openpose_if_cuda8.sh; \
    sed -i 's/\<sudo -H\>//g' 3rdparty/caffe/install_caffe_if_cuda8.sh; \
    sed -i 's/\<sudo\>//g' 3rdparty/caffe/install_caffe_if_cuda8.sh; \
    sync; sleep 1; ./ubuntu/install_caffe_and_openpose_if_cuda8.sh
