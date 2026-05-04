/**
 * ============================================================================
 * Toast.js - Toast Notification Component
 * ============================================================================
 *
 * PURPOSE:
 * - Display non-blocking notifications (errors, success, info, warning)
 * - Auto-dismiss after configurable duration
 * - Queue multiple notifications
 * - Accessible (screen readers, keyboard navigation)
 *
 * USAGE:
 * // Show success notification
 * Toast.success('Item added to cart successfully!');
 *
 * // Show error notification
 * Toast.error('Failed to process payment. Please try again.');
 *
 * // Show warning
 * Toast.warning('Only 3 items left in stock');
 *
 * // Show info
 * Toast.info('Your order has been confirmed');
 *
 * // Show with custom duration
 * Toast.success('Saved!', 2000);
 */

const Toast = (() => {
    let toastContainer = null;
    let toastQueue = [];
    let toastId = 0;

    const TYPES = {
        SUCCESS: 'success',
        ERROR: 'error',
        WARNING: 'warning',
        INFO: 'info'
    };

    const DEFAULT_DURATION = 4000; // 4 seconds

    /**
     * Initialize toast container on page load
     */
    const init = () => {
        if (!document.getElementById('toast-container')) {
            const containerHTML = `
                <div id="toast-container" class="toast-container" role="region" aria-label="Notifications" aria-live="polite">
                </div>
            `;
            document.body.insertAdjacentHTML('beforeend', containerHTML);
        }

        toastContainer = document.getElementById('toast-container');
    };

    /**
     * Create a new toast element
     * @private
     */
    const createToastElement = (message, type, duration) => {
        const id = ++toastId;
        const toastElement = document.createElement('div');
        toastElement.className = `toast toast-${type}`;
        toastElement.id = `toast-${id}`;
        toastElement.setAttribute('role', 'alert');
        toastElement.innerHTML = `
            <div class="toast-icon">
                ${getIcon(type)}
            </div>
            <div class="toast-message">${escapeHtml(message)}</div>
            <button class="toast-close" aria-label="Close notification" onclick="Toast.remove('toast-${id}')">
                <span aria-hidden="true">&times;</span>
            </button>
        `;

        return { element: toastElement, id, duration };
    };

    /**
     * Get icon SVG for toast type
     * @private
     */
    const getIcon = (type) => {
        const icons = {
            success: `
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
                </svg>
            `,
            error: `
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z"/>
                </svg>
            `,
            warning: `
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M1 21h22L12 2 1 21zm12-3h-2v-2h2v2zm0-4h-2v-4h2v4z"/>
                </svg>
            `,
            info: `
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z"/>
                </svg>
            `
        };

        return icons[type] || icons.info;
    };

    /**
     * Escape HTML to prevent XSS
     * @private
     */
    const escapeHtml = (text) => {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    };

    /**
     * Show a toast notification
     * @private
     */
    const showToast = (message, type, duration = DEFAULT_DURATION) => {
        if (!toastContainer) init();

        const toast = createToastElement(message, type, duration);
        toastContainer.appendChild(toast.element);

        // Trigger animation
        setTimeout(() => {
            toast.element.classList.add('show');
        }, 10);

        // Auto-remove after duration
        if (duration > 0) {
            setTimeout(() => {
                removeToast(toast.id);
            }, duration);
        }

        console.log(`[Toast.${type}]`, message);

        return toast.id;
    };

    /**
     * Remove toast element with fade-out animation
     * @private
     */
    const removeToast = (toastId) => {
        const element = document.getElementById(`toast-${toastId}`);
        if (element) {
            element.classList.remove('show');
            setTimeout(() => {
                if (element.parentNode) {
                    element.parentNode.removeChild(element);
                }
            }, 300); // Wait for fade-out animation
        }
    };

    /**
     * Show success toast
     * @param {string} message - Message to display
     * @param {number} duration - Duration in milliseconds (default: 4000)
     */
    const success = (message, duration = DEFAULT_DURATION) => {
        return showToast(message, TYPES.SUCCESS, duration);
    };

    /**
     * Show error toast
     * @param {string} message - Message to display
     * @param {number} duration - Duration in milliseconds (default: 6000 for errors)
     */
    const error = (message, duration = 6000) => {
        return showToast(message, TYPES.ERROR, duration);
    };

    /**
     * Show warning toast
     * @param {string} message - Message to display
     * @param {number} duration - Duration in milliseconds (default: 5000)
     */
    const warning = (message, duration = 5000) => {
        return showToast(message, TYPES.WARNING, duration);
    };

    /**
     * Show info toast
     * @param {string} message - Message to display
     * @param {number} duration - Duration in milliseconds (default: 4000)
     */
    const info = (message, duration = DEFAULT_DURATION) => {
        return showToast(message, TYPES.INFO, duration);
    };

    /**
     * Remove a specific toast
     * @param {string|number} toastId - Toast ID or element ID
     */
    const remove = (toastId) => {
        // Handle both 'toast-123' and 123 formats
        const id = typeof toastId === 'string' ? toastId.replace('toast-', '') : toastId;
        removeToast(id);
    };

    /**
     * Clear all toasts
     */
    const clearAll = () => {
        if (toastContainer) {
            const toasts = toastContainer.querySelectorAll('.toast');
            toasts.forEach(toast => {
                toast.classList.remove('show');
                setTimeout(() => {
                    if (toast.parentNode) {
                        toast.parentNode.removeChild(toast);
                    }
                }, 300);
            });
        }
    };

    // Initialize on DOM ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }

    return {
        success,
        error,
        warning,
        info,
        remove,
        clearAll
    };
})();

/**
 * ============================================================================
 * Usage Examples
 * ============================================================================
 *
 * 1. Add to cart success:
 *    Toast.success('Item added to cart!');
 *
 * 2. Add to cart error:
 *    fetch('/api/cart/add', {...})
 *        .catch(err => {
 *            Toast.error('Failed to add to cart. Please try again.');
 *        });
 *
 * 3. Form validation errors:
 *    if (!email) {
 *        Toast.warning('Please enter an email address');
 *    }
 *
 * 4. Coupon application:
 *    Toast.success('Coupon applied! You saved $50', 3000);
 *
 * 5. Payment processing:
 *    Toast.info('Processing payment...', 0); // Don't auto-close
 *    // Later: Toast.success('Payment successful!');
 *
 * 6. Clear all notifications:
 *    Toast.clearAll();
 */
