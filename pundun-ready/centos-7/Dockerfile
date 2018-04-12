FROM centos:7

RUN yum -y install --setopt=tsflags=nodocs centos-release-scl
RUN yum -y update --setopt=tsflags=nodocs
RUN yum -y install --skip-broken --setopt=tsflags=nodocs devtoolset-4
RUN scl enable devtoolset-4 bash
ENV PATH="/opt/rh/devtoolset-4/root/usr/bin:${PATH}"
RUN yum -y install --setopt=tsflags=nodocs sudo which wget openssh openssh-server passwd expat-devel libcurl-devel perl-devel gettext asciidoc zlib1g-dev ncurses-devel autoconf openssl-devel unzip rebar rpm-build; yum clean all
RUN yum -y install --setopt=tsflags=nodocs snappy snappy-devel zlib zlib-devel bzip2 bzip2-devel lz4-devel libasan && yum  clean all

RUN wget https://github.com/git/git/archive/v2.11.0.zip
RUN unzip v2.11.0.zip
WORKDIR ./git-2.11.0
RUN make prefix=/usr all
RUN make prefix=/usr install
WORKDIR /root/

RUN mkdir /var/run/sshd
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN git clone https://github.com/gflags/gflags.git
RUN gcc --version
WORKDIR gflags
RUN git fetch --all --tags --prune
RUN git checkout tags/v2.0 -b v2.0
RUN ./configure
RUN cat config.log
RUN make
RUN sudo make install
WORKDIR /root/

RUN wget https://github.com/facebook/zstd/archive/v1.1.3.tar.gz
RUN mv v1.1.3.tar.gz zstd-1.1.3.tar.gz
RUN tar zxvf zstd-1.1.3.tar.gz
WORKDIR zstd-1.1.3
RUN make && sudo make install
WORKDIR /root/

RUN wget http://erlang.org/download/otp_src_20.0.tar.gz -P .
RUN tar xzfv otp_src_20.0.tar.gz
WORKDIR ./otp_src_20.0/
RUN ./configure --prefix=/usr/local/erlang/
RUN make
RUN sudo make install
ENV PATH=/usr/local/erlang/bin:$PATH
WORKDIR /root/

RUN git clone https://github.com/erlang/rebar3.git
WORKDIR ./rebar3
RUN git fetch --all --tags --prune
RUN git checkout tags/3.4.3 -b 3.4.3
RUN ./bootstrap
RUN cp rebar3 /usr/local/bin/
WORKDIR /root/
RUN wget https://github.com/rebar/rebar/wiki/rebar -P /usr/bin/
RUN chmod +x /usr/bin/rebar

RUN cd /opt \
	&& curl -O https://www.python.org/ftp/python/3.4.2/Python-3.4.2.tar.xz \
	&& tar xf Python-3.4.2.tar.xz && cd Python-3.4.2 \
	&&./configure --prefix=/usr --enable-shared LDFLAGS="-Wl,-rpath /usr/lib" \
	&& make \
	&& make altinstall && cd /opt \
	&& rm -f Python-3.4.2.tar.xz \
	&& rm -rf Python-3.4.2/
RUN which python
RUN /usr/bin/python --version
RUN ls /usr/bin/python*
RUN ln -sf /usr/bin/python3.4 /usr/bin/python
RUN /usr/bin/python --version

RUN rm -rf otp_src_20.0/ rebar3/ git-2.11.0/ v2.11.0.zip otp_src_20.0.tar.gz gflags
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
