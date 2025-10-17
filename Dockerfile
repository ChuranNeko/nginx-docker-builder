# 使用debian作为基础镜像
FROM debian:bookworm-slim as builder

# 定义参数
ARG NGINX_VERSION=1.27.0
ARG DEBIAN_VERSION=bookworm

# 安装依赖
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    libpcre3-dev \
    zlib1g-dev \
    libssl-dev \
    wget \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# 下载并编译nginx
RUN wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
    tar -zxvf nginx-${NGINX_VERSION}.tar.gz && \
    cd nginx-${NGINX_VERSION} && \
    ./configure \
    --prefix=/usr/local/nginx \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-http_stub_status_module \
    --with-threads \
    --with-stream \
    --with-stream_ssl_module \
    --with-stream_ssl_preread_module && \
    make && \
    make install

# 创建一个新的镜像
FROM debian:bookworm-slim

# 从builder镜像中复制编译好的nginx
COPY --from=builder /usr/local/nginx /usr/local/nginx

# 暴露端口
EXPOSE 80 443

# 启动nginx
CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]