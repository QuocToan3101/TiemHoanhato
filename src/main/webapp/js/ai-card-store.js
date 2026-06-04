/**
 * AI Card State Store
 * Centralized state management for AI Card feature
 * Follows Flux pattern with immutable updates
 */

class AICardStore {
  constructor() {
    this.state = {
      // Form inputs
      recipient: '',
      occasion: 'sinhnhat',
      tone: 'warm',
      customMessage: '',
      length: 'medium',
      sender: '',
      theme: 'luxury_rose',
      holiday: 'none',
      
      // Generated content
      generatedMessage: '',
      imageData: '',
      backgroundImageUrl: '',
      
      // UI states
      isLoading: false,
      isGenerating: false,
      error: null,
      success: null,
      
      // Cache
      history: [],  // For tracking recent generations
      favorites: [], // For saved cards
    };
    
    this.listeners = new Set();
    this.loadFromLocalStorage();
  }
  
  /**
   * Get current state (immutable)
   */
  getState() {
    return Object.freeze({ ...this.state });
  }
  
  /**
   * Update single field
   */
  updateField(field, value) {
    this.state[field] = value;
    this.notifyListeners();
  }
  
  /**
   * Update multiple fields at once
   */
  updateFields(updates) {
    Object.assign(this.state, updates);
    this.notifyListeners();
  }
  
  /**
   * Set loading state
   */
  setLoading(isLoading) {
    this.state.isLoading = isLoading;
    this.notifyListeners();
  }
  
  /**
   * Set generating state
   */
  setGenerating(isGenerating) {
    this.state.isGenerating = isGenerating;
    this.notifyListeners();
  }
  
  /**
   * Set error
   */
  setError(error) {
    this.state.error = error;
    if (error) {
      // Clear error after 5s
      setTimeout(() => {
        if (this.state.error === error) {
          this.state.error = null;
          this.notifyListeners();
        }
      }, 5000);
    }
    this.notifyListeners();
  }
  
  /**
   * Set success message
   */
  setSuccess(message) {
    this.state.success = message;
    if (message) {
      setTimeout(() => {
        if (this.state.success === message) {
          this.state.success = null;
          this.notifyListeners();
        }
      }, 3000);
    }
    this.notifyListeners();
  }
  
  /**
   * Save card to history
   */
  addToHistory(card) {
    this.state.history.unshift({
      id: Date.now(),
      timestamp: new Date().toISOString(),
      ...card
    });
    
    // Keep only last 10
    if (this.state.history.length > 10) {
      this.state.history.pop();
    }
    
    this.saveToLocalStorage();
    this.notifyListeners();
  }
  
  /**
   * Add to favorites
   */
  addToFavorites(card) {
    if (!this.state.favorites.find(f => f.id === card.id)) {
      this.state.favorites.unshift({
        id: Date.now(),
        timestamp: new Date().toISOString(),
        ...card
      });
      
      this.saveToLocalStorage();
      this.notifyListeners();
    }
  }
  
  /**
   * Remove from favorites
   */
  removeFromFavorites(cardId) {
    this.state.favorites = this.state.favorites.filter(f => f.id !== cardId);
    this.saveToLocalStorage();
    this.notifyListeners();
  }
  
  /**
   * Clear generated content
   */
  clearGenerated() {
    this.updateFields({
      generatedMessage: '',
      imageData: '',
      backgroundImageUrl: '',
      error: null
    });
  }
  
  /**
   * Reset to default state
   */
  reset() {
    this.state = {
      recipient: '',
      occasion: 'sinhnhat',
      tone: 'warm',
      customMessage: '',
      length: 'medium',
      sender: '',
      theme: 'luxury_rose',
      holiday: 'none',
      generatedMessage: '',
      imageData: '',
      backgroundImageUrl: '',
      isLoading: false,
      isGenerating: false,
      error: null,
      success: null,
      history: this.state.history,
      favorites: this.state.favorites
    };
    this.notifyListeners();
  }
  
  /**
   * Listen to state changes
   */
  subscribe(listener) {
    this.listeners.add(listener);
    return () => this.listeners.delete(listener);
  }
  
  /**
   * Notify all listeners
   */
  notifyListeners() {
    this.listeners.forEach(listener => {
      try {
        listener(this.getState());
      } catch (error) {
        console.error('Listener error:', error);
      }
    });
  }
  
  /**
   * Save state to localStorage
   */
  saveToLocalStorage() {
    try {
      const dataToSave = {
        history: this.state.history,
        favorites: this.state.favorites
      };
      localStorage.setItem('aiCardStore', JSON.stringify(dataToSave));
    } catch (error) {
      console.warn('Failed to save to localStorage:', error);
    }
  }
  
  /**
   * Load state from localStorage
   */
  loadFromLocalStorage() {
    try {
      const saved = localStorage.getItem('aiCardStore');
      if (saved) {
        const data = JSON.parse(saved);
        this.state.history = data.history || [];
        this.state.favorites = data.favorites || [];
      }
    } catch (error) {
      console.warn('Failed to load from localStorage:', error);
    }
  }
  
  /**
   * Export state for debugging
   */
  debug() {
    console.log('AI Card Store State:', this.getState());
  }
}

// Create singleton instance
const aiCardStore = new AICardStore();
