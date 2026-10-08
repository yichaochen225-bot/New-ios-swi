import SwiftUI

struct ContentView: View {
    @AppStorage("tapCount") private var tapCount = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 22) {
                Image(systemName: "iphone.gen3")
                    .font(.system(size: 62))
                    .foregroundStyle(.tint)
                    .accessibilityHidden(true)

                Text("SwiftUI 云端开发")
                    .font(.title.bold())

                Text("这是由免费的 GitHub 云端 Xcode 编译的原生 iPhone 应用。")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                Text("点击次数：\(tapCount)")
                    .font(.headline)
                    .accessibilityIdentifier("tapCount")

                Button("测试按钮") {
                    tapCount += 1
                }
                .buttonStyle(.borderedProminent)
                .accessibilityIdentifier("incrementButton")
            }
            .padding(28)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("原生 App")
        }
    }
}
