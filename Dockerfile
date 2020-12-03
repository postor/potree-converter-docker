FROM ubuntu:16.04

RUN apt-get update && apt install software-properties-common -y
RUN add-apt-repository ppa:ubuntu-toolchain-r/test -y

RUN apt-get update && apt-get install -y g++-9 git cmake libboost-all-dev

RUN mkdir /data

WORKDIR /data

RUN git clone https://github.com/m-schuetz/LAStools.git
WORKDIR /data/LAStools/LASzip
COPY laszip/CMakeLists.txt CMakeLists.txt
RUN mkdir build
RUN cd build && CXX=g++-9 cmake -DCMAKE_BUILD_TYPE=Release ..
RUN cd build && CXX=g++-9 make

RUN mkdir ./PotreeConverter
WORKDIR /data/PotreeConverter
ADD . /data/PotreeConverter
RUN mkdir build
RUN cd build && CXX=g++-9 cmake -DCMAKE_BUILD_TYPE=Release -DLASZIP_INCLUDE_DIRS=/data/LAStools/LASzip/dll -DLASZIP_LIBRARY=/data/LAStools/LASzip/build/src/liblaszip.so .. 
RUN cd build && CXX=g++-9 make
RUN cp -R /data/PotreeConverter/PotreeConverter/resources/ /data

