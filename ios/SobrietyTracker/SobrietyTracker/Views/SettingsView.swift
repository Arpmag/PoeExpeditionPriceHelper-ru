import SwiftUI

struct SettingsView: View {
  @EnvironmentObject private var store: SobrietyStore
  @Environment(\.dismiss) private var dismiss
  @State private var showResetAlert = false

  var body: some View {
    NavigationStack {
      Form {
        Section("Дата початку") {
          if let startDate = store.startDate {
            DatePicker(
              "Початок тверезості",
              selection: Binding(
                get: { startDate },
                set: { store.startSobriety(from: $0) }
              ),
              in: ...Date(),
              displayedComponents: .date
            )
          }
        }

        Section {
          Button("Скинути лічильник", role: .destructive) {
            showResetAlert = true
          }
        } footer: {
          Text("Скидання видалить поточну дату початку. Ти зможеш встановити нову дату.")
        }

        Section("Про додаток") {
          LabeledContent("Версія", value: "1.0.0")
          LabeledContent("Мова", value: "Українська")
        }
      }
      .navigationTitle("Налаштування")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button("Готово") { dismiss() }
        }
      }
      .alert("Скинути лічильник?", isPresented: $showResetAlert) {
        Button("Скасувати", role: .cancel) {}
        Button("Скинути", role: .destructive) {
          store.resetSobriety()
          dismiss()
        }
      } message: {
        Text("Цю дію неможливо скасувати. Лічильник буде обнулено.")
      }
    }
  }
}

#Preview {
  SettingsView()
    .environmentObject(SobrietyStore())
}
