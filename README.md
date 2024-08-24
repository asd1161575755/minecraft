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
- 模组配置文件默认读取`/server/config/`，可选择 -v /server/config:/server/config
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
- [客户端启动器](https://ci.huangyuhui.net/job/HMCL/)
- [客户端整合基础包](https://www.curseforge.com/minecraft/modpacks/fabulously-optimized)
- [NectarRCON](https://github.com/zkhssb/NectarRCON)
- [docker-image.yml](.github/workflows/docker-image.yml)可自动完成镜像上传过程

### 推荐插件与模组

#### 优化模组

##### 共有
   - **FerriteCore**: 减少内存占用，特别是在大量区块和实体存在时非常有用
      - https://modrinth.com/mod/ferrite-core
##### 服务端
   - **Lithium**: 优化物理引擎、实体处理等核心服务器功能
      - https://modrinth.com/mod/lithium
      - https://github.com/CaffeineMC/lithium-fabric/releases
   - **Krypton**: 优化服务器网络代码，减少网络延迟
      - https://modrinth.com/mod/krypton
      - https://github.com/astei/krypton/releases
   - **Concurrent Chunk Management Engine**: 并发块管理引擎，旨在提高块生成、I/O 和加载的性能
      - https://modrinth.com/mod/c2me-fabric
   - **Noisium Noisium**: 优化世界生成过程的性能以获得更好的游戏体验
      - https://modrinth.com/mod/noisium
   - **Very Many Players**: 非常多的玩家，旨在提高高玩家人数的服务器性能
      - https://modrinth.com/mod/vmp-fabric
   - **RecipeCooldown**: 配方冷却，防止允许玩家发送垃圾邮件数据包并导致服务器延迟的漏洞
      - https://modrinth.com/mod/recipecooldown
   - **ScalableLux**: 可提高 Minecraft 中灯光更新的性能
      - https://modrinth.com/mod/scalablelux
   - **BRRP**: 更好的运行时资源包，运行时资源包减少了I/O（可选，目前改善不大）
      - https://modrinth.com/mod/brrp 
   - **Clumps**: 将经验球合并减少大量经验球产生时的性能消耗（可选，会略微降低画面效果）
      - https://modrinth.com/mod/clumps
   - **Chunky**: 预先生成世界的部分或全部区块，避免玩家探索新区域时的卡顿（可选，主要是主动渲染未涉足区域）
      - https://modrinth.com/plugin/chunky
   - **ServerCore**: 优化多线程处理和实体管理，适用于需要极致性能优化的场景（可选，可通过配置调整服务器生成相关内容）
      - https://modrinth.com/mod/servercore
      - https://github.com/Wesley1808/ServerCore/releases
##### 客户端（推荐直接用[整合基础包](https://www.curseforge.com/minecraft/modpacks/fabulously-optimized)）
   - **Dynamic View**: 动态调整视距，不聚焦窗口时降低fps
      - https://modrinth.com/mod/dynamic-fps
      - https://github.com/juliand665/Dynamic-FPS/releases
   - **EntityCulling**: 仅渲染玩家视角内的实体
      - https://modrinth.com/mod/entityculling
      - https://github.com/tr7zw/EntityCulling/releases
   - **ImmediatelyFast**: 客户端的渲染优化
      - https://modrinth.com/mod/immediatelyfast
      - https://github.com/RaphiMC/ImmediatelyFast/releases

#### 登录模组
> 未完成整理
- AutoLogin https://modrinth.com/mod/autologin
- LuckPerms https://modrinth.com/mod/luckperms
- EasyAuth https://modrinth.com/mod/easyauth

#### 实用模组
> 未完成整理
>
> [整合基础包](https://www.curseforge.com/minecraft/modpacks/fabulously-optimized)不存在的模组

##### 服务端
   - **bad packets**: 允许在不同 Mod 平台之间进行数据包消息传递的库，一些模组会用到这个
      - https://modrinth.com/mod/badpackets
   - **WTHIT**: 所见之物显示在HUB
     - https://modrinth.com/mod/wthit
   - **When Dungeons Arise**: 当地牢出现时
      - https://modrinth.com/mod/when-dungeons-arise
   - **Beautified Chat**: 美化聊天
      - https://modrinth.com/mod/beautified-chat-server
   - **PerPlayerWanderingTraders**: 让流浪商人以玩家相近位置生成
      - https://modrinth.com/mod/beautified-chat-server

##### 客户端 
   - **Xaero's Minimap**: 地图
      - https://modrinth.com/mod/xaeros-minimap
      - https://modrinth.com/mod/xaeros-world-map
   - **Inventory**: 背包整理
      - https://modrinth.com/mod/balm
      - https://modrinth.com/mod/owo-lib
      - https://modrinth.com/mod/inventory-essentials
      - https://modrinth.com/mod/inventorytweak
