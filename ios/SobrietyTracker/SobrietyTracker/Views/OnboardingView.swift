import SwiftUI

struct OnboardingView: View {
  @EnvironmentObject private var store: SobrietyStore
  @State private var selectedDate = Date()
  @State private var useToday = true

  var body: some View {
    ZStack {
      LinearGradient(
        colors: [Color(red: 0.08, green: 0.12, blue: 0.22), Color(red: 0.04, green: 0.08, blue: 0.14)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
      .ignoresSafeArea()

      VStack(spacing: 32) {
        Spacer()

        VStack(spacing: 12) {
          Text("🌿")
            .font(.system(size: 72))

          Text("Тверезі дні")
            .font(.largeTitle.bold())
            .foregroundStyle(.white)

          Text("Відстежуй свій шлях до тверезості.\nКожен день — це перемога.")
            .font(.body)
            .multilineTextAlignment(.center)
            .foregroundStyle(.white.opacity(0.7))
            .padding(.horizontal)
        }

        VStack(alignment: .leading, spacing: 16) {
          Text("Коли ти почав(ла) тверезість?")
            .font(.headline)
            .foregroundStyle(.white)

          Toggle("Почати з сьогодні", isOn: $useToday)
            .tint(.green)
            .foregroundStyle(.white)

          if !useToday {
            DatePicker(
              "Дата початку",
              selection: $selectedDate,
              in: ...Date(),
              displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .tint(.green)
            .colorScheme(.dark)
          }
        }
        .padding(20)
        .background(.white.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 20))

        Button {
          let date = useToday ? Date() : selectedDate
          store.startSobriety(from: date)
        } label: {
          Text("Почати відлік")
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.green.gradient)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }

        Spacer()
      }
      .padding(24)
    }
  }
}

#Preview {
  OnboardingView()
    .environmentObject(SobrietyStore())
}
