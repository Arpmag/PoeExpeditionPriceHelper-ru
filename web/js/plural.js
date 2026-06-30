function ukrainianDays(count, capitalized = false) {
  const word = pluralForm(count, 'день', 'дні', 'днів');
  return capitalized ? word.charAt(0).toUpperCase() + word.slice(1) : word;
}

function ukrainianWeeks(count) {
  return pluralForm(count, 'тиждень', 'тижні', 'тижнів');
}

function ukrainianHours(count) {
  return pluralForm(count, 'година', 'години', 'годин');
}

function ukrainianMinutes(count) {
  return pluralForm(count, 'хвилина', 'хвилини', 'хвилин');
}

function pluralForm(count, one, few, many) {
  const absCount = Math.abs(count) % 100;
  const lastDigit = absCount % 10;

  if (absCount >= 11 && absCount <= 19) return many;
  if (lastDigit === 1) return one;
  if (lastDigit >= 2 && lastDigit <= 4) return few;
  return many;
}

function formatDateUk(date) {
  return date.toLocaleDateString('uk-UA', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  });
}
