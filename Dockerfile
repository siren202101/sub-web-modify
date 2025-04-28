# 构建阶段
FROM node:18-alpine AS build
WORKDIR /app
RUN yarn config set registry https://registry.npmmirror.com
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile
RUN npx update-browserslist-db@latest
COPY . .
RUN yarn build

# 生产阶段
FROM nginx:1.24-alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
