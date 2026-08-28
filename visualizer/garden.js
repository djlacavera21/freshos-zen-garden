(function () {
  const canvas = document.getElementById("garden");
  if (!canvas) return;
  const ctx = canvas.getContext("2d");
  const loadEl = document.getElementById("m-load");
  const memEl = document.getElementById("m-mem");
  const netEl = document.getElementById("m-net");
  const state = { load: 0.22, mem: 0.41, net: 3, t: 0 };
  function resize() {
    const rect = canvas.getBoundingClientRect();
    const dpr = Math.min(window.devicePixelRatio || 1, 2);
    canvas.width = Math.floor(rect.width * dpr);
    canvas.height = Math.floor((rect.width * 0.56) * dpr);
    ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
  }
  resize();
  window.addEventListener("resize", resize);
  function rake(w, h, intensity) {
    ctx.save();
    ctx.strokeStyle = "rgba(196,180,154," + (0.18 + intensity * 0.25) + ")";
    ctx.lineWidth = 1;
    const rows = 18 + Math.floor(intensity * 10);
    for (let i = 0; i < rows; i++) {
      ctx.beginPath();
      const y = (h * 0.18) + i * ((h * 0.7) / rows);
      for (let x = 20; x < w - 20; x += 8) {
        const wave = Math.sin((x + state.t * 30 + i * 12) / 70) * (3 + intensity * 6);
        ctx.lineTo(x, y + wave);
      }
      ctx.stroke();
    }
    ctx.restore();
  }
  function stone(x, y, r) {
    ctx.beginPath();
    ctx.ellipse(x, y, r * 1.3, r * 0.85, -0.3, 0, Math.PI * 2);
    ctx.fillStyle = "#5c564c";
    ctx.fill();
    ctx.strokeStyle = "#8a8274";
    ctx.stroke();
  }
  function lantern(x, y, on) {
    ctx.fillStyle = on ? "#c4a35a" : "#4a4338";
    ctx.fillRect(x - 4, y - 16, 8, 14);
    ctx.beginPath();
    ctx.moveTo(x - 8, y - 16);
    ctx.lineTo(x + 8, y - 16);
    ctx.lineTo(x, y - 26);
    ctx.closePath();
    ctx.fill();
    if (on) {
      ctx.beginPath();
      ctx.arc(x, y - 8, 10, 0, Math.PI * 2);
      ctx.fillStyle = "rgba(196,163,90,0.18)";
      ctx.fill();
    }
  }
  function orb(w, h) {
    const x = w * 0.5, y = h * 0.48;
    const pulse = 26 + Math.sin(state.t * 2) * 3;
    ctx.beginPath();
    ctx.arc(x, y, pulse + 18, 0, Math.PI * 2);
    ctx.fillStyle = "rgba(126,200,196,0.08)";
    ctx.fill();
    ctx.beginPath();
    ctx.arc(x, y, pulse, 0, Math.PI * 2);
    ctx.fillStyle = "#7ec8c4";
    ctx.fill();
  }
  function tick() {
    state.t += 0.016;
    state.load = 0.18 + 0.12 * (0.5 + 0.5 * Math.sin(state.t * 0.35));
    state.mem = 0.36 + 0.08 * (0.5 + 0.5 * Math.sin(state.t * 0.21 + 1));
    state.net = 2 + Math.round(2 * (0.5 + 0.5 * Math.sin(state.t * 0.4)));
    const w = canvas.clientWidth;
    const h = canvas.clientWidth * 0.56;
    ctx.clearRect(0, 0, w, h);
    ctx.fillStyle = "#1a1814";
    ctx.fillRect(0, 0, w, h);
    rake(w, h, state.load);
    const stones = 3 + Math.round(state.mem * 5);
    for (let i = 0; i < stones; i++) {
      stone(80 + i * 70, h * 0.62 + (i % 2) * 18, 10 + (i % 3) * 3);
    }
    for (let i = 0; i < state.net; i++) lantern(w * 0.72 + i * 28, h * 0.32, true);
    orb(w, h);
    if (loadEl) loadEl.textContent = state.load.toFixed(2);
    if (memEl) memEl.textContent = Math.round(state.mem * 100) + "%";
    if (netEl) netEl.textContent = String(state.net);
    requestAnimationFrame(tick);
  }
  tick();
})();
