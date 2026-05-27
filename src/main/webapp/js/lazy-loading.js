/**
 * Image Lazy Loading with Intersection Observer
 * Tự động load hình ảnh khi xuất hiện trong viewport
 */

(function() {
    'use strict';
    
    // Kiểm tra browser support
    if (!('IntersectionObserver' in window)) {
        // Fallback cho browser cũ - load tất cả ảnh ngay
        console.log('IntersectionObserver not supported. Loading all images.');
        loadAllImages();
        return;
    }
    
    // Cấu hình observer
    const config = {
        rootMargin: '50px 0px', // Load trước 50px
        threshold: 0.01
    };
    
    // Tạo observer
    const imageObserver = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const img = entry.target;
                loadImage(img);
                observer.unobserve(img);
            }
        });
    }, config);
    
    // Load image
    function loadImage(img) {
        const src = img.dataset.src;
        const srcset = img.dataset.srcset;
        
        if (!src) return;
        
        // Tạo image mới để preload
        const tempImg = new Image();
        
        tempImg.onload = () => {
            // Set src sau khi load xong
            img.src = src;
            if (srcset) {
                img.srcset = srcset;
            }
            
            // Add loaded class cho fade-in effect
            img.classList.add('loaded');
            img.classList.remove('lazy');
        };
        
        tempImg.onerror = () => {
            // Fallback nếu load fail
            img.src = src;
            img.classList.add('error');
            img.classList.remove('lazy');
        };
        
        tempImg.src = src;
    }
    
    // Load tất cả ảnh (fallback)
    function loadAllImages() {
        const lazyImages = document.querySelectorAll('img.lazy');
        lazyImages.forEach(img => {
            const src = img.dataset.src;
            if (src) {
                img.src = src;
                const srcset = img.dataset.srcset;
                if (srcset) {
                    img.srcset = srcset;
                }
                img.classList.remove('lazy');
                img.classList.add('loaded');
            }
        });
    }
    
    // Initialize
    function init() {
        const lazyImages = document.querySelectorAll('img.lazy');
        
        if (lazyImages.length === 0) return;
        
        // Observe tất cả lazy images
        lazyImages.forEach(img => {
            imageObserver.observe(img);
        });
    }
    
    // Run on DOM ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
    
    // Re-initialize khi có thêm ảnh mới (AJAX)
    window.reinitLazyLoad = function() {
        init();
    };
    
})();

/**
 * CSS cho lazy loading (thêm vào stylesheet):
 * 
 * img.lazy {
 *     opacity: 0;
 *     transition: opacity 0.3s ease-in;
 * }
 * 
 * img.lazy.loaded {
 *     opacity: 1;
 * }
 * 
 * img.lazy.error {
 *     opacity: 0.5;
 *     filter: grayscale(1);
 * }
 */
