/**
 * Notification System Utility
 * Centralized, premium notification system using SweetAlert2 with responsive fallback
 * Replaces all native alert(), confirm(), prompt() with premium custom dialogs
 * Design System: Modern SaaS, Apple Human Interface, and Material 3 inspired.
 */

// Theme configuration using harmonic HSL values to prevent color overlap and ensure perfect contrast
const NOTIFICATION_THEME = {
    primary: '#c99366',       // Warm gold accent
    primaryDark: '#aa6a3f',   // Dark warm gold
    success: 'hsl(142, 70%, 45%)',     // Emerald green
    successBg: 'hsl(142, 70%, 97%)',
    successText: 'hsl(142, 80%, 15%)',
    error: 'hsl(350, 75%, 50%)',       // Crimson red
    errorBg: 'hsl(350, 80%, 98%)',
    errorText: 'hsl(350, 90%, 15%)',
    warning: 'hsl(38, 90%, 50%)',      // Amber orange
    warningBg: 'hsl(38, 90%, 97%)',
    warningText: 'hsl(38, 90%, 15%)',
    info: 'hsl(210, 80%, 55%)',        // Sapphire blue
    infoBg: 'hsl(210, 80%, 98%)',
    infoText: 'hsl(210, 90%, 15%)',
    dark: '#3c2922',          // Creamy cocoa dark
};

let SWAL_AVAILABLE = false;

// Initialize components and apply global custom stylesheets on DOMContentLoaded
document.addEventListener('DOMContentLoaded', function() {
    SWAL_AVAILABLE = typeof Swal !== 'undefined';
    injectDesignSystemCSS();
    if (SWAL_AVAILABLE) {
        configureGlobalSwal();
    }
});

/**
 * 1. CORE NOTIFICATION HANDLERS (Success, Error, Warning, Info)
 */

function showSuccess(message, title = "Thành công", options = {}) {
    if (SWAL_AVAILABLE) {
        return Swal.fire({
            title: title,
            html: message,
            icon: 'success',
            confirmButtonText: 'Đóng',
            customClass: {
                popup: 'premium-popup premium-success-popup'
            },
            showClass: {
                popup: 'animate__animated animate__fadeInUp' // Slide Up + Fade In
            },
            timer: 4000,
            timerProgressBar: true,
            ...options
        });
    } else {
        return showCustomModal('success', title, message);
    }
}

function showError(message, title = "Lỗi", options = {}) {
    // Sanitize network/server error details from being exposed to the user
    let userMessage = message;
    if (message && (message.includes('500') || message.toLowerCase().includes('internal server error') || message.includes('failed to fetch') || message.includes('fetch failed'))) {
        userMessage = "Đã xảy ra lỗi hệ thống. Vui lòng thử lại sau hoặc liên hệ với bộ phận hỗ trợ.";
    }

    if (SWAL_AVAILABLE) {
        return Swal.fire({
            title: title,
            html: userMessage,
            icon: 'error',
            confirmButtonText: 'Đóng',
            customClass: {
                popup: 'premium-popup premium-error-popup'
            },
            showClass: {
                popup: 'animate__animated animate__shake' // Shake + Fade In
            },
            ...options
        });
    } else {
        return showCustomModal('error', title, userMessage);
    }
}

function showWarning(message, title = "Cảnh báo", options = {}) {
    if (SWAL_AVAILABLE) {
        return Swal.fire({
            title: title,
            html: message,
            icon: 'warning',
            confirmButtonText: 'Đóng',
            customClass: {
                popup: 'premium-popup premium-warning-popup'
            },
            showClass: {
                popup: 'animate__animated animate__slideDown' // Slide Down
            },
            ...options
        });
    } else {
        return showCustomModal('warning', title, message);
    }
}

function showInfo(message, title = "Thông tin", options = {}) {
    if (SWAL_AVAILABLE) {
        return Swal.fire({
            title: title,
            html: message,
            icon: 'info',
            confirmButtonText: 'Đóng',
            customClass: {
                popup: 'premium-popup premium-info-popup'
            },
            showClass: {
                popup: 'animate__animated animate__fadeIn' // Fade In
            },
            ...options
        });
    } else {
        return showCustomModal('info', title, message);
    }
}

/**
 * 2. PREMIUM DIALOGS & CONFIRMATIONS (Replaces window.confirm / alert)
 */

function showConfirm(message, onConfirm, onCancel = null, title = "Xác nhận", confirmText = "Xác nhận", cancelText = "Hủy") {
    if (SWAL_AVAILABLE) {
        return Swal.fire({
            title: title,
            html: message,
            icon: 'question',
            showCancelButton: true,
            confirmButtonText: confirmText,
            cancelButtonText: cancelText,
            reverseButtons: true,
            allowOutsideClick: false,
            customClass: {
                popup: 'premium-popup premium-confirm-popup',
                confirmButton: 'swal-btn-primary',
                cancelButton: 'swal-btn-secondary'
            }
        }).then((result) => {
            if (result.isConfirmed) {
                if (typeof onConfirm === 'function') onConfirm();
            } else if (result.isDismissed) {
                if (typeof onCancel === 'function') onCancel();
            }
        });
    } else {
        return showCustomConfirm(message, onConfirm, onCancel, title, confirmText, cancelText);
    }
}

function showDeleteConfirm(itemName, onConfirm, onCancel = null) {
    return showConfirm(
        `Bạn có chắc chắn muốn xóa <strong>${itemName}</strong>?<br/>Hành động này sẽ không thể hoàn tác.`,
        onConfirm,
        onCancel,
        "Xác nhận xóa",
        "Xóa",
        "Hủy"
    );
}

function showPrompt(message, inputType = 'text', onConfirm, onCancel = null, title = "Nhập thông tin", placeholderText = "") {
    if (SWAL_AVAILABLE) {
        return Swal.fire({
            title: title,
            html: message,
            input: inputType,
            inputPlaceholder: placeholderText,
            showCancelButton: true,
            confirmButtonText: "Xác nhận",
            cancelButtonText: "Hủy",
            reverseButtons: true,
            allowOutsideClick: false,
            customClass: {
                popup: 'premium-popup',
                confirmButton: 'swal-btn-primary',
                cancelButton: 'swal-btn-secondary'
            },
            inputValidator: (value) => {
                if (!value) {
                    return 'Vui lòng điền thông tin vào ô trống!';
                }
                if (inputType === 'email' && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)) {
                    return 'Email không đúng định dạng!';
                }
                return undefined;
            }
        }).then((result) => {
            if (result.isConfirmed) {
                if (typeof onConfirm === 'function') onConfirm(result.value);
            } else {
                if (typeof onCancel === 'function') onCancel();
            }
        });
    } else {
        const val = prompt(message, placeholderText);
        if (val !== null) {
            if (typeof onConfirm === 'function') onConfirm(val);
        } else {
            if (typeof onCancel === 'function') onCancel();
        }
    }
}

/**
 * 3. DYNAMIC TOAST SYSTEM (Modern non-blocking notifications)
 */

function showToast(message, type = 'info', duration = 4000) {
    const validTypes = ['success', 'error', 'warning', 'info'];
    const finalType = validTypes.includes(type) ? type : 'info';
    
    // Fallback error translation inside Toast
    let displayMsg = message;
    if (type === 'error' && message && (message.includes('500') || message.includes('failed to fetch') || message.includes('fetch failed'))) {
        displayMsg = "Đã xảy ra lỗi kết nối. Vui lòng thử lại sau.";
    }

    if (SWAL_AVAILABLE) {
        const backgroundColor = {
            success: NOTIFICATION_THEME.success,
            error: NOTIFICATION_THEME.error,
            warning: NOTIFICATION_THEME.warning,
            info: NOTIFICATION_THEME.info
        }[finalType];

        const Toast = Swal.mixin({
            toast: true,
            position: 'top-end',
            showConfirmButton: false,
            timer: duration,
            timerProgressBar: true,
            iconColor: '#ffffff',
            customClass: {
                popup: 'colored-toast premium-toast'
            },
            didOpen: (toast) => {
                toast.addEventListener('mouseenter', Swal.stopTimer);
                toast.addEventListener('mouseleave', Swal.resumeTimer);
            }
        });

        return Toast.fire({
            icon: finalType,
            title: displayMsg,
            background: backgroundColor,
            color: '#ffffff'
        });
    } else {
        return showCustomToast(displayMsg, finalType, duration);
    }
}

/**
 * 4. FORM VALIDATION INLINE HELPERS
 */

function showFormError(inputElement, errorMessage) {
    if (!inputElement) return;
    
    // Add red border focus class
    inputElement.classList.add('input-error');
    
    // Find or create error container
    let errorContainer = inputElement.parentNode.querySelector('.validation-error-msg');
    if (!errorContainer) {
        errorContainer = document.createElement('div');
        errorContainer.className = 'validation-error-msg';
        inputElement.parentNode.appendChild(errorContainer);
    }
    
    errorContainer.innerHTML = `<i class="fas fa-exclamation-circle animate__animated animate__headShake"></i> ${errorMessage}`;
    errorContainer.style.display = 'flex';
    
    // Automatically clear when user interacts
    const clearHandler = () => {
        inputElement.classList.remove('input-error');
        errorContainer.style.display = 'none';
        inputElement.removeEventListener('input', clearHandler);
        inputElement.removeEventListener('change', clearHandler);
    };
    inputElement.addEventListener('input', clearHandler);
    inputElement.addEventListener('change', clearHandler);
}

function clearFormErrors(formElement) {
    if (!formElement) return;
    formElement.querySelectorAll('.input-error').forEach(input => {
        input.classList.remove('input-error');
    });
    formElement.querySelectorAll('.validation-error-msg').forEach(msg => {
        msg.style.display = 'none';
    });
}

/**
 * 5. UPLOAD NOTIFICATION & PROGRESS TRACKER
 */

function createUploadProgressTracker(containerElement, retryCallback = null) {
    if (!containerElement) return null;
    
    containerElement.innerHTML = `
        <div class="premium-upload-card animate__animated animate__fadeIn">
            <div class="upload-preview-wrapper" style="display: none;">
                <img class="upload-img-preview" src="" alt="Preview"/>
            </div>
            <div class="upload-progress-info">
                <span class="upload-status-label"><i class="fas fa-cloud-upload-alt"></i> Đang tải lên...</span>
                <span class="upload-pct-label">0%</span>
            </div>
            <div class="premium-progress-bar-container">
                <div class="premium-progress-fill" style="width: 0%;"></div>
            </div>
            <button class="upload-retry-btn btn btn-outline btn-sm" style="display: none;">
                <i class="fas fa-redo"></i> Thử lại
            </button>
        </div>
    `;

    const card = containerElement.querySelector('.premium-upload-card');
    const previewWrapper = containerElement.querySelector('.upload-preview-wrapper');
    const imgPreview = containerElement.querySelector('.upload-img-preview');
    const statusLabel = containerElement.querySelector('.upload-status-label');
    const pctLabel = containerElement.querySelector('.upload-pct-label');
    const progressFill = containerElement.querySelector('.premium-progress-fill');
    const retryBtn = containerElement.querySelector('.upload-retry-btn');

    if (retryCallback && retryBtn) {
        retryBtn.addEventListener('click', retryCallback);
    }

    return {
        updateProgress: (percentage, imageSrc = null) => {
            const pct = Math.min(100, Math.max(0, Math.round(percentage)));
            pctLabel.textContent = `${pct}%`;
            progressFill.style.width = `${pct}%`;
            
            if (imageSrc) {
                imgPreview.src = imageSrc;
                previewWrapper.style.display = 'block';
            }
            retryBtn.style.display = 'none';
        },
        showSuccess: (message = "Tải lên thành công!") => {
            statusLabel.innerHTML = `<i class="fas fa-check-circle" style="color: ${NOTIFICATION_THEME.success}"></i> ${message}`;
            pctLabel.textContent = "100%";
            progressFill.style.width = "100%";
            progressFill.style.backgroundColor = NOTIFICATION_THEME.success;
            retryBtn.style.display = 'none';
        },
        showError: (errorMessage = "Tải lên thất bại.") => {
            statusLabel.innerHTML = `<i class="fas fa-times-circle" style="color: ${NOTIFICATION_THEME.error}"></i> ${errorMessage}`;
            progressFill.style.backgroundColor = NOTIFICATION_THEME.error;
            if (retryCallback) {
                retryBtn.style.display = 'inline-flex';
            }
        }
    };
}

/**
 * 6. BUTTON LOADING & INTERACTION SPIN HELPERS
 */

function setButtonLoading(buttonElement, isLoading, loadingText = "Đang xử lý...") {
    if (!buttonElement) return;

    if (isLoading) {
        if (!buttonElement.dataset.originalHtml) {
            buttonElement.dataset.originalHtml = buttonElement.innerHTML;
        }
        buttonElement.disabled = true;
        buttonElement.setAttribute('aria-busy', 'true');
        buttonElement.classList.add('btn-loading');
        buttonElement.innerHTML = `<span class="premium-button-spinner"></span> ${loadingText}`;
    } else {
        if (buttonElement.dataset.originalHtml) {
            buttonElement.innerHTML = buttonElement.dataset.originalHtml;
            delete buttonElement.dataset.originalHtml;
        }
        buttonElement.disabled = false;
        buttonElement.removeAttribute('aria-busy');
        buttonElement.classList.remove('btn-loading');
    }
}

/**
 * 7. SPINNER LOADING OVERLAY (Centralized)
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

function hideLoading() {
    if (SWAL_AVAILABLE) {
        Swal.close();
    } else {
        const overlay = document.getElementById('custom-loading-overlay');
        if (overlay) overlay.remove();
    }
}

/**
 * 8. COMPATIBILITY WRAPPERS
 */

function showNotification(title, message, type = 'info', options = {}) {
    const normalizedType = (type || 'info').toLowerCase();
    if (normalizedType === 'success') return showSuccess(message, title, options);
    if (normalizedType === 'error') return showError(message, title, options);
    if (normalizedType === 'warning') return showWarning(message, title, options);
    return showInfo(message, title, options);
}

/**
 * 9. FALLBACK RENDERING IMPLEMENTATION (Pure vanilla JS popup cards)
 */

function showCustomModal(type, title, message) {
    const overlay = document.createElement('div');
    overlay.className = 'fallback-modal-overlay animate__animated animate__fadeIn';
    
    const icon = { success: '✓', error: '✕', warning: '⚠', info: 'ℹ' }[type] || '•';
    
    overlay.innerHTML = `
        <div class="fallback-modal-card fallback-${type} animate__animated animate__zoomIn">
            <div class="fallback-modal-header">
                <span class="fallback-icon">${icon}</span>
                <h3>${title}</h3>
            </div>
            <div class="fallback-modal-body">${message}</div>
            <div class="fallback-modal-footer">
                <button class="btn btn-primary fallback-close-btn">Đóng</button>
            </div>
        </div>
    `;

    overlay.querySelector('.fallback-close-btn').addEventListener('click', () => {
        overlay.classList.add('animate__fadeOut');
        setTimeout(() => overlay.remove(), 300);
    });

    document.body.appendChild(overlay);
}

function showCustomConfirm(message, onConfirm, onCancel, title, confirmText, cancelText) {
    const overlay = document.createElement('div');
    overlay.className = 'fallback-modal-overlay animate__animated animate__fadeIn';
    
    overlay.innerHTML = `
        <div class="fallback-modal-card fallback-confirm animate__animated animate__zoomIn">
            <div class="fallback-modal-header">
                <span class="fallback-icon">❓</span>
                <h3>${title}</h3>
            </div>
            <div class="fallback-modal-body">${message}</div>
            <div class="fallback-modal-footer fallback-confirm-footer">
                <button class="btn btn-outline fallback-cancel-btn">${cancelText}</button>
                <button class="btn btn-primary fallback-confirm-btn">${confirmText}</button>
            </div>
        </div>
    `;

    const closeOverlay = () => {
        overlay.classList.add('animate__fadeOut');
        setTimeout(() => overlay.remove(), 300);
    };

    overlay.querySelector('.fallback-cancel-btn').addEventListener('click', () => {
        closeOverlay();
        if (typeof onCancel === 'function') onCancel();
    });

    overlay.querySelector('.fallback-confirm-btn').addEventListener('click', () => {
        closeOverlay();
        if (typeof onConfirm === 'function') onConfirm();
    });

    document.body.appendChild(overlay);
}

function showCustomToast(message, type, duration) {
    let container = document.getElementById('fallback-toast-container');
    if (!container) {
        container = document.createElement('div');
        container.id = 'fallback-toast-container';
        container.className = 'fallback-toast-container';
        document.body.appendChild(container);
    }

    const toast = document.createElement('div');
    toast.className = `fallback-toast fallback-toast-${type} animate__animated animate__slideInRight`;
    
    const icon = { success: '✓', error: '✕', warning: '⚠', info: 'ℹ' }[type] || '•';
    
    toast.innerHTML = `
        <span class="toast-indicator">${icon}</span>
        <span class="toast-text">${message}</span>
        <span class="toast-close-x">&times;</span>
    `;

    toast.querySelector('.toast-close-x').addEventListener('click', () => {
        toast.classList.replace('animate__slideInRight', 'animate__slideOutRight');
        setTimeout(() => toast.remove(), 300);
    });

    container.appendChild(toast);

    setTimeout(() => {
        if (toast.parentNode) {
            toast.classList.replace('animate__slideInRight', 'animate__slideOutRight');
            setTimeout(() => toast.remove(), 300);
        }
    }, duration);
}

function showCustomLoading(message) {
    const overlay = document.createElement('div');
    overlay.id = 'custom-loading-overlay';
    overlay.className = 'fallback-modal-overlay animate__animated animate__fadeIn';
    overlay.innerHTML = `
        <div class="premium-spinner-box">
            <div class="custom-spinner-dots">
                <div class="dot1"></div>
                <div class="dot2"></div>
                <div class="dot3"></div>
            </div>
            <p>${message}</p>
        </div>
    `;
    document.body.appendChild(overlay);
}

/**
 * 10. SYSTEM STYLESHEET CONFIGURATOR
 */

function configureGlobalSwal() {
    Swal.mixin({
        buttonsStyling: true,
        confirmButtonColor: NOTIFICATION_THEME.primary,
        cancelButtonColor: '#95a5a6'
    });
}

function injectDesignSystemCSS() {
    const style = document.createElement('style');
    style.id = 'premium-notification-styles';
    style.textContent = `
        /* Premium Core Animations */
        @keyframes customShake {
            0%, 100% { transform: translateX(0); }
            20%, 60% { transform: translateX(-8px); }
            40%, 80% { transform: translateX(8px); }
        }
        @keyframes customSlideDown {
            from { transform: translateY(-30px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
        @keyframes customFadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        @keyframes customFadeUp {
            from { transform: translateY(15px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
        @keyframes spin {
            to { transform: rotate(360deg); }
        }
        @keyframes bounceDot {
            0%, 80%, 100% { transform: scale(0); opacity: 0.3; }
            40% { transform: scale(1); opacity: 1; }
        }

        .animate__animated {
            animation-duration: 0.3s;
            animation-fill-mode: both;
        }
        .animate__fadeInUp { animation-name: customFadeUp; }
        .animate__shake { animation-name: customShake; }
        .animate__slideDown { animation-name: customSlideDown; }
        .animate__fadeIn { animation-name: customFadeIn; }

        /* Form validation styles */
        .validation-error-msg {
            display: none;
            align-items: center;
            gap: 6px;
            color: ${NOTIFICATION_THEME.error} !important;
            font-size: 0.85rem !important;
            margin-top: 5px !important;
            font-weight: 500 !important;
            animation: customSlideDown 0.25s ease-out;
        }
        .validation-error-msg i {
            font-size: 0.95rem;
        }
        .input-error {
            border-color: ${NOTIFICATION_THEME.error} !important;
            box-shadow: 0 0 0 3px rgba(231, 76, 60, 0.12) !important;
            background-color: ${NOTIFICATION_THEME.errorBg} !important;
        }

        /* Button loading spinner */
        .premium-button-spinner {
            display: inline-block;
            width: 14px;
            height: 14px;
            border: 2px solid rgba(255,255,255,0.3);
            border-radius: 50%;
            border-top-color: white;
            animation: spin 0.8s linear infinite;
            margin-right: 8px;
            vertical-align: middle;
        }
        .btn-loading {
            opacity: 0.85 !important;
            cursor: not-allowed !important;
        }

        /* Standalone Fallback Styles */
        .fallback-modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(60, 41, 34, 0.45);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 999999999 !important;
        }
        .fallback-modal-card {
            background-color: white;
            border-radius: 16px;
            width: 90%;
            max-width: 440px;
            padding: 24px;
            box-shadow: 0 20px 40px rgba(60, 41, 34, 0.15);
            border: 1px solid rgba(201, 147, 102, 0.15);
        }
        .fallback-modal-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 16px;
        }
        .fallback-modal-header h3 {
            margin: 0;
            font-family: 'Crimson Text', -apple-system, sans-serif;
            font-size: 1.35rem;
            color: ${NOTIFICATION_THEME.dark};
        }
        .fallback-icon {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            font-weight: bold;
            font-size: 0.95rem;
            color: white;
        }
        .fallback-success .fallback-icon { background-color: ${NOTIFICATION_THEME.success}; }
        .fallback-error .fallback-icon { background-color: ${NOTIFICATION_THEME.error}; }
        .fallback-warning .fallback-icon { background-color: ${NOTIFICATION_THEME.warning}; }
        .fallback-info .fallback-icon { background-color: ${NOTIFICATION_THEME.info}; }
        .fallback-confirm .fallback-icon { background-color: ${NOTIFICATION_THEME.primary}; }
        
        .fallback-modal-body {
            color: #555555;
            font-size: 1rem;
            line-height: 1.6;
            margin-bottom: 24px;
        }
        .fallback-modal-footer {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }
        
        /* Fallback toast styling */
        .fallback-toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 999999999 !important;
            display: flex;
            flex-direction: column;
            gap: 10px;
            max-width: 360px;
            width: 90%;
        }
        .fallback-toast {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 16px;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.12);
            color: white;
            font-weight: 500;
            font-size: 0.95rem;
        }
        .fallback-toast-success { background-color: ${NOTIFICATION_THEME.success}; }
        .fallback-toast-error { background-color: ${NOTIFICATION_THEME.error}; }
        .fallback-toast-warning { background-color: ${NOTIFICATION_THEME.warning}; }
        .fallback-toast-info { background-color: ${NOTIFICATION_THEME.info}; }
        
        .toast-indicator { font-weight: bold; }
        .toast-text { flex-grow: 1; }
        .toast-close-x { cursor: pointer; opacity: 0.7; font-size: 1.2rem; }
        .toast-close-x:hover { opacity: 1; }

        /* Spinner box for loading state */
        .premium-spinner-box {
            background-color: white;
            border-radius: 16px;
            padding: 30px;
            text-align: center;
            box-shadow: 0 15px 30px rgba(0,0,0,0.15);
        }
        .custom-spinner-dots {
            display: flex;
            justify-content: center;
            gap: 6px;
            margin-bottom: 16px;
        }
        .custom-spinner-dots div {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background-color: ${NOTIFICATION_THEME.primary};
            animation: bounceDot 1.4s infinite ease-in-out both;
        }
        .custom-spinner-dots .dot1 { animation-delay: -0.32s; }
        .custom-spinner-dots .dot2 { animation-delay: -0.16s; }

        /* Upload progress bar styles */
        .premium-upload-card {
            border: 1px solid rgba(201, 147, 102, 0.2);
            border-radius: 12px;
            padding: 16px;
            background-color: #faf5ef;
            display: flex;
            flex-direction: column;
            gap: 12px;
            margin-top: 10px;
        }
        .upload-preview-wrapper {
            width: 60px;
            height: 60px;
            border-radius: 8px;
            overflow: hidden;
            border: 1px solid rgba(0,0,0,0.1);
        }
        .upload-img-preview {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .upload-progress-info {
            display: flex;
            justify-content: space-between;
            font-size: 0.9rem;
            font-weight: 500;
            color: ${NOTIFICATION_THEME.dark};
        }
        .premium-progress-bar-container {
            width: 100%;
            height: 6px;
            background-color: rgba(201, 147, 102, 0.15);
            border-radius: 3px;
            overflow: hidden;
        }
        .premium-progress-fill {
            height: 100%;
            background-color: ${NOTIFICATION_THEME.primary};
            border-radius: 3px;
            transition: width 0.2s ease;
        }
        .upload-retry-btn {
            align-self: flex-end;
            margin-top: 4px;
        }

        /* Swal Override styling */
        .premium-popup {
            font-family: 'Poppins', 'Crimson Text', -apple-system, sans-serif !important;
            border-radius: 16px !important;
            box-shadow: 0 15px 40px rgba(60, 41, 34, 0.12) !important;
            padding: 24px !important;
        }
        .swal2-title {
            color: ${NOTIFICATION_THEME.dark} !important;
            font-family: 'Crimson Text', serif !important;
            font-size: 1.45rem !important;
        }
        .swal2-html-container {
            color: #555555 !important;
            font-size: 1rem !important;
        }
        .swal-btn-primary {
            background-color: ${NOTIFICATION_THEME.primary} !important;
            color: white !important;
            border-radius: 8px !important;
            padding: 10px 24px !important;
        }
        .swal-btn-secondary {
            background-color: #95a5a6 !important;
            color: white !important;
            border-radius: 8px !important;
            padding: 10px 24px !important;
        }
        
        /* Force SweetAlert2 container on top of header menus */
        .swal2-container {
            z-index: 999999999 !important;
        }
    `;
    document.head.appendChild(style);
}
