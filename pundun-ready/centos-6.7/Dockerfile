FROM centos:6.7

RUN yum -y install centos-release-SCL
RUN yum -y install sudo wget openssh openssh-server passwd expat-devel libcurl-devel perl-devel gettext asciidoc zlib1g-dev ncurses-devel autoconf openssl-devel unzip devtoolset-4; yum clean all

RUN scl enable devtoolset-4 bash

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

RUN wget http://erlang.org/download/otp_src_19.1.tar.gz -P .
RUN tar xzfv otp_src_19.1.tar.gz
WORKDIR ./otp_src_19.1/
RUN ./configure --prefix=/usr/local/erlang/ --enable-dirty-schedulers
RUN make
RUN sudo make install
ENV PATH=/usr/local/erlang/bin:$PATH
WORKDIR ~/

RUN git clone https://github.com/erlang/rebar3.git
WORKDIR ./rebar3
RUN git checkout 3.3.2
RUN ./bootstrap
RUN cp rebar3 /usr/local/bin/
WORKDIR ~/

RUN rm -rf otp_src_19.1/ rebar3/ git-2.11.0/ v2.11.0.zip otp_src_19.1.tar.gz
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
