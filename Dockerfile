FROM node:22.14.0-alpine3.21 AS builder

RUN apk add --no-cache git

WORKDIR /opt/jaeger-ui

COPY . /opt/jaeger-ui

RUN yarn install || true
ENV HOST=0.0.0.0
RUN yarn build

FROM nginx:stable-alpine

LABEL org.label-schema.description="Jaeger UI Docker Image"
LABEL org.label-schema.name="randoli/jaeger-ui"
LABEL org.label-schema.schema-version="1.0.0"
LABEL org.label-schema.vcs-url="https://github.com/randoli/jaeger-ui"
LABEL org.opencontainers.image.source="https://github.com/randoli/jaeger-ui"
LABEL org.opencontainers.image.description="Jaeger UI Docker image"

COPY --from=builder /opt/jaeger-ui/packages/jaeger-ui/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]