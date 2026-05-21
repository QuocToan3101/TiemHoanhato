/**
 * AI Card UI Renderer
 * Handles all UI rendering and DOM manipulation
 */

class AICardUI {
  constructor(containerSelector = '#aiCardModal') {
    this.container = document.querySelector(containerSelector);
    this.backdrop = document.querySelector('#aiCardBackdrop');
    
    if (!this.container) {
      console.warn('⚠️ AI Card container not found');
    }
  }
  
  /**
   * Show loading state
   */
  showLoading(message = 'Đang xử lý...') {
    const canvas = document.getElementById('aiCanvas');
    if (!canvas) return;
    
    const ctx = canvas.getContext('2d');
    const w = canvas.width;
    const h = canvas.height;
    
    // Clear canvas
    ctx.fillStyle = '#f9f9f9';
    ctx.fillRect(0, 0, w, h);
    
    // Draw loading spinner
    ctx.save();
    ctx.translate(w / 2, h / 2);
    
    // Background circle
    ctx.fillStyle = 'rgba(102, 126, 234, 0.1)';
    ctx.fillRect(-100, -100, 200, 200);
    ctx.fillStyle = 'rgba(102, 126, 234, 0.05)';
    ctx.beginPath();
    ctx.arc(0, 0, 100, 0, Math.PI * 2);
    ctx.fill();
    
    // Spinner arc
    ctx.strokeStyle = 'rgb(102, 126, 234)';
    ctx.lineWidth = 4;
    ctx.beginPath();
    ctx.arc(0, 0, 60, 0, Math.PI);
    ctx.stroke();
    
    // Text
    ctx.fillStyle = '#333';
    ctx.font = 'bold 16px Arial';
    ctx.textAlign = 'center';
    ctx.fillText(message, 0, 100);
    
    ctx.restore();
  }
  
  /**
   * Show skeleton loading (placeholder animation)
   */
  showSkeleton() {
    const canvas = document.getElementById('aiCanvas');
    if (!canvas) return;
    
    const ctx = canvas.getContext('2d');
    const w = canvas.width;
    const h = canvas.height;
    
    // Background
    ctx.fillStyle = '#f0f0f0';
    ctx.fillRect(0, 0, w, h);
    
    // Animated gradient skeleton
    const gradient = ctx.createLinearGradient(0, 0, w, 0);
    gradient.addColorStop(0, '#f0f0f0');
    gradient.addColorStop(0.5, '#e0e0e0');
    gradient.addColorStop(1, '#f0f0f0');
    
    ctx.fillStyle = gradient;
    ctx.fillRect(50, 100, w - 100, 120);
    ctx.fillRect(50, 250, w - 100, 120);
    ctx.fillRect(50, 400, w - 100, 100);
  }
  
  /**
   * Render card image from base64
   */
  renderCardImage(base64ImageData) {
    const canvas = document.getElementById('aiCanvas');
    if (!canvas) return;
    
    const img = new Image();
    
    img.onload = () => {
      const ctx = canvas.getContext('2d');
      
      // Resize canvas to match image
      canvas.width = img.width;
      canvas.height = img.height;
      
      // Draw image
      ctx.drawImage(img, 0, 0);
      
      console.log('✓ Card image rendered');
    };
    
    img.onerror = () => {
      console.error('❌ Failed to render card image');
      this.showError('Không thể hiển thị ảnh thiệp');
    };
    
    img.src = base64ImageData;
  }
  
  /**
   * Display success toast
   */
  showSuccess(message, duration = 3000) {
    this._showToast(message, 'success', duration);
  }
  
  /**
   * Display error toast
   */
  showError(message, duration = 4000) {
    this._showToast(message, 'error', duration);
  }
  
  /**
   * Display warning toast
   */
  showWarning(message, duration = 3000) {
    this._showToast(message, 'warning', duration);
  }
  
  /**
   * Show toast notification
   */
  _showToast(message, type = 'info', duration = 3000) {
    const toast = document.createElement('div');
    
    const bgColor = {
      success: 'linear-gradient(135deg, #4ecca3 0%, #2ecc71 100%)',
      error: 'linear-gradient(135deg, #ff6b6b 0%, #ee5a6f 100%)',
      warning: 'linear-gradient(135deg, #ffa500 0%, #ffb84d 100%)',
      info: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)'
    }[type];
    
    const icon = {
      success: '✓',
      error: '✕',
      warning: '⚠',
      info: 'ℹ'
    }[type];
    
    toast.innerHTML = `
      <div style="
        position: fixed;
        top: 100px;
        right: 20px;
        background: ${bgColor};
        color: white;
        padding: 14px 20px;
        border-radius: 12px;
        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
        z-index: 10001;
        font-weight: 600;
        font-size: 14px;
        display: flex;
        align-items: center;
        gap: 10px;
        max-width: 400px;
        word-wrap: break-word;
        animation: slideInRight 0.3s ease-out;
      ">
        <span style="font-size: 18px;">${icon}</span>
        <span>${message}</span>
      </div>
    `;
    
    document.body.appendChild(toast);
    
    // Auto remove
    setTimeout(() => {
      toast.style.animation = 'slideOut 0.3s ease-out';
      setTimeout(() => toast.remove(), 300);
    }, duration);
  }
  
  /**
   * Enable/disable form inputs
   */
  setFormDisabled(disabled) {
    const inputs = document.querySelectorAll('.ai-field input, .ai-field select, .ai-field textarea');
    inputs.forEach(input => {
      input.disabled = disabled;
      input.style.opacity = disabled ? '0.6' : '1';
      input.style.cursor = disabled ? 'not-allowed' : 'auto';
    });
    
    const buttons = document.querySelectorAll('.ai-btn');
    buttons.forEach(btn => {
      btn.disabled = disabled;
      btn.style.opacity = disabled ? '0.6' : '1';
      btn.style.cursor = disabled ? 'not-allowed' : 'pointer';
    });
  }
  
  /**
   * Update form fields from state
   */
  updateFormFields(state) {
    const fields = {
      aiTo: state.recipient,
      aiOccasion: state.occasion,
      aiTone: state.tone,
      aiManual: state.customMessage,
      aiLength: state.length,
      aiFrom: state.sender
    };
    
    for (const [id, value] of Object.entries(fields)) {
      const element = document.getElementById(id);
      if (element) {
        element.value = value;
      }
    }
  }
  
  /**
   * Get form fields as object
   */
  getFormFields() {
    return {
      recipient: document.getElementById('aiTo')?.value?.trim() || '',
      occasion: document.getElementById('aiOccasion')?.value || 'sinhnhat',
      tone: document.getElementById('aiTone')?.value || 'warm',
      customMessage: document.getElementById('aiManual')?.value?.trim() || '',
      length: document.getElementById('aiLength')?.value || 'trungbinh',
      sender: document.getElementById('aiFrom')?.value?.trim() || ''
    };
  }
  
  /**
   * Show/hide modal
   */
  showModal() {
    if (this.container) {
      this.container.classList.add('active');
    }
    if (this.backdrop) {
      this.backdrop.classList.add('active');
    }
  }
  
  closeModal() {
    if (this.container) {
      this.container.classList.remove('active');
    }
    if (this.backdrop) {
      this.backdrop.classList.remove('active');
    }
  }
  
  /**
   * Render history items
   */
  renderHistory(items) {
    if (!items || items.length === 0) {
      return '<p style="color: #999; text-align: center;">Chưa có lịch sử</p>';
    }
    
    return items.map(item => `
      <div class="history-item" style="
        padding: 12px;
        border-radius: 8px;
        background: #f9f9f9;
        margin-bottom: 8px;
        cursor: pointer;
        transition: all 0.2s;
      " onclick="aiCardModule.loadHistoryItem(${item.id})">
        <div style="font-weight: 600; color: #333;">${item.generatedMessage.slice(0, 50)}...</div>
        <div style="font-size: 12px; color: #999; margin-top: 4px;">
          ${new Date(item.timestamp).toLocaleDateString('vi-VN')}
        </div>
      </div>
    `).join('');
  }
  
  /**
   * Clear all UI
   */
  clear() {
    const canvas = document.getElementById('aiCanvas');
    if (canvas) {
      const ctx = canvas.getContext('2d');
      ctx.fillStyle = '#fff';
      ctx.fillRect(0, 0, canvas.width, canvas.height);
    }
  }
}

// Create singleton instance
const aiCardUI = new AICardUI();
