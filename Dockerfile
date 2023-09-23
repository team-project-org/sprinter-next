FROM node:18-alpine as builder

RUN mkdir /turbo
WORKDIR /turbo
ADD . /turbo

RUN npm i @esbuild/linux-x64 -D
RUN npm install
RUN npm run build

FROM node:18-alpine
WORKDIR /turbo

# for front
COPY --from=builder /turbo/apps/front/package.json /turbo/apps/front/package.json
COPY --from=builder /turbo/apps/front/.next /turbo/apps/front/.next
COPY --from=builder /turbo/apps/front/public /turbo/apps/front/public

# for server
COPY --from=builder /turbo/apps/server/package.json /turbo/apps/server/package.json
COPY --from=builder /turbo/apps/server/dist /turbo/apps/server/dist

# for turborepo
COPY --from=builder /turbo/package.json /turbo/package.json
COPY --from=builder /turbo/turbo.json /turbo/turbo.json
COPY --from=builder /turbo/packages /turbo/packages

RUN npm install --production

EXPOSE 3000 5000
CMD ["npm", "start"]