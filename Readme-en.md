# Build Nginx with Docker Quickly

This repository provides a method to compile Nginx using Docker, aiming to keep the system environment clean and facilitate rapid deployment.

> Currently, it only supports Debian-based Linux distributions. If you don't want to compile it yourself, you can get the pre-compiled artifacts directly from [here](https://github.com/ChuranNeko/nginx-docker-builder/actions/).

## How to Use

### 1. Install Docker

If you don't have Docker installed on your system, please install it first.

```bash
# Install using the official script
curl -fsSL https://get.docker.com | bash -s docker
```

To speed up Docker image downloads, you can configure a domestic mirror source. Edit the `/etc/docker/daemon.json` file:

```bash
sudo nano /etc/docker/daemon.json
```

Add the following content:

```json
{
  "registry-mirrors": ["https://docker.1ms.run"]
}
```

Then, reload the Docker service:

```bash
sudo systemctl daemon-reload
sudo systemctl restart docker
```

### 2. Clone the Project

```bash
git clone https://github.com/ChuranNeko/nginx-docker-builder.git
cd nginx-docker-builder
```

### 3. Compile Nginx

You can specify the Debian and Nginx versions by setting the `DEBIAN_VERSION` and `NGINX_VERSION` environment variables.

```bash
export DEBIAN_VERSION=$(lsb_release -cs)
export NGINX_VERSION=1.27.0
docker-compose run --build --rm nginx-builder
docker rmi nginx-builder:${NGINX_VERSION}-${DEBIAN_VERSION}
```

After the compilation is complete, the compiled Nginx files will be in the `output` directory.

### 4. Install Nginx

```bash
sudo mv ./output /usr/local/nginx
sudo mv ./nginx.service /etc/systemd/system/
```

### 5. Register and Start the Service

```bash
sudo systemctl daemon-reload
sudo systemctl enable nginx.service
sudo systemctl start nginx.service
```

Now, you can check the status of the Nginx service with `systemctl status nginx.service`.

## Uninstall

If you want to uninstall the Nginx compiled with this project, execute the following commands:

```bash
sudo systemctl stop nginx.service
sudo systemctl disable nginx.service
sudo rm /etc/systemd/system/nginx.service
sudo rm -rf /usr/local/nginx
```

## Contributing

Contributions are welcome! If you have any suggestions or find any bugs, please feel free to submit an issue or pull request.

## License

This project is licensed under the [MIT License](LICENSE).
