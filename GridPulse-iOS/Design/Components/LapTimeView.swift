import SwiftUI

/// Formatted lap time display in monospaced font
struct LapTimeView: View {
    let time: String
    let fontSize: CGFloat
    let highlight: Bool

    init(time: String, fontSize: CGFloat = 16, highlight: Bool = false) {
        self.time = time
        self.fontSize = fontSize
        self.highlight = highlight
    }

    private var formattedTime: String {
        // Already formatted time (e.g., "1:23.456" or "--:--.---")
        if time.contains(":") || time.contains("--") {
            return time
        }
        // Try to format seconds into mm:ss.xxx
        if let seconds = Double(time) {
            return LapData.formatLapTime(seconds)
        }
        return time
    }

    var body: some View {
        Text(formattedTime)
            .font(.system(size: fontSize, weight: highlight ? .bold : .regular, design: .monospaced))
            .foregroundStyle(highlight ? GridPulseTheme.accent : .white)
    }
}

/// Gap to leader display
struct GapView: View {
    let gap: String?

    var body: some View {
        if let gap, !gap.isEmpty {
            Text(gap)
                .font(.system(.caption, weight: .medium, design: .monospaced))
                .foregroundStyle(GridPulseTheme.mutedText)
        } else {
            Text("—")
                .font(.system(.caption, weight: .medium, design: .monospaced))
                .foregroundStyle(GridPulseTheme.mutedText)
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(alignment: .leading, spacing: 8) {
        LapTimeView(time: "1:23.456")
        LapTimeView(time: "1:23.456", highlight: true)
        LapTimeView(time: "--:--.---")
        GapView(gap: "+3.456")
        GapView(gap: nil)
    }
    .padding()
    .background(Color.black)
}