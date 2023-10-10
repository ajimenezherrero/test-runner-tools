FROM node:20-alpine AS base
ARG NODE_ENV
ENV NODE_ENV ${NODE_ENV}
ENV HOME /app
WORKDIR ${HOME}
COPY package.json tsconfig.json entrypoint.sh ${HOME}/

FROM base AS dependencies
COPY yarn.lock ${HOME}/
RUN yarn install --production
RUN cp -R node_modules prod_node_modules
RUN yarn install --production=false
COPY src/ ${HOME}/src

FROM dependencies AS development
ENTRYPOINT ["./entrypoint.sh", "development"]

FROM dependencies AS builder
RUN yarn build

FROM base AS release
COPY --from=builder /app/build ./build
COPY --from=builder /app/prod_node_modules ./node_modules
ENTRYPOINT ["./entrypoint.sh", "production"]