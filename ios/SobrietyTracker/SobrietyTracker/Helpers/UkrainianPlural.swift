import Foundation

func ukrainianDays(_ count: Int, capitalized: Bool = false) -> String {
  let word = pluralForm(
    count: count,
    one: "день",
    few: "дні",
    many: "днів"
  )
  return capitalized ? word.capitalized : word
}

func ukrainianWeeks(_ count: Int) -> String {
  pluralForm(count: count, one: "тиждень", few: "тижні", many: "тижнів")
}

func ukrainianHours(_ count: Int) -> String {
  pluralForm(count: count, one: "година", few: "години", many: "годин")
}

func ukrainianMinutes(_ count: Int) -> String {
  pluralForm(count: count, one: "хвилина", few: "хвилини", many: "хвилин")
}

private func pluralForm(count: Int, one: String, few: String, many: String) -> String {
  let absCount = abs(count) % 100
  let lastDigit = absCount % 10

  if absCount >= 11 && absCount <= 19 {
    return many
  }
  switch lastDigit {
  case 1: return one
  case 2, 3, 4: return few
  default: return many
  }
}
