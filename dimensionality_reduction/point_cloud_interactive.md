# Point Cloud — Rotation & Scaling

This interactive shows a 2D Gaussian point cloud with standard deviations 3.5 (x) and 1.2 (y), rotated initially by 33°. Use the controls to rotate the points and stretch/shrink along the current axes. Reset returns to the initial state.

<div style="display:flex; gap:16px; align-items:flex-start; flex-wrap:wrap">
  <div style="min-width:280px; font:14px/1.4 system-ui, sans-serif">
    <div style="margin-bottom:8px">
      <label>Rotation (°): <span id="val-rot">0</span></label>
      <input id="ctrl-rot" type="range" min="-180" max="180" step="1" value="0" style="width:100%"/>
    </div>
    <div style="margin-bottom:8px">
      <label>Scale X: <span id="val-sx">1.00</span></label>
      <input id="ctrl-sx" type="range" min="0.2" max="3" step="0.01" value="1" style="width:100%"/>
    </div>
    <div style="margin-bottom:8px">
      <label>Scale Y: <span id="val-sy">1.00</span></label>
      <input id="ctrl-sy" type="range" min="0.2" max="3" step="0.01" value="1" style="width:100%"/>
    </div>
    <button id="btn-reset" style="padding:6px 10px">Reset</button>
    <div style="margin-top:10px; color:#666; font-size:12px">
      Note: rotation rotates the points (axes stay fixed). Scaling stretches/shrinks along the current axes implied by the rotation.
    </div>
  </div>
  <div style="display:flex; flex-direction:column; gap:8px;">
    <textarea id="mat-txt" rows="3" readonly style="width:100%; max-width:100%; font:13px/1.4 ui-monospace, SFMono-Regular, Menlo, Consolas, monospace; padding:6px; border:1px solid #ddd; border-radius:4px; background:#fafafa"></textarea>
    <div style="display:flex; gap:12px; flex-wrap:wrap; align-items:flex-start;">
      <div style="display:flex; flex-direction:column; gap:4px;">
        <div style="font:12px/1.2 system-ui, sans-serif; color:#666">Main: points + Σ columns</div>
        <svg id="pc-svg" width="240" height="200" viewBox="0 0 240 200" style="border:1px solid #ccc; background:#fff"></svg>
      </div>
      <div style="display:flex; flex-direction:column; gap:4px;">
        <div style="font:12px/1.2 system-ui, sans-serif; color:#666">Standard normal N(0, I)</div>
        <svg id="pc-norm" width="240" height="200" viewBox="0 0 240 200" style="border:1px solid #eee; background:#fff"></svg>
      </div>
      <div style="display:flex; flex-direction:column; gap:4px;">
        <div style="font:12px/1.2 system-ui, sans-serif; color:#666">Apply sqrt(Σ) to N(0, I): y = Σ^{1/2} x</div>
        <svg id="pc-covapply" width="240" height="200" viewBox="0 0 240 200" style="border:1px solid #eee; background:#fff"></svg>
      </div>
      <div style="display:flex; flex-direction:column; gap:4px;">
        <div style="font:12px/1.2 system-ui, sans-serif; color:#666">sqrt(Σ) with PCA rotation vectors</div>
        <svg id="pc-pca" width="240" height="200" viewBox="0 0 240 200" style="border:1px solid #eee; background:#fff"></svg>
      </div>
    </div>
  </div>
</div>

```js browser
// Point cloud with SDx=3.5, SDy=1.2, rotated 33° initially.
// Controls: rotate points (axes fixed), scale along current rotated axes.
(function pointCloud() {
  const svg = document.querySelector('#pc-svg');
  const rotInp = document.querySelector('#ctrl-rot');
  const sxInp  = document.querySelector('#ctrl-sx');
  const syInp  = document.querySelector('#ctrl-sy');
  const reset  = document.querySelector('#btn-reset');
  const matTxt = document.querySelector('#mat-txt');
  const svgN   = document.querySelector('#pc-norm');
  const svgS   = document.querySelector('#pc-covapply');
  const svgP   = document.querySelector('#pc-pca');
  const vRot   = document.querySelector('#val-rot');
  const vSx    = document.querySelector('#val-sx');
  const vSy    = document.querySelector('#val-sy');
  if (!svg) return;

  const W = svg.viewBox?.baseVal?.width  || svg.clientWidth  || 240;
  const H = svg.viewBox?.baseVal?.height || svg.clientHeight || 200;
  const Wn = svgN?.viewBox?.baseVal?.width  || svgN?.clientWidth  || 240;
  const Hn = svgN?.viewBox?.baseVal?.height || svgN?.clientHeight || 200;
  const Ws = svgS?.viewBox?.baseVal?.width  || svgS?.clientWidth  || 240;
  const Hs = svgS?.viewBox?.baseVal?.height || svgS?.clientHeight || 200;
  const Wp = svgP?.viewBox?.baseVal?.width  || svgP?.clientWidth  || 240;
  const Hp = svgP?.viewBox?.baseVal?.height || svgP?.clientHeight || 200;

  function elt(name){ return document.createElementNS('http://www.w3.org/2000/svg', name); }
  // Axes helper available to whole module
  function mkAxes(svgEl, W, H, xMin,xMax,yMin,yMax){
    const x2sx = x => ( (x - xMin) / (xMax - xMin) ) * W;
    const y2sy = y => H - ( (y - yMin) / (yMax - yMin) ) * H;
    const axX = elt('line'); axX.setAttribute('x1', '0'); axX.setAttribute('x2', String(W)); axX.setAttribute('y1', String(y2sy(0))); axX.setAttribute('y2', String(y2sy(0))); axX.setAttribute('stroke','#eee');
    const axY = elt('line'); axY.setAttribute('y1', '0'); axY.setAttribute('y2', String(H)); axY.setAttribute('x1', String(x2sx(0))); axY.setAttribute('x2', String(x2sx(0))); axY.setAttribute('stroke','#eee');
    return {x2sx,y2sy,axX,axY};
  }

  // Symmetric PSD 2x2 square root: returns S with S S^T = [[a,b],[b,c]]
  function sqrtSigma2x2(a,b,c){
    // Eigen decomposition
    const tr = a + c;
    const diff = a - c;
    const disc = Math.sqrt(Math.max(0, diff*diff + 4*b*b));
    let l1 = (tr + disc)/2;
    let l2 = (tr - disc)/2;
    if (l1 < 0) l1 = 0; if (l2 < 0) l2 = 0; // clamp tiny negatives
    // First eigenvector for l1
    let q1x, q1y;
    if (Math.abs(b) > 1e-12 || Math.abs(a - l1) > 1e-12){
      q1x = b; q1y = l1 - a;
    } else {
      // Diagonal matrix case
      if (a >= c) { q1x = 1; q1y = 0; } else { q1x = 0; q1y = 1; }
    }
    const n1 = Math.hypot(q1x, q1y) || 1; q1x /= n1; q1y /= n1;
    // Orthogonal second eigenvector
    let q2x = -q1y, q2y = q1x;
    const r1 = Math.sqrt(l1), r2 = Math.sqrt(l2);
    // Recompose symmetric square root S = r1*q1*q1^T + r2*q2*q2^T
    const s11 = r1*q1x*q1x + r2*q2x*q2x;
    const s12 = r1*q1x*q1y + r2*q2x*q2y;
    const s22 = r1*q1y*q1y + r2*q2y*q2y;
    return [[s11, s12],[s12, s22]];
  }

  // Generate base points: Z ~ N(0,1)^2 -> scale to SDs -> rotate by 33°
  const N = 800;
  const SDx = 3.5, SDy = 1.2;
  const deg2rad = d => d*Math.PI/180;
  const R0 = 33;
  function boxMuller(){
    // Standard normal via Box-Muller
    let u=0, v=0; while(u===0) u=Math.random(); while(v===0) v=Math.random();
    const mag = Math.sqrt(-2.0*Math.log(u));
    const z0 = mag*Math.cos(2*Math.PI*v);
    const z1 = mag*Math.sin(2*Math.PI*v);
    return [z0, z1];
  }
  function rot2(theta){ const c=Math.cos(theta), s=Math.sin(theta); return [[c,-s],[s,c]]; }
  function mul2(A, x){ return [A[0][0]*x[0]+A[0][1]*x[1], A[1][0]*x[0]+A[1][1]*x[1]]; }

  const R0m = rot2(deg2rad(R0));
  const base = new Array(N);
  for (let i=0;i<N;i++){
    const [z0,z1] = boxMuller();
    const p = [z0*SDx, z1*SDy];
    const pr = mul2(R0m, p); // rotated by 33° initially
    base[i] = pr; // base reference
  }

  // World bounds: radius max times max scale (3.0) with margin.
  const rmax = base.reduce((m,[x,y]) => Math.max(m, Math.hypot(x,y)), 0);
  const sMaxUI = Math.max(parseFloat(sxInp.max||'3'), parseFloat(syInp.max||'3'));
  const worldR = rmax * sMaxUI * 1.1;
  const world = { xMin: -worldR, xMax: worldR, yMin: -worldR, yMax: worldR };

  // Clear and draw axes
  while (svg.firstChild) svg.removeChild(svg.firstChild);
  const gAxes = elt('g');
  const gPts  = elt('g');
  const gCov  = elt('g');
  svg.appendChild(gAxes); svg.appendChild(gPts); svg.appendChild(gCov);
  // Main axes using shared world
  const axesM = mkAxes(svg, W, H, world.xMin, world.xMax, world.yMin, world.yMax);
  gAxes.appendChild(axesM.axX); gAxes.appendChild(axesM.axY);

  // Prepare point elements once
  const circles = new Array(N);
  for (let i=0;i<N;i++){
    const c = elt('circle'); c.setAttribute('r','2'); c.setAttribute('fill','hsl(210,50%,45%)'); c.setAttribute('opacity','0.9');
    gPts.appendChild(c); circles[i]=c;
  }

  // Standard normal panel and Σ-applied panel
  let zPts = [];
  const Nn = 600;
  if (svgN && svgS && svgP){
    while (svgN.firstChild) svgN.removeChild(svgN.firstChild);
    while (svgS.firstChild) svgS.removeChild(svgS.firstChild);
    while (svgP.firstChild) svgP.removeChild(svgP.firstChild);
    var gNaxes = elt('g'), gNpts = elt('g'); svgN.appendChild(gNaxes); svgN.appendChild(gNpts);
    var gSaxes = elt('g'), gSpts = elt('g'); svgS.appendChild(gSaxes); svgS.appendChild(gSpts);
    var gPaxes = elt('g'), gPpts = elt('g'), gPvec = elt('g'); svgP.appendChild(gPaxes); svgP.appendChild(gPpts); svgP.appendChild(gPvec);
    // Static world for N(0,I)
    var worldN = {min:-4, max:4};
    var axesN = mkAxes(svgN, Wn, Hn, worldN.min, worldN.max, worldN.min, worldN.max);
    gNaxes.appendChild(axesN.axX); gNaxes.appendChild(axesN.axY);
    // Prepare circles
    var nCircles = new Array(Nn), sCircles = new Array(Nn), pCircles = new Array(Nn);
    for (let i=0;i<Nn;i++){
      const [z0,z1] = boxMuller(); zPts.push([z0, z1]);
      const cn = elt('circle'); cn.setAttribute('r','2'); cn.setAttribute('fill','hsl(210,15%,25%)'); cn.setAttribute('opacity','0.7'); gNpts.appendChild(cn); nCircles[i]=cn;
      const cs = elt('circle'); cs.setAttribute('r','2'); cs.setAttribute('fill','hsl(25,70%,45%)'); cs.setAttribute('opacity','0.8'); gSpts.appendChild(cs); sCircles[i]=cs;
      const cp = elt('circle'); cp.setAttribute('r','2'); cp.setAttribute('fill','hsl(265,60%,45%)'); cp.setAttribute('opacity','0.85'); gPpts.appendChild(cp); pCircles[i]=cp;
    }
    // Build axes for both side panels using the same world as main
    var axesS = mkAxes(svgS, Ws, Hs, world.xMin, world.xMax, world.yMin, world.yMax);
    gSaxes.appendChild(axesS.axX); gSaxes.appendChild(axesS.axY);
    // Override axesN to use the same world
    axesN = mkAxes(svgN, Wn, Hn, world.xMin, world.xMax, world.yMin, world.yMax);
    // Replace axes group children with new axes
    while (gNaxes.firstChild) gNaxes.removeChild(gNaxes.firstChild);
    gNaxes.appendChild(axesN.axX); gNaxes.appendChild(axesN.axY);
    // Axes for PCA panel
    var axesP = mkAxes(svgP, Wp, Hp, world.xMin, world.xMax, world.yMin, world.yMax);
    gPaxes.appendChild(axesP.axX); gPaxes.appendChild(axesP.axY);
    // PCA vector arrows
    var pcaL1 = elt('line'); pcaL1.setAttribute('stroke', '#d33'); pcaL1.setAttribute('stroke-width','2');
    var pcaL2 = elt('line'); pcaL2.setAttribute('stroke', '#2a7'); pcaL2.setAttribute('stroke-width','2');
    var pcaT1 = elt('circle'); pcaT1.setAttribute('r','3'); pcaT1.setAttribute('fill','#d33');
    var pcaT2 = elt('circle'); pcaT2.setAttribute('r','3'); pcaT2.setAttribute('fill','#2a7');
    gPvec.appendChild(pcaL1); gPvec.appendChild(pcaL2); gPvec.appendChild(pcaT1); gPvec.appendChild(pcaT2);
  }

  // Covariance column vectors (arrows from origin)
  const covL1 = elt('line'); covL1.setAttribute('stroke', '#d33'); covL1.setAttribute('stroke-width', '2');
  const covL2 = elt('line'); covL2.setAttribute('stroke', '#2a7'); covL2.setAttribute('stroke-width', '2');
  const tip1  = elt('circle'); tip1.setAttribute('r','3'); tip1.setAttribute('fill','#d33');
  const tip2  = elt('circle'); tip2.setAttribute('r','3'); tip2.setAttribute('fill','#2a7');
  gCov.appendChild(covL1); gCov.appendChild(covL2); gCov.appendChild(tip1); gCov.appendChild(tip2);

  function updateLabels(){
    vRot.textContent = String(parseInt(rotInp.value,10));
    vSx.textContent  = parseFloat(sxInp.value).toFixed(2);
    vSy.textContent  = parseFloat(syInp.value).toFixed(2);
  }

  // Apply transform: y = S(sx,sy) * R(phi) * base
  function redraw(){
    const phi = deg2rad(parseFloat(rotInp.value));
    const sx = parseFloat(sxInp.value);
    const sy = parseFloat(syInp.value);
    const R = rot2(phi);
    const xs = new Array(N), ys = new Array(N);
    let sumX = 0, sumY = 0;
    for (let i=0;i<N;i++){
      const p = base[i];
      const pr = mul2(R, p);            // rotate points (axes fixed)
      const ps = [pr[0]*sx, pr[1]*sy];  // scale along current axes
      xs[i] = ps[0]; ys[i] = ps[1]; sumX += ps[0]; sumY += ps[1];
      circles[i].setAttribute('cx', String(axesM.x2sx(ps[0])));
      circles[i].setAttribute('cy', String(axesM.y2sy(ps[1])));
    }
    // Covariance matrix of transformed points
    const meanX = sumX / N, meanY = sumY / N;
    let cxx = 0, cxy = 0, cyy = 0;
    for (let i=0;i<N;i++){
      const dx = xs[i] - meanX; const dy = ys[i] - meanY;
      cxx += dx*dx; cxy += dx*dy; cyy += dy*dy;
    }
    cxx /= (N-1); cxy /= (N-1); cyy /= (N-1);

    // Column vectors v1=[cxx,cxy], v2=[cxy,cyy], scaled to fit
    const v1 = [cxx, cxy];
    const v2 = [cxy, cyy];
    const l1 = Math.hypot(v1[0], v1[1]);
    const l2 = Math.hypot(v2[0], v2[1]);
    const s  = (0.35*worldR) / Math.max(1e-9, l1, l2);
    const p1 = [v1[0]*s, v1[1]*s];
    const p2 = [v2[0]*s, v2[1]*s];
    const ox = axesM.x2sx(0), oy = axesM.y2sy(0);
    covL1.setAttribute('x1', String(ox)); covL1.setAttribute('y1', String(oy));
    covL1.setAttribute('x2', String(axesM.x2sx(p1[0]))); covL1.setAttribute('y2', String(axesM.y2sy(p1[1])));
    covL2.setAttribute('x1', String(ox)); covL2.setAttribute('y1', String(oy));
    covL2.setAttribute('x2', String(axesM.x2sx(p2[0]))); covL2.setAttribute('y2', String(axesM.y2sy(p2[1])));
    tip1.setAttribute('cx', String(axesM.x2sx(p1[0]))); tip1.setAttribute('cy', String(axesM.y2sy(p1[1])));
    tip2.setAttribute('cx', String(axesM.x2sx(p2[0]))); tip2.setAttribute('cy', String(axesM.y2sy(p2[1])));

    // Update matrix display M and Σ
    if (matTxt){
      const c = Math.cos(phi), s_ = Math.sin(phi);
      const a = sx*c, b = -sx*s_, c2 = sy*s_, d = sy*c;
      const fmt = n => (Math.abs(n) < 1e-6 ? '0.000' : n.toFixed(3));
      matTxt.value = `M = S(sx,sy) · R(θ)\n`+
        `  = [ ${fmt(a)}  ${fmt(b)} ]\n`+
        `    [ ${fmt(c2)}  ${fmt(d)} ]\n`+
        `where θ=${parseInt(rotInp.value,10)}°, sx=${sx.toFixed(2)}, sy=${sy.toFixed(2)}\n\n`+
        `Σ = cov(points)\n`+
        `  = [ ${fmt(cxx)}  ${fmt(cxy)} ]\n`+
        `    [ ${fmt(cxy)}  ${fmt(cyy)} ]`;
    }

    // Update side panels if present
    if (svgN && svgS && svgP){
      // Draw N(0,I)
      for (let i=0;i<Nn;i++){
        const p = zPts[i];
        nCircles[i].setAttribute('cx', String(axesN.x2sx(p[0])));
        nCircles[i].setAttribute('cy', String(axesN.y2sy(p[1])));
      }
      // Apply sqrt(Σ) to points (same world as main)
      const S = sqrtSigma2x2(cxx, cxy, cyy);
      const ptsS = new Array(Nn);
      for (let i=0;i<Nn;i++){
        const p = zPts[i];
        const y = [S[0][0]*p[0] + S[0][1]*p[1], S[1][0]*p[0] + S[1][1]*p[1]];
        ptsS[i] = y;
      }
      for (let i=0;i<Nn;i++){
        const y = ptsS[i];
        sCircles[i].setAttribute('cx', String(axesS.x2sx(y[0])));
        sCircles[i].setAttribute('cy', String(axesS.y2sy(y[1])));
        pCircles[i].setAttribute('cx', String(axesP.x2sx(y[0])));
        pCircles[i].setAttribute('cy', String(axesP.y2sy(y[1])));
      }
      // PCA rotation vectors from Σ eigenvectors (columns of Q)
      const tr = cxx + cyy; const diff = cxx - cyy; const disc = Math.sqrt(Math.max(0, diff*diff + 4*cxy*cxy));
      let l1 = (tr + disc)/2, l2 = (tr - disc)/2; if (l1 < 0) l1 = 0; if (l2 < 0) l2 = 0;
      let q1x, q1y; if (Math.abs(cxy) > 1e-12 || Math.abs(cxx - l1) > 1e-12){ q1x = cxy; q1y = l1 - cxx; } else { if (cxx >= cyy){ q1x=1; q1y=0; } else { q1x=0; q1y=1; } }
      const n1 = Math.hypot(q1x, q1y) || 1; q1x /= n1; q1y /= n1; const q2x = -q1y, q2y = q1x;
      const scaleVec = 0.5 * (world.xMax - world.xMin) * 0.3; // moderate length arrows
      const u1 = [q1x*scaleVec, q1y*scaleVec]; const u2 = [q2x*scaleVec, q2y*scaleVec];
      const oxP = axesP.x2sx(0), oyP = axesP.y2sy(0);
      pcaL1.setAttribute('x1', String(oxP)); pcaL1.setAttribute('y1', String(oyP));
      pcaL1.setAttribute('x2', String(axesP.x2sx(u1[0]))); pcaL1.setAttribute('y2', String(axesP.y2sy(u1[1])));
      pcaL2.setAttribute('x1', String(oxP)); pcaL2.setAttribute('y1', String(oyP));
      pcaL2.setAttribute('x2', String(axesP.x2sx(u2[0]))); pcaL2.setAttribute('y2', String(axesP.y2sy(u2[1])));
      pcaT1.setAttribute('cx', String(axesP.x2sx(u1[0]))); pcaT1.setAttribute('cy', String(axesP.y2sy(u1[1])));
      pcaT2.setAttribute('cx', String(axesP.x2sx(u2[0]))); pcaT2.setAttribute('cy', String(axesP.y2sy(u2[1])));
    }
  }

  function resetAll(){
    rotInp.value = '0'; sxInp.value = '1'; syInp.value = '1';
    updateLabels(); redraw();
  }

  // Wire up events
  ['input','change'].forEach(ev => {
    rotInp.addEventListener(ev, () => { updateLabels(); redraw(); });
    sxInp.addEventListener(ev,  () => { updateLabels(); redraw(); });
    syInp.addEventListener(ev,  () => { updateLabels(); redraw(); });
  });
  reset.addEventListener('click', resetAll);

  // First draw
  updateLabels(); redraw();
})();
```
