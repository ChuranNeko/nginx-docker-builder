# 使用 Docker 快速编译 Nginx

此仓库旨在提供一种使用 Docker 编译 Nginx 的方法，以保持系统环境的干净整洁，并方便快速部署。

> 目前只支持 Debian 系的 Linux。如果你不想自己编译，可以直接在 [这里](https://github.com/ChuranNeko/nginx-docker-builder/actions/) 获取到已经编译好的产物。

## 使用方法

### 1. 安装 Docker

如果你的系统中还没有安装 Docker，请先安装 Docker。

```bash
# 使用官方提供的脚本进行安装
curl -fsSL https://get.docker.com | bash -s docker
```

为了加快 Docker 镜像的下载速度，你可以配置国内的镜像源。编辑 `/etc/docker/daemon.json` 文件：

```bash
sudo nano /etc/docker/daemon.json
```

添加以下内容：

```json
{
  "registry-mirrors": ["https://docker.1ms.run"]
}
```

然后重载 Docker 服务：

```bash
sudo systemctl daemon-reload
sudo systemctl restart docker
```

### 2. 克隆项目

```bash
git clone https://github.com/ChuranNeko/nginx-docker-builder.git
cd nginx-docker-builder
```

### 3. 编译 Nginx

你可以通过设置环境变量 `DEBIAN_VERSION` 和 `NGINX_VERSION` 来指定 Debian 版本和 Nginx 版本。

```bash
export DEBIAN_VERSION=$(lsb_release -cs)
export NGINX_VERSION=1.27.0
docker-compose run --build --rm nginx-builder
docker rmi nginx-builder:${NGINX_VERSION}-${DEBIAN_VERSION}
```

编译完成后，编译好的 Nginx 文件将位于 `output` 目录中。

### 4. 安装 Nginx

```bash
sudo mv ./output /usr/local/nginx
sudo mv ./nginx.service /etc/systemd/system/
```

### 5. 注册并启动服务

```bash
sudo systemctl daemon-reload
sudo systemctl enable nginx.service
sudo systemctl start nginx.service
```

现在，你可以通过 `systemctl status nginx.service` 来查看 Nginx 服务的状态。

## 卸载

如果你想卸载通过此项目编译的 Nginx，请执行以下命令：

```bash
sudo systemctl stop nginx.service
sudo systemctl disable nginx.service
sudo rm /etc/systemd/system/nginx.service
sudo rm -rf /usr/local/nginx
```

## 贡献

欢迎为此项目做出贡献！如果你有任何建议或发现了 bug，请随时提交 issue 或 pull request。

## 许可证

此项目采用 [MIT 许可证](LICENSE)。
