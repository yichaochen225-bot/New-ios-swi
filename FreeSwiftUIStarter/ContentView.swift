import SwiftUI

@MainActor
final class GoSession: ObservableObject {
    @Published var game: GoGame {
        didSet { persist() }
    }
    @Published var notice: String = ""

    init() {
        if let bytes = UserDefaults.standard.data(forKey: "francis.go.local.v1"),
           let restored = try? JSONDecoder().decode(GoGame.self, from: bytes),
           [9, 13, 19].contains(restored.size),
           restored.board.count == restored.size * restored.size {
            game = restored
        } else {
            game = GoGame()
        }
    }

    private func persist() {
        if let bytes = try? JSONEncoder().encode(game) {
            UserDefaults.standard.set(bytes, forKey: "francis.go.local.v1")
        }
    }

    func put(_ point: GoPoint) {
        if game.phase == .reviewing {
            game.toggleDeadGroup(at: point)
            notice = ""
            return
        }
        switch game.play(at: point) {
        case .played: notice = ""
        case let .invalid(reason): notice = reason
        }
    }

    func pass() { game.pass(); notice = "" }
    func undo() {
        if game.undo() { notice = "" }
        else { notice = "当前没有可以悔棋的棋步" }
    }
    func resign() { game.resign(); notice = "" }
    func reset(size: Int) { game = GoGame(size: size); notice = "" }
    func score() { game.confirmScore(); notice = "" }
    func resume() { game.resume(); notice = "" }
}

private enum GoPalette {
    static let background = Color(red: 0.055, green: 0.082, blue: 0.075)
    static let panel = Color(red: 0.11, green: 0.16, blue: 0.14)
    static let accent = Color(red: 0.83, green: 0.70, blue: 0.43)
    static let secondary = Color(red: 0.67, green: 0.73, blue: 0.68)
    static let wood = Color(red: 0.90, green: 0.70, blue: 0.40)
}

struct ContentView: View {
    @StateObject private var session = GoSession()
    @State private var showRules = false
    @State private var confirmResign = false
    @State private var confirmReset = false
    @State private var newSize = 9

    private var game: GoGame { session.game }

    var body: some View {
        ZStack {
            GoPalette.background.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 19) {
                    heading
                    playerRow
                    turnCard
                    GoBoardView(game: game, onIntersection: { session.put($0) })
                        .aspectRatio(1, contentMode: .fit)
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 17)
                                .fill(Color(red: 0.21, green: 0.20, blue: 0.15))
                        )
                        .overlay(RoundedRectangle(cornerRadius: 17).stroke(GoPalette.accent.opacity(0.34)))
                        .accessibilityIdentifier("goBoard")
                    instruction
                    controls
                    if game.phase == .reviewing { scoringCard }
                    if game.phase == .finished || game.phase == .resigned { resultCard }
                    footer
                }
                .padding(.horizontal, 17)
                .padding(.top, 22)
                .padding(.bottom, 44)
                .frame(maxWidth: 560)
                .frame(maxWidth: .infinity)
            }
            .scrollIndicators(.hidden)
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showRules) { rulesSheet }
        .alert("确认认输？", isPresented: $confirmResign) {
            Button("认输", role: .destructive) { session.resign() }
            Button("取消", role: .cancel) {}
        } message: {
            Text("当前 \(game.toMove.name)认输后，对方直接获胜。")
        }
        .confirmationDialog("开始新对局？", isPresented: $confirmReset, titleVisibility: .visible) {
            Button("开始 \(newSize) 路对局", role: .destructive) { session.reset(size: newSize) }
            Button("取消", role: .cancel) {}
        } message: {
            Text("将清除当前未完成的对局，已有棋局不会保留。")
        }
    }

    private var heading: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 7) {
                HStack(spacing: 7) {
                    Circle().fill(GoPalette.accent).frame(width: 6, height: 6)
                    Text("LOCAL TWO-PLAYER").font(.system(size: 10, weight: .bold, design: .monospaced))
                        .tracking(2).foregroundStyle(GoPalette.accent)
                }
                Text("对弈 · 围棋")
                    .font(.system(size: 31, weight: .bold, design: .serif))
                    .tracking(1.6)
                    .foregroundStyle(.white)
                Text("同屏双人  ·  \(game.size) 路棋盘")
                    .font(.system(size: 12))
                    .foregroundStyle(GoPalette.secondary)
            }
            Spacer()
            Menu {
                ForEach([9,13,19], id: \.self) { size in
                    Button("\(size) 路" + (size == game.size ? " · 当前" : "")) {
                        newSize = size
                        confirmReset = true
                    }
                }
            } label: {
                HStack(spacing: 5) {
                    Image(systemName: "square.grid.3x3")
                    Text("\(game.size) 路")
                    Image(systemName: "chevron.down").font(.system(size: 9))
                }
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(GoPalette.accent)
                .padding(.horizontal, 11).padding(.vertical, 10)
                .background(GoPalette.panel, in: RoundedRectangle(cornerRadius: 10))
            }
            .accessibilityIdentifier("boardSizeMenu")
        }
    }

    private var playerRow: some View {
        HStack(spacing: 10) {
            playerCard(.black, isActive: game.phase == .playing && game.toMove == .black)
            playerCard(.white, isActive: game.phase == .playing && game.toMove == .white)
        }
    }

    private func playerCard(_ stone: GoStone, isActive: Bool) -> some View {
        let captures = stone == .black ? game.capturesBlack : game.capturesWhite
        return HStack(spacing: 11) {
            StoneDisc(stone: stone)
                .frame(width: 28, height: 28)
            VStack(alignment: .leading, spacing: 3) {
                Text(stone.name).font(.system(size: 15, weight: .bold))
                Text("提子 \(captures)").font(.system(size: 11)).foregroundStyle(GoPalette.secondary)
            }
            Spacer(minLength: 0)
            if isActive {
                Circle().fill(GoPalette.accent).frame(width: 7, height: 7)
            }
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 12).padding(.vertical, 13)
        .background(GoPalette.panel, in: RoundedRectangle(cornerRadius: 13))
        .overlay(
            RoundedRectangle(cornerRadius: 13)
                .stroke(isActive ? GoPalette.accent : .white.opacity(0.07), lineWidth: isActive ? 1.3 : 0.8)
        )
        .frame(maxWidth: .infinity)
    }

    private var turnCard: some View {
        HStack(spacing: 10) {
            Image(systemName: game.phase == .playing ? "circle.dotted.circle" : "checkmark.seal")
                .foregroundStyle(GoPalette.accent)
            VStack(alignment: .leading, spacing: 3) {
                Text(turnText).font(.system(size: 14, weight: .bold))
                Text(game.lastAction).font(.system(size: 11)).foregroundStyle(GoPalette.secondary)
                    .lineLimit(2)
            }
            Spacer(minLength: 0)
            Text("第 \(game.moveCount) 手")
                .font(.system(size: 11, weight: .medium, design: .monospaced))
                .foregroundStyle(GoPalette.accent)
        }
        .padding(13)
        .background(GoPalette.panel, in: RoundedRectangle(cornerRadius: 13))
    }

    private var turnText: String {
        switch game.phase {
        case .playing: return "轮到 \(game.toMove.name)落子"
        case .reviewing: return "数子阶段 · 双方核对死子"
        case .finished: return "终局 · 数子完成"
        case .resigned: return "终局 · 认输"
        }
    }

    private var instruction: some View {
        HStack(alignment: .top, spacing: 9) {
            Image(systemName: session.notice.isEmpty ? "hand.tap" : "exclamationmark.circle")
                .foregroundStyle(session.notice.isEmpty ? GoPalette.accent : Color.orange)
            Text(session.notice.isEmpty ? (game.phase == .reviewing
                 ? "点击整块死棋可标记或取消。双方确认无误后，再按「确认计分」。"
                 : game.phase == .playing ? "在棋盘交叉点触摸落子。拖动手指可预览位置，松开即落子。"
                 : "本局已结束，可以查看结果或开始新对局。") : session.notice)
                .font(.system(size: 12)).foregroundStyle(GoPalette.secondary)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 3)
    }

    private var controls: some View {
        HStack(spacing: 9) {
            actionButton("虚着", icon: "forward.end", enabled: game.phase == .playing) {
                session.pass()
            }
            actionButton("悔棋", icon: "arrow.uturn.backward", enabled: !game.history.isEmpty) {
                session.undo()
            }
            actionButton("认输", icon: "flag", enabled: game.phase == .playing) {
                confirmResign = true
            }
            Button {
                showRules = true
            } label: {
                VStack(spacing: 7) {
                    Image(systemName: "questionmark.circle").font(.system(size: 18))
                    Text("规则").font(.system(size: 12, weight: .semibold))
                }.frame(maxWidth: .infinity).frame(height: 59)
            }
            .buttonStyle(.plain).foregroundStyle(GoPalette.accent)
            .background(GoPalette.panel, in: RoundedRectangle(cornerRadius: 12))
        }
    }

    private func actionButton(_ title: String, icon: String, enabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 7) {
                Image(systemName: icon).font(.system(size: 17))
                Text(title).font(.system(size: 12, weight: .semibold))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 59)
        }
        .buttonStyle(.plain)
        .foregroundStyle(enabled ? .white : GoPalette.secondary.opacity(0.5))
        .background(GoPalette.panel, in: RoundedRectangle(cornerRadius: 12))
        .disabled(!enabled)
    }

    private var scoringCard: some View {
        VStack(alignment: .leading, spacing: 13) {
            HStack {
                Image(systemName: "chart.bar.xaxis").foregroundStyle(GoPalette.accent)
                Text("终局点目").font(.system(size: 17, weight: .bold))
                Spacer()
                Text("中国数子法").font(.system(size: 11)).foregroundStyle(GoPalette.secondary)
            }
            Text("标记双方认为已经死亡的棋块；棋子与其控制的空点计入面积。白方贴 6.5 目。")
                .font(.system(size: 12)).foregroundStyle(GoPalette.secondary)
            scoreSummary
            HStack(spacing: 10) {
                Button("继续对局") { session.resume() }
                    .buttonStyle(.bordered)
                    .tint(GoPalette.secondary)
                Button("双方确认 · 计分") { session.score() }
                    .buttonStyle(.borderedProminent)
                    .tint(GoPalette.accent)
                    .foregroundStyle(GoPalette.background)
            }
        }
        .padding(17)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(GoPalette.panel, in: RoundedRectangle(cornerRadius: 15))
        .accessibilityIdentifier("scoringCard")
    }

    private var scoreSummary: some View {
        let s = game.score()
        return HStack {
            Text("黑 " + String(format: "%.1f", s.black))
            Spacer()
            Text("白 " + String(format: "%.1f", s.white))
        }
        .font(.system(size: 21, weight: .bold, design: .rounded))
        .foregroundStyle(GoPalette.accent)
    }

    private var resultCard: some View {
        VStack(spacing: 12) {
            Image(systemName: "trophy").font(.system(size: 26)).foregroundStyle(GoPalette.accent)
            Text(game.phase == .resigned
                 ? "\(game.resignationWinner?.name ?? "对方")获胜"
                 : "\(game.score().winner.name)胜 \(game.score().difference.formatted(.number.precision(.fractionLength(1)))) 目")
                .font(.system(size: 24, weight: .bold, design: .serif))
            if game.phase == .finished { scoreSummary }
            Text(game.phase == .finished ? "中国数子法 · 白贴 6.5 目" : "认输终局")
                .font(.system(size: 12)).foregroundStyle(GoPalette.secondary)
            Button {
                newSize = game.size
                confirmReset = true
            } label: {
                Label("再来一局", systemImage: "arrow.clockwise")
                    .font(.system(size: 14, weight: .bold))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(GoPalette.accent)
            .foregroundStyle(GoPalette.background)
        }
        .padding(22).frame(maxWidth: .infinity)
        .background(GoPalette.panel, in: RoundedRectangle(cornerRadius: 15))
        .accessibilityIdentifier("resultCard")
    }

    private var footer: some View {
        HStack {
            Text("双人本地对弈 · 自动保存")
            Spacer()
            Text("SWIFTUI  /  v1.0")
        }
        .font(.system(size: 10, weight: .medium, design: .monospaced))
        .foregroundStyle(GoPalette.secondary.opacity(0.76))
    }

    private var rulesSheet: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    rule("基本玩法", "黑先白后，双方轮流把棋子下在棋线交叉点上。可选 9、13、19 路棋盘。")
                    rule("吃子与气", "一块相连棋子没有相邻空点（气）时，立即被对方提走。")
                    rule("禁着与劫", "不可自杀落子；禁止立即提回造成与对方上一手之前相同的棋盘（简单劫）。")
                    rule("虚着与终局", "双方连续选择「虚着」后进入死子确认阶段。可点击死棋整块标记，双方确认后数子。也可以继续对局或认输。")
                    rule("计分方法", "采用简化中国数子法：活棋枚数 + 完全围住的空点，白方贴 6.5 目。争议死子请双方协商后标记；这不是裁判系统。")
                    rule("双人方式", "两位玩家面对面共用同一台 iPhone 或 iPad 轮流落子。当前版本不包含在线联机或电脑 AI。")
                    rule("保存与悔棋", "棋局自动保存在本机。可按「悔棋」回到上一手；切换棋盘路数或新开对局会清除当前棋局。")
                }.padding(20)
            }
            .background(GoPalette.background)
            .navigationTitle("对弈规则")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .topBarTrailing) {
                Button("完成") { showRules = false }
            }}
        }
        .preferredColorScheme(.dark)
    }

    private func rule(_ title: String, _ content: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).font(.system(size: 17, weight: .semibold)).foregroundStyle(GoPalette.accent)
            Text(content).font(.system(size: 14)).foregroundStyle(GoPalette.secondary)
        }
    }
}

private struct StoneDisc: View {
    let stone: GoStone
    var body: some View {
        Circle()
            .fill(RadialGradient(
                colors: stone == .black
                    ? [Color(white: 0.42), Color(white: 0.1), .black]
                    : [.white, Color(white: 0.94), Color(white: 0.68)],
                center: UnitPoint(x: 0.29, y: 0.22),
                startRadius: 0, endRadius: 28))
            .overlay(Circle().strokeBorder(
                stone == .black ? Color.black.opacity(0.6) : Color.white.opacity(0.8),
                lineWidth: 0.7))
            .shadow(color: .black.opacity(0.35), radius: 2, x: 0.7, y: 1.4)
    }
}

private struct GoBoardView: View {
    let game: GoGame
    let onIntersection: (GoPoint) -> Void
    @State private var hover: GoPoint?

    private func stars() -> [GoPoint] {
        let n = game.size
        let offset = n == 9 ? 2 : 3
        let coords = [offset, n / 2, n - offset - 1]
        if n == 9 || n == 13 {
            return [
                GoPoint(row: offset, col: offset),
                GoPoint(row: offset, col: n - offset - 1),
                GoPoint(row: n - offset - 1, col: offset),
                GoPoint(row: n - offset - 1, col: n - offset - 1),
                GoPoint(row: n / 2, col: n / 2)
            ]
        }
        return coords.flatMap { row in coords.map { col in GoPoint(row: row, col: col) } }
    }

    var body: some View {
        GeometryReader { geometry in
            let dimension = geometry.size.width
            let margin = dimension * 0.065
            let spacing = (dimension - margin * 2) / CGFloat(game.size - 1)
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 9)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.95, green: 0.77, blue: 0.48),
                                Color(red: 0.87, green: 0.65, blue: 0.34),
                                Color(red: 0.93, green: 0.73, blue: 0.43)
                            ], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                Canvas { context, _ in
                    var lines = Path()
                    for line in 0..<game.size {
                        let coord = margin + CGFloat(line) * spacing
                        lines.move(to: CGPoint(x: margin, y: coord))
                        lines.addLine(to: CGPoint(x: dimension - margin, y: coord))
                        lines.move(to: CGPoint(x: coord, y: margin))
                        lines.addLine(to: CGPoint(x: coord, y: dimension - margin))
                    }
                    context.stroke(lines, with: .color(.black.opacity(0.67)),
                                   style: StrokeStyle(lineWidth: 0.85))
                    for point in stars() {
                        let x = margin + CGFloat(point.col) * spacing
                        let y = margin + CGFloat(point.row) * spacing
                        context.fill(Path(ellipseIn: CGRect(x: x - 2.1, y: y - 2.1, width: 4.2, height: 4.2)),
                                     with: .color(.black.opacity(0.84)))
                    }
                }
                .accessibilityHidden(true)

                ForEach(game.board.indices, id: \.self) { i in
                    if let stone = game.board[i] {
                        StoneDisc(stone: stone)
                            .frame(width: spacing * 0.89, height: spacing * 0.89)
                            .position(x: margin + CGFloat(i % game.size) * spacing,
                                      y: margin + CGFloat(i / game.size) * spacing)
                            .accessibilityHidden(true)
                    }
                }

                if let latest = game.lastMove, game.phase == .playing, let lastStone = game.stone(at: latest) {
                    Circle()
                        .fill(lastStone == .black ? Color.white : Color.black)
                        .frame(width: max(4, spacing * 0.16), height: max(4, spacing * 0.16))
                        .position(x: margin + CGFloat(latest.col) * spacing,
                                  y: margin + CGFloat(latest.row) * spacing)
                        .accessibilityHidden(true)
                }

                if game.phase == .reviewing {
                    ForEach(Array(game.markedDead).sorted(), id: \.self) { i in
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(Color.red.opacity(0.87))
                            .frame(width: spacing * 0.52, height: spacing * 0.52)
                            .position(x: margin + CGFloat(i % game.size) * spacing,
                                      y: margin + CGFloat(i / game.size) * spacing)
                    }
                }

                if let hover, game.phase == .playing, game.stone(at: hover) == nil {
                    Circle()
                        .fill(game.toMove == .black ? .black.opacity(0.5) : .white.opacity(0.75))
                        .frame(width: spacing * 0.89, height: spacing * 0.89)
                        .position(x: margin + CGFloat(hover.col) * spacing,
                                  y: margin + CGFloat(hover.row) * spacing)
                        .accessibilityHidden(true)
                }
            }
            .frame(width: dimension, height: dimension)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        hover = nearest(value.location, margin: margin, spacing: spacing)
                    }
                    .onEnded { value in
                        let p = nearest(value.location, margin: margin, spacing: spacing)
                        hover = nil
                        if let p { onIntersection(p) }
                    }
            )
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("\(game.size) 路围棋棋盘。轮到\(game.toMove.name)")
            .accessibilityHint("在棋线交叉点落子")
        }
    }

    private func nearest(_ position: CGPoint, margin: CGFloat, spacing: CGFloat) -> GoPoint? {
        let c = Int(round((position.x - margin) / spacing))
        let r = Int(round((position.y - margin) / spacing))
        let p = GoPoint(row: r, col: c)
        guard game.valid(p) else { return nil }
        let dx = abs(position.x - (margin + CGFloat(c) * spacing))
        let dy = abs(position.y - (margin + CGFloat(r) * spacing))
        return dx <= spacing * 0.65 && dy <= spacing * 0.65 ? p : nil
    }
}
