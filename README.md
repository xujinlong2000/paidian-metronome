# 拍点 · 简单节拍器

一个轻量的离线节拍器，提供独立 macOS 桌面程序和浏览器版。声音实时合成，无需账号、网络或外部音频文件。

## 安装与使用

下载仓库中的 [Paidian-macOS-universal.zip](output/Paidian-macOS-universal.zip)，解压后将「拍点.app」拖入「应用程序」，双击打开，再点击「开始节拍」。本地构建的程序位于 `output/拍点.app`。

系统要求：macOS 13 或更新版本，同时支持 Apple 芯片和 Intel Mac。

发布包使用本地签名，尚未通过 Apple 公证。下载后若被系统拦截，请按照 macOS「隐私与安全性」中的提示处理。

浏览器版：直接打开 `dist/index.html`，无需安装。也可使用[在线版](https://paidian-metronome-jl-1106.honeyoak11.chatgpt.site)。

## 功能

- 速度：20–280 BPM，可拖动滑杆、点击加减或直接输入数字。
- 拍号：2/4、3/4、4/4、6/4，支持首拍重音和音量调节。
- 敲击测速：按自己的节奏连续点击，自动计算速度。
- 快捷键：空格开始／暂停，上下方向键调速，T 敲击测速。输入框或按钮获得焦点时遵循其原生键盘行为。
- 自动记住上次的速度、拍号、重音和音量设置。

播放时桌面版请求保持系统唤醒，暂停后恢复正常节能行为。浏览器版切换到后台或锁屏时，播放连续性取决于浏览器。

## 从源码构建

需要 macOS 和 Apple Command Line Tools；无需完整 Xcode 或第三方依赖。

```sh
bash scripts/build-macos.sh
```

生成：

- `output/拍点.app`：可双击启动的通用桌面程序。
- `output/Paidian-macOS-universal.zip`：可分发的压缩包。

## 项目结构

```text
dist/index.html            节拍器界面与音频引擎，也是离线浏览器版
native/main.swift          macOS 窗口、菜单与播放期间的电源管理
native/Info.plist          应用信息和系统版本要求
scripts/build-macos.sh     通用架构构建、签名与打包
scripts/make-icon.swift    生成程序图标
.github/workflows/         自动构建与标签发布
```

推送主分支会自动构建安装包，可在 GitHub Actions 对应运行的 Artifacts 中下载。推送 `v*` 标签时，会创建 GitHub Release 并附带安装包。私有仓库中的下载需要对应的仓库访问权限。

## 隐私

速度、拍号、重音和音量仅保存在设备上。程序不采集数据、不请求麦克风权限、不包含遥测。卸载时删除应用即可，偏好数据由系统 WebKit 管理。

`.tmp/` 保存构建缓存与检查截图，不提交到 Git。`output/` 保存本地交付物；仓库仅跟踪其中的 ZIP 安装包，便于直接下载保存。
