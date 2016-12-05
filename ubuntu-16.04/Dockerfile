FROM ubuntu:16.04

RUN apt-get update
RUN apt-get -y install sudo wget build-essential autoconf libncurses5-dev openssl libssl-dev fop xsltproc unixodbc-dev git openssh-server

RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN useradd -m pundun && echo "pundun:pundun" | chpasswd && adduser pundun sudo
RUN echo "pundun ALL = NOPASSWD: /usr/bin/make, /bin/cp, /bin/tar, /bin/rm" >> /etc/sudoers
RUN sudo mkdir /usr/local/erlang
USER pundun
RUN mkdir /home/pundun/artifacts 
WORKDIR /home/pundun/artifacts/
RUN wget http://erlang.org/download/otp_src_19.1.tar.gz
RUN tar xzf otp_src_19.1.tar.gz
WORKDIR /home/pundun/artifacts/otp_src_19.1/
RUN ./configure --prefix=/usr/local/erlang/ --enable-dirty-schedulers
RUN make
RUN sudo make install
WORKDIR /home/pundun/
RUN echo "export PATH=/usr/local/erlang/bin:/home/pundun/bin:$PATH" > .bashrc
ENV PATH=/usr/local/erlang/bin:/home/pundun/bin:$PATH
WORKDIR /home/pundun/artifacts/
RUN git clone https://github.com/erlang/rebar3.git
WORKDIR /home/pundun/artifacts/rebar3
RUN git checkout 3.3.2
RUN ./bootstrap
RUN sudo cp rebar3 /usr/local/bin/
WORKDIR /home/pundun/artifacts/
RUN git clone https://github.com/pundunlabs/pundun.git
WORKDIR /home/pundun/artifacts/pundun/
RUN rebar3 as prod tar
RUN mv _build/prod/rel/pundun/pundun-1.0.0.tar.gz /home/pundun/
WORKDIR /home/pundun/
RUN tar xzf pundun-1.0.0.tar.gz
USER root
EXPOSE 22
EXPOSE 8887
EXPOSE 8886
CMD ["/usr/sbin/sshd", "-D"]
