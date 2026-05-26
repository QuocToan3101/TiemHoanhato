(function(){
  const CartUI = {
    contextPath: '',
    timers: {},
    updating: new Map(),
    init(contextPath) {
      this.contextPath = contextPath || '';
      window.cartItems = window.cartItems || [];
      this.loadCart();
      // expose helpers for legacy inline calls
      window.increaseQuantity = (id) => this.changeQuantity(id, 1);
      window.decreaseQuantity = (id) => this.changeQuantity(id, -1);
      window.removeItem = (id) => this.removeItem(id);
      window.applyDiscount = () => this.applyDiscount();
      window.CartUI = this;
    },

    async loadCart(){
      this.showSkeleton(true);
      try{
        const res = await fetch(this.contextPath + '/api/cart', { cache: 'no-store' });
        const data = await res.json();
        if (data && data.success && Array.isArray(data.items)){
          const newItems = data.items.map(item => ({
            id: item.productId || item.id,
            name: item.name || (item.product ? item.product.name : 'Sản phẩm'),
            meta: item.product && item.product.category ? item.product.category.name : 'Hoa tươi',
            price: item.price ? parseFloat(item.price) : (item.product ? parseFloat(item.product.salePrice || item.product.price) : 0),
            quantity: Number(item.quantity || 0),
            image: item.image || (item.product && item.product.image ? item.product.image : 'https://via.placeholder.com/100x100?text=No+Image')
          })).filter(i => i.id && i.quantity > 0);
          // mutate existing array to preserve reference used by other scripts
          window.cartItems.length = 0;
          newItems.forEach(i => window.cartItems.push(i));
          this.updateCartBadge(data.itemCount || data.cartCount || window.cartItems.length);
        } else {
          window.cartItems.length = 0;
          this.updateCartBadge(0);
        }
      }catch(e){
        console.error('Error loading cart', e);
        window.cartItems.length = 0;
      } finally{
        this.showSkeleton(false);
        this.renderCart();
        this.renderSummary();
      }
    },

    showSkeleton(show){
      const container = document.getElementById('cartItems');
      if (!container) return;
      if (show){
        container.innerHTML = `<div class="empty-cart" style="padding:20px;">
          <div style="height:120px; background:linear-gradient(90deg,#f6ece4,#fff); border-radius:12px; margin-bottom:12px;" ></div>
          <div style="height:18px; width:60%; background:#eee; border-radius:8px; margin:6px auto;"></div>
          <div style="height:18px; width:40%; background:#eee; border-radius:8px; margin:6px auto;"></div>
        </div>`;
      }
    },

    renderCart(){
      const container = document.getElementById('cartItems');
      if (!container) return;
      if (!window.cartItems || window.cartItems.length === 0){
        container.innerHTML = `
          <div class="empty-cart">
            <div class="empty-cart-icon">🛒</div>
            <h3>Giỏ hàng trống</h3>
            <p style="color: var(--muted); margin: 12px 0;">Hãy thêm sản phẩm vào giỏ hàng!</p>
            <button class="btn" onclick="continueShopping()">Mua sắm ngay</button>
          </div>
        `;
        this.renderSummary();
        return;
      }

      container.innerHTML = window.cartItems.map(item => {
        return `
          <div class="cart-row" data-id="${item.id}">
            <div class="prod">
              <div class="photo"><img loading="lazy" src="${item.image}" alt="${item.name}"/></div>
              <div>
                <div class="name">${this.escape(item.name)}</div>
                <div class="meta">${this.escape(item.meta)}</div>
              </div>
            </div>
            <div>
              <div class="qty-pill" data-id="${item.id}">
                <button class="qty-btn" data-action="dec" aria-label="Giảm">−</button>
                <span class="qty-number">${item.quantity}</span>
                <button class="qty-btn" data-action="inc" aria-label="Tăng">+</button>
              </div>
            </div>
            <div class="price">${this.formatPrice(item.price * item.quantity)}</div>
            <div>
              <div class="remove" data-action="remove" title="Xóa" style="transition:all .25s;">🗑️</div>
            </div>
          </div>
        `;
      }).join('');

      // Attach controls
      container.querySelectorAll('.qty-pill').forEach(el => {
        const id = el.getAttribute('data-id');
        el.querySelectorAll('[data-action]').forEach(btn => {
          btn.addEventListener('click', (e) => {
            const act = btn.getAttribute('data-action');
            if (act === 'inc') this.changeQuantity(Number(id), 1);
            if (act === 'dec') this.changeQuantity(Number(id), -1);
          });
        });
      });

      container.querySelectorAll('[data-action="remove"]').forEach(btn => {
        btn.addEventListener('click', (e) => {
          const row = btn.closest('.cart-row');
          const id = Number(row.getAttribute('data-id'));
          this.removeItem(id);
        });
      });

      // small hover effect
      container.querySelectorAll('.cart-row').forEach(r => {
        r.addEventListener('mouseenter', () => r.classList.add('hover'));
        r.addEventListener('mouseleave', () => r.classList.remove('hover'));
      });

      this.renderSummary();
    },

    changeQuantity(id, delta){
      const item = window.cartItems.find(i => i.id === id);
      if (!item) return;
      const newQty = Math.max(0, item.quantity + delta);
      if (newQty === item.quantity) return;

      // Optimistic UI
      item.quantity = newQty;
      this.updateQtyInDOM(id, newQty);
      this.renderSummary();

      // Debounce API calls per item
      clearTimeout(this.timers[id]);
      this.timers[id] = setTimeout(() => {
        this.sendQuantityUpdate(id, newQty);
      }, 400);
    },

    updateQtyInDOM(id, qty){
      const row = document.querySelector(`.cart-row[data-id="${id}"]`);
      if (!row) return;
      const num = row.querySelector('.qty-number');
      if (num) num.textContent = qty;
      const priceEl = row.querySelector('.price');
      const item = window.cartItems.find(i => i.id === id);
      if (priceEl && item) priceEl.textContent = this.formatPrice(item.price * qty);
    },

    async sendQuantityUpdate(id, qty){
      try{
        this.updating.set(id, true);
        const res = await fetch(this.contextPath + '/api/cart', {
          method: 'PUT',
          headers: { 'Content-Type':'application/json', 'X-CSRF-Token': (window.getCsrfToken? window.getCsrfToken() : '') },
          body: JSON.stringify({ productId: id, quantity: qty })
        });
        const data = await res.json();
        if (!data || !data.success){
          // revert if failed
          console.warn('Update qty failed', data && data.message);
          // refetch cart to be safe
          await this.loadCart();
          this.showError(data && data.message ? data.message : 'Không thể cập nhật số lượng');
        } else {
          this.updateCartBadge(data.cartCount || data.itemCount || window.cartItems.length);
        }
      }catch(e){
        console.error('Qty update error', e);
        await this.loadCart();
        this.showError('Có lỗi khi cập nhật số lượng');
      } finally{
        this.updating.delete(id);
      }
    },

    async removeItem(id){
      // confirm
      const row = document.querySelector(`.cart-row[data-id="${id}"]`);
      const name = row ? row.querySelector('.name')?.textContent : '';
      const ok = await Swal.fire({
        title: 'Xóa sản phẩm',
        text: `Bạn có muốn xóa "${name}" khỏi giỏ hàng không?`,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Xóa',
        cancelButtonText: 'Hủy',
        confirmButtonColor: '#e74c3c'
      });
      if (!ok.isConfirmed) return;

      // optimistic remove animation
      if (row){
        row.style.transition = 'opacity .25s, transform .25s';
        row.style.opacity = 0;
        row.style.transform = 'scale(.98)';
      }

      try{
        const res = await fetch(this.contextPath + '/api/cart?productId=' + id, {
          method: 'DELETE',
          headers: { 'X-CSRF-Token': (window.getCsrfToken? window.getCsrfToken() : '') }
        });
        const data = await res.json();
          if (data && data.success){
          const remaining = window.cartItems.filter(i => i.id !== id);
          window.cartItems.length = 0;
          remaining.forEach(i => window.cartItems.push(i));
          setTimeout(() => this.renderCart(), 260);
          this.updateCartBadge(data.cartCount || data.itemCount || window.cartItems.length);
          this.showSuccess('Đã xóa sản phẩm');
        } else {
          this.showError(data && data.message ? data.message : 'Không thể xóa sản phẩm');
          await this.loadCart();
        }
      }catch(e){
        console.error('Remove error', e);
        this.showError('Có lỗi khi xóa sản phẩm');
        await this.loadCart();
      }
    },

    async applyDiscount(){
      const discountInput = document.getElementById('discountCode');
      if (!discountInput) return;
      const code = discountInput.value.trim();
      if (!code){ this.showWarning('Vui lòng nhập mã giảm giá!'); return; }
      if (!window.cartItems || window.cartItems.length === 0){ this.showWarning('Giỏ hàng đang trống, chưa thể áp mã giảm giá.'); return; }

      const subtotal = window.cartItems.reduce((s,i)=> s + i.price * i.quantity, 0);
      // UI loading state
      const btn = document.querySelector('.coupon-btn');
      btn && (btn.disabled = true);
      btn && (btn.textContent = 'Đang kiểm tra...');

      try{
        const res = await fetch(this.contextPath + '/api/coupon/validate', {
          method:'POST',
          headers: { 'Content-Type':'application/json', 'X-CSRF-Token': (window.getCsrfToken? window.getCsrfToken() : '') },
          body: JSON.stringify({ code: code, subtotal: subtotal })
        });
        const data = await res.json();
        if (res.ok && data.success){
          window.discountAmount = parseFloat(data.discountAmount || 0);
          window.appliedCouponCode = code.toUpperCase();
          document.getElementById('appliedCouponInfo').style.display = 'block';
          document.getElementById('appliedCouponCode').textContent = window.appliedCouponCode;
          discountInput.value = '';
          discountInput.disabled = true;
          this.renderSummary();
          this.showSuccess('Áp dụng mã giảm giá thành công!');
        } else {
          window.discountAmount = 0;
          window.appliedCouponCode = null;
          this.renderSummary();
          this.showError(data && data.message ? data.message : 'Mã giảm giá không hợp lệ!');
        }
      }catch(e){
        console.error('Coupon error', e);
        this.showError('Không thể kiểm tra mã giảm giá. Vui lòng thử lại!');
      }finally{
        btn && (btn.disabled = false);
        btn && (btn.textContent = 'Áp dụng');
      }
    },

    renderSummary(){
      const subtotal = window.cartItems.reduce((s,i)=> s + i.price * i.quantity, 0);
      const discount = window.discountAmount || 0;
      const total = Math.max(0, subtotal - discount);
      const subtotalEl = document.getElementById('subtotal');
      const discountEl = document.getElementById('discount');
      const discountRow = document.getElementById('discountRow');
      const totalEl = document.getElementById('total');
      const discountInput = document.getElementById('discountInput');
      const totalInput = document.getElementById('totalInput');

      if (subtotalEl) subtotalEl.textContent = this.formatPrice(subtotal);
      if (discountEl) discountEl.textContent = '-' + this.formatPrice(discount);
      if (discountRow) discountRow.style.display = discount > 0 ? 'flex' : 'none';
      if (totalEl) totalEl.textContent = this.formatPrice(total);
      if (discountInput) discountInput.value = discount;
      if (totalInput) totalInput.value = total;
      // Compact item list for the order summary
      const summaryContainer = document.getElementById('summaryItems');
      if (summaryContainer){
        if (!window.cartItems || window.cartItems.length === 0){
          summaryContainer.innerHTML = '<div style="color:var(--muted); font-size:13px;">Giỏ hàng trống</div>';
        } else {
          summaryContainer.innerHTML = window.cartItems.map(item => {
            return `
              <div class="item" data-id="${item.id}">
                <img loading="lazy" src="${item.image}" alt="${this.escape(item.name)}" />
                <div class="meta">
                  <div class="name">${this.escape(item.name)}</div>
                  <div class="qty">x${item.quantity} • ${this.formatPrice(item.price)}</div>
                </div>
                <div class="price">${this.formatPrice(item.price * item.quantity)}</div>
              </div>
            `;
          }).join('');
        }
      }
    },

    updateCartBadge(count){
      const badgeElements = document.querySelectorAll('.js-number-cart, .number-cart, .cart-count');
      badgeElements.forEach((el) => {
        if (count > 0) {
          el.textContent = count;
          el.style.display = 'inline-block';
        } else {
          el.textContent = '';
          el.style.display = 'none';
        }
      });
    },

    formatPrice(v){
      return new Intl.NumberFormat('vi-VN',{style:'currency', currency:'VND'}).format(v);
    },

    escape(str){
      return (''+str).replace(/[&<>"']/g, function(m){ return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":"&#39;"})[m]; });
    },

    showError(msg){ if (window.showError) return window.showError(msg); if (window.notifyError) return window.notifyError(msg); Swal.fire('Lỗi', msg || 'Đã có lỗi xảy ra', 'error'); },
    showSuccess(msg){ if (window.showSuccess) return window.showSuccess(msg); if (window.notify) return window.notify(msg); Swal.fire({ position: 'top-end', icon: 'success', title: msg, showConfirmButton:false, timer:1400, toast:true }); },
    showWarning(msg){ if (window.showWarning) return window.showWarning(msg); Swal.fire('Thông báo', msg, 'warning'); }
  };

  // expose
  window.CartUI = CartUI;
})();
