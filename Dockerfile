FROM node:22-alpine AS build-stage
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# 编译时注入占位符
RUN VITE_GRAPHQL_URI=_VITE_GRAPHQL_URI_PLACEHOLDER_ \
    VITE_SERVER_URI=_VITE_SERVER_URI_PLACEHOLDER_ \
    npm run build

# 生产环境部署阶段
FROM nginx:alpine AS production-stage
COPY nginx-custom.conf /etc/nginx/conf.d/default.conf
COPY --from=build-stage /app/dist /usr/share/nginx/html

# 复制脚本并赋予执行权限
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 8080
# 启动时先执行脚本，再启动Nginx
ENTRYPOINT ["/docker-entrypoint.sh"]