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

ENTRYPOINT ["sh", "-c", "java -jar ${JVM_OPTS} server.jar --nogui --eraseCache --forceUpgrade --optimize --universe /data/"]
```
- docker build -t minecraft-server .

### 编写server.properties文件
[properties](https://minecraft.fandom.com/zh/wiki/Server.properties)

```properties
## 不公开服务器
public=false
## 服务器端口
server-port=25565
## 服务器信息 https://tool.chinaz.com/tools/unicode.aspx
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

#### **1. 基础性能优化组合**
**适用场景**: 小型服务器或仅有少量玩家的服务器，主要优化服务器的基础性能。

- **Lithium**: 优化物理引擎、实体处理等核心服务器功能。https://modrinth.com/mod/lithium
- **Starlight**: 替代 Phosphor 进行光照优化，大幅减少光照计算负担。 https://modrinth.com/mod/starlight
- **Krypton**: 优化服务器网络代码，减少网络延迟。 https://modrinth.com/mod/krypton
- **LazyDFU**: 优化服务器启动时间，减轻启动时的负载。 https://modrinth.com/mod/lazydfu
- **Smooth Boot**: 防止服务器在启动时因过高的 CPU 负载而卡顿。 https://modrinth.com/mod/smoothboot-fabric

#### **2. 中型服务器优化组合**
**适用场景**: 中型服务器，通常有 20-50 名玩家同时在线，需要处理较多的实体、区块生成和玩家操作。

- **Lithium** + **Starlight** + **Krypton** + **LazyDFU** + **Smooth Boot**
- **C2ME**: 优化区块加载和保存过程，加快区块生成速度。 https://modrinth.com/mod/connectored-c2me-(c2me-fork-for-connector)
- **Dynamic View**: 动态调整视距，根据服务器负载自动优化。 https://modrinth.com/mod/dynamic-fps
- **Fast Furnace for Fabric**: 优化熔炉处理，减少大规模熔炼操作时的服务器负载。 https://modrinth.com/mod/smelter-the-hedgehog

#### **3. 大型服务器优化组合**
**适用场景**: 大型服务器，通常有 50-100 名玩家甚至更多，涉及大规模世界生成、大量实体处理和复杂的红石机械。

- **基础性能优化组合**中的所有模组
- **FerriteCore**: 减少内存占用，特别是在大量区块和实体存在时非常有用。 https://modrinth.com/mod/ferrite-core
- **EntityCulling**: 仅渲染玩家视角内的实体，减少服务器负载。 https://modrinth.com/mod/entityculling
- **Chunky**: 预先生成世界的部分或全部区块，避免玩家探索新区域时的卡顿。 https://modrinth.com/plugin/chunky

#### **4. 超大型服务器优化组合**
**适用场景**: 超大型服务器，支持上百名玩家同时在线，且拥有复杂的经济系统、RPG元素或其他大量数据处理需求。

- **大型服务器优化组合**中的所有模组
- **Tick Dynamic** (Fabric版): 动态调整每个区块和实体的 tick 处理，确保服务器在高负载情况下不会卡死。 https://modrinth.com/mod/tick-dynamic-continuation
- **Clumps**: 将经验球合并，减少大量经验球产生时的性能消耗。 https://modrinth.com/mod/clumps
- **ServerCore**: 优化多线程处理和实体管理，适用于需要极致性能优化的场景。 https://modrinth.com/mod/servercore

#### **登录管理**
- AutoLogin https://modrinth.com/mod/autologin
- LuckPerms https://modrinth.com/mod/luckperms

### 其他
...

