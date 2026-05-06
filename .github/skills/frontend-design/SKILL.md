---
name: frontend-design
description: Opinionated, framework-free frontend defaults for small workshop apps. Use when generating HTML/CSS/JS UIs without a build step.
---

# Frontend design defaults

Use these defaults whenever a workshop scenario builds a small browser UI (no framework, no build step).

## Markup

- Semantic HTML first: `<header>`, `<main>`, `<section>`, `<form>`, `<button>`, `<label>`. No `<div>` soup.
- Every form control has a `<label for="...">`. Every button has a clear text label.
- Set `<html lang="en">` and a `<meta name="viewport" content="width=device-width, initial-scale=1">`.

## Styling

- Single `style.css`. No CSS frameworks, no Tailwind CDN.
- Use a small system font stack: `font-family: system-ui, -apple-system, "Segoe UI", Roboto, sans-serif;`.
- Use CSS variables for colors so theming stays easy:
  ```css
  :root { --bg:#fafafa; --fg:#1f2328; --accent:#0969da; --danger:#cf222e; --muted:#656d76; }
  ```
- Layout with CSS Grid or Flexbox. Avoid absolute positioning unless necessary.
- Provide a sensible default max-width container (~720px) centered with `margin: 0 auto`.
- Respect `prefers-color-scheme: dark` if it's a small extra.

## Behavior

- Vanilla JS modules (`<script type="module">`).
- No external runtime dependencies.
- Persist with `localStorage` for client-only apps; for server-backed apps, use a JSON file under `data/`.
- Validate user input client-side and show inline error messages near the field, not alerts.

## Accessibility (the minimum)

- Visible focus styles (`:focus-visible { outline: 2px solid var(--accent); }`).
- Buttons are `<button type="button">` unless they submit a form.
- Use `aria-live="polite"` for toast/status regions.
- Don't rely on color alone to convey state.

## What NOT to do in workshop apps

- No build tools (no Vite, Webpack, Next.js).
- No CSS-in-JS, no React, no jQuery.
- No third-party icon kits or fonts loaded from the internet.
- No analytics, no telemetry.
