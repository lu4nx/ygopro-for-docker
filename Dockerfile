FROM debian:latest
MAINTAINER lu4nx <lx@shellcodes.org>

RUN echo -n 'deb http://mirrors.tuna.tsinghua.edu.cn/debian/ buster main contrib non-free\ndeb http://mirrors.tuna.tsinghua.edu.cn/debian/ buster-updates main contrib non-free\ndeb http://mirrors.tuna.tsinghua.edu.cn/debian/ buster-backports main contrib non-free\ndeb http://mirrors.tuna.tsinghua.edu.cn/debian-security buster/updates main contrib non-free' > /etc/apt/sources.list
RUN apt-get update -y
RUN apt-get install -y git cmake g++ libfreetype6-dev libevent-dev libsqlite3-dev libgl1-mesa-dev libglu-dev mono-complete liblua5.2-dev libirrlicht-dev p7zip-full wget
RUN cd / && git clone https://github.com/Smile-DK/ygopro.git
RUN cd /ygopro && git submodule update --init --recursive && mkdir build && cd build && cmake -DCMAKE_BUILD_TYPE=Release -G "Unix Makefiles" .. && cmake --build .
RUN sed -i -e 's/simhei.ttf/wqy-zenhei.ttc/' -e 's/arial.ttf/wqy-zenhei.ttc/' /ygopro/system.conf
RUN rm -f /ygopro/cards.cdb

RUN git clone https://github.com/IceYGO/windbot.git && cd windbot && mkdir /ygopro/windbot/ && xbuild /property:Configuration=Release /property:OutDir=/ygopro/windbot/ && mv /ygopro/windbot/bot.conf /ygopro/bot.conf
COPY bot /ygopro
RUN chmod +x /ygopro/bot

VOLUME ["/ygopro/pics", "/ygopro/script", "/ygopro/deck", "/ygopro/fonts", "/ygopro/cards.cdb", "/ygopro/replay", "/ygopro/lflist.conf"]
WORKDIR /ygopro

CMD ./build/bin/ygopro
