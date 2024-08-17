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
- [Dockerfile](Dockerfile)
- docker build -t minecraft-server .
- docker run -d -v /data/:/data/ -p 25565:25565 -p 25575:25575 minecraft-server

### 编写server.properties文件
- [properties详解](https://minecraft.fandom.com/zh/wiki/Server.properties)
- [server.properties](server.properties)

### Rcon管理器
- https://github.com/zkhssb/NectarRCON

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
- [客户端](https://ci.huangyuhui.net/job/HMCL/)

