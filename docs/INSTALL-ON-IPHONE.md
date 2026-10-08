# 将原生围棋安装到实体 iPhone（免费路线）
这个仓库默认 CI 输出的 `Debug-iphonesimulator` 是 **模拟器程序**，不能安装到真实手机。
`iphone-unsigned.yml` 使用 `iphoneos` SDK 构建 **实体 iPhone** 二进制并打包为**未签名 IPA**。

## 准备 iPhone 版安装包
1. GitHub → **Actions → Unsigned iPhone IPA (for local signing)** → **Run workflow**。
2. 在该运行记录下方下载 **Weiqi-iPhone-UNSIGNED-IPA** Artifact。
3. 解开 GitHub 的 Artifact 压缩包，得到 `Weiqi-iPhone-UNSIGNED.ipa`。该 IPA **尚未被苹果签名**，不能直接从 iPhone 的“文件”App 点击安装。

## 免费安装到实体 iPhone
使用你**本人可操作且信任的 Windows 或 Mac 电脑**连接 iPhone，借助 [Sideloadly](https://sideloadly.io/) 或 [AltStore Classic](https://altstore.io/) 在电脑/手机上用你的 Apple Account 完成签名和设备安装。
- 选择下载好的 **Weiqi-iPhone-UNSIGNED.ipa**，不要选模拟器压缩包。
- 可能需要开启 iPhone **设置 → 隐私与安全性 → 开发者模式**，重新启动后确认启用。
- 免费 Apple ID 的安装签名通常 **7 天到期**，须重新签名/刷新；这不是永久免费的 App Store/TestFlight 分发渠道。
- 不要把 Apple ID 密码、2FA 验证码、开发证书、Provisioning Profile 或签名私钥放进公开 GitHub 仓库、Actions Secrets（日后签名步骤应专门评估）、Cloudflare 或聊天中。
- 使用同一 Bundle ID 与 Apple ID 更新更有利于保留设备上的本地棋局数据，仍应事先备份重要数据。

## 长期稳定安装
[Apple Developer Program](https://developer.apple.com/programs/) 当前为 99 美元/年，提供 TestFlight 和 App Store 分发能力。
TestFlight 单个构建最长可测试 90 天，需要及时更新；正式 App Store 上架还要经过审核。**免费+只有 iPhone+永久稳定原生安装**不能仅靠 GitHub/Cloudflare 达成。

以上云端工作流只负责生成**可用于设备签名的未签名 IPA**，不对用户设备远程安装、也不代用户登录 Apple ID。
