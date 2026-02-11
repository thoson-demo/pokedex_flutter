# Design System Master File

> **LOGIC:** When building a specific page, first check `design-system/pages/[page-name].md`.
> If that file exists, its rules **override** this Master file.
> If not, strictly follow the rules below.

---

**Project:** Pokedex Neon
**Theme:** Cyberpunk / Neon Glow / Beauty App
**Category:** Entertainment / Gaming

---

## Global Rules

### Color Palette

| Role | Hex | CSS Variable | Usage |
|------|-----|--------------|-------|
| Primary | `#7C3AED` | `--color-primary` | Neon Purple (Main actions, headers) |
| Secondary | `#F43F5E` | `--color-secondary` | Fluorescent Rose (Highlights, gradients) |
| Background | `#0F0F23` | `--color-background` | Deep Space Dark (Global background) |
| Surface | `#1E1E3F` | `--color-surface` | Card background (Lighter dark) |
| Text | `#E2E8F0` | `--color-text` | Primary text (Light Grey) |
| Text Dim | `#94A3B8` | `--color-text-dim` | Secondary text |

### Typography

- **Font Family:** [Outfit](https://fonts.google.com/specimen/Outfit) (Geometric Sans)
- **Headlines:** Cyberpunk style - Uppercase, Wide tracking, Glow effects.
- **Body:** Clean, legible sans-serif.

### Component Specs

#### Buttons & Interactables
- **Style:** Neon borders or gradients.
- **Hover:** Glow intensity increase + Scale.
- **Shadows:** Colored shadows (`BoxShadow(color: primary.withOpacity(0.5), blurRadius: 15)`).

#### Cards (Cyberpunk Style)
- **Background:** Dark Surface (`#1E1E3F`).
- **Border:** Thin neon border (optional) or Glow.
- **Effect:** Glassmorphism overlay for text containers.

### Layout Patterns
- **Home:** Immersive dark grid, Floating Neon Search.
- **Detail:** Full-screen beauty shot, glowing stats, "HUD" style info.

---

## Anti-Patterns (Do NOT Use)

- ❌ **Light Mode:** The app is strictly Dark Mode now.
- ❌ **Flat Design:** Use glows and gradients.
- ❌ **Dull Colors:** Use high saturation neon colors.
- ❌ **Standard Shadows:** Use colored/glowing shadows.

---

## Pre-Delivery Checklist

- [ ] Dark Mode (`#0F0F23`) is active
- [ ] Primary Color is `#7C3AED`
- [ ] Text is Light (`#E2E8F0`)
- [ ] Neon Glow effects are present
