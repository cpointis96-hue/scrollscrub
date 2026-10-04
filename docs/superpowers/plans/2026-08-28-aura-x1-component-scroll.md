# AURA X1 Component Scroll Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the video-derived frame sequence with a deterministic browser animation that assembles the supplied headphone components on scroll.

**Architecture:** Keep the Vite/GSAP shell, but render the supplied exploded reference and assembled reference on a Canvas. Eleven transparent PNG cutouts are loaded from a JSON manifest and interpolated from measured exploded positions toward final assembly positions; the references provide the seamless start and end states.

**Tech Stack:** Vite, vanilla JavaScript, GSAP ScrollTrigger, Canvas 2D, ImageMagick for reproducible local cutouts.

**Spec:** User-provided brief; the project requirements are retained in `PRODUCT.md`.

## Global Constraints

- No Veo, video generation, or invented intermediate frames.
- Never modify the supplied originals; work from project copies.
- Preserve each visible component as an independent transparent layer.
- Scroll playback must be deterministic and reversible.
- Black components must remain intact; do not remove dark pixels globally.
- Keep the page usable at desktop, tablet, 390px, and reduced motion.

### Task 1: Source copies and component assets

**Files:**
- Create: `assets/source/exploded.png`, `assets/source/assembled.png`
- Create: `assets/components/*.png`
- Create: `scripts/segment-components.sh`
- Create: `src/data/components.json`

- [ ] Copy the two supplied project references without modifying the originals.
- [ ] Generate eleven masked PNG layers with ImageMagick polygon/ellipse masks and a transparent margin.
- [ ] Record each source bounding box, center, and layer path in JSON.
- [ ] Verify dimensions and alpha channels with ImageMagick identify.

### Task 2: Deterministic renderer

**Files:**
- Modify: `src/main.js`

- [ ] Load the two references and component manifest.
- [ ] Draw the exploded reference first, then crossfade to layers between 2% and 6% progress.
- [ ] Interpolate every layer's position and scale through 88% progress, then crossfade to the exact assembled reference.
- [ ] Use GSAP ScrollTrigger with `scrub`, `pin`, and `ease: none`; support reverse scrolling and reduced motion.

### Task 3: Premium responsive surface

**Files:**
- Modify: `index.html`
- Modify: `src/style.css`

- [ ] Retain concise editorial copy and add explicit progress/status semantics.
- [ ] Use near-black aubergine background, restrained orange reflection, hairline separators, and responsive typography.
- [ ] Ensure no horizontal overflow, controls remain tappable, and the post-film section reflows at mobile widths.

### Task 4: Validation

- [ ] Run the segmentation script and inspect the generated assets.
- [ ] Run `npm run build`.
- [ ] Run the Vite preview and verify the start, mid-scroll, end, reverse, mobile, and reduced-motion states.
