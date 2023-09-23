FROM node:18-alpine AS base
 
FROM base AS builder
RUN apk add --no-cache libc6-compat
RUN apk update

WORKDIR /app
RUN npm install turbo -g
COPY . .
RUN turbo prune --scope=front --docker
 
# Add lockfile and package.json's of isolated subworkspace
FROM base AS installer
RUN apk add --no-cache libc6-compat
RUN apk update
WORKDIR /app
 
# First install the dependencies (as they change less often)
COPY .gitignore .gitignore
COPY --from=builder /app/out/json/ .
COPY --from=builder /app/out/package-lock.json ./package-lock.json
RUN npm install
 
# Build the project
COPY --from=builder /app/out/full/ .
RUN npm run build --filter=front...
 
FROM base AS runner
WORKDIR /app
 
# Don't run production as root
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs
USER nextjs
 
COPY --from=installer /app/apps/front/next.config.js .
COPY --from=installer /app/apps/front/package.json .
 
COPY --from=installer --chown=nextjs:nodejs /app/apps/front/.next/standalone ./
COPY --from=installer --chown=nextjs:nodejs /app/apps/front/.next/static ./apps/front/.next/static
COPY --from=installer --chown=nextjs:nodejs /app/apps/front/public ./apps/front/public
 
CMD next start