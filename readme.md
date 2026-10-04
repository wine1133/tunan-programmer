# 兔南程序员

uni-app 前端通过本地 PHP API 连接 MySQL，页面不再直接访问外部演示接口。

## 数据库

- 数据库：`itbaizhan`
- 专用账号：`itbaizhan_app`
- 配置位置：`server/src/config.php`
- 初始化脚本：`server/database/init.sql`

初始化或重置演示数据：

```powershell
powershell -ExecutionPolicy Bypass -File .\server\database\init-db.ps1
```

脚本会把 SQL 临时复制到不含中文的路径，再通过 MySQL 执行，避免 Windows 中文路径导致 `source` 失败。

## 启动 API

```powershell
powershell -ExecutionPolicy Bypass -File .\server\start-api.ps1
```

健康检查：

```text
http://127.0.0.1:8088/api/health
```

真机调试时，将监听地址改为 `0.0.0.0`，并把 `common/api.js` 中的地址改为电脑局域网 IP：

```powershell
powershell -ExecutionPolicy Bypass -File .\server\start-api.ps1 -Listen 0.0.0.0
```

## 发布到 GitHub 与 GitHub Pages

```powershell
powershell -ExecutionPolicy Bypass -File .\server\publish-github.ps1
```

脚本会启动公网 API 隧道、更新 `docs/api-config.js`、提交代码、创建或推送 GitHub 仓库，并启用 GitHub Pages。

默认仓库：

`wine1133/tunan-programmer`

默认发布地址：

`https://wine1133.github.io/tunan-programmer/`
## 一键公网访问

```powershell
powershell -ExecutionPolicy Bypass -File .\server\start-online.ps1
```

脚本会启动 API 和临时公网隧道，公网地址会保存到：

`server\online-url.txt`

H5 页面会自动使用当前公网域名请求 API，外部访问时不会误连访问者自己的 `127.0.0.1`。
## API

- `GET /api/index/banner`
- `GET /api/index/nav`
- `GET /api/index/specific?userid=2162`
- `GET /api/index/course`
- `GET /api/index/recommend`
- `GET /api/course/detail?id=1&course=no`

图片资源由 API 服务下的 `/static/demo/` 提供，响应中会自动生成与当前访问主机一致的可访问地址。

## 原接口说明

- 接口地址：http://html5.bjsxt.cn/api/index/banner
- 接口地址：http://html5.bjsxt.cn/api/index/nav
- 接口地址：http://html5.bjsxt.cn/api/index/specific?userid=2162
- 接口地址：http://html5.bjsxt.cn/api/index/course
- 接口地址：http://html5.bjsxt.cn/api/index/recommend
- 接口地址：http://html5.bjsxt.cn/api/course/detail?id=4&course=no

## 项目打包

1. H5 端
   1. 配置 uniapp 的 appid
   2. 修改默认运行的路径
2. 微信小程序端
   1. 注册微信小程序账号
   2. 获取微信小程序的 Appid
   3. 注意：微信小程序的最大项目限制是 2MB
3. App 端（Android）