/**
 * Notification System Utility
 * Centralized notification system using SweetAlert2 with fallback to custom modals
 * Replaces all alert(), confirm(), prompt() with modern notifications
 */

// Theme configuration
const NOTIFICATION_THEME = {
    primary: '#c99366',      // Accent color
    success: '#27ae60',      // Green for success
    error: '#e74c3c',        // Red for error
    warning: '#f39c12',      // Orange for warning
    info: '#3498db',         // Blue for info
    dark: '#3c2922',         // Dark brown (main color)
};

// Check if SweetAlert2 is available
let SWAL_AVAILABLE = false;

// Initialize SweetAlert2 detection
document.addEventListener('DOMContentLoaded', function() {
    SWAL_AVAILABLE = typeof Swal !== 'undefined';
    if (SWAL_AVAILABLE) {
        configureGlobalNotifications();
    } else {
        createCustomNotificationStyles();
    }
});

/**
 * Show success notification
 */
function showSuccess(message, title = "Thành công", options = {}) {
    if (SWAL_AVAILABLE) {
        return Swal.fire({
            title: title,
            html: message,
            icon: 'success',
            confirmButtonColor: NOTIFICATION_THEME.success,
            confirmButtonText: 'Đóng',
            allowOutsideClick: false,
            timer: 4000,
            timerProgressBar: true,
            ...options
        });
    } else {
        return showCustomModal('success', title, message);
    }
}

/**
 * Show error notification
 */
function showError(message, title = "Lỗi", options = {}) {
    if (SWAL_AVAILABLE) {
        return Swal.fire({
            title: title,
            html: message,
            icon: 'error',
            confirmButtonColor: NOTIFICATION_THEME.error,
            confirmButtonText: 'Đóng',
            allowOutsideClick: false,
            ...options
        });
    } else {
        return showCustomModal('error', title, message);
    }
}

/**
 * Show warning notification
 */
function showWarning(message, title = "Cảnh báo", options = {}) {
    if (SWAL_AVAILABLE) {
        return Swal.fire({
            title: title,
            html: message,
            icon: 'warning',
            confirmButtonColor: NOTIFICATION_THEME.warning,
            confirmButtonText: 'Đóng',
            allowOutsideClick: false,
            ...options
        });
    } else {
        return showCustomModal('warning', title, message);
    }
}

/**
 * Show info notification
 */
function showInfo(message, title = "Thông tin", options = {}) {
    if (SWAL_AVAILABLE) {
        return Swal.fire({
            title: title,
            html: message,
            icon: 'info',
            confirmButtonColor: NOTIFICATION_THEME.info,
            confirmButtonText: 'Đóng',
            allowOutsideClick: false,
            ...options
        });
    } else {
        return showCustomModal('info', title, message);
    }
}

/**
 * Show confirmation dialog
 */
function showConfirm(message, onConfirm, onCancel = null, title = "Xác nhận", confirmText = "Xác nhận", cancelText = "Hủy") {
    if (SWAL_AVAILABLE) {
        return Swal.fire({
            title: title,
            html: message,
            icon: 'question',
            confirmButtonColor: NOTIFICATION_THEME.success,
            cancelButtonColor: '#95a5a6',
            confirmButtonText: confirmText,
            cancelButtonText: cancelText,
            showCancelButton: true,
            reverseButtons: true,
            allowOutsideClick: false,
            focusConfirm: true
        }).then((result) => {
            if (result.isConfirmed) {
                if (onConfirm && typeof onConfirm === 'function') {
                    onConfirm();
                }
            } else if (result.isDismissed) {
                if (onCancel && typeof onCancel === 'function') {
                    onCancel();
                }
            }
        });
    } else {
        return showCustomConfirm(message, onConfirm, onCancel, title, confirmText, cancelText);
    }
}

/**
 * Show delete confirmation dialog
 */
function showDeleteConfirm(itemName, onConfirm, onCancel = null) {
    return showConfirm(
        `Bạn có chắc chắn muốn xóa <strong>${itemName}</strong>?<br/>Hành động này không thể hoàn tác.`,
        onConfirm,
        onCancel,
        "Xác nhận xóa",
        "Xóa",
        "Hủy"
    );
}

/**
 * Show loading notification
 */
function showLoading(message = "Đang xử lý...") {
    if (SWAL_AVAILABLE) {
        return Swal.fire({
            title: message,
            allowOutsideClick: false,
            allowEscapeKey: false,
            didOpen: async () => {
                await Swal.showLoadingAsync();
            }
        });
    } else {
        return showCustomLoading(message);
    }
}

/**
 * Hide loading notification
 */
function hideLoading() {
    if (SWAL_AVAILABLE) {
        Swal.close();
    } else {
        const overlay = document.getElementById('custom-modal-overlay');
        if (overlay) overlay.style.display = 'none';
    }
}

/**
 * Show toast notification
 */
function showToast(message, type = 'info', duration = 3000) {
    if (SWAL_AVAILABLE) {
        const backgroundColor = {
            'success': NOTIFICATION_THEME.success,
            'error': NOTIFICATION_THEME.error,
            'warning': NOTIFICATION_THEME.warning,
            'info': NOTIFICATION_THEME.info
        }[type] || NOTIFICATION_THEME.info;

        const Toast = Swal.mixin({
            toast: true,
            position: 'top-right',
            iconColor: '#fff',
            customClass: {
                popup: 'colored-toast'
            },
            showConfirmButton: false,
            timerProgressBar: true,
            timer: duration
        });

        return Toast.fire({
            icon: type,
            title: message,
            background: backgroundColor,
            color: '#fff'
        });
    } else {
        return showCustomToast(message, type, duration);
    }
}

/**
 * Show input prompt dialog
 */
function showPrompt(message, inputType = 'text', onConfirm, onCancel = null, title = "Nhập dữ liệu", placeholderText = "") {
    if (SWAL_AVAILABLE) {
        return Swal.fire({
            title: title,
            html: message,
            input: inputType,
            inputPlaceholder: placeholderText,
            confirmButtonColor: NOTIFICATION_THEME.success,
            cancelButtonColor: '#95a5a6',
            confirmButtonText: "Xác nhận",
            cancelButtonText: "Hủy",
            showCancelButton: true,
            reverseButtons: true,
            allowOutsideClick: false,
            inputValidator: (value) => {
                if (inputType === 'email' && value && !isValidEmail(value)) {
                    return 'Vui lòng nhập email hợp lệ!';
                }
                return undefined;
            }
        }).then((result) => {
            if (result.isConfirmed && result.value) {
                if (onConfirm && typeof onConfirm === 'function') {
                    onConfirm(result.value);
                }
            } else if (result.isDismissed) {
                if (onCancel && typeof onCancel === 'function') {
                    onCancel();
                }
            }
        });
    } else {
        // Fallback to native prompt for custom modal system
        const value = prompt(message, placeholderText);
        if (value !== null) {
            if (onConfirm && typeof onConfirm === 'function') {
                onConfirm(value);
            }
        } else {
            if (onCancel && typeof onCancel === 'function') {
                onCancel();
            }
        }
    }
}

/**
 * Custom modal fallback functions
 */
function showCustomModal(type, title, message) {
    const modal = document.createElement('div');
    modal.className = 'custom-modal';
    modal.innerHTML = `
        <div class="custom-modal-content custom-modal-${type}">
            <div class="custom-modal-header">
                <h2>${getIcon(type)} ${title}</h2>
                <button class="custom-modal-close" onclick="this.closest('.custom-modal').remove()">✕</button>
            </div>
            <div class="custom-modal-body">
                ${message}
            </div>
            <div class="custom-modal-footer">
                <button class="custom-modal-btn custom-modal-btn-primary" onclick="this.closest('.custom-modal').remove()">Đóng</button>
            </div>
        </div>
    `;
    document.body.appendChild(modal);
}

function showCustomConfirm(message, onConfirm, onCancel, title, confirmText, cancelText) {
    const modal = document.createElement('div');
    modal.className = 'custom-modal custom-modal-confirm';
    modal.innerHTML = `
        <div class="custom-modal-content">
            <div class="custom-modal-header">
                <h2>❓ ${title}</h2>
                <button class="custom-modal-close" onclick="this.closest('.custom-modal').remove()">✕</button>
            </div>
            <div class="custom-modal-body">
                ${message}
            </div>
            <div class="custom-modal-footer custom-modal-footer-confirm">
                <button class="custom-modal-btn custom-modal-btn-cancel" onclick="
                    const e = this.closest('.custom-modal');
                    e.remove();
                    if (onCancel) onCancel();
                ">${cancelText}</button>
                <button class="custom-modal-btn custom-modal-btn-confirm" onclick="
                    const e = this.closest('.custom-modal');
                    e.remove();
                    if (onConfirm) onConfirm();
                ">${confirmText}</button>
            </div>
        </div>
    `;
    document.body.appendChild(modal);
}

function showCustomToast(message, type, duration) {
    const toast = document.createElement('div');
    toast.className = `custom-toast custom-toast-${type}`;
    toast.innerHTML = `${getIcon(type)} ${message}`;
    document.body.appendChild(toast);
    
    setTimeout(() => {
        toast.classList.add('show');
    }, 10);
    
    setTimeout(() => {
        toast.classList.remove('show');
        setTimeout(() => toast.remove(), 300);
    }, duration);
}

function showCustomLoading(message) {
    const overlay = document.createElement('div');
    overlay.id = 'custom-loading-overlay';
    overlay.className = 'custom-loading-overlay';
    overlay.innerHTML = `
        <div class="custom-loading">
            <div class="custom-spinner"></div>
            <p>${message}</p>
        </div>
    `;
    document.body.appendChild(overlay);
}

function getIcon(type) {
    const icons = {
        'success': '✓',
        'error': '✕',
        'warning': '⚠',
        'info': 'ℹ'
    };
    return icons[type] || '•';
}

/**
 * Validate email format
 */
function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

/**
 * Create custom notification styles as fallback
 */
function createCustomNotificationStyles() {
    const style = document.createElement('style');
    style.textContent = `
        /* Custom Modal Styles */
        .custom-modal {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 10000;
            animation: fadeIn 0.3s ease;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        
        .custom-modal-content {
            background: white;
            border-radius: 12px;
            box-shadow: 0 10px 40px rgba(60, 41, 34, 0.2);
            max-width: 400px;
            width: 90%;
            overflow: hidden;
            animation: slideUp 0.3s ease;
        }
        
        @keyframes slideUp {
            from { transform: translateY(20px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
        
        .custom-modal-header {
            background: #f5f5f5;
            padding: 20px;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .custom-modal-header h2 {
            margin: 0;
            font-size: 1.3rem;
            color: #3c2922;
            font-family: 'Crimson Text', serif;
        }
        
        .custom-modal-close {
            background: none;
            border: none;
            font-size: 1.5rem;
            cursor: pointer;
            color: #999;
        }
        
        .custom-modal-body {
            padding: 20px;
            color: #555;
            font-size: 1rem;
            line-height: 1.6;
        }
        
        .custom-modal-footer {
            padding: 15px 20px;
            border-top: 1px solid #eee;
            text-align: right;
        }
        
        .custom-modal-footer-confirm {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
        }
        
        .custom-modal-btn {
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.95rem;
            transition: all 0.3s ease;
        }
        
        .custom-modal-btn-primary {
            background: #c99366;
            color: white;
        }
        
        .custom-modal-btn-primary:hover {
            background: #aa6a3f;
        }
        
        .custom-modal-btn-confirm {
            background: #27ae60;
            color: white;
        }
        
        .custom-modal-btn-confirm:hover {
            background: #229954;
        }
        
        .custom-modal-btn-cancel {
            background: #95a5a6;
            color: white;
        }
        
        .custom-modal-btn-cancel:hover {
            background: #7f8c8d;
        }
        
        /* Toast Styles */
        .custom-toast {
            position: fixed;
            bottom: 20px;
            right: 20px;
            padding: 15px 20px;
            border-radius: 6px;
            background: white;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            z-index: 9999;
            min-width: 300px;
            opacity: 0;
            transform: translateY(100px);
            transition: all 0.3s ease;
        }
        
        .custom-toast.show {
            opacity: 1;
            transform: translateY(0);
        }
        
        .custom-toast-success {
            border-left: 4px solid #27ae60;
            color: #27ae60;
        }
        
        .custom-toast-error {
            border-left: 4px solid #e74c3c;
            color: #e74c3c;
        }
        
        .custom-toast-warning {
            border-left: 4px solid #f39c12;
            color: #f39c12;
        }
        
        .custom-toast-info {
            border-left: 4px solid #3498db;
            color: #3498db;
        }
        
        /* Loading Styles */
        .custom-loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 10000;
        }
        
        .custom-loading {
            background: white;
            padding: 40px;
            border-radius: 12px;
            text-align: center;
        }
        
        .custom-spinner {
            border: 4px solid #f0f0f0;
            border-top: 4px solid #c99366;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            animation: spin 1s linear infinite;
            margin: 0 auto 20px;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    `;
    document.head.appendChild(style);
}

/**
 * Configure global Swal settings
 */
function configureGlobalNotifications() {
    // Set default button classes
    Swal.mixin({
        buttonsStyling: true
    });
    
    // Add custom CSS
    const style = document.createElement('style');
    style.textContent = `
        .swal2-popup {
            font-family: 'Crimson Text', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(60, 41, 34, 0.2);
        }
        
        .swal2-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: #3c2922;
            margin-bottom: 1rem;
        }
        
        .swal2-html-container {
            font-size: 1.1rem;
            color: #555;
            line-height: 1.6;
        }
        
        .swal2-confirm, .swal2-cancel {
            padding: 0.75rem 2rem;
            border-radius: 6px;
            font-size: 1rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .swal2-confirm {
            background-color: #c99366 !important;
            border: none;
        }
        
        .swal2-confirm:hover {
            background-color: #aa6a3f !important;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(201, 147, 102, 0.3);
        }
        
        .swal2-cancel {
            background-color: #95a5a6 !important;
        }
        
        .swal2-cancel:hover {
            background-color: #7f8c8d !important;
            transform: translateY(-2px);
        }
        
        .colored-toast.swal2-popup {
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }
        
        .swal2-progress-steps {
            margin-bottom: 1rem;
        }
        
        @media (max-width: 768px) {
            .swal2-popup {
                width: 90% !important;
                margin: auto;
            }
            
            .swal2-confirm, .swal2-cancel {
                padding: 0.6rem 1.2rem;
                font-size: 0.95rem;
            }
        }
    `;
    document.head.appendChild(style);
}

