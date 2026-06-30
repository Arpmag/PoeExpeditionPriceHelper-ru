import SwiftUI

struct StatCard: View {
  let value: Int
  let label: String
  let icon: String

  var body: some View {
    VStack(spacing: 6) {
      Image(systemName: icon)
        .font(.caption)
        .foregroundStyle(.green)

      Text("\(value)")
        .font(.title2.bold())
        .foregroundStyle(.white)
        .contentTransition(.numericText())

      Text(label)
        .font(.caption2)
        .foregroundStyle(.white.opacity(0.5))
        .multilineTextAlignment(.center)
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 16)
    .background(.white.opacity(0.06))
    .clipShape(RoundedRectangle(cornerRadius: 14))
  }
}

#Preview {
  HStack {
    StatCard(value: 6, label: "тижнів", icon: "calendar")
    StatCard(value: 14, label: "годин", icon: "clock")
    StatCard(value: 32, label: "хвилин", icon: "timer")
  }
  .padding()
  .background(Color.black)
}
