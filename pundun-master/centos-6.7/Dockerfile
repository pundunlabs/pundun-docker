FROM pundunlabs/pundun-ready:centos-6.7

RUN useradd -m pundun
RUN echo 'pundun:pundun' | chpasswd

USER pundun
ENV PATH=/opt/rh/devtoolset-4/root/usr/bin:$PATH
RUN echo 'source scl_source enable devtoolset-4' >> ~/.bashrc
RUN source scl_source enable devtoolset-4
RUN mkdir /home/pundun/artifacts 
WORKDIR /home/pundun/artifacts/
RUN git clone https://github.com/pundunlabs/pundun.git
WORKDIR /home/pundun/artifacts/pundun/
RUN rebar3 as prod tar
RUN mv _build/prod/rel/pundun/pundun-1.0.0.tar.gz /home/pundun/
WORKDIR /home/pundun/
RUN tar xzf pundun-1.0.0.tar.gz
RUN echo "export PATH=/home/pundun/bin:$PATH" >> .bashrc
USER root
EXPOSE 8887 8886
CMD ["/usr/sbin/sshd", "-D"]
