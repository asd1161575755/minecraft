这个分支将会使用[Forge](https://files.minecraftforge.net/net/minecraftforge/forge/)作为模组插件
### 获取`Fabric`文件
> [Forge元数据](https://files.minecraftforge.net/net/minecraftforge/forge/promotions_slim.json)
> 
> `Forge`会自动下载指定版本的`Server`文件
1. 通过完整版本信息连接 [version_forge](https://files.minecraftforge.net/net/minecraftforge/forge/promotions_slim.json)
2. 匹配版本`-latest`左部分是`minecraft`版本号，需要什么对应版本拼接上去就行，可以排序下默认去最大的即可获得最新版本
3. 请求完整`Forge`下载连接即可获得对应`Server`版本最新的`Forge`插件包
   - https://maven.minecraftforge.net/net/minecraftforge/forge/{server_version}-{forge_version}/forge-{server_version}-{forge_version}-installer.jar
