/**
 * AI Card Module - Main Orchestrator
 * Coordinates store, API, UI, and business logic
 */

class AICardModule {
  constructor() {
    this.store = aiCardStore;
    this.api = aiCardAPI;
    this.ui = aiCardUI;
    
    this.initialized = false;
    this.debounceTimers = {};
  }
  
  /**
   * Initialize module
   */
  init() {
    if (this.initialized) return;
    
    console.log('🎨 Initializing AI Card Module...');
    
    // Setup DOM elements
    this._setupEventListeners();
    
    // Subscribe to store changes
    this.store.subscribe(state => this._onStateChange(state));
    
    // Load initial state
    this.ui.updateFormFields(this.store.getState());
    
    // Initialize theme selector UI
    this.ui.initThemes();
    
    this.initialized = true;
    console.log('✓ AI Card Module initialized');
  }
  
  /**
   * Setup event listeners
   */
  _setupEventListeners() {
    // Form inputs - debounced
    const inputs = [
      { id: 'aiTo', field: 'recipient' },
      { id: 'aiOccasion', field: 'occasion' },
      { id: 'aiTone', field: 'tone' },
      { id: 'aiManual', field: 'customMessage' },
      { id: 'aiLength', field: 'length' },
      { id: 'aiFrom', field: 'sender' },
      { id: 'aiHoliday', field: 'holiday' }
    ];
    
    inputs.forEach(({ id, field }) => {
      const element = document.getElementById(id);
      if (element) {
        element.addEventListener('change', (e) => {
          this.store.updateField(field, e.target.value);
        });
        
        // Debounced input for text fields
        if (element.type === 'text' || element.type === 'textarea') {
          element.addEventListener('input', (e) => {
            this._debounce(`input-${id}`, () => {
              this.store.updateField(field, e.target.value);
            }, 500);
          });
        }
      }
    });
    
    // Action buttons
    const createBtn = document.querySelector('.ai-btn.primary');
    if (createBtn) {
      createBtn.addEventListener('click', () => this.handleCreateCard());
    }
    
    const downloadBtn = document.querySelector('.ai-btn[onclick*="downloadCard"]');
    if (downloadBtn) {
      downloadBtn.addEventListener('click', () => this.handleDownloadCard());
    }
    
    // Modal control
    const backdrop = document.getElementById('aiCardBackdrop');
    if (backdrop) {
      backdrop.addEventListener('click', () => this.closeModal());
    }
    
    const closeBtn = document.querySelector('.ai-close');
    if (closeBtn) {
      closeBtn.addEventListener('click', () => this.closeModal());
    }
  }
  
  /**
   * Handle create card action
   */
  async handleCreateCard() {
    console.log('🎨 Creating card...');
    try {
      const formData = this.ui.getFormFields();
      
      if (!formData.occasion) {
        this.ui.showWarning('Vui lòng chọn dịp');
        return;
      }
      
      this.store.setGenerating(true);
      this.ui.setFormDisabled(true);
      
      let message = formData.customMessage;
      
      // If the textarea is empty, run AI writing first
      if (!message) {
        this.ui.showLoading('AI đang sáng tác lời chúc...');
        const result = await this.api.generateGreeting({
          recipient: formData.recipient,
          occasion: formData.occasion,
          tone: formData.tone,
          customMessage: '',
          length: 'medium',
          holiday: formData.holiday
        });
        message = result.message;
        
        // Put generated text in the textarea & store
        const textArea = document.getElementById('aiManual');
        if (textArea) textArea.value = message;
        this.store.updateField('generatedMessage', message);
      }
      
      this.ui.showLoading('Đang kết xuất hình ảnh...');
      
      // Render the image
      const renderResult = await this.api.generateCardImage(
        message,
        formData.occasion,
        formData.tone,
        formData.recipient,
        formData.theme,
        formData.holiday,
        formData.sender
      );
      
      this.store.updateFields({
        generatedMessage: message,
        imageData: renderResult.imageData,
        error: null
      });
      
      this.ui.renderCardImage(renderResult.imageData);
      
      this.store.addToHistory({
        recipient: formData.recipient,
        occasion: formData.occasion,
        tone: formData.tone,
        theme: formData.theme,
        holiday: formData.holiday,
        sender: formData.sender,
        generatedMessage: message,
        imageData: renderResult.imageData
      });
      
      this.ui.showSuccess('✨ Thiệp đã được vẽ hoàn tất!');
      console.log('✓ Card created successfully');
      
    } catch (error) {
      console.error('❌ Error creating card:', error);
      this.store.setError(error.message);
      this.ui.showError('Lỗi: ' + error.message);
      this.ui.hideLoading();
    } finally {
      this.store.setGenerating(false);
      this.ui.setFormDisabled(false);
    }
  }

  /**
   * AI writes text only, filling the textarea
   */
  async handleGenerateTextOnly() {
    console.log('🤖 Generating text only...');
    try {
      const formData = this.ui.getFormFields();
      if (!formData.occasion) {
        this.ui.showWarning('Vui lòng chọn dịp');
        return;
      }
      
      this.ui.setFormDisabled(true);
      this.ui.showLoading('AI đang viết lời chúc...');
      
      const result = await this.api.generateGreeting({
        recipient: formData.recipient,
        occasion: formData.occasion,
        tone: formData.tone,
        customMessage: '',
        length: 'medium',
        holiday: formData.holiday
      });
      
      const textArea = document.getElementById('aiManual');
      if (textArea) textArea.value = result.message;
      
      this.store.updateField('generatedMessage', result.message);
      this.ui.showSuccess('✨ AI đã viết xong lời chúc!');
    } catch (error) {
      console.error('❌ Error generating text:', error);
      this.ui.showError('Lỗi: ' + error.message);
    } finally {
      this.ui.setFormDisabled(false);
      this.ui.hideLoading();
    }
  }
  
  /**
   * Handle regenerate action
   */
  async handleRegenerateMessage() {
    console.log('🔄 Regenerating message...');
    
    try {
      const state = this.store.getState();
      
      this.store.setGenerating(true);
      this.ui.showLoading('Đang tái tạo lời chúc...');
      
      const result = await this.api.generateGreeting({
        recipient: state.recipient,
        occasion: state.occasion,
        tone: state.tone,
        customMessage: state.customMessage,
        length: state.length
      });
      
      this.store.updateField('generatedMessage', result.message);
      
      // Regenerate image with new message
      await this._regenerateImage();
      
      this.ui.showSuccess('🔄 Lời chúc được tái tạo!');
      
    } catch (error) {
      console.error('❌ Regenerate error:', error);
      this.ui.showError('Lỗi khi tái tạo: ' + error.message);
    } finally {
      this.store.setGenerating(false);
    }
  }
  
  /**
   * Regenerate image
   */
  async _regenerateImage() {
    const state = this.store.getState();
    
    const result = await this.api.generateCardImage(
      state.generatedMessage,
      state.occasion,
      state.tone,
      state.recipient,
      state.theme,
      state.holiday,
      state.sender
    );
    
    this.store.updateField('imageData', result.imageData);
    this.ui.renderCardImage(result.imageData);
  }
  
  /**
   * Handle download card
   */
  async handleDownloadCard() {
    console.log('📥 Downloading card...');
    
    try {
      this.ui.showLoading('Đang tải...');
      await this.api.downloadCard();
      this.ui.showSuccess('📥 Thiệp đã tải xuống!');
    } catch (error) {
      console.error('❌ Download error:', error);
      this.ui.showError('Lỗi khi tải: ' + error.message);
    }
  }
  
  /**
   * Load history item
   */
  loadHistoryItem(cardId) {
    const state = this.store.getState();
    const item = state.history.find(h => h.id === cardId);
    
    if (item) {
      this.store.updateFields({
        recipient: item.recipient,
        occasion: item.occasion,
        tone: item.tone,
        theme: item.theme || 'luxury_rose',
        holiday: item.holiday || 'none',
        sender: item.sender || '',
        generatedMessage: item.generatedMessage,
        imageData: item.imageData
      });
      
      this.ui.updateFormFields({ ...item });
      if (typeof this.ui.selectTheme === 'function') {
        this.ui.selectTheme(item.theme || 'luxury_rose');
      }
      this.ui.renderCardImage(item.imageData);
      
      this.ui.showSuccess('Đã tải thiệp từ lịch sử');
    }
  }
  
  /**
   * Add to favorites
   */
  addToFavorites() {
    const state = this.store.getState();
    
    if (!state.generatedMessage) {
      this.ui.showWarning('Vui lòng tạo thiệp trước');
      return;
    }
    
    this.store.addToFavorites({
      recipient: state.recipient,
      occasion: state.occasion,
      tone: state.tone,
      generatedMessage: state.generatedMessage,
      imageData: state.imageData
    });
    
    this.ui.showSuccess('❤️ Thêm vào yêu thích');
  }
  
  /**
   * Open modal
   */
  openModal() {
    this.ui.showModal();
    console.log('🎨 AI Card modal opened');
  }
  
  /**
   * Close modal
   */
  closeModal() {
    this.ui.closeModal();
    console.log('✕ AI Card modal closed');
  }
  
  /**
   * State change handler
   */
  _onStateChange(newState) {
    if (newState.generatedMessage && newState.imageData) {
      this.ui.updateCartPreview(newState.generatedMessage, newState.imageData);
    }
  }
  
  /**
   * Attach card to cart and close modal
   */
  attachCardToCart() {
    const state = this.store.getState();
    if (!state.generatedMessage) {
      this.ui.showWarning('Vui lòng tạo thiệp trước khi đính kèm!');
      return;
    }
    
    // Close modal
    this.closeModal();
    
    // Show success
    this.ui.showSuccess('✓ Đã đính kèm thiệp AI vào đơn hàng!');
    
    // Scroll to preview
    const previewSection = document.getElementById('aiCardPreviewSection');
    if (previewSection) {
      previewSection.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }
  }
  
  /**
   * Debounce helper
   */
  _debounce(id, fn, delay) {
    clearTimeout(this.debounceTimers[id]);
    this.debounceTimers[id] = setTimeout(fn, delay);
  }
  
  /**
   * Debug info
   */
  debug() {
    console.group('AI Card Module Debug');
    this.store.debug();
    console.log('API Cache:', this.api.getCacheStats());
    console.groupEnd();
  }
  
  /**
   * Cleanup
   */
  destroy() {
    Object.values(this.debounceTimers).forEach(clearTimeout);
    this.debounceTimers = {};
    this.initialized = false;
    console.log('✓ AI Card Module destroyed');
  }
}
 
// Create singleton instance
const aiCardModule = new AICardModule();
 
// Auto-init on DOM ready
document.addEventListener('DOMContentLoaded', () => {
  if (document.getElementById('aiCardModal')) {
    aiCardModule.init();
  }
});
 
// Expose to window for legacy inline calls
window.showAICardModal = () => aiCardModule.openModal();
window.closeAICardModal = () => aiCardModule.closeModal();
window.createNewCard = () => aiCardModule.handleCreateCard();
window.downloadCard = () => aiCardModule.handleDownloadCard();
window.attachCardToCart = () => aiCardModule.attachCardToCart();
window.generateTextOnly = () => aiCardModule.handleGenerateTextOnly();
