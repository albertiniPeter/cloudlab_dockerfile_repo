## 1. 设定/etc/hosts文件

> 注意：本文档根据【C66174(主节点)，S66171(从节点)，S66172(从节点)，S66173(mysql)】节点名,包含所有步骤，编写的，操作时请自行匹配自身环境的节点名进行修改。

执行下面的命令，将集群中**所有节点**的IP 地址与主机名写入所有主机的/etc/hosts中，并将本机器映射localhost，完成域名映射的添加。

> 修改对象为【C66174(主节点)，S66171(从节点)，S66172(从节点)】

```shell
$vim /etc/hosts
```

如图：

> 注意：请将ipv6的映射关系注释掉

![image-20200507094229883](./image-20200507094229883.png)



## 2.SSH登录权限设置

- 集群**所有节点**切换到用户hadoop

  ``` shell
  $su hadoop
  ```

  如图：

  ![image-20200507094338232](./image-20200507094338232.png)

- 在集群**所有节点**上生成公钥和私钥。

  ```shell
  $ssh-keygen -t rsa
  ```

  > 注意：一路回车，将在~/目录下自动创建目录.ssh，内部创建id_rsa（私钥）和id_rsa.pub（公钥）。

  如图：

  ![image-20200507094514906](./image-20200507094514906.png)

- 在集群的**所有节点**上执行下列命令：

  ```shell
  $cd ~/.ssh
  $ssh-copy-id -i id_rsa.pub hadoop@C66175
  $ssh-copy-id -i id_rsa.pub hadoop@S66172
  $ssh-copy-id -i id_rsa.pub hadoop@S66173
  ```

  > 注意：如下图红线所示
  >
  > Are you sure you want to continue connecting (yes/no)? 请输入yes
  >
  > hadoop@S66172's password: 请输入hadoop

  如图：

  ![image-20200507095127679](./image-20200507095127679.png)

## 3.修改Hadoop配置文件

在集群中**所有节点**上执行下列命令, 进入Hadoop配置目录。

```shell
$cd /usr/local/hadoop/etc/hadoop
```

### slaves

在集群中**所有节点**上执行下列命令, 编辑slaves文件将所有节点的hostname添加到改文件里。

```shell
$vim slaves
```

![image-20200507102849434](./image-20200507102849434.png)

### core-site.xml

在集群中**所有节点**上执行下列命令, 将namenode替换成个节点主机名称【C66175】

````shell
$vim core-site.xml
````

如图：

![image-20200507103449207](./image-20200507103449207.png)

### hdfs-site.xml

在集群中**所有节点**上执行下列命令, 将namenode替换成个节点主机名称【C66175】

```shell
$vim hdfs-site.xml
```

如图：

![image-20200507103745167](./image-20200507103745167.png)

### yarn-site.xml

在集群中**所有节点**上执行下列命令, 将namenode替换成个节点主机名称【C66175】

````shell
$vim yarn-site.xml
````

如图：

![image-20200507104214629](./image-20200507104214629.png)

## 4.格式化NameNode节点【C66175】

> 注意： 只在namenode节点执行下面的命令。

```shell
$cd /usr/local/hadoop
$bin/hdfs namenode -format
```

如图：

![image-20200507104747520](./image-20200507104747520.png)

## 5.在主节点【C66175】启动Hadoop服务

> 注意： 只在namenode节点执行下面的命令。

```` shell
$cd /usr/local/hadoop
````

```shell
$sbin/start-dfs.sh
```

如图：

![image-20200507105146696](./image-20200507105146696.png)

```shell
$sbin/start-yarn.sh
```

如图：

![image-20200507105244782](./image-20200507105244782.png)

在集群中**所有节点**上执行下列命令，验证是否成功。

````shell
$jps
````

**namenode【C66175】节点如图：**

![image-20200507105414842](./image-20200507105414842.png)

**datanode【S66172,S66173】节点如图：**

![image-20200507105619830](./image-20200507105619830.png)

## 6.运行MapReduce程序

```shell
$cd /usr/local/hadoop
```

**关闭安全模式**

```shell
$bin/hadoop dfsadmin -safemode leave
```

如图：

![image-20200507110015816](./image-20200507110015816.png)

**运行命令**

````shell
$bin/hadoop jar /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.3.jar pi 2 1000
````

如图：

![image-20200507110236663](./image-20200507110236663.png)

## 7.验证

在主节点【C66175】切换图型界面，打开浏览器，输入下列网站。

> http://C66175:8088/cluster 访问YARN管理界面。例如：

![image-20200507110624732](./image-20200507110624732.png)

> http://C66175:50070查看HDFS管理界面。例如：

![image-20200507110918412](./image-20200507110918412.png)