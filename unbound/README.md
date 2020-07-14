# unbound 相关脚本

## gendns.php
从 powerdns 的数据库里面生成 unbound 的配置文件，适合像公司内网 dns 这种使用场景，既要做内网域名的权威服务器，又要做递归服务器，有时候还有劫持外网 dns 的需求。这样的话使用 poweradmin 来直接管理 powerdns 的库，然后使用 unbound 来做解析和转发就好。
