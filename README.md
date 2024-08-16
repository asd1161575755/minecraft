### 获取`Server`文件
1. 通过完整版本信息连接 [version_manifest](https://launchermeta.mojang.com/mc/game/version_manifest.json)
2. 通过`JSONPath`过滤包类型
    - 发行版表达式为：`$.versions[?(@.type=='release')]`
       - 可通过`$.latest.release`确认最新的发行版本
       - 结合表达式为：`$.versions[?(@.type=='release' && @.id=='1.21.1')]`
    - 快照版表达式为：`$.versions[?(@.type=='snapshot')]`
       - 可通过`$.latest.snapshot`确认最新的快照版本
       - 结合表达式为：`$.versions[?(@.type=='release' && @.id=='1.21.1')]`
    - 旧的Beta版表达式为：`$.versions[?(@.type=='old_beta')]`
    - 旧的Alpha版表达式为：`$.versions[?(@.type=='old_alpha')]`
3. 获取最新发行版本的下载地址
    - 表达式为：`$.versions[?(@.type=='release' && @.id=='1.21.1')].url`
    - 获取连接中的`JSON`信息并通过`JSONPath`过滤，表达式为：`$.downloads.server.url`
    - 通过最后获得的连接发起请求即可获得需要的Server版本

### 制作Dockerfile

```Dockerfile
FROM eclipse-temurin:21-jre

WORKDIR server

Expose 25565

COPY server.jar .
# ADD https://piston-data.mojang.com/v1/objects/59353fb40c36d304f2035d51e7d6e6baa98dc05c/server.jar .

# JVM针对2C2G机器
ENV JVM_OPTS="\
-server \
-Xms1G \
-Xmx2G \
-Xshare:auto \
-XX:+UseTLAB \
-XX:+UseFMA \
-XX:UseAVX=3 \
-XX:+UseG1GC \
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
-XX:+AggressiveOpts \
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

ENTRYPOINT ["sh", "-c", "java -jar ${JVM_OPTS} server.jar --nogui --eraseCache --forceUpgrade --universe /data/"]
```
- docker build -t minecraft-server .

### 编写server.properties文件
[properties](https://minecraft.fandom.com/zh/wiki/Server.properties)

```properties
## 不公开服务器
public=false
## 服务器端口
server-port=25565
## 服务器信息[unicode](https://tool.chinaz.com/tools/unicode.aspx)
motd=§4§lMinecraft §6§l Server
## 世界名称
level-name=world
## 世界类型
# minecraft:normal - 带有丘陵、河谷、海洋等的标准的世界。
# minecraft:flat - 一个没有特性的平坦世界，可用generator-settings修改。
# minecraft:large_biomes - 如同默认的世界，但所有生物群系都更大。
# minecraft:amplified - 如同默认的世界，但世界生成高度提高。
# minecraft:single_biome_surface - 单一生物群系世界
level-type=minecraft:large_biomes
## 游戏难度
# peaceful (0) - 和平
# easy (1) - 简单
# normal (2) - 普通
# hard (3) - 困难
difficulty=hard
## 游戏模式
# survival (0) - 生存模式
# creative (1) - 创造模式
# adventure (2) - 冒险模式
# spectator (3) - 旁观模式
gamemode=survival
# 最大人数
max-players=10
## 可建造最大高度
max-build-height=200
## 玩家可以互相伤害
pvp=true
## 允许OP在服务器人满时也能加入游戏
admin-slot=true
## 启用命令方块
enable-command-block=true
## 服务器不会尝试检查玩家
online-mode=false
## 不具有Mojang签名的公钥的玩家也可进入服务器
enforce-secure-profile=false
## 服务器将会禁止玩家使用虚拟专用网络或代理
prevent-proxy-connections=true
## 强制启用服务器资源包
require-resource-pack=true
## rcon
# 开启RCON远程访问
enable-rcon=true
# RCON远程访问端口
rcon.port=25575
# RCON远程访问密码
rcon.password=yVsWYYc7EOxTshngbtBqJvKbPSujLH
```

### 必要插件与模组
...

### 其他
...

