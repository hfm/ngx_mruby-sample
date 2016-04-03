FROM centos:7
MAINTAINER hfm.garden@gmail.com

RUN yum -y install git wget gcc make patch rake which openssl-devel mercurial bison

ENV NGX_MRUBY_VERSION v1.17.0

RUN git clone --depth 1 --branch $NGX_MRUBY_VERSION --single-branch https://github.com/matsumoto-r/ngx_mruby.git /usr/local/src/ngx_mruby
ENV NGINX_CONFIG_OPT_ENV --with-http_stub_status_module --with-http_ssl_module --prefix=/usr/local/nginx --with-http_realip_module --with-http_addition_module --with-http_sub_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_random_index_module --with-http_secure_link_module
WORKDIR /usr/local/src/ngx_mruby
ADD build_config.rb /usr/local/src/ngx_mruby/build_config.rb
RUN sh build.sh && make install

EXPOSE 80
EXPOSE 443

ONBUILD ADD hook /usr/local/nginx/hook
ONBUILD ADD conf /usr/local/nginx/conf
ONBUILD ADD conf/nginx.conf /usr/local/nginx/conf/nginx.conf

CMD ["/usr/local/nginx/sbin/nginx"]
