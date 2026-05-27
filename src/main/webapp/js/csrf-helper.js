/**
 * CSRF Token Helper
 * Tự động thêm CSRF token vào tất cả AJAX, Fetch, XMLHttpRequest, jQuery và Axios requests.
 */

// Định nghĩa hàm getCsrfToken toàn cục để tương thích ngược với các trang JSP cũ
function getCsrfToken() {
    // 1. Thử lấy từ meta tag
    const metaTag = document.querySelector('meta[name="csrf-token"]');
    if (metaTag) {
        return metaTag.getAttribute('content');
    }
    
    // 2. Thử lấy từ hidden input trong form
    const hiddenInput = document.querySelector('input[name="csrfToken"]');
    if (hiddenInput) {
        return hiddenInput.value;
    }
    
    // 3. Thử lấy từ window variable
    if (window.csrfToken) {
        return window.csrfToken;
    }
    
    return '';
}

// Đưa getCsrfToken lên đối tượng window
window.getCsrfToken = getCsrfToken;

(function() {
    'use strict';
    
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
    
    // Override jQuery AJAX để tự động thêm CSRF token
    if (typeof jQuery !== 'undefined') {
        jQuery.ajaxSetup({
            beforeSend: function(xhr, settings) {
                const method = (settings.type || 'GET').toUpperCase();
                if (['POST', 'PUT', 'DELETE', 'PATCH'].includes(method)) {
                    const token = getCsrfToken();
                    if (token) {
                        xhr.setRequestHeader('X-CSRF-Token', token);
                    }
                }
            }
        });
    }
    
    // Override Axios để tự động thêm CSRF token
    if (typeof axios !== 'undefined') {
        axios.interceptors.request.use(function (config) {
            const method = (config.method || 'get').toUpperCase();
            if (['POST', 'PUT', 'DELETE', 'PATCH'].includes(method)) {
                const token = getCsrfToken();
                if (token) {
                    config.headers['X-CSRF-Token'] = token;
                }
            }
            return config;
        }, function (error) {
            return Promise.reject(error);
        });
    }
    
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
    
    // Export helper functions trên đối tượng window.CSRF
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
    
    console.log('Standardized CSRF Helper loaded');
})();
