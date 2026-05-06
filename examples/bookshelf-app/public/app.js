const list = document.getElementById("book-list");
const empty = document.getElementById("empty");
const form = document.getElementById("add-form");
const errorEl = document.getElementById("add-error");

const STATUS_LABEL = { want: "Want to read", reading: "Reading", read: "Read" };
const NEXT_STATUS = { want: "reading", reading: "read", read: "want" };

async function load() {
  const res = await fetch("/api/books");
  const books = await res.json();
  render(books);
}

function render(books) {
  list.innerHTML = "";
  empty.hidden = books.length > 0;
  for (const b of books) {
    const li = document.createElement("li");
    li.className = "card";
    li.dataset.id = b.id;
    li.innerHTML = `
      <div>
        <strong>${escapeHtml(b.title)}</strong>
        <div class="meta">${escapeHtml(b.author)} · <span class="badge ${b.status}">${STATUS_LABEL[b.status]}</span></div>
      </div>
      <div class="actions">
        <button type="button" class="secondary" data-action="advance">Mark ${STATUS_LABEL[NEXT_STATUS[b.status]]}</button>
        <button type="button" class="danger" data-action="delete">Delete</button>
      </div>
    `;
    list.appendChild(li);
  }
}

function escapeHtml(s) {
  return String(s).replace(/[&<>"']/g, (c) => ({
    "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;"
  }[c]));
}

form.addEventListener("submit", async (e) => {
  e.preventDefault();
  errorEl.hidden = true;
  const data = Object.fromEntries(new FormData(form));
  const res = await fetch("/api/books", {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: JSON.stringify(data)
  });
  if (!res.ok) {
    const body = await res.json().catch(() => ({}));
    errorEl.textContent = (body.errors || ["Could not add book"]).join(", ");
    errorEl.hidden = false;
    return;
  }
  form.reset();
  load();
});

list.addEventListener("click", async (e) => {
  const btn = e.target.closest("button[data-action]");
  if (!btn) return;
  const id = btn.closest(".card").dataset.id;
  const action = btn.dataset.action;

  if (action === "delete") {
    await fetch(`/api/books/${id}`, { method: "DELETE" });
  } else if (action === "advance") {
    const card = btn.closest(".card");
    const current = card.querySelector(".badge").classList[1];
    await fetch(`/api/books/${id}`, {
      method: "PATCH",
      headers: { "content-type": "application/json" },
      body: JSON.stringify({ status: NEXT_STATUS[current] })
    });
  }
  load();
});

load();
