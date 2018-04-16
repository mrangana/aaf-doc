FROM openjdk:8
RUN apt-get update
RUN apt-get install -y softhsm2
RUN apt-get install -y libsofthsm2
RUN apt-get install -y opensc
