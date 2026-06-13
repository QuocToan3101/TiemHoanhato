/**
 * AI Card UI Renderer
 * Handles all UI rendering and DOM manipulation
 */

const CARD_THEMES = [
  { id: 'luxury_rose', name: 'Luxury Rose', bg: '#FDF7F7', text: '#C97B84', border: '#EAB8B8', flower: 'rose' },
  { id: 'sunflower_birthday', name: 'Hướng Dương', bg: '#FFF8E7', text: '#8F6B00', border: '#FFD95A', flower: 'sunflower' },
  { id: 'wedding_gold', name: 'Wedding Gold', bg: '#FFFFFF', text: '#5A4B29', border: '#D4AF37', flower: 'baby_flower' },
  { id: 'mothers_day', name: 'Ngày Của Mẹ', bg: '#FFF0F5', text: '#8B4513', border: '#FFB6C1', flower: 'carnation' },
  { id: 'graduation', name: 'Tốt Nghiệp', bg: '#F3F0FC', text: '#3F1B93', border: '#B197FC', flower: 'sunflower_eucalyptus' },
  { id: 'christmas', name: 'Giáng Sinh', bg: '#FFF5F5', text: '#C92A2A', border: '#FFA8A8', flower: 'christmas' },
  { id: 'thank_you', name: 'Lời Cảm Ơn', bg: '#F4F9F4', text: '#2E7D32', border: '#A9DFBF', flower: 'tulip' },
  { id: 'congratulation', name: 'Chúc Mừng', bg: '#F0F4C3', text: '#0E6251', border: '#76D7C4', flower: 'hydrangea' },
  { id: 'valentine', name: 'Lễ Tình Nhân', bg: '#FFF5F5', text: '#C92A2A', border: '#FFA8A8', flower: 'red_rose' }
];

class AICardUI {
  constructor(containerSelector = '#aiCardModal') {
    this.container = document.querySelector(containerSelector);
    this.backdrop = document.querySelector('#aiCardBackdrop');
    this.selectedTheme = 'luxury_rose';
    
    if (!this.container) {
      console.warn('⚠️ AI Card container not found');
    }
  }

  /**
   * Render theme cards dynamically
   */
  initThemes() {
    const grid = document.getElementById('themeGrid');
    if (!grid) return;

    grid.innerHTML = CARD_THEMES.map(theme => {
      const isSelected = this.selectedTheme === theme.id;
      return `
        <div class="theme-card" data-id="${theme.id}" data-text="${theme.text}" style="
          border-radius: 16px;
          height: 90px;
          border: 1.5px solid ${isSelected ? '#a97155' : 'rgba(169,113,85,0.15)'};
          background: ${isSelected ? 'rgba(169,113,85,0.1)' : '#ffffff'};
          cursor: pointer;
          display: flex;
          flex-direction: column;
          align-items: center;
          justify-content: center;
          padding: 8px;
          transition: all 0.25s ease;
          box-shadow: ${isSelected ? '0 0 16px rgba(169,113,85,0.2)' : 'none'};
          box-sizing: border-box;
          gap: 6px;
        ">
          <span style="font-size: 28px; line-height: 1;">
            ${this._getFlowerIcon(theme.flower)}
          </span>
          <span class="theme-name-text" style="font-size: 11px; font-weight: 600; color: ${isSelected ? '#a97155' : '#7a6e65'}; text-align: center; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; width: 100%; transition: color 0.2s;">
            ${theme.name}
          </span>
        </div>
      `;
    }).join('');

    // Add click listeners
    grid.querySelectorAll('.theme-card').forEach(card => {
      card.addEventListener('click', () => {
        this.selectTheme(card.dataset.id);
      });
    });
  }

  _getFlowerIcon(flower) {
    switch(flower) {
      case 'rose': return '🌹';
      case 'red_rose': return '🌹';
      case 'sunflower': return '🌻';
      case 'baby_flower': return '💍';
      case 'carnation': return '💖';
      case 'tulip': return '🌸';
      case 'peony': return '🌸';
      case 'hydrangea': return '💐';
      case 'sunflower_eucalyptus': return '🎓';
      case 'christmas': return '🎄';
      default: return '✿';
    }
  }

  /**
   * Select and highlight theme
   */
  selectTheme(themeId) {
    this.selectedTheme = themeId;
    aiCardStore.updateField('theme', themeId);
    
    // Highlight in UI
    const themeCards = document.querySelectorAll('.theme-card');
    themeCards.forEach(card => {
      const isSelected = card.dataset.id === themeId;
      if (isSelected) {
        card.classList.add('active');
        card.style.borderColor = '#a97155';
        card.style.background = 'rgba(169,113,85,0.1)';
        card.style.boxShadow = '0 0 16px rgba(169,113,85,0.2)';
        const nameText = card.querySelector('.theme-name-text');
        if (nameText) nameText.style.color = '#a97155';
      } else {
        card.classList.remove('active');
        card.style.borderColor = 'rgba(169,113,85,0.15)';
        card.style.background = '#ffffff';
        card.style.boxShadow = 'none';
        const nameText = card.querySelector('.theme-name-text');
        if (nameText) nameText.style.color = '#7a6e65';
      }
    });

    // Instant image regeneration on theme change
    const state = aiCardStore.getState();
    if (state.generatedMessage) {
      aiCardModule._regenerateImage();
    }
  }
  
  /**
   * Show loading state
   */
  showLoading(message = 'Đang xử lý...') {
    const loader = document.getElementById('aiCanvasLoader');
    const canvas = document.getElementById('aiCanvas');
    if (!loader || !canvas) return;
    
    canvas.style.display = 'none';
    loader.style.display = 'flex';
    
    const textEl = document.getElementById('aiLoaderText');
    if (textEl) {
      textEl.textContent = message;
    }
    
    // Cycle loading texts every 2 seconds
    const messages = [
      '🎨 Đang thiết kế thiệp...',
      '✍️ AI đang viết lời chúc...',
      '🖼️ Đang dựng bố cục...'
    ];
    let idx = 0;
    
    if (this.loadingInterval) {
      clearInterval(this.loadingInterval);
    }
    
    this.loadingInterval = setInterval(() => {
      idx = (idx + 1) % messages.length;
      if (textEl) {
        textEl.textContent = messages[idx];
      }
    }, 2000);
  }
  
  /**
   * Hide loading state
   */
  hideLoading() {
    const loader = document.getElementById('aiCanvasLoader');
    const canvas = document.getElementById('aiCanvas');
    if (loader) loader.style.display = 'none';
    if (canvas) canvas.style.display = 'block';
    
    if (this.loadingInterval) {
      clearInterval(this.loadingInterval);
      this.loadingInterval = null;
    }
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
      
      this.hideLoading();
      console.log('✓ Card image rendered');
    };
    
    img.onerror = () => {
      console.error('❌ Failed to render card image');
      this.hideLoading();
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
      aiFrom: state.sender,
      aiHoliday: state.holiday || 'none'
    };
    
    for (const [id, value] of Object.entries(fields)) {
      const element = document.getElementById(id);
      if (element) {
        element.value = value;
      }
    }

    if (state.theme) {
      this.selectedTheme = state.theme;
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
      length: document.getElementById('aiLength')?.value || 'medium',
      sender: document.getElementById('aiFrom')?.value?.trim() || '',
      theme: this.selectedTheme || 'luxury_rose',
      holiday: document.getElementById('aiHoliday')?.value || 'none'
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

  /**
   * Update AI Card preview section on the cart page
   */
  updateCartPreview(message, base64ImageData) {
    const previewSection = document.getElementById('aiCardPreviewSection');
    const previewImg = document.getElementById('aiCardPreviewImg');
    const previewText = document.getElementById('aiCardPreviewText');
    const giftNote = document.getElementById('giftNote');
    
    if (previewSection && previewImg && previewText) {
      if (base64ImageData) {
        previewImg.src = base64ImageData.startsWith('data:') ? base64ImageData : ('data:image/png;base64,' + base64ImageData);
      }
      previewText.textContent = message;
      previewSection.style.display = 'block';
    }
    
    if (giftNote) {
      giftNote.value = message;
    }
  }
}

// Create singleton instance
const aiCardUI = new AICardUI();
