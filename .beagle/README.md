# kasm-images

<https://github.com/kasmtech/workspaces-images>

```bash
git remote add upstream git@github.com:kasmtech/workspaces-images.git

git fetch upstream

# 1.16.0
git merge upstream/release/1.16.0
```

## images

<https://kasmweb.com/docs/latest/guide/custom_images.html?utm_campaign=Github&utm_source=github>

如何开启GPU加速
<!-- https://kasmweb.com/docs/latest/how_to/gpu.html -->

```bash
# 在主机上执行
chmod 666 /dev/dri/card0
chmod 666 /dev/dri/renderD128

# 为容器增加环境变量
# 将/dev/input挂载给容器
- name: KASM_EGL_CARD
  value: /dev/dri/card0
- name: KASM_RENDERD
  value: /dev/dri/renderD128
```

```bash
# kasmweb/debian-bookworm-desktop:1.16.0
docker pull kasmweb/debian-bookworm-desktop:1.16.0 && \
docker tag kasmweb/debian-bookworm-desktop:1.16.0 registry.cn-qingdao.aliyuncs.com/wod/kasmweb:debian-bookworm-desktop-1.16.0 && \
docker push registry.cn-qingdao.aliyuncs.com/wod/kasmweb:debian-bookworm-desktop-1.16.0

# kasmweb/chrome:1.16.0
docker pull kasmweb/chrome:1.16.0 && \
docker tag kasmweb/chrome:1.16.0 registry.cn-qingdao.aliyuncs.com/wod/kasmweb:chrome-1.16.0 && \
docker push registry.cn-qingdao.aliyuncs.com/wod/kasmweb:chrome-1.16.0


# kasmweb/steam:1.16.0
docker pull kasmweb/steam:1.16.0 && \
docker tag kasmweb/steam:1.16.0 registry.cn-qingdao.aliyuncs.com/wod/kasmweb:steam-1.16.0 && \
docker push registry.cn-qingdao.aliyuncs.com/wod/kasmweb:steam-1.16.0

# kasmweb/core-debian-bookworm
docker pull kasmweb/core-debian-bookworm:1.16.0 && \
docker tag kasmweb/core-debian-bookworm:1.16.0 registry.cn-qingdao.aliyuncs.com/wod/kasmweb:core-debian-bookworm-1.16.0-amd64 && \
docker push registry.cn-qingdao.aliyuncs.com/wod/kasmweb:core-debian-bookworm-1.16.0-amd64

docker pull --platform=linux/arm64 kasmweb/core-debian-bookworm:1.16.0 && \
docker tag kasmweb/core-debian-bookworm:1.16.0 registry.cn-qingdao.aliyuncs.com/wod/kasmweb:core-debian-bookworm-1.16.0-arm64 && \
docker push registry.cn-qingdao.aliyuncs.com/wod/kasmweb:core-debian-bookworm-1.16.0-arm64
```

## build

```bash
docker pull registry.cn-qingdao.aliyuncs.com/wod/kasmweb:core-debian-bookworm-v1.16.0-amd64 && \
docker build \
  --build-arg BASE=registry.cn-qingdao.aliyuncs.com/wod/kasmweb:core-debian-bookworm-v1.16.0-amd64 \
  --build-arg AUTHOR=mengkzhaoyun@gmail.com \
  --build-arg VERSION=1.16.0 \
  --build-arg TARGETOS=linux \
  --build-arg TARGETARCH=amd64 \
  --build-arg SOCKS5_PROXY=${LOCAL_SOCKS5_PROXY} \
  -t registry.cn-qingdao.aliyuncs.com/wod/kasmweb:debian-bookworm-desktop-v1.16.0-amd64 \
  -f .beagle/kasm-debian-bookworm-desktop.dockerfile \
  .

docker run -it --rm \
  -v $PWD:/go/src/github.com/open-beagle/kasm-images \
  -w /go/src/github.com/open-beagle/kasm-images \
  --entrypoint=/bin/bash \
  registry.cn-qingdao.aliyuncs.com/wod/kasmweb:debian-bookworm-desktop-v1.16.0-amd64

cp -r /usr/share/kasmvnc/www/app/images/icons/ /go/src/github.com/open-beagle/kasm-images/www/app/images/icons/

docker run -it --rm \
  -v $PWD:/go/src/github.com/open-beagle/kasm-images \
  -w /go/src/github.com/open-beagle/kasm-images \
  --entrypoint=/bin/bash \
  -e SOCKS5_PROXY=${LOCAL_SOCKS5_PROXY} \
  registry.cn-qingdao.aliyuncs.com/wod/kasmweb:core-debian-bookworm-v1.16.0-amd64
sudo bash .beagle/build.sh
```

## cache

```bash
# 构建缓存-->推送缓存至服务器
docker run --rm \
  -e PLUGIN_REBUILD=true \
  -e PLUGIN_ENDPOINT=${S3_ENDPOINT_ALIYUN} \
  -e PLUGIN_ACCESS_KEY=${S3_ACCESS_KEY_ALIYUN} \
  -e PLUGIN_SECRET_KEY=${S3_SECRET_KEY_ALIYUN} \
  -e DRONE_REPO_OWNER="open-beagle" \
  -e DRONE_REPO_NAME="kasm-images" \
  -e PLUGIN_MOUNT="./.git" \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  registry.cn-qingdao.aliyuncs.com/wod/devops-s3-cache:1.0

# 读取缓存-->将缓存从服务器拉取到本地
docker run --rm \
  -e PLUGIN_RESTORE=true \
  -e PLUGIN_ENDPOINT=${S3_ENDPOINT_ALIYUN} \
  -e PLUGIN_ACCESS_KEY=${S3_ACCESS_KEY_ALIYUN} \
  -e PLUGIN_SECRET_KEY=${S3_SECRET_KEY_ALIYUN} \
  -e DRONE_REPO_OWNER="open-beagle" \
  -e DRONE_REPO_NAME="kasm-images" \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  registry.cn-qingdao.aliyuncs.com/wod/devops-s3-cache:1.0
```
