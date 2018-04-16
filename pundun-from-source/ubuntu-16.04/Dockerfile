FROM pundunlabs/pundun-ready:ubuntu-16.04
RUN apt-get update
RUN apt-get install -y curl

RUN mkdir artifacts
WORKDIR artifacts/
RUN git clone https://github.com/pundunlabs/pundun.git
WORKDIR pundun/
RUN export DEBUG=1
RUN git checkout -b v1.0.8 v1.0.8
RUN rebar3 as prod tar
RUN mkdir -p /opt/pundun
RUN tar xzf _build/prod/rel/pundun/pundun-1.0.8.tar.gz -C /opt/pundun

RUN useradd -ms /bin/bash pundun
RUN chown -R pundun:pundun /opt/pundun/
RUN echo 'pundun:pundun' | chpasswd

USER pundun
WORKDIR /opt/pundun/lib/pundun-1.0.8/priv/ssh/
RUN ssh-keygen -t rsa -f id_rsa
RUN ssh-keygen -t rsa -f ssh_host_rsa_key

ENV PATH="/opt/pundun/bin:${PATH}"
RUN echo "export PATH=/opt/pundun/bin:$PATH" >> /home/pundun/.bash.profile

RUN echo "-kernel inet_dist_listen_min 50000 inet_dist_listen_max 50001" >> /opt/pundun/releases/1.0.8/vm.args

EXPOSE 8887 8884 4369 50000 50001 
CMD ["pundun", "foreground"]
