FROM centos:6.7

RUN yum -y install centos-release-SCL
RUN yum -y install sudo wget openssh openssh-server passwd expat-devel libcurl-devel perl-devel gettext asciidoc zlib1g-dev ncurses-devel autoconf openssl-devel unzip devtoolset-4; yum clean all

RUN scl enable devtoolset-4 bash

RUN wget https://github.com/git/git/archive/v2.11.0.zip
RUN unzip v2.11.0.zip
RUN rm v2.11.0.zip
WORKDIR ./git-2.11.0
RUN make prefix=/usr all
RUN make prefix=/usr install

WORKDIR ~/
RUN rm -rf git-2.11.0/

RUN mkdir /var/run/sshd
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''

RUN useradd -m pundun && usermod -aG wheel pundun
RUN echo 'pundun:pundun' | chpasswd
RUN echo "%wheel ALL = NOPASSWD:SETENV: /usr/bin/make, /bin/cp, /bin/tar, /bin/rm, /usr/bin/scl" >> /etc/sudoers
RUN sudo mkdir /usr/local/erlang

USER pundun
RUN echo 'source scl_source enable devtoolset-4' >> ~/.bashrc
RUN source scl_source enable devtoolset-4
RUN mkdir /home/pundun/artifacts 
WORKDIR /home/pundun/artifacts/
RUN wget http://erlang.org/download/otp_src_19.1.tar.gz /home/pundun/artifacts/
RUN tar xzf otp_src_19.1.tar.gz
RUN rm otp_src_19.1.tar.gz
WORKDIR /home/pundun/artifacts/otp_src_19.1/
RUN ./configure --prefix=/usr/local/erlang/ --enable-dirty-schedulers
RUN make
RUN sudo make install
WORKDIR /home/pundun/
RUN echo "export PATH=/usr/local/erlang/bin:/home/pundun/bin:/opt/rh/devtoolset-4/root/usr/bin:$PATH" >> .bashrc
ENV PATH=/usr/local/erlang/bin:/home/pundun/bin:/opt/rh/devtoolset-4/root/usr/bin:$PATH
WORKDIR /home/pundun/artifacts/
RUN git clone https://github.com/erlang/rebar3.git
WORKDIR /home/pundun/artifacts/rebar3
RUN git checkout 3.3.2
RUN ./bootstrap
RUN sudo cp rebar3 /usr/local/bin/
WORKDIR /home/pundun/artifacts/
RUN rm -rf rebar3
RUN git clone https://github.com/pundunlabs/pundun.git
WORKDIR /home/pundun/artifacts/pundun/
RUN export DEBUG=1
RUN rebar3 as prod tar
RUN mv _build/prod/rel/pundun/pundun-1.0.0.tar.gz /home/pundun/
WORKDIR /home/pundun/
RUN tar xzf pundun-1.0.0.tar.gz
USER root
EXPOSE 22
EXPOSE 8887
EXPOSE 8886
CMD ["/usr/sbin/sshd", "-D"]
