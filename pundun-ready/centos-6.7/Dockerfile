FROM centos:6.7

RUN yum -y update --setopt=tsflags=nodocs
RUN yum -y install --setopt=tsflags=nodocs scl-utils centos-release-SCL
RUN yum -y install --setopt=tsflags=nodocs sudo wget openssh openssh-server passwd expat-devel libcurl-devel perl-devel gettext asciidoc zlib2g-dev ncurses-devel autoconf openssl-devel unzip tar rebar rpm-build
RUN yum -y install --setopt=tsflags=nodocs devtoolset-4-toolchain && yum  clean all
RUN yum -y install --setopt=tsflags=nodocs snappy snappy-devel zlib zlib-devel bzip2 bzip2-devel lz4-devel libasan && yum  clean all
ENV PATH=/opt/rh/devtoolset-4/root/usr/bin:$PATH

RUN wget https://github.com/git/git/archive/v2.11.0.zip
RUN unzip v2.11.0.zip
WORKDIR ./git-2.11.0
RUN make prefix=/usr all
RUN make prefix=/usr install
WORKDIR ~/

RUN mkdir /var/run/sshd
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN git clone https://github.com/gflags/gflags.git
WORKDIR gflags
RUN git checkout v2.0
RUN ./configure && make && sudo make install
WORKDIR ~/

RUN wget https://github.com/facebook/zstd/archive/v1.1.3.tar.gz
RUN mv v1.1.3.tar.gz zstd-1.1.3.tar.gz
RUN tar zxvf zstd-1.1.3.tar.gz
WORKDIR zstd-1.1.3
RUN make && sudo make install
WORKDIR ~/

RUN wget http://erlang.org/download/otp_src_20.0.tar.gz -P .
RUN tar xzfv otp_src_20.0.tar.gz
WORKDIR ./otp_src_20.0/
RUN ./configure --prefix=/usr/local/erlang/
RUN make
RUN sudo make install
ENV PATH=/usr/local/erlang/bin:$PATH
WORKDIR ~/

RUN git clone https://github.com/erlang/rebar3.git
WORKDIR ./rebar3
RUN git fetch --all --tags --prune
RUN git checkout tags/3.4.3 -b 3.4.3
RUN ./bootstrap
RUN cp rebar3 /usr/local/bin/

WORKDIR /root/
RUN wget https://github.com/rebar/rebar/wiki/rebar -P /usr/bin/
RUN chmod +x /usr/bin/rebar
RUN rm -rf otp_src_20.0/ rebar3/ git-2.11.0/ v2.11.0.zip otp_src_20.0.tar.gz
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
