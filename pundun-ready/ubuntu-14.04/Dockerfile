FROM ubuntu:14.04

RUN apt-get update
RUN apt-get -y install sudo wget build-essential autoconf libncurses5-dev openssl libssl-dev fop xsltproc unixodbc-dev git openssh-server devscripts debhelper lintian

RUN wget https://github.com/rebar/rebar/wiki/rebar
RUN chmod +x rebar
RUN mv rebar /usr/bin/rebar

RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN mkdir /usr/local/erlang
RUN wget http://erlang.org/download/otp_src_19.2.tar.gz
RUN tar xzfv otp_src_19.2.tar.gz
WORKDIR ./otp_src_19.2/
RUN ./configure --prefix=/usr/local/erlang/ --enable-dirty-schedulers
RUN make
RUN make install
ENV PATH=/usr/local/erlang/bin:$PATH
WORKDIR ~/
RUN git clone https://github.com/erlang/rebar3.git
WORKDIR ./rebar3
RUN git checkout 3.3.2
RUN ./bootstrap
RUN cp rebar3 /usr/bin/
RUN rm -rf otp_src_19.2/ rebar3/ otp_src_19.2.tar.gz
WORKDIR /root/
RUN wget https://github.com/rebar/rebar/wiki/rebar -P /usr/bin/
RUN chmod +x /usr/bin/rebar
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
