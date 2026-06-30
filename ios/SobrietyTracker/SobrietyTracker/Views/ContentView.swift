import SwiftUI

struct ContentView: View {
  @EnvironmentObject private var store: SobrietyStore

  var body: some View {
    Group {
      if store.hasCompletedOnboarding, store.startDate != nil {
        HomeView()
      } else {
        OnboardingView()
      }
    }
    .preferredColorScheme(.dark)
  }
}

#Preview {
  ContentView()
    .environmentObject(SobrietyStore())
}
