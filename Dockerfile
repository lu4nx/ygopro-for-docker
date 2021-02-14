FROM debian:latest
MAINTAINER lu4nx <lx@shellcodes.org>

RUN echo -n 'deb http://mirrors.tuna.tsinghua.edu.cn/debian/ buster main contrib non-free\ndeb http://mirrors.tuna.tsinghua.edu.cn/debian/ buster-updates main contrib non-free\ndeb http://mirrors.tuna.tsinghua.edu.cn/debian/ buster-backports main contrib non-free\ndeb http://mirrors.tuna.tsinghua.edu.cn/debian-security buster/updates main contrib non-free' > /etc/apt/sources.list
RUN apt-get update -y
RUN apt-get install -y libfreetype6-dev libevent-dev libsqlite3-dev libirrlicht-dev liblua5.3-dev libgl1-mesa-dev libglu-dev git cmake g++ p7zip-full wget mono-complete

RUN cd / && git clone https://github.com/Fluorohydride/ygopro.git
RUN sed -i 's#git@github.com:#https://github.com/#' /ygopro/.gitmodules
RUN cd /ygopro && git submodule update --init --recursive ocgcore
RUN cd /ygopro && mkdir build && cd build && cmake -DCMAKE_BUILD_TYPE=Release -G "Unix Makefiles" .. && cmake --build .
# 修改字体、启动机器人模式
RUN sed -i -e 's/simhei.ttf/wqy-zenhei.ttc/' -e 's/arial.ttf/wqy-zenhei.ttc/' -e 's/enable_bot_mode = 0/enable_bot_mode = 1/' /ygopro/system.conf
# 卡库、脚本和禁卡表通过挂载提供，方便更新数据
RUN rm -rf /ygopro/cards.cdb /ygopro/script /ygopro/lflist.conf

RUN git clone https://github.com/IceYGO/windbot.git && cd windbot && mkdir /ygopro/windbot/ && xbuild /property:Configuration=Release /property:OutDir=/ygopro/windbot/ && mv /ygopro/windbot/bot.conf /ygopro/bot.conf
COPY bot /ygopro
RUN chmod +x /ygopro/bot

VOLUME ["/ygopro/pics", "/ygopro/script", "/ygopro/deck", "/ygopro/fonts", "/ygopro/cards.cdb", "/ygopro/replay", "/ygopro/lflist.conf"]
WORKDIR /ygopro

CMD ./build/bin/ygopro
