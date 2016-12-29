FROM pundunlabs/pundun-ready:ubuntu-14.04

RUN mkdir artifacts
WORKDIR artifacts/
RUN git clone https://github.com/pundunlabs/pundun.git
WORKDIR pundun/
RUN export DEBUG=1
RUN make package RELEASE=1
RUN mv package/packages/pundun*.deb /var/cache/apt/archives/
RUN ls /var/cache/apt/archives/pundun*.deb | xargs dpkg -i
RUN mkdir /var/lib/pundun/packages
RUN chown pundun:pundun /var/lib/pundun/packages/
RUN cp /var/cache/apt/archives/pundun*.deb /var/lib/pundun/packages/
RUN echo 'pundun:pundun' | chpasswd
EXPOSE 8887 8886 8885 8884
CMD ["/usr/sbin/sshd", "-D"]
