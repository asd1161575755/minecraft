FROM eclipse-temurin:21-jre as builder
WORKDIR server

COPY server.jar server.jar
COPY forge-installer.jar forge-installer.jar
RUN java -jar forge-installer.jar --installServer

################################

FROM eclipse-temurin:21-jre
WORKDIR server

COPY --from=builder server .
RUN rm -rf server.properties eula.txt logs/* forge-installer.jar && \
    mv forge-${MINECRAFT_VERSION}-${FORGE_VERSION}.jar forge-server.jar
COPY server.properties .
COPY fabric-api.jar /public/
RUN echo "eula=true" > eula.txt

# JVM针对2C6G机器
ENV JVM_OPTS="\
-server \
-Xms1G \
-Xmx6G \
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
ENTRYPOINT ["sh", "-c", "cp -r /public/* mods/ && java -jar ${JVM_OPTS} forge-server.jar --nogui --eraseCache --forceUpgrade --universe /data/"]
