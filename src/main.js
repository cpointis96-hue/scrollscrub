import { gsap } from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';
import './style.css';
import manifest from './data/components.json';

gsap.registerPlugin(ScrollTrigger);
const canvas = document.querySelector('#sequence');
const context = canvas.getContext('2d');
const statusText = document.querySelector('#status-text');
const progressLine = document.querySelector('.progress span');
const reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
const state = { progress: 0 };
let exploded, assembled, components = [];
let viewport = { width: 0, height: 0, scale: 1, x: 0, y: 0 };

const load = (src) => new Promise((resolve, reject) => {
  const image = new Image(); image.onload = () => resolve(image); image.onerror = reject; image.src = src;
});

function resize() {
  const dpr = Math.min(window.devicePixelRatio || 1, 2);
  viewport.width = window.innerWidth; viewport.height = window.innerHeight;
  viewport.scale = viewport.width < 700 ? Math.min(viewport.width / 1672, viewport.height / 941) * 1.15 : Math.max(viewport.width / 1672, viewport.height / 941) * 1.02;
  viewport.x = (viewport.width - 1672 * viewport.scale) / 2;
  viewport.y = (viewport.height - 941 * viewport.scale) / 2;
  canvas.width = Math.round(viewport.width * dpr); canvas.height = Math.round(viewport.height * dpr);
  canvas.style.width = `${viewport.width}px`; canvas.style.height = `${viewport.height}px`;
  context.setTransform(dpr, 0, 0, dpr, 0, 0); context.imageSmoothingEnabled = true; context.imageSmoothingQuality = 'high';
}

function drawImage(image, x, y, width, height, alpha = 1) {
  context.globalAlpha = alpha;
  context.drawImage(image, viewport.x + x * viewport.scale, viewport.y + y * viewport.scale, width * viewport.scale, height * viewport.scale);
}

function render(progress = state.progress) {
  if (!exploded || !assembled || !components.length) return;
  const p = Math.max(0, Math.min(1, progress));
  context.clearRect(0, 0, viewport.width, viewport.height); context.fillStyle = '#07060d'; context.fillRect(0, 0, viewport.width, viewport.height);
  const layerAlpha = Math.min(1, Math.max(0, (p - 0.02) / 0.04));
  drawImage(exploded, 0, 0, 1672, 941, 1 - layerAlpha);
  const assemblyProgress = Math.min(1, Math.max(0, (p - 0.04) / 0.84));
  components.forEach(({ image, source, target }) => {
    const ease = assemblyProgress * assemblyProgress * (3 - 2 * assemblyProgress);
    drawImage(image, source.x + (target.x - source.x) * ease, source.y + (target.y - source.y) * ease, source.width + (target.width - source.width) * ease, source.height + (target.height - source.height) * ease, layerAlpha);
  });
  drawImage(assembled, 0, 0, 1672, 941, Math.min(1, Math.max(0, (p - 0.88) / 0.12)));
  context.globalAlpha = 1; progressLine.style.transform = `scaleX(${p})`; document.documentElement.style.setProperty('--sequence-progress', p);
  statusText.textContent = p > 0.88 ? 'Assembly complete' : p > 0.06 ? 'Components aligning' : 'Assembly ready';
}

async function start() {
  [exploded, assembled, components] = await Promise.all([
    load('/assets/source/exploded.png'), load('/assets/source/assembled.png'),
    Promise.all(manifest.map(async (item) => ({ ...item, image: await load(item.file) })))
  ]);
  resize(); render(0);
  if (reducedMotion) { state.progress = 1; render(1); document.body.classList.add('reduced-motion'); return; }
  gsap.to(state, { progress: 1, ease: 'none', scrollTrigger: { trigger: '.film', start: 'top top', end: '+=520%', pin: true, scrub: 0.35, anticipatePin: 1, onUpdate: (trigger) => render(trigger.progress) } });
  window.addEventListener('resize', () => { resize(); render(); }, { passive: true });
}

start().catch((error) => { statusText.textContent = 'Assembly unavailable'; console.error(error); });
