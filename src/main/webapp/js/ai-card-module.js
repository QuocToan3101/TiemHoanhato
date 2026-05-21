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
      { id: 'aiFrom', field: 'sender' }
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
      // Get form data
      const formData = this.ui.getFormFields();
      
      // Validate
      if (!formData.occasion || !formData.tone) {
        this.ui.showWarning('Vui lòng chọn dịp và giọng điệu');
        return;
      }
      
      // Set loading state
      this.store.setGenerating(true);
      this.ui.setFormDisabled(true);
      this.ui.showLoading('Đang tạo thiệp...');
      
      // Call API - complete generation (text + image + background)
      const result = await this.api.generateComplete({
        recipient: formData.recipient,
        occasion: formData.occasion,
        tone: formData.tone,
        customMessage: formData.customMessage,
        length: formData.length
      });
      
      // Update store with result
      this.store.updateFields({
        generatedMessage: result.message,
        imageData: result.imageData,
        backgroundImageUrl: result.backgroundImageUrl,
        error: null
      });
      
      // Render card image
      this.ui.renderCardImage(result.imageData);
      
      // Save to history
      this.store.addToHistory({
        recipient: formData.recipient,
        occasion: formData.occasion,
        tone: formData.tone,
        generatedMessage: result.message,
        imageData: result.imageData
      });
      
      // Show success
      this.ui.showSuccess('✨ Thiệp đã được tạo thành công!');
      
      console.log('✓ Card created successfully');
      
    } catch (error) {
      console.error('❌ Error creating card:', error);
      this.store.setError(error.message);
      this.ui.showError('Lỗi: ' + error.message);
    } finally {
      this.store.setGenerating(false);
      this.ui.setFormDisabled(false);
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
      state.recipient
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
        generatedMessage: item.generatedMessage,
        imageData: item.imageData
      });
      
      this.ui.updateFormFields({ ...item });
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
    // You can add side effects here if needed
    // For now, mainly used for debugging
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
