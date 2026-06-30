import SwiftUI

struct MilestonesView: View {
  @EnvironmentObject private var store: SobrietyStore

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("Досягнення")
        .font(.headline)
        .foregroundStyle(.white)

      ForEach(store.milestones) { milestone in
        HStack(spacing: 14) {
          Text(milestone.emoji)
            .font(.title2)
            .frame(width: 40)
            .opacity(store.isMilestoneReached(milestone) ? 1 : 0.3)

          VStack(alignment: .leading, spacing: 2) {
            Text(milestone.title)
              .font(.subheadline.weight(.medium))
              .foregroundStyle(store.isMilestoneReached(milestone) ? .white : .white.opacity(0.4))
            Text("\(milestone.days) \(ukrainianDays(milestone.days))")
              .font(.caption)
              .foregroundStyle(.white.opacity(0.4))
          }

          Spacer()

          if store.isMilestoneReached(milestone) {
            Image(systemName: "checkmark.circle.fill")
              .foregroundStyle(.green)
          } else {
            Image(systemName: "circle")
              .foregroundStyle(.white.opacity(0.2))
          }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(store.isMilestoneReached(milestone) ? .green.opacity(0.1) : .white.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: 12))
      }
    }
  }
}

#Preview {
  let store = SobrietyStore()
  store.startSobriety(from: Calendar.current.date(byAdding: .day, value: -45, to: .now)!)
  return MilestonesView()
    .environmentObject(store)
    .padding()
    .background(Color.black)
}
