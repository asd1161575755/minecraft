这个分支将会使用[Forge](https://files.minecraftforge.net/net/minecraftforge/forge/)作为模组插件
### 获取`Fabric`文件
> [Forge元数据](https://files.minecraftforge.net/net/minecraftforge/forge/promotions_slim.json)
> 
> `Forge`会自动下载指定版本的`Server`文件
1. 通过完整版本信息连接 [version_forge](https://files.minecraftforge.net/net/minecraftforge/forge/promotions_slim.json)
2. 匹配版本，`-latest`左部分是`minecraft`版本号，需要什么对应版本拼接上去就行，可以排序下默认去最大的即可获得最新版本
3. 请求完整`Forge`下载连接即可获得对应`Server`版本最新的`Forge`插件包
   - https://maven.minecraftforge.net/net/minecraftforge/forge/{server_version}-{forge_version}/forge-{server_version}-{forge_version}-installer.jar

### 制作Dockerfile
- [Dockerfile](Dockerfile)
- docker build -t minecraft-server-forge .
- docker run -d --restart=unless-stopped -v /data/:/data/ -v /server/mods:/server/mods -p 25565:25565 -p 25575:25575 minecraft-server-forge

### 编写server.properties文件
- [properties详解](https://minecraft.fandom.com/zh/wiki/Server.properties)
- [server.properties](server.properties)

### 使用说明
- 世界资源默认读取`/data/`路径，可选择 -v /data/:/data/
- 配置文件`server.properties`放置与server.jar所在的目录中，可选择 -v /server/server.properties:/server/server.properties
- 模组文件默认读取`/server/mods/`路径，可选择 -v /server/mods:/server/mods
- 模组配置文件默认读取`/server/config/`，可选择 -v /server/config:/server/config
- 端口都按官方默认
  - server-port=25565，可选择 -p 25565:25565
  - rcon.port=25575，可选择 -p 25575:25575
- RCON远程访问密码，每次构建镜像都会生成一个随机的 30 位大小写字母和数字组合的密码，基于`tr -dc 'A-Za-z0-9'`
  - 可选择
    1. 通过自有配置覆盖来修改密码
    2. 通过`docker exec -it minecraft-server cat /server/server.properties`查询密码
