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
![图片|609x500](upload://lcJ1zMXZ6NkLCGbLBCWg7OnlLIL.png)
![图片|690x102](upload://mcRHS1fX0ragOHdaFyPiq4ZM1ga.png)
![图片|690x191](upload://1p326YrCUlSm9xbKhcHuWV8qGoJ.png)
3. 获取最新发行版本的下载地址
    - 表达式为：`$.versions[?(@.type=='release' && @.id=='1.21.1')].url`
    ![图片|690x109](upload://qsYOuomgQwWcPMx12OkZ1DQQEeU.png)
    - 获取连接中的`JSON`信息并通过`JSONPath`过滤，表达式为：`$.downloads.server.url`
    ![图片|690x71](upload://bT7oT3xE4cP2cfrnNCFky9zQqDR.png)
    - 通过最后获得的连接发起请求即可获得需要的Server版本
    ![图片|555x106](upload://ea7wCvMcCvCOdpa9SFx1Mc89AHm.png)

逻辑串起来就可以轻松实现快速版本包的选择下载~
当然`client`也可以通过这个方法获取，但`client`需要结合`libraries`才可以直接运行。通过启动器下载会更方便些。
