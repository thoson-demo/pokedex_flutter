# Design System Master File

> **LOGIC:** When building a specific page, first check `design-system/pages/[page-name].md`.
> If that file exists, its rules **override** this Master file.
> If not, strictly follow the rules below.

---

**Project:** Pokedex Wiki
**Theme:** Vibrant Red (News/Media Style)
**Category:** Information / Wiki

---

## Global Rules

### Color Palette

| Role | Hex | CSS Variable | Usage |
|------|-----|--------------|-------|
| Primary | `#DC2626` | `--color-primary` | Main headers, active icons, primary actions |
| Secondary | `#EF4444` | `--color-secondary` | Gradients, highlights |
| Background | `#FEF2F2` | `--color-background` | Global scaffold background (Warm Light Grey) |
| Surface | `#FFFFFF` | `--color-surface` | Cards, modsls, input fields |
| Text | `#111827` | `--color-text` | Primary text (Deep Grey) |
| Text Light | `#6B7280` | `--color-text-light` | Secondary text, hints |

### Typography

- **Font Family:** [Outfit](https://fonts.google.com/specimen/Outfit)
- **Headlines:** Bold, Uppercase, Tracking-wide.
- **Body:** Clean, geometric sans-serif.

### Component Specs

#### Buttons & Interactables
- **Hover Effects:** Scale up (1.05x) with smooth transition.
- **Shadows:** Soft, diffused shadows (`BoxShadow(color: Colors.black12, blurRadius: 10)`).
- **Rounding:** `BorderRadius.circular(16)` for cards and inputs.

#### Cards (Block Style)
- **Background:** White (`#FFFFFF`).
- **Elevation:** Moderate to High (4-8).
- **Border:** None (use shadow).
- **Layout:** Full-bleed images where possible.

### Layout Patterns
- **Home:** Floating Search Bar (detached from AppBar), Responsive Grid.
- **Detail:** Vibrant Header with curved gradient, Floating Info Cards.

---

## Anti-Patterns (Do NOT Use)

- ❌ **Dark Mode / Neon:** Do not use the old purple/dark theme.
- ❌ **Flat Design:** Always use shadows and depth (elevation).
- ❌ **System Fonts:** Always use `Outfit`.
- ❌ **Borders:** Avoid borders on cards; use shadows for separation.

---

## Pre-Delivery Checklist

- [ ] Primary color is `#DC2626`
- [ ] Font is `Outfit`
- [ ] Background is `#FEF2F2`
- [ ] Cards have rounded corners (16px) and shadows
- [ ] No borders on cards
