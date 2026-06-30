import Foundation
import Combine

struct Milestone: Identifiable, Equatable {
  let id: Int
  let days: Int
  let title: String
  let emoji: String
}

@MainActor
final class SobrietyStore: ObservableObject {
  private enum Keys {
    static let startDate = "sobrietyStartDate"
    static let hasCompletedOnboarding = "hasCompletedOnboarding"
  }

  @Published var startDate: Date? {
    didSet { persist() }
  }

  @Published var hasCompletedOnboarding: Bool {
    didSet { UserDefaults.standard.set(hasCompletedOnboarding, forKey: Keys.hasCompletedOnboarding) }
  }

  @Published var now: Date = .now

  private var timer: AnyCancellable?

  let milestones: [Milestone] = [
    Milestone(id: 1, days: 1, title: "Перший день", emoji: "🌱"),
    Milestone(id: 2, days: 7, title: "Тиждень", emoji: "⭐"),
    Milestone(id: 3, days: 14, title: "Два тижні", emoji: "💪"),
    Milestone(id: 4, days: 30, title: "Місяць", emoji: "🏆"),
    Milestone(id: 5, days: 90, title: "90 днів", emoji: "🔥"),
    Milestone(id: 6, days: 180, title: "Пів року", emoji: "🌟"),
    Milestone(id: 7, days: 365, title: "Рік", emoji: "👑"),
    Milestone(id: 8, days: 730, title: "Два роки", emoji: "💎"),
    Milestone(id: 9, days: 1095, title: "Три роки", emoji: "🚀")
  ]

  init() {
    hasCompletedOnboarding = UserDefaults.standard.bool(forKey: Keys.hasCompletedOnboarding)

    if let timestamp = UserDefaults.standard.object(forKey: Keys.startDate) as? TimeInterval {
      startDate = Date(timeIntervalSince1970: timestamp)
    }

    timer = Timer.publish(every: 60, on: .main, in: .common)
      .autoconnect()
      .sink { [weak self] date in
        self?.now = date
      }
  }

  var daysSober: Int {
    guard let startDate else { return 0 }
    return Calendar.current.dateComponents([.day], from: startDate, to: now).day ?? 0
  }

  var hoursSober: Int {
    guard let startDate else { return 0 }
    let total = Calendar.current.dateComponents([.hour], from: startDate, to: now).hour ?? 0
    return total % 24
  }

  var minutesSober: Int {
    guard let startDate else { return 0 }
    let total = Calendar.current.dateComponents([.minute], from: startDate, to: now).minute ?? 0
    return total % 60
  }

  var weeksSober: Int { daysSober / 7 }
  var monthsSober: Int { daysSober / 30 }

  var nextMilestone: Milestone? {
    milestones.first { $0.days > daysSober }
  }

  var daysUntilNextMilestone: Int? {
    guard let next = nextMilestone else { return nil }
    return next.days - daysSober
  }

  func isMilestoneReached(_ milestone: Milestone) -> Bool {
    daysSober >= milestone.days
  }

  func startSobriety(from date: Date) {
    startDate = Calendar.current.startOfDay(for: date)
    hasCompletedOnboarding = true
  }

  func resetSobriety() {
    startDate = nil
    hasCompletedOnboarding = false
  }

  private func persist() {
    if let startDate {
      UserDefaults.standard.set(startDate.timeIntervalSince1970, forKey: Keys.startDate)
    } else {
      UserDefaults.standard.removeObject(forKey: Keys.startDate)
    }
  }
}
