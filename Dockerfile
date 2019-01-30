FROM i386/ubuntu:16.04

#docker build -t code-browser:2.18 .
#docker run --rm -h code-browser -v ~:/home/developer code-browser:2.18 code-browser

RUN apt-get update && \
  apt-get install -y \
    sudo bzip2 \
    libgtk2.0-0 \
    libpangoxft-1.0-0 \
    libpangox-1.0-0

COPY code-browser-2.18-pkg.tar.bz2 /code-browser-2.18-pkg.tar.bz2
RUN tar jxvf /code-browser-2.18-pkg.tar.bz2
RUN cd /packages && ./linkit code-browser-2.18
RUN rm /code-browser-2.18-pkg.tar.bz2

# Replace 1000 with your user / group id
RUN export uid=503 gid=20 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer

USER developer
ENV HOME /home/developer
ENV DISPLAY docker.for.mac.localhost:0
CMD /usr/bin/code-browser
