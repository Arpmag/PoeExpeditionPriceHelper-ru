import SwiftUI

struct HomeView: View {
  @EnvironmentObject private var store: SobrietyStore
  @State private var showSettings = false

  var body: some View {
    NavigationStack {
      ZStack {
        LinearGradient(
          colors: [Color(red: 0.08, green: 0.12, blue: 0.22), Color(red: 0.04, green: 0.08, blue: 0.14)],
          startPoint: .topLeading,
          endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        ScrollView {
          VStack(spacing: 24) {
            mainCounter
            timeBreakdown
            nextMilestoneCard
            MilestonesView()
          }
          .padding(20)
        }
      }
      .navigationTitle("Тверезі дні")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            showSettings = true
          } label: {
            Image(systemName: "gearshape.fill")
              .foregroundStyle(.white.opacity(0.8))
          }
        }
      }
      .sheet(isPresented: $showSettings) {
        SettingsView()
      }
    }
  }

  private var mainCounter: some View {
    VStack(spacing: 8) {
      Text("\(store.daysSober)")
        .font(.system(size: 96, weight: .bold, design: .rounded))
        .foregroundStyle(
          LinearGradient(
            colors: [.green, Color(red: 0.4, green: 0.9, blue: 0.6)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          )
        )
        .contentTransition(.numericText())
        .animation(.easeInOut, value: store.daysSober)

      Text(daysLabel)
        .font(.title2.weight(.medium))
        .foregroundStyle(.white.opacity(0.8))

      if let startDate = store.startDate {
        Text("з \(formattedDate(startDate))")
          .font(.subheadline)
          .foregroundStyle(.white.opacity(0.5))
      }
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 32)
    .background(.white.opacity(0.06))
    .clipShape(RoundedRectangle(cornerRadius: 24))
  }

  private var timeBreakdown: some View {
    HStack(spacing: 12) {
      StatCard(value: store.weeksSober, label: weeksLabel, icon: "calendar")
      StatCard(value: store.hoursSober, label: hoursLabel, icon: "clock")
      StatCard(value: store.minutesSober, label: minutesLabel, icon: "timer")
    }
  }

  @ViewBuilder
  private var nextMilestoneCard: some View {
    if let next = store.nextMilestone, let daysLeft = store.daysUntilNextMilestone {
      VStack(alignment: .leading, spacing: 12) {
        HStack {
          Text(next.emoji)
            .font(.title)
          VStack(alignment: .leading, spacing: 2) {
            Text("Наступна ціль: \(next.title)")
              .font(.headline)
              .foregroundStyle(.white)
            Text("Ще \(daysLeft) \(ukrainianDays(daysLeft))")
              .font(.subheadline)
              .foregroundStyle(.white.opacity(0.6))
          }
          Spacer()
        }

        ProgressView(value: Double(store.daysSober), total: Double(next.days))
          .tint(.green)
      }
      .padding(16)
      .background(.white.opacity(0.06))
      .clipShape(RoundedRectangle(cornerRadius: 16))
    } else {
      HStack {
        Text("🎉")
          .font(.largeTitle)
        VStack(alignment: .leading) {
          Text("Всі цілі досягнуто!")
            .font(.headline)
            .foregroundStyle(.white)
          Text("Ти неймовірний(а)!")
            .font(.subheadline)
            .foregroundStyle(.white.opacity(0.6))
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(16)
      .background(.green.opacity(0.15))
      .clipShape(RoundedRectangle(cornerRadius: 16))
    }
  }

  private var daysLabel: String {
    ukrainianDays(store.daysSober, capitalized: true)
  }

  private var weeksLabel: String {
    ukrainianWeeks(store.weeksSober)
  }

  private var hoursLabel: String {
    ukrainianHours(store.hoursSober)
  }

  private var minutesLabel: String {
    ukrainianMinutes(store.minutesSober)
  }

  private func formattedDate(_ date: Date) -> String {
    date.formatted(.dateTime.day().month(.wide).year().locale(Locale(identifier: "uk_UA")))
  }
}

#Preview {
  let store = SobrietyStore()
  store.startSobriety(from: Calendar.current.date(byAdding: .day, value: -45, to: .now)!)
  return HomeView()
    .environmentObject(store)
}
