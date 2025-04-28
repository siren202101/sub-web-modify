# 使用 Node.js 官方镜像
FROM node:18-alpine AS build

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 yarn.lock
COPY package.json yarn.lock ./

# 安装依赖
RUN yarn install

# 复制应用代码
COPY . .

# 执行构建命令
RUN yarn build

# 使用 Nginx 镜像来提供静态文件
FROM nginx:1.24-alpine

# 复制构建的文件到 Nginx 的 web 根目录
COPY --from=build /app/dist /usr/share/nginx/html

# 暴露 80 端口
EXPOSE 80

# 启动 Nginx
CMD ["nginx", "-g", "daemon off;"]
