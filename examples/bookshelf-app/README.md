# Bookshelf — brownfield sample (Scenario 2)

A tiny reading-list app: list, add, advance status, delete books.

- Node.js HTTP server, no external dependencies.
- Vanilla HTML/CSS/JS, no build step.
- Persists to `data/books.json`.

## Run

```bash
npm install   # nothing to install, but harmless
npm start
```

Open <http://localhost:4173>.

Override the port:

```bash
PORT=4180 npm start
```

## API

- `GET /api/books` — list
- `POST /api/books` — `{ title, author, status? }`
- `PATCH /api/books/:id` — `{ title?, author?, status? }`
- `DELETE /api/books/:id`

`status` is one of `want`, `reading`, `read`.
