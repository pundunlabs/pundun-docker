FROM pundunlabs/pundun-ready:ubuntu-16.04

RUN useradd -m pundun
RUN echo 'pundun:pundun' | chpasswd

USER pundun
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
