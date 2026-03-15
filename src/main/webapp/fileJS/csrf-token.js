/**
 * CSRF Token Helper
 * Auto-inject CSRF token vào tất cả fetch/AJAX requests
 */

// Lấy CSRF token từ meta tag hoặc session attribute
function getCsrfToken() {
    // Thử lấy từ meta tag
    const metaTag = document.querySelector('meta[name="csrf-token"]');
    if (metaTag) {
        return metaTag.getAttribute('content');
    }
    
    // Fallback: lấy từ window variable
    if (window.csrfToken) {
        return window.csrfToken;
    }
    
    return null;
}

// Override fetch để tự động thêm CSRF token
const originalFetch = window.fetch;
window.fetch = function(url, options = {}) {
    // Chỉ thêm CSRF token cho POST, PUT, DELETE, PATCH
    const method = (options.method || 'GET').toUpperCase();
    if (['POST', 'PUT', 'DELETE', 'PATCH'].includes(method)) {
        const token = getCsrfToken();
        if (token) {
            options.headers = options.headers || {};
            if (options.headers instanceof Headers) {
                options.headers.append('X-CSRF-Token', token);
            } else {
                options.headers['X-CSRF-Token'] = token;
            }
        }
    }
    
    return originalFetch(url, options);
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

console.log('CSRF Token Helper loaded');
