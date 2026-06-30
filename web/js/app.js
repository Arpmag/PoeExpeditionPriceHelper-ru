const STORAGE_KEY = 'sobrietyStartDate';

const MILESTONES = [
  { days: 1, title: 'Перший день', emoji: '🌱' },
  { days: 7, title: 'Тиждень', emoji: '⭐' },
  { days: 14, title: 'Два тижні', emoji: '💪' },
  { days: 30, title: 'Місяць', emoji: '🏆' },
  { days: 90, title: '90 днів', emoji: '🔥' },
  { days: 180, title: 'Пів року', emoji: '🌟' },
  { days: 365, title: 'Рік', emoji: '👑' },
  { days: 730, title: 'Два роки', emoji: '💎' },
  { days: 1095, title: 'Три роки', emoji: '🚀' }
];

const app = document.getElementById('app');
let tickTimer = null;

function getStartDate() {
  const raw = localStorage.getItem(STORAGE_KEY);
  if (!raw) return null;
  const date = new Date(raw);
  return Number.isNaN(date.getTime()) ? null : date;
}

function setStartDate(date) {
  const normalized = new Date(date);
  normalized.setHours(0, 0, 0, 0);
  localStorage.setItem(STORAGE_KEY, normalized.toISOString());
}

function clearStartDate() {
  localStorage.removeItem(STORAGE_KEY);
}

function getStats(now = new Date()) {
  const start = getStartDate();
  if (!start) {
    return { days: 0, weeks: 0, hours: 0, minutes: 0, start: null };
  }

  const diffMs = Math.max(0, now - start);
  const totalMinutes = Math.floor(diffMs / 60000);
  const totalHours = Math.floor(diffMs / 3600000);
  const days = Math.floor(diffMs / 86400000);

  return {
    days,
    weeks: Math.floor(days / 7),
    hours: totalHours % 24,
    minutes: totalMinutes % 60,
    start
  };
}

function getNextMilestone(days) {
  return MILESTONES.find((m) => m.days > days) || null;
}

function escapeHtml(text) {
  return String(text)
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;');
}

function renderOnboarding() {
  const today = new Date().toISOString().slice(0, 10);
  app.innerHTML = `
    <main class="screen onboarding">
      <div class="hero">
        <div class="emoji-large">🌿</div>
        <h1>Тверезі дні</h1>
        <p class="subtitle">Відстежуй свій шлях до тверезості.<br>Кожен день — це перемога.</p>
      </div>

      <section class="card">
        <h2>Коли ти почав(ла) тверезість?</h2>
        <label class="toggle-row">
          <span>Почати з сьогодні</span>
          <input type="checkbox" id="useToday" checked>
          <span class="switch"></span>
        </label>
        <div id="datePickerWrap" class="hidden">
          <input type="date" id="startDate" max="${today}" value="${today}">
        </div>
      </section>

      <button class="btn-primary" id="startBtn">Почати відлік</button>
    </main>
  `;

  const useToday = document.getElementById('useToday');
  const dateWrap = document.getElementById('datePickerWrap');

  useToday.addEventListener('change', () => {
    dateWrap.classList.toggle('hidden', useToday.checked);
  });

  document.getElementById('startBtn').addEventListener('click', () => {
    const date = useToday.checked ? new Date() : new Date(document.getElementById('startDate').value);
    setStartDate(date);
    render();
  });
}

function renderHome() {
  const stats = getStats();
  const next = getNextMilestone(stats.days);
  const daysLeft = next ? next.days - stats.days : 0;
  const progress = next ? (stats.days / next.days) * 100 : 100;

  app.innerHTML = `
    <main class="screen home">
      <header class="topbar">
        <h1>Тверезі дні</h1>
        <button class="icon-btn" id="settingsBtn" aria-label="Налаштування">⚙️</button>
      </header>

      <section class="counter-card">
        <div class="counter-number">${stats.days}</div>
        <div class="counter-label">${ukrainianDays(stats.days, true)}</div>
        <div class="counter-since">з ${formatDateUk(stats.start)}</div>
      </section>

      <section class="stats-row">
        <div class="stat-card">
          <div class="stat-icon">📅</div>
          <div class="stat-value">${stats.weeks}</div>
          <div class="stat-label">${ukrainianWeeks(stats.weeks)}</div>
        </div>
        <div class="stat-card">
          <div class="stat-icon">🕐</div>
          <div class="stat-value">${stats.hours}</div>
          <div class="stat-label">${ukrainianHours(stats.hours)}</div>
        </div>
        <div class="stat-card">
          <div class="stat-icon">⏱️</div>
          <div class="stat-value">${stats.minutes}</div>
          <div class="stat-label">${ukrainianMinutes(stats.minutes)}</div>
        </div>
      </section>

      <section class="card milestone-progress">
        ${next ? `
          <div class="milestone-header">
            <span class="milestone-emoji">${next.emoji}</span>
            <div>
              <div class="milestone-title">Наступна ціль: ${escapeHtml(next.title)}</div>
              <div class="milestone-sub">Ще ${daysLeft} ${ukrainianDays(daysLeft)}</div>
            </div>
          </div>
          <div class="progress-bar"><div class="progress-fill" style="width:${progress}%"></div></div>
        ` : `
          <div class="milestone-header">
            <span class="milestone-emoji">🎉</span>
            <div>
              <div class="milestone-title">Всі цілі досягнуто!</div>
              <div class="milestone-sub">Ти неймовірний(а)!</div>
            </div>
          </div>
        `}
      </section>

      <section class="milestones-list">
        <h2>Досягнення</h2>
        ${MILESTONES.map((m) => {
          const reached = stats.days >= m.days;
          return `
            <div class="milestone-item ${reached ? 'reached' : ''}">
              <span class="milestone-emoji">${m.emoji}</span>
              <div class="milestone-info">
                <div class="milestone-name">${escapeHtml(m.title)}</div>
                <div class="milestone-days">${m.days} ${ukrainianDays(m.days)}</div>
              </div>
              <span class="check">${reached ? '✅' : '○'}</span>
            </div>
          `;
        }).join('')}
      </section>
    </main>
  `;

  document.getElementById('settingsBtn').addEventListener('click', renderSettings);
}

function renderSettings() {
  const stats = getStats();
  const today = new Date().toISOString().slice(0, 10);
  const current = stats.start.toISOString().slice(0, 10);

  app.innerHTML = `
    <main class="screen settings">
      <header class="topbar">
        <button class="text-btn" id="backBtn">← Назад</button>
        <h1>Налаштування</h1>
        <span class="spacer"></span>
      </header>

      <section class="card">
        <label class="field-label">Дата початку тверезості</label>
        <input type="date" id="editDate" max="${today}" value="${current}">
      </section>

      <section class="card danger-zone">
        <button class="btn-danger" id="resetBtn">Скинути лічильник</button>
        <p class="hint">Скидання видалить поточну дату. Ти зможеш встановити нову.</p>
      </section>

      <section class="card about">
        <div class="about-row"><span>Версія</span><span>1.0.0</span></div>
        <div class="about-row"><span>Мова</span><span>Українська</span></div>
      </section>
    </main>
  `;

  document.getElementById('backBtn').addEventListener('click', render);

  document.getElementById('editDate').addEventListener('change', (e) => {
    setStartDate(new Date(e.target.value));
    renderHome();
    renderSettings();
  });

  document.getElementById('resetBtn').addEventListener('click', () => {
    if (confirm('Скинути лічильник? Цю дію неможливо скасувати.')) {
      clearStartDate();
      render();
    }
  });
}

function render() {
  if (tickTimer) {
    clearInterval(tickTimer);
    tickTimer = null;
  }

  if (!getStartDate()) {
    renderOnboarding();
    return;
  }

  renderHome();
  tickTimer = setInterval(() => {
    if (getStartDate()) renderHome();
  }, 60000);
}

render();
