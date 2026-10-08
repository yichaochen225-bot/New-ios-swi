# SwiftUI 免费云端开发环境

原生 SwiftUI + Xcode 工程，通过 **GitHub Actions 标准 macOS 26** 云端机器使用 **Xcode 26.6** 编译 iOS 模拟器 App。此仓库是公开的示例环境，不需自有 Mac 或 Apple Developer 付费账户即可编译模拟器版本。

## 使用方法

1. 使用 GitHub 网页或 `github.dev` 编辑 `FreeSwiftUIStarter/ContentView.swift`。
2. 通过分支 + Pull Request 提交代码；PR 会自动运行 Xcode 编译，并启动 iPhone 模拟器验收截图。
3. 打开 **Actions → Free SwiftUI Cloud Xcode Build** 查看编译结果。
4. 下载该次运行中的 `ios-swiftui-build` Artifact，内容为 **iOS Simulator 专用 App**，不能直接在真实 iPhone 安装。
5. 将经过人工检查且 CI 通过的 PR 合并到 main；合并后的 push 只做快速编译。主分支的 **Actions → Run workflow → simulator_smoke_test** 也可以手动触发模拟器截图。

## 安全与费用

- **公开仓库，所有代码、Git 历史、Actions 日志和构建产物可能对外可见**；不要提交密钥、私钥、Apple ID、证书、真实设备标识、私人数据或付费服务凭据。
- GitHub 免费标准 macOS Hosted Runners 可以用于符合政策的公开仓库 Actions 构建，但有配额、限制和反滥用规则；不要使用 larger runners。
- 工作流权限限制为 `contents: read`，不使用 Secrets、第三方上传服务或任何持续运行服务器。
- 运行器是临时 macOS 执行机，不提供持久远程桌面。
- `macos-26` + `/Applications/Xcode_26.6.app` 使用固定工具链，升级前需要验证。
- 当前示例只生成未签名模拟器 App。真机安装、TestFlight 与 App Store 分发需要另外处理苹果签名/开发者资格。
- 合并保持人工审批；建议在 GitHub Settings → Rules → Rulesets 为 main 增加 PR 与 CI 成功要求。

## 目录

- `FreeSwiftUIStarter/FreeSwiftUIStarterApp.swift`: SwiftUI 应用入口
- `FreeSwiftUIStarter/ContentView.swift`: SwiftUI 用户界面示例
- `FreeSwiftUIStarter.xcodeproj`: Xcode 工程与共享 Scheme
- `.github/workflows/ios-ci.yml`: 固定 macOS 和 Xcode 的 CI 编译
- `scripts/simulator-smoke-test.sh`: PR 自动运行 / 手动触发的模拟器验收截图

构建状态和截图需要在 Actions 运行后确认，不能仅凭源码判断成功。
