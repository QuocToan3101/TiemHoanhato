// Leaflet + Nominatim shipping widget
// - Nominatim autocomplete with debounce
// - Leaflet mini map preview
// - address confirmation modal
// - realtime shipping estimate from backend

(function () {
  const resolvedContextPath = (window.CONTEXT_PATH || document.querySelector('meta[name="context-path"]')?.content || '').trim();
  const ctxPath = resolvedContextPath || inferContextPath();
  const addressInput = document.getElementById('shippingAddressInput');
  const suggestionsBox = document.getElementById('shippingSuggestions');
  const latInput = document.getElementById('shipping_lat');
  const lngInput = document.getElementById('shipping_lng');
  const placeIdInput = document.getElementById('shipping_place_id');
  const osmTypeInput = document.getElementById('shipping_osm_type');
  const osmIdInput = document.getElementById('shipping_osm_id');
  const useLocationBtn = document.getElementById('useLocationBtn');
  const mapContainer = document.getElementById('shippingMap');
  const skeleton = document.getElementById('shippingSkeleton');
  const result = document.getElementById('shippingResult');
  const errorBox = document.getElementById('shippingError');
  const shipDistance = document.getElementById('ship_distance');
  const shipEta = document.getElementById('ship_eta');
  const shipFee = document.getElementById('ship_fee');
  const shipFeeEstimate = document.getElementById('ship_fee_estimate');
  const confirmModal = document.getElementById('addressConfirmModal');
  const confirmText = document.getElementById('addressConfirmText');
  const confirmAccept = document.getElementById('addressConfirmAccept');
  const confirmCancel = document.getElementById('addressConfirmCancel');

  let debounceTimer = null;
  let searchAbort = null;
  let selectedAddress = null;
  let map = null;
  let marker = null;
  let leafletReady = false;

  injectShippingStyles();
  initEvents();

  function initEvents() {
    if (!addressInput || !suggestionsBox) return;

    addressInput.addEventListener('input', () => {
      clearSelection(false);
      scheduleSearch(addressInput.value.trim());
    });

    addressInput.addEventListener('blur', () => {
      setTimeout(() => hideSuggestions(), 120);
    });

    addressInput.addEventListener('focus', () => {
      if (addressInput.value.trim()) {
        scheduleSearch(addressInput.value.trim());
      }
    });

    useLocationBtn?.addEventListener('click', (event) => {
      event.preventDefault();
      useCurrentLocation();
    });

    confirmAccept?.addEventListener('click', () => {
      hideConfirmModal();
      calculateShipping();
    });

    confirmCancel?.addEventListener('click', () => {
      hideConfirmModal();
      addressInput.focus();
    });

    document.addEventListener('click', (event) => {
      if (!suggestionsBox.contains(event.target) && event.target !== addressInput) {
        hideSuggestions();
      }
    });
  }

  function scheduleSearch(query) {
    if (debounceTimer) clearTimeout(debounceTimer);
    if (!query || query.length < 3) {
      hideSuggestions();
      return;
    }
    debounceTimer = setTimeout(() => searchPlaces(query), 350);
  }

  async function searchPlaces(query) {
    if (searchAbort) searchAbort.abort();
    searchAbort = new AbortController();
    showSuggestionsLoading();
    try {
      const url = new URL('https://nominatim.openstreetmap.org/search');
      url.searchParams.set('q', query);
      url.searchParams.set('format', 'jsonv2');
      url.searchParams.set('addressdetails', '1');
      url.searchParams.set('countrycodes', 'vn');
      url.searchParams.set('limit', '6');

      const response = await fetch(url.toString(), {
        signal: searchAbort.signal,
        headers: {
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest'
        }
      });
      if (!response.ok) throw new Error('search_failed');
      const data = await response.json();
      renderSuggestions(Array.isArray(data) ? data : []);
    } catch (error) {
      if (error.name !== 'AbortError') {
        renderSuggestions([]);
      }
    }
  }

  function renderSuggestions(items) {
    if (!suggestionsBox) return;
    if (!items.length) {
      suggestionsBox.innerHTML = '<div class="shipping-suggestion-empty">Không tìm thấy địa chỉ phù hợp</div>';
      suggestionsBox.style.display = 'block';
      return;
    }

    suggestionsBox.innerHTML = items.map((item) => `
      <button type="button" class="shipping-suggestion" data-place-id="${escapeHtml(item.place_id || '')}" data-lat="${escapeHtml(item.lat || '')}" data-lon="${escapeHtml(item.lon || '')}" data-name="${escapeHtml(item.display_name || '')}" data-osm-type="${escapeHtml(item.osm_type || '')}" data-osm-id="${escapeHtml(item.osm_id || '')}">
        <span class="shipping-suggestion-title">${escapeHtml(shorten(item.display_name || 'Địa chỉ'))}</span>
        <span class="shipping-suggestion-meta">${escapeHtml(formatAddressMeta(item))}</span>
      </button>
    `).join('');

    suggestionsBox.style.display = 'block';
    suggestionsBox.querySelectorAll('.shipping-suggestion').forEach((button) => {
      button.addEventListener('click', () => selectSuggestion(button.dataset));
    });
  }

  function selectSuggestion(data) {
    selectedAddress = {
      placeId: data.placeId || data.place_id,
      lat: parseFloat(data.lat),
      lng: parseFloat(data.lon),
      displayName: data.name,
      osmType: data.osmType || data.osm_type,
      osmId: data.osmId || data.osm_id
    };

    if (!selectedAddress.placeId || Number.isNaN(selectedAddress.lat) || Number.isNaN(selectedAddress.lng)) {
      showError('Địa chỉ được chọn không hợp lệ.');
      return;
    }

    addressInput.value = selectedAddress.displayName;
    placeIdInput.value = selectedAddress.placeId;
    latInput.value = String(selectedAddress.lat);
    lngInput.value = String(selectedAddress.lng);
    osmTypeInput.value = selectedAddress.osmType || '';
    osmIdInput.value = String(selectedAddress.osmId || '');

    hideSuggestions();
    showConfirmModal(selectedAddress);
    renderMap(selectedAddress.lat, selectedAddress.lng, selectedAddress.displayName);
  }

  function showConfirmModal(address) {
    if (!confirmModal || !confirmText || !confirmAccept) {
      calculateShipping();
      return;
    }
    confirmText.textContent = `${address.displayName} - ${address.lat.toFixed(6)}, ${address.lng.toFixed(6)}`;
    confirmModal.style.display = 'flex';
  }

  function hideConfirmModal() {
    if (confirmModal) {
      confirmModal.style.display = 'none';
    }
  }

  function clearSelection(keepInputValue) {
    selectedAddress = null;
    placeIdInput.value = '';
    latInput.value = '';
    lngInput.value = '';
    osmTypeInput.value = '';
    osmIdInput.value = '';
    if (!keepInputValue) {
      if (result) result.style.display = 'none';
      if (mapContainer) mapContainer.style.display = 'none';
    }
  }

  async function calculateShipping() {
    if (!selectedAddress) {
      showError('Vui lòng chọn địa chỉ từ danh sách gợi ý trước khi tính phí.');
      return;
    }

    showSkeleton(true);
    try {
      const orderAmount = getOrderAmount();
      const response = await fetch(`${ctxPath}/api/shipping/calculate`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-Token': window.csrfToken || ''
        },
        body: JSON.stringify({
          place_id: selectedAddress.placeId,
          display_name: selectedAddress.displayName,
          lat: selectedAddress.lat,
          lng: selectedAddress.lng,
          osm_type: selectedAddress.osmType,
          osm_id: selectedAddress.osmId,
          order_amount: orderAmount
        })
      });

      const payload = await response.json();
      if (!response.ok) {
        throw new Error(payload.error || 'calculate_failed');
      }

      if (!payload.deliverable) {
        showError(payload.error || payload.message || 'Địa chỉ không thuộc phạm vi giao hàng.');
        return;
      }

      updateSummary(payload);
    } catch (error) {
      showError(friendlyError(error));
    } finally {
      showSkeleton(false);
    }
  }

  function updateSummary(payload) {
    const distance = Number(payload.distance_km || 0);
    const eta = Number(payload.eta_minutes || 0);
    const displayFee = Number(payload.display_fee || 0);
    const estimatedFee = Number(payload.estimated_fee || payload.carrier_fee || payload.ghtk_fee || 0);

    if (shipDistance) shipDistance.textContent = `${distance.toFixed(2)} km`;
    if (shipEta) shipEta.textContent = `${eta} phút`;
    if (shipFee) shipFee.textContent = payload.free_shipping || displayFee === 0 ? 'Miễn phí' : formatMoney(displayFee);
    if (shipFeeEstimate) shipFeeEstimate.textContent = estimatedFee > 0 ? formatMoney(estimatedFee) : 'Đang chờ GHN';
    if (result) result.style.display = 'block';

    syncCheckoutFields(payload, displayFee);
    dispatchShippingUpdated(payload);

    const shippingEl = document.getElementById('shippingFee');
    if (shippingEl) {
      shippingEl.textContent = payload.free_shipping || displayFee === 0 ? 'Miễn phí' : formatMoney(displayFee);
    }
  }

  function syncCheckoutFields(payload, displayFee) {
    const shippingFeeInput = document.getElementById('shippingFeeInput');
    const totalInput = document.getElementById('totalInput');
    const grandTotal = document.getElementById('grandTotal');
    const subtotalInput = document.querySelector('input[name="subtotal"]');
    const subtotalValue = subtotalInput ? parseInt(subtotalInput.value || '0', 10) : getOrderAmount();
    const shippingValue = Number.isFinite(displayFee) ? Math.round(displayFee) : 0;
    const totalValue = subtotalValue + shippingValue - getDiscountValue();

    if (shippingFeeInput) shippingFeeInput.value = String(shippingValue);
    if (totalInput) totalInput.value = String(totalValue);
    if (grandTotal) grandTotal.textContent = formatMoney(totalValue);
  }

  function getDiscountValue() {
    const discountInput = document.getElementById('discountInput');
    if (!discountInput) return 0;
    const value = parseInt(discountInput.value || '0', 10);
    return Number.isNaN(value) ? 0 : value;
  }

  function dispatchShippingUpdated(payload) {
    document.dispatchEvent(new CustomEvent('shipping:updated', { detail: payload }));
  }

  function renderMap(lat, lng, label) {
    if (!mapContainer) return;
    loadLeaflet(() => {
      mapContainer.style.display = 'block';
      if (!map) {
        map = L.map(mapContainer, { zoomControl: true, scrollWheelZoom: false }).setView([lat, lng], 15);
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
          attribution: '&copy; OpenStreetMap contributors',
          maxZoom: 19
        }).addTo(map);
        marker = L.marker([lat, lng], { icon: createAnimatedMarkerIcon() }).addTo(map);
      } else {
        map.setView([lat, lng], 15);
        marker.setLatLng([lat, lng]);
      }
      marker.bindPopup(escapeHtml(label || 'Địa chỉ đã chọn')).openPopup();
      setTimeout(() => map.invalidateSize(), 100);
    });
  }

  function loadLeaflet(callback) {
    if (leafletReady && window.L) {
      callback();
      return;
    }
    leafletReady = true;

    if (!document.querySelector('link[data-leaflet="1"]')) {
      const css = document.createElement('link');
      css.rel = 'stylesheet';
      css.href = 'https://unpkg.com/leaflet@1.9.4/dist/leaflet.css';
      css.setAttribute('data-leaflet', '1');
      document.head.appendChild(css);
    }

    if (document.querySelector('script[data-leaflet="1"]')) {
      const waitForLeaflet = () => {
        if (window.L) {
          callback();
          return;
        }
        setTimeout(waitForLeaflet, 50);
      };
      waitForLeaflet();
      return;
    }

    const script = document.createElement('script');
    script.src = 'https://unpkg.com/leaflet@1.9.4/dist/leaflet.js';
    script.async = true;
    script.setAttribute('data-leaflet', '1');
    script.onload = callback;
    script.onerror = () => showError('Không thể tải bản đồ Leaflet.');
    document.head.appendChild(script);
  }

  function useCurrentLocation() {
    if (!navigator.geolocation) {
      showError('Trình duyệt không hỗ trợ định vị hiện tại.');
      return;
    }
    showSkeleton(true);
    navigator.geolocation.getCurrentPosition(async (position) => {
      try {
        const { latitude, longitude } = position.coords;
        const url = new URL('https://nominatim.openstreetmap.org/reverse');
        url.searchParams.set('lat', String(latitude));
        url.searchParams.set('lon', String(longitude));
        url.searchParams.set('format', 'jsonv2');
        url.searchParams.set('addressdetails', '1');

        const response = await fetch(url.toString(), {
          headers: {
            'Accept': 'application/json',
            'X-Requested-With': 'XMLHttpRequest'
          }
        });
        const data = await response.json();
        if (!data || !data.place_id) {
          throw new Error('reverse_failed');
        }
        const suggestion = {
          place_id: data.place_id,
          display_name: data.display_name,
          lat: latitude,
          lon: longitude,
          osm_type: data.osm_type,
          osm_id: data.osm_id
        };
        selectSuggestion({
          placeId: suggestion.place_id,
          lat: suggestion.lat,
          lon: suggestion.lon,
          name: suggestion.display_name,
          osmType: suggestion.osm_type,
          osmId: suggestion.osm_id
        });
      } catch (error) {
        showError('Không thể xác định vị trí hiện tại.');
      } finally {
        showSkeleton(false);
      }
    }, () => {
      showError('Không thể lấy vị trí hiện tại.');
    }, { enableHighAccuracy: true, timeout: 10000 });
  }

  function showSkeleton(visible) {
    if (skeleton) skeleton.style.display = visible ? 'block' : 'none';
    if (visible) {
      if (result) result.style.display = 'none';
      if (errorBox) errorBox.style.display = 'none';
    }
  }

  function showError(message) {
    if (errorBox) {
      errorBox.textContent = message;
      errorBox.style.display = 'block';
    }
    if (result) result.style.display = 'none';
    if (skeleton) skeleton.style.display = 'none';
  }

  function hideSuggestions() {
    if (!suggestionsBox) return;
    suggestionsBox.style.display = 'none';
    suggestionsBox.innerHTML = '';
  }

  function showSuggestionsLoading() {
    if (!suggestionsBox) return;
    suggestionsBox.innerHTML = '<div class="shipping-suggestion-empty">Đang tìm địa chỉ...</div>';
    suggestionsBox.style.display = 'block';
  }

  function formatAddressMeta(item) {
    const parts = [];
    if (item.address) {
      if (item.address.city) parts.push(item.address.city);
      if (item.address.state) parts.push(item.address.state);
      if (item.address.country) parts.push(item.address.country);
    }
    return parts.length ? parts.join(' • ') : 'OpenStreetMap';
  }

  function shorten(text) {
    return text.length > 96 ? `${text.slice(0, 96)}...` : text;
  }

  function formatMoney(value) {
    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(value || 0);
  }

  function getOrderAmount() {
    const subtotalInput = document.querySelector('input[name="subtotal"]');
    const rawValue = subtotalInput?.value || document.getElementById('subtotal')?.textContent || '0';
    const total = parseInt(String(rawValue).replace(/[^0-9]/g, ''), 10);
    return Number.isNaN(total) ? 0 : total;
  }

  function inferContextPath() {
    const path = window.location.pathname || '';
    const parts = path.split('/').filter(Boolean);
    if (parts.length > 0) {
      return `/${parts[0]}`;
    }
    return '';
  }

  function friendlyError(error) {
    const message = (error && error.message) ? error.message : String(error || '');
    if (message.includes('fetch')) return 'Không thể kết nối máy chủ tính phí. Vui lòng thử lại.';
    if (message.includes('calculate_failed')) return 'Không tính được phí giao hàng lúc này.';
    return 'Địa chỉ không hợp lệ hoặc không thuộc phạm vi giao hàng.';
  }

  function createAnimatedMarkerIcon() {
    return L.divIcon({
      className: 'shipping-marker-wrap',
      html: '<div class="shipping-marker-pulse"></div><div class="shipping-marker-pin"></div>',
      iconSize: [32, 32],
      iconAnchor: [16, 32]
    });
  }

  function escapeHtml(value) {
    return String(value)
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&#39;');
  }

  function injectShippingStyles() {
    const style = document.createElement('style');
    style.textContent = `
      .shipping-suggestions {
        position: relative;
        z-index: 20;
        margin-bottom: 10px;
        border: 1px solid #ead9ca;
        border-radius: 14px;
        background: #fff;
        box-shadow: 0 16px 30px rgba(43, 41, 38, 0.08);
        overflow: hidden;
      }
      .shipping-suggestion {
        width: 100%;
        display: flex;
        flex-direction: column;
        gap: 4px;
        padding: 12px 14px;
        border: none;
        background: #fff;
        text-align: left;
        cursor: pointer;
        border-bottom: 1px solid #f4eadf;
      }
      .shipping-suggestion:hover {
        background: #faf3ea;
      }
      .shipping-suggestion:last-child {
        border-bottom: none;
      }
      .shipping-suggestion-title {
        font-weight: 600;
        color: var(--ink);
      }
      .shipping-suggestion-meta,
      .shipping-suggestion-empty {
        font-size: 12px;
        color: var(--muted);
      }
      .shipping-skeleton {
        padding: 8px 0 12px;
      }
      .sk-line {
        height: 12px;
        border-radius: 999px;
        margin-bottom: 10px;
        background: linear-gradient(90deg, #f2e7df 25%, #e8d7c9 37%, #f2e7df 63%);
        background-size: 400% 100%;
        animation: shippingSkeleton 1.25s ease-in-out infinite;
      }
      .sk-line-lg { width: 90%; height: 16px; }
      .sk-line-sm { width: 55%; }
      @keyframes shippingSkeleton {
        0% { background-position: 100% 50%; }
        100% { background-position: 0 50%; }
      }
      .shipping-modal {
        position: fixed;
        inset: 0;
        background: rgba(23, 19, 17, 0.42);
        z-index: 1000;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 18px;
      }
      .shipping-modal-card {
        width: min(100%, 460px);
        background: #fff;
        border-radius: 20px;
        padding: 18px;
        box-shadow: 0 30px 70px rgba(0,0,0,.18);
      }
      .shipping-marker-wrap {
        background: transparent;
        border: none;
      }
      .shipping-marker-pin {
        width: 16px;
        height: 16px;
        border-radius: 50% 50% 50% 0;
        transform: rotate(-45deg);
        background: linear-gradient(180deg, #a97155, #8a5c44);
        border: 2px solid #fff;
        box-shadow: 0 8px 18px rgba(138, 92, 68, 0.35);
        position: absolute;
        left: 8px;
        top: 4px;
        animation: shippingMarkerBounce 1.6s ease-in-out infinite;
      }
      .shipping-marker-pulse {
        width: 28px;
        height: 28px;
        border-radius: 50%;
        background: rgba(169, 113, 85, 0.16);
        animation: shippingPulse 1.6s ease-out infinite;
      }
      @keyframes shippingPulse {
        0% { transform: scale(0.7); opacity: 0.8; }
        100% { transform: scale(1.6); opacity: 0; }
      }
      @keyframes shippingMarkerBounce {
        0%, 100% { transform: rotate(-45deg) translateY(0); }
        50% { transform: rotate(-45deg) translateY(-4px); }
      }
      @media (max-width: 768px) {
        .shipping-modal-card { padding: 16px; }
      }
    `;
    document.head.appendChild(style);
  }
})();
