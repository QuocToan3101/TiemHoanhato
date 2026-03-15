const __fragmentCache = new Map();
async function loadFragment(url) {
  if (__fragmentCache.has(url)) return __fragmentCache.get(url);
  const res = await fetch(url);
  const html = await res.text();
  __fragmentCache.set(url, html);
  return html;
}

class SiteHeader extends HTMLElement {
  async connectedCallback() {
    const src = this.getAttribute("src") || "partials/header.jsp";
    this.innerHTML = await loadFragment(src);
  }
}
class SiteFooter extends HTMLElement {
  async connectedCallback() {
    const src = this.getAttribute("src") || "partials/footer.jsp";
    this.innerHTML = await loadFragment(src);
  }
}

customElements.define("site-header", SiteHeader);
customElements.define("site-footer", SiteFooter);
