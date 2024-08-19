FROM eclipse-temurin:21-jre as builder
WORKDIR server

COPY *.jar fabric-server.jar
RUN echo '#!/bin/bash\n\
java -jar fabric-server.jar --nogui --universe /temp/cache/ > /temp/app.log 2>&1 &\n\
PID=$!\n\
tail -f /temp/app.log | while read LINE; do\n\
    echo "$LINE" | grep -q "Done"\n\
    if [ $? -eq 0 ]; then\n\
        kill -SIGTERM $PID\n\
        echo "============`fabric`安装完成============"\n\
        exit 0\n\
    fi\n\
done' > start-server.sh && chmod +x start-server.sh && sh start-server.sh

################################

FROM eclipse-temurin:21-jre
WORKDIR server

COPY --from=builder server .
RUN rm -rf server.properties eula.txt logs/*
COPY server.properties .
RUN echo "eula=true" > eula.txt

# JVM针对2C4G机器
ENV JVM_OPTS="\
-server \
-Xms1G \
-Xmx4G \
-Xshare:auto \
-XX:+UseTLAB \
-XX:+UseG1GC \
-Duser.language=zh \
-Duser.country=CN \
-Duser.timezone=GMT+8 \
-Dfile.encoding=UTF-8 \
-XX:MaxGCPauseMillis=100 \
-XX:+ParallelRefProcEnabled \
-XX:ParallelGCThreads=2 \
-XX:ConcGCThreads=2 \
-XX:+UnlockExperimentalVMOptions \
-XX:+AlwaysPreTouch \
-XX:+UseCompressedOops \
-XX:G1HeapRegionSize=8M \
-XX:G1ReservePercent=20 \
-XX:G1MixedGCLiveThresholdPercent=90 \
-XX:InitiatingHeapOccupancyPercent=15 \
-XX:G1NewSizePercent=20 \
-XX:G1MaxNewSizePercent=60 \
-XX:SurvivorRatio=32 \
-XX:MaxTenuringThreshold=1 \
-XX:G1MixedGCCountTarget=4 \
-Djava.awt.headless=true \
-XX:CICompilerCount=2 \
-XX:+TieredCompilation \
-XX:TieredStopAtLevel=4 \
-XX:MetaspaceSize=128M \
-XX:MaxMetaspaceSize=256M \
-XX:CompileThreshold=15000 \
-XX:InitialCodeCacheSize=32M \
-XX:ReservedCodeCacheSize=128M \
-Djava.net.preferIPv4Stack=true \
-Djdk.virtualThreadEnable=true \
-Djdk.attach.allowAttachSelf \
-XX:+UseStringDeduplication \
-XX:+OptimizeStringConcat" \
    TZ=Asia/Shanghai
RUN ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone

Expose 25565
ENTRYPOINT ["sh", "-c", "java -jar ${JVM_OPTS} fabric-server.jar --nogui --eraseCache --forceUpgrade --universe /data/"]
