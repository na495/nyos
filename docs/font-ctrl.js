(function () {
  const BASE = 15,
    MIN = 12,
    MAX = 21,
    STEP = 1;
  const root = document.documentElement;
  const down = document.getElementById("font-down");
  const up = document.getElementById("font-up");
  const label = document.getElementById("font-size");

  let size = parseInt(getComputedStyle(root).getPropertyValue("--root-fs"), 10) || BASE;

  const apply = () => {
    root.style.setProperty("--root-fs", size + "px");
    label.textContent = Math.round((size / BASE) * 100) + "%";
    down.disabled = size <= MIN;
    up.disabled = size >= MAX;
    try {
      localStorage.setItem("fontSize", size);
    } catch (e) {}
  };

  down.addEventListener("click", () => {
    size = Math.max(MIN, size - STEP);
    apply();
  });
  up.addEventListener("click", () => {
    size = Math.min(MAX, size + STEP);
    apply();
  });
  label.addEventListener("click", () => {
    size = BASE;
    apply();
  });

  apply();
})();
