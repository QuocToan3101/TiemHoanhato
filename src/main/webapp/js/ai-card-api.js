/**
 * AI Card API Layer
 * Handles all API calls with retry logic, error handling, and caching
 */

class AICardAPI {
  constructor(contextPath = '') {
    this.contextPath = contextPath;
    this.timeout = 30000; // 30 seconds
    this.maxRetries = 2;
    this.retryDelay = 500;
    this.responseCache = new Map();
    this.cacheExpiry = 5 * 60 * 1000; // 5 minutes
  }
  
  /**
   * Generate greeting text from AI
   */
  async generateGreeting(params) {
    const cacheKey = `greeting:${JSON.stringify(params)}`;
    
    // Check cache
    if (this.responseCache.has(cacheKey)) {
      const cached = this.responseCache.get(cacheKey);
      if (Date.now() - cached.timestamp < this.cacheExpiry) {
        console.log('✓ Cache hit for greeting');
        return cached.data;
      }
    }
    
    const response = await this._apiCall('/api/ai-card-generate', 'POST', params);
    
    // Cache response
    this.responseCache.set(cacheKey, {
      data: response,
      timestamp: Date.now()
    });
    
    return response;
  }
  
  /**
   * Generate card image
   */
  async generateCardImage(message, occasion, tone, recipient, theme, holiday, sender) {
    const response = await this._apiCall('/api/generate-card-image', 'POST', {
      message,
      occasion,
      tone,
      recipient,
      theme,
      holiday,
      sender
    });
    
    return response;
  }
  
  /**
   * Generate background image
   */
  async generateBackground(occasion, tone, message) {
    const cacheKey = `bg:${occasion}:${tone}`;
    
    if (this.responseCache.has(cacheKey)) {
      const cached = this.responseCache.get(cacheKey);
      if (Date.now() - cached.timestamp < this.cacheExpiry) {
        return cached.data;
      }
    }
    
    const response = await this._apiCall('/api/ai-card-background', 'POST', {
      occasion,
      tone,
      message
    });
    
    this.responseCache.set(cacheKey, {
      data: response,
      timestamp: Date.now()
    });
    
    return response;
  }
  
  /**
   * Complete one-step generation
   */
  async generateComplete(params) {
    const response = await this._apiCall('/api/ai-card-complete', 'POST', params);
    return response;
  }
  
  /**
   * Download card
   */
  async downloadCard() {
    try {
      const response = await fetch(`${this.contextPath}/api/download-card`, {
        method: 'GET',
        headers: {
          'X-CSRF-Token': this._getCsrfToken()
        }
      });
      
      if (!response.ok) {
        throw new Error(`Download failed: ${response.statusText}`);
      }
      
      const blob = await response.blob();
      const url = URL.createObjectURL(blob);
      const link = document.createElement('a');
      link.href = url;
      link.download = `thiep-${new Date().toISOString().slice(0, 10)}.png`;
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
      URL.revokeObjectURL(url);
      
      console.log('✓ Card downloaded');
      return true;
    } catch (error) {
      console.error('❌ Download error:', error);
      throw error;
    }
  }
  
  /**
   * Internal API call with retry logic
   */
  async _apiCall(endpoint, method = 'POST', data = null, retryCount = 0) {
    
    const url = `${this.contextPath}${endpoint}`;
    
    try {
      // Build request options
      const options = {
        method,
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': this._getCsrfToken()
        },
        signal: AbortSignal.timeout(this.timeout)
      };
      
      if (data) {
        options.body = JSON.stringify(data);
      }
      
      // Make request
      const response = await fetch(url, options);
      
      // Handle response
      if (!response.ok) {
        const errorData = await response.json().catch(() => ({}));
        throw new Error(errorData.error || `API error: ${response.status}`);
      }
      
      const result = await response.json();
      
      if (!result.success) {
        throw new Error(result.error || 'API returned failure');
      }
      
      return result;
      
    } catch (error) {
      // Retry logic
      if (retryCount < this.maxRetries && this._isRetryable(error)) {
        console.warn(`⚠️ API call failed, retrying... (${retryCount + 1}/${this.maxRetries})`);
        await this._delay(this.retryDelay);
        return this._apiCall(endpoint, method, data, retryCount + 1);
      }
      
      // Final error
      console.error(`❌ API call failed: ${error.message}`);
      throw error;
    }
  }
  
  /**
   * Check if error is retryable
   */
  _isRetryable(error) {
    const message = error.message || '';
    
    // Don't retry auth errors
    if (message.includes('401') || message.includes('Unauthorized')) {
      return false;
    }
    
    // Retry on network/timeout errors
    return message.includes('Failed to fetch') ||
           message.includes('timeout') ||
           message.includes('NetworkError') ||
           message.includes('ERR_');
  }
  
  /**
   * Get CSRF token
   */
  _getCsrfToken() {
    const token = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');
    return token || '';
  }
  
  /**
   * Delay helper
   */
  _delay(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
  
  /**
   * Clear cache
   */
  clearCache() {
    this.responseCache.clear();
    console.log('✓ API cache cleared');
  }
  
  /**
   * Get cache stats
   */
  getCacheStats() {
    return {
      size: this.responseCache.size,
      entries: Array.from(this.responseCache.keys())
    };
  }
}

// Create singleton instance
const aiCardAPI = new AICardAPI(contextPath || '');
