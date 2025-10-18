#FROM node:buster-slim as builder
FROM node:20-bookworm-slim as builder

WORKDIR /workspace
RUN apt-get update -q && \
    apt-get install -qy build-essential git python3
ADD package*.json /workspace/
RUN npm install && \
    apt-get remove -qy build-essential git python3 &&\
    rm -rf /var/lib/apt/lists/* && \
    apt autoremove -y && \
    apt-get clean

#FROM node:buster-slim
FROM node:20-bookworm-slim

RUN apt-get update -q && \
    apt-get install -qy libjemalloc2 && \
    rm -rf /var/lib/apt/lists/* && \
    apt autoremove -y && \
    apt-get clean
WORKDIR /workspace
COPY --from=builder /workspace .
CMD node-gyp rebuild
ENV NODE_OPTIONS=--max_old_space_size=4096
ENV LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2
ADD . /workspace
CMD npm start
EXPOSE 3002
