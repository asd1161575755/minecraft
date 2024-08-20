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
> 此分支为纯净版本，模组支持还在制作中。目前从`Fabric`开始，可查阅`main-fabric`分支 

### 其他
- [客户端](https://ci.huangyuhui.net/job/HMCL/)
- [docker-image.yml](.github/workflows/docker-image.yml)可自动完成镜像上传过程

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
