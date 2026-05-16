/**
 * ============================================================================
 * LoadingSpinner.js - Reusable Loading Animation Component
 * ============================================================================
 *
 * PURPOSE:
 * - Show visual feedback during async operations (cart updates, search, etc.)
 * - Prevent user interaction during loading (disable buttons)
 * - Display messages indicating what's loading
 *
 * USAGE:
 * // Show spinner
 * LoadingSpinner.show("Adding to cart...");
 *
 * // Hide spinner
 * LoadingSpinner.hide();
 *
 * // Auto-hide after 3 seconds
 * LoadingSpinner.show("Processing payment...", 3000);
 */

const LoadingSpinner = (() => {
    let spinnerElement = null;
    let messageElement = null;
    let autoHideTimeout = null;

    /**
     * Initialize spinner HTML structure on page load
     */
    const init = () => {
        // Create spinner container if it doesn't exist
        if (!document.getElementById('loading-spinner')) {
            const spinnerHTML = `
                <div id="loading-spinner" class="loading-spinner hidden">
                    <div class="spinner-overlay"></div>
                    <div class="spinner-container">
                        <div class="spinner-animation">
                            <div class="spinner-dot"></div>
                            <div class="spinner-dot"></div>
                            <div class="spinner-dot"></div>
                        </div>
                        <p id="spinner-message" class="spinner-message">Loading...</p>
                    </div>
                </div>
            `;
            document.body.insertAdjacentHTML('beforeend', spinnerHTML);
        }

        spinnerElement = document.getElementById('loading-spinner');
        messageElement = document.getElementById('spinner-message');
    };

    /**
     * Show loading spinner with optional message
     * @param {string} message - Message to display (default: "Loading...")
     * @param {number} autoHideMs - Auto-hide after N milliseconds (optional)
     */
    const show = (message = 'Loading...', autoHideMs = null) => {
        if (!spinnerElement) init();

        messageElement.textContent = message;
        spinnerElement.classList.remove('hidden');

        // Disable scrolling while loading
        document.body.style.overflow = 'hidden';

        // Clear any existing timeout
        if (autoHideTimeout) {
            clearTimeout(autoHideTimeout);
        }

        // Auto-hide if specified
        if (autoHideMs && typeof autoHideMs === 'number') {
            autoHideTimeout = setTimeout(() => hide(), autoHideMs);
        }

        console.log('[LoadingSpinner] Shown:', message);
    };

    /**
     * Hide loading spinner
     */
    const hide = () => {
        if (!spinnerElement) return;

        spinnerElement.classList.add('hidden');
        document.body.style.overflow = 'auto';

        if (autoHideTimeout) {
            clearTimeout(autoHideTimeout);
        }

        console.log('[LoadingSpinner] Hidden');
    };

    /**
     * Update loading message without hiding/showing
     * @param {string} message - New message to display
     */
    const updateMessage = (message) => {
        if (messageElement) {
            messageElement.textContent = message;
        }
    };

    /**
     * Check if spinner is currently visible
     * @returns {boolean} - True if visible
     */
    const isVisible = () => {
        return spinnerElement && !spinnerElement.classList.contains('hidden');
    };

    // Initialize on DOM ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }

    return {
        show,
        hide,
        updateMessage,
        isVisible
    };
})();

/**
 * ============================================================================
 * Usage Examples
 * ============================================================================
 *
 * 1. Add to cart with loading indicator:
 *    LoadingSpinner.show('Adding to cart...');
 *    fetch('/api/cart/add', {...})
 *        .then(r => r.json())
 *        .then(data => {
 *            LoadingSpinner.hide();
 *            Toast.success('Added to cart!');
 *        })
 *        .catch(err => {
 *            LoadingSpinner.hide();
 *            Toast.error('Failed to add to cart');
 *        });
 *
 * 2. Checkout process:
 *    LoadingSpinner.show('Processing payment...');
 *    // Payment API call
 *    // LoadingSpinner.hide() in callback
 *
 * 3. Search with auto-hide:
 *    LoadingSpinner.show('Searching...', 5000); // Auto-hide after 5 sec
 *
 * 4. Multi-step process:
 *    LoadingSpinner.show('Step 1 of 3: Validating...');
 *    // Step 1
 *    LoadingSpinner.updateMessage('Step 2 of 3: Processing...');
 *    // Step 2
 *    LoadingSpinner.updateMessage('Step 3 of 3: Finalizing...');
 *    // Step 3
 *    LoadingSpinner.hide();
 */
