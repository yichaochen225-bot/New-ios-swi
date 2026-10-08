# SwiftUI Cloud Studio

免费 Cloudflare Worker 控制台，读取 GitHub 公开仓库的构建、PR、SwiftUI 源码。**只读 API，无 GitHub 密钥、无 OAuth、无服务端写入权限**。

- 部署：`npx wrangler deploy --config studio/wrangler.jsonc`（如在根目录运行，先 `cd studio` 再 `npx wrangler deploy`）。
- 状态接口：`GET /api/overview`、`GET /api/health`。
- 代码预览：`GET /api/file?path=FreeSwiftUIStarter/ContentView.swift`（固定白名单）。
- 任何实际代码修改，请用 GitHub 网页编辑器提交 PR，由 `ios-build` + 模拟器 smoke test 验收，GitHub 规则控制合并。
- 不使用 Cloudflare 付费服务、D1、KV、AI 模型或凭据。
- **限制**：网页的本地草稿不自动保存；不是远程 macOS，不允许不经 GitHub 认证直接写入仓库。
- 生产 Worker 名称：`swiftui-cloud-studio`，不覆盖 `light-ai-trader` 等已部署项目。
