import { createServer } from "node:http";
import { readFile, writeFile, mkdir, stat } from "node:fs/promises";
import { extname, join, dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import { randomUUID } from "node:crypto";

const __dirname = dirname(fileURLToPath(import.meta.url));
const PORT = Number(process.env.PORT || 4173);
const DATA_FILE = resolve(__dirname, "data", "books.json");
const PUBLIC_DIR = resolve(__dirname, "public");

const MIME = {
  ".html": "text/html; charset=utf-8",
  ".css": "text/css; charset=utf-8",
  ".js": "text/javascript; charset=utf-8",
  ".json": "application/json; charset=utf-8",
  ".svg": "image/svg+xml"
};

const ALLOWED_STATUS = new Set(["want", "reading", "read"]);

async function loadBooks() {
  try {
    const raw = await readFile(DATA_FILE, "utf8");
    return JSON.parse(raw);
  } catch (err) {
    if (err.code === "ENOENT") return [];
    throw err;
  }
}

async function saveBooks(books) {
  await mkdir(dirname(DATA_FILE), { recursive: true });
  await writeFile(DATA_FILE, JSON.stringify(books, null, 2), "utf8");
}

function send(res, status, body, headers = {}) {
  res.writeHead(status, { "content-type": "application/json; charset=utf-8", ...headers });
  res.end(typeof body === "string" ? body : JSON.stringify(body));
}

async function readJsonBody(req) {
  return new Promise((resolveBody, rejectBody) => {
    let data = "";
    req.on("data", (chunk) => (data += chunk));
    req.on("end", () => {
      if (!data) return resolveBody({});
      try { resolveBody(JSON.parse(data)); } catch (err) { rejectBody(err); }
    });
    req.on("error", rejectBody);
  });
}

function validateBookInput(input, { partial = false } = {}) {
  const errors = [];
  if (!partial || input.title !== undefined) {
    if (typeof input.title !== "string" || !input.title.trim()) errors.push("title is required");
  }
  if (!partial || input.author !== undefined) {
    if (typeof input.author !== "string" || !input.author.trim()) errors.push("author is required");
  }
  if (input.status !== undefined && !ALLOWED_STATUS.has(input.status)) {
    errors.push(`status must be one of ${[...ALLOWED_STATUS].join(", ")}`);
  }
  return errors;
}

async function serveStatic(req, res) {
  let pathname = new URL(req.url, "http://localhost").pathname;
  if (pathname === "/") pathname = "/index.html";
  const filePath = resolve(PUBLIC_DIR, "." + pathname);
  if (!filePath.startsWith(PUBLIC_DIR)) return send(res, 403, { error: "forbidden" });
  try {
    const info = await stat(filePath);
    if (!info.isFile()) throw Object.assign(new Error("not file"), { code: "ENOENT" });
    const body = await readFile(filePath);
    res.writeHead(200, { "content-type": MIME[extname(filePath)] || "application/octet-stream" });
    res.end(body);
  } catch {
    send(res, 404, { error: "not found" });
  }
}

const server = createServer(async (req, res) => {
  const url = new URL(req.url, "http://localhost");

  try {
    if (url.pathname === "/api/books" && req.method === "GET") {
      const books = await loadBooks();
      return send(res, 200, books);
    }

    if (url.pathname === "/api/books" && req.method === "POST") {
      const body = await readJsonBody(req);
      const errors = validateBookInput(body);
      if (errors.length) return send(res, 400, { errors });
      const books = await loadBooks();
      const book = {
        id: randomUUID(),
        title: body.title.trim(),
        author: body.author.trim(),
        status: body.status && ALLOWED_STATUS.has(body.status) ? body.status : "want",
        addedAt: new Date().toISOString()
      };
      books.push(book);
      await saveBooks(books);
      return send(res, 201, book);
    }

    const idMatch = url.pathname.match(/^\/api\/books\/([^/]+)$/);
    if (idMatch) {
      const id = idMatch[1];
      const books = await loadBooks();
      const idx = books.findIndex((b) => b.id === id);
      if (idx === -1) return send(res, 404, { error: "not found" });

      if (req.method === "PATCH") {
        const body = await readJsonBody(req);
        const errors = validateBookInput(body, { partial: true });
        if (errors.length) return send(res, 400, { errors });
        const updated = { ...books[idx] };
        if (body.title !== undefined) updated.title = body.title.trim();
        if (body.author !== undefined) updated.author = body.author.trim();
        if (body.status !== undefined) updated.status = body.status;
        books[idx] = updated;
        await saveBooks(books);
        return send(res, 200, updated);
      }

      if (req.method === "DELETE") {
        const [removed] = books.splice(idx, 1);
        await saveBooks(books);
        return send(res, 200, removed);
      }
    }

    if (req.method === "GET") return serveStatic(req, res);
    send(res, 404, { error: "not found" });
  } catch (err) {
    console.error(err);
    send(res, 500, { error: "internal error" });
  }
});

server.listen(PORT, () => {
  console.log(`Bookshelf running at http://localhost:${PORT}`);
});
