#!/bin/sh
set -e

# 设置默认值，防止没传环境变量时报错
VITE_GRAPHQL_URI="${VITE_GRAPHQL_URI:-http://50.17.96.210:8082/graphql}"
VITE_SERVER_URI="${VITE_SERVER_URI:-http://50.17.96.210:8082}"

# 在打包好的 JS 文件中寻找占位符，并替换为真实 IP
find /usr/share/nginx/html/assets -name '*.js' -exec sed -i "s|_VITE_GRAPHQL_URI_PLACEHOLDER_|${VITE_GRAPHQL_URI}|g" {} +
find /usr/share/nginx/html/assets -name '*.js' -exec sed -i "s|_VITE_SERVER_URI_PLACEHOLDER_|${VITE_SERVER_URI}|g" {} +

echo "Configured VITE_GRAPHQL_URI=${VITE_GRAPHQL_URI}"
echo "Configured VITE_SERVER_URI=${VITE_SERVER_URI}"

# 启动 Nginx
exec nginx -g 'daemon off;'