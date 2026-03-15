/**
 * CSRF Token Helper
 * Tự động thêm CSRF token vào tất cả AJAX requests
 */

(function() {
    'use strict';
    
    // Lấy CSRF token từ meta tag hoặc cookie
    function getCsrfToken() {
        // Thử lấy từ meta tag
        const metaTag = document.querySelector('meta[name="csrf-token"]');
        if (metaTag) {
            return metaTag.getAttribute('content');
        }
        
        // Thử lấy từ hidden input
        const hiddenInput = document.querySelector('input[name="csrfToken"]');
        if (hiddenInput) {
            return hiddenInput.value;
        }
        
        return null;
    }
    
    // Override fetch để tự động thêm CSRF token
    const originalFetch = window.fetch;
    window.fetch = function(...args) {
        const [url, options = {}] = args;
        
        // Chỉ thêm token cho POST, PUT, DELETE, PATCH
        const method = (options.method || 'GET').toUpperCase();
        if (['POST', 'PUT', 'DELETE', 'PATCH'].includes(method)) {
            const token = getCsrfToken();
            if (token) {
                options.headers = options.headers || {};
                if (options.headers instanceof Headers) {
                    options.headers.set('X-CSRF-Token', token);
                } else {
                    options.headers['X-CSRF-Token'] = token;
                }
            }
        }
        
        return originalFetch(url, options);
    };
    
    // Override XMLHttpRequest để tự động thêm CSRF token
    const originalOpen = XMLHttpRequest.prototype.open;
    const originalSend = XMLHttpRequest.prototype.send;
    
    XMLHttpRequest.prototype.open = function(method, url, ...rest) {
        this._method = method;
        return originalOpen.call(this, method, url, ...rest);
    };
    
    XMLHttpRequest.prototype.send = function(...args) {
        if (this._method && ['POST', 'PUT', 'DELETE', 'PATCH'].includes(this._method.toUpperCase())) {
            const token = getCsrfToken();
            if (token) {
                this.setRequestHeader('X-CSRF-Token', token);
            }
        }
        return originalSend.call(this, ...args);
    };
    
    // Thêm token vào tất cả forms khi submit
    document.addEventListener('submit', function(e) {
        const form = e.target;
        const method = (form.method || 'GET').toUpperCase();
        
        if (['POST', 'PUT', 'DELETE', 'PATCH'].includes(method)) {
            const token = getCsrfToken();
            if (token) {
                // Kiểm tra xem đã có input token chưa
                let tokenInput = form.querySelector('input[name="csrfToken"]');
                if (!tokenInput) {
                    tokenInput = document.createElement('input');
                    tokenInput.type = 'hidden';
                    tokenInput.name = 'csrfToken';
                    form.appendChild(tokenInput);
                }
                tokenInput.value = token;
            }
        }
    });
    
    // Export helper function
    window.CSRF = {
        getToken: getCsrfToken,
        
        // Thêm token vào FormData
        addToFormData: function(formData) {
            const token = getCsrfToken();
            if (token) {
                formData.append('csrfToken', token);
            }
            return formData;
        },
        
        // Tạo headers object với token
        createHeaders: function(additionalHeaders = {}) {
            const token = getCsrfToken();
            const headers = { ...additionalHeaders };
            if (token) {
                headers['X-CSRF-Token'] = token;
            }
            return headers;
        }
    };
    
})();
