FROM pundunlabs/pundun-ready:centos-6.7

ENV PATH=/opt/rh/devtoolset-4/root/usr/bin:$PATH
RUN echo 'source scl_source enable devtoolset-4' >> ~/.bashrc
RUN source scl_source enable devtoolset-4
RUN mkdir artifacts 
WORKDIR ./artifacts/
RUN git clone https://github.com/pundunlabs/pundun.git
WORKDIR pundun/
RUN make package RELEASE=1
RUN ls package/packages/*.rpm | xargs rpm -Uvh
RUN echo 'pundun:pundun' | chpasswd
RUN mkdir /var/lib/pundun/packages
RUN chown pundun:pundun /var/lib/pundun/packages/
RUN cp package/packages/*.rpm /var/lib/pundun/packages/
RUN /sbin/service pundun start
EXPOSE 8887 8886
CMD ["/usr/sbin/sshd", "-D"]
