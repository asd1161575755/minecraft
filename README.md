这个分支将会使用[Fabric](https://fabricmc.net/use/server/)作为模组插件

### 获取`Fabric`文件
> [Fabric元数据](https://meta.fabricmc.net/)
> 
> `Fabric`会自动下载指定版本的`Server`文件
1. 通过完整版本信息连接 [version_fabric](https://meta.fabricmc.net/v2/versions/)
2. 通过`JSONPath`过滤类型
   - 获取`server_version`，具体表达式为：`$.game[?(@.stable==true)].version`，会得到一个版本集合，选择需要的即可
   - 获取`fabric_loader_version`，具体表达式为：`$.loader[?(@.stable==true)].version`
   - 获取`fabric_installer_version`，具体表达式为：`$.installer[?(@.stable==true)].version`
4. 组合完整`Fabric`下载连接：https://meta.fabricmc.net/v2/versions/loader/{server_version}/{fabric_loader_version}/{fabric_installer_version}/server/jar
5. 获取`fabric-api`
   1. 通过完整版本信息连接 [version_fabric_api](https://api.github.com/repos/FabricMC/fabric/releases?per_page=100&page=1)`单词最大100条，得翻页查询`
   2. 获取`fabric-api`下载路径，具体表达式为：`$[?(@.target_commitish=='{server_version}')].assets.*.browser_download_url`，可能会有多个版本，取第一个最新的即可。
   3. 下载的模组`jar`文件放置在`mods`中即可
6. 请求完整`Fabric`下载连接即可获得对应`Server`版本最新的`Fabric`插件包
   - 需要将`fabric-server-mc.{server_version}-loader.{fabric_loader_version}-launcher.{server_version}.jar`放置于`server.jar`同级目录下
   - 启动命令，需要将`server.jar`替换为`fabric-server-mc.{server_version}-loader.{fabric_loader_version}-launcher.{server_version}.jar`即可
   
### 制作Dockerfile
- [Dockerfile](Dockerfile)
- docker build -t minecraft-server-fabric .
- docker run -d --restart=unless-stopped -v /data/:/data/ -v /server/mods:/server/mods -p 25565:25565 -p 25575:25575 minecraft-server-fabric

### 编写server.properties文件
- [properties详解](https://minecraft.fandom.com/zh/wiki/Server.properties)
- [server.properties](server.properties)

### 使用说明
- 世界资源默认读取`/data/`路径，可选择 -v /data/:/data/
- 配置文件`server.properties`放置与server.jar所在的目录中，可选择 -v /server/server.properties:/server/server.properties
- 模组文件默认读取`/server/mods/`路径，可选择 -v /server/mods:/server/mods
  - `fabric-api.jar`基础模组会自动添加到mods中，配置挂载也不会影响。
- 端口都按官方默认
  - server-port=25565，可选择 -p 25565:25565
  - rcon.port=25575，可选择 -p 25575:25575
- RCON远程访问密码，每次构建镜像都会生成一个随机的 30 位大小写字母和数字组合的密码，基于`tr -dc 'A-Za-z0-9'`
  - 可选择
    1. 通过自有配置覆盖来修改密码
    2. 通过`docker exec -it minecraft-server cat /server/server.properties`查询密码

### 默认模组信息预览
![模组](https://github.com/user-attachments/assets/b9b7801c-69ab-44c1-bad1-c0dfbd250de9)

### 补充信息
- [客户端](https://ci.huangyuhui.net/job/HMCL/)
- [docker-image.yml](.github/workflows/docker-image.yml)可自动完成镜像上传过程

### 必要插件与模组
> 未完成整理
> 
> 会逐步测试并把下方优化模组作为默认模组

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
