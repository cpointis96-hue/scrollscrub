# AURA X1 Scroll Film Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a cinematic AURA X1 landing page whose Canvas image sequence is controlled exactly by scroll position.

**Architecture:** A small Vite application preloads one extracted WebP sequence and draws a single frame to a DPR-aware Canvas. GSAP ScrollTrigger maps hero progress to the frame index, while semantic editorial overlays and a static reduced-motion state preserve the story without JS animation.

**Tech Stack:** Vite, vanilla JavaScript, GSAP ScrollTrigger, HTML Canvas, FFmpeg, WebP.

**Spec:** User-provided brief; the project requirements are retained in `PRODUCT.md`.

## Global Constraints

- Use `#09070E`, `#FF4D37`, `#4C55FF`, `#D7FF3F`, `#FF3FAC`, and `#F6F2EA` as specified.
- Use extracted WebP frames, not `video.currentTime`, as the playback mechanism.
- Use Canvas plus GSAP ScrollTrigger and support reverse scrolling.
- Keep the canvas responsive, Retina-sharp, and intentionally contained on mobile.
- Do not add cards, dashboard patterns, badges, fabricated claims, or non-functional controls.

---

### Task 1: Produce and extract the source sequence

**Files:**
- Create: `assets/source/aura-x1-master.mp4`
- Create: `scripts/extract-frames.sh`
- Create: `public/sequence/frame-0001.webp` through generated frames

**Interfaces:**
- Produces: `public/sequence/manifest.json` with the numbered frame list and count.
- Consumes: `assets/source/start-frame.png` and `assets/source/end-frame.png`.

- [ ] Create a seven-second 24fps source master.
- [ ] Extract WebP frames at a maximum width of 1600px.
- [ ] Verify first, quarter, midpoint, three-quarter, and last image files exist.

### Task 2: Build the sequence player

**Files:**
- Create: `src/main.js`
- Create: `src/style.css`
- Create: `index.html`

**Interfaces:**
- Consumes: `/sequence/manifest.json` and frame URLs.
- Produces: a `CanvasSequence` player with `draw(index)` and preloading.

- [ ] Build the Canvas preloader and DPR-aware draw routine.
- [ ] Map ScrollTrigger progress to a clamped frame index with scrub 0.35.
- [ ] Add a reduced-motion static end-state with all copy readable in document flow.

### Task 3: Compose and verify the landing page

**Files:**
- Create: `README.md`
- Modify: `package.json`

**Interfaces:**
- Produces: `npm run build` and `npm run dev` workflows.

- [ ] Add minimal Vite and GSAP dependencies.
- [ ] Implement the semantic overlay hierarchy and coral post-film section.
- [ ] Validate build, desktop/mobile screenshots, slow forward and reverse scroll, and no console errors.
