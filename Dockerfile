FROM node:16

WORKDIR /tmp

RUN echo "deb [check-valid-until=no] http://archive.debian.org/debian buster main contrib non-free" > /etc/apt/sources.list && \
    echo "deb [check-valid-until=no] http://archive.debian.org/debian buster-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb [check-valid-until=no] http://archive.debian.org/debian-security buster/updates main contrib non-free" >> /etc/apt/sources.list && \
    apt-get -o Acquire::Check-Valid-Until=false update && \
    apt-get install -y --no-install-recommends apt-utils && \
    apt-get install -y \
      wget gnupg fonts-noto-cjk libxss1 \
      fonts-liberation libasound2 libatk-bridge2.0-0 libatspi2.0-0 libdrm2 \
      libgbm1 libgtk-3-0 libnspr4 libnss3 libx11-xcb1 libxkbcommon0 xdg-utils  \
      libu2f-udev libvulkan1 \
      --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt-get install ./google-chrome-stable_current_amd64.deb

WORKDIR /app

COPY server/package.json ./
COPY server/yarn.lock ./

RUN yarn

COPY ./server ./
COPY ./client/build/*.js ./public/static/js/
COPY ./client/build/*.css ./public/static/css/

ENTRYPOINT ["node", "src/index.js"]
