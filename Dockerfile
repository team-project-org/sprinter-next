FROM node:18-alpine as builder
RUN mkdir /turbo
WORKDIR /turbo
ADD . /turbo
RUN npm install
RUN npm run build

FROM node:18-alpine

# for front
COPY --from=builder /turbo/apps/front/package.json /turbo/apps/front/package.json
COPY --from=builder /turbo/apps/front/.next /turbo/apps/front/.next
COPY --from=builder /turbo/apps/front/node_modules /turbo/apps/front/node_modules
COPY --from=builder /turbo/apps/front/public /turbo/apps/front/public
COPY --from=builder /turbo/apps/front/turbo.json /turbo/apps/front/turbo.json
COPY --from=builder /turbo/apps/front/next.config.json /turbo/apps/front/next.config.json

# for server
COPY --from=builder /turbo/apps/server/package.json /turbo/apps/server/package.json
COPY --from=builder /turbo/apps/server/dist /turbo/apps/server/dist
COPY --from=builder /turbo/apps/server/node_modules /turbo/apps/server/node_modules
COPY --from=builder /turbo/apps/server/turbo.json /turbo/apps/server/turbo.json
COPY --from=builder /turbo/apps/server/tsup.config.json /turbo/apps/server/tsup.config.json

# for turborepo
COPY --from=builder /turbo/package.json /turbo/package.json
COPY --from=builder /turbo/package-lock.json /turbo/package-lock.json
COPY --from=builder /turbo/turbo.json /turbo/turbo.json
COPY --from=builder /turbo/node_modules /turbo/node_modules
COPY --from=builder /turbo/packages /turbo/packages
COPY --from=builder /turbo/turbo.json /turbo/turbo.json

EXPOSE 3000 5000
CMD ["node", "run", "start"]