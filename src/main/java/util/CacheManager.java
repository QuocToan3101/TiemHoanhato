package util;

import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.TimeUnit;

/**
 * Simple Cache Manager
 * Cache đơn giản cho dữ liệu tĩnh (categories, settings, etc.)
 */
public class CacheManager {
    
    private static final ConcurrentHashMap<String, CacheEntry> cache = new ConcurrentHashMap<>();
    private static final long DEFAULT_TTL_MINUTES = 30; // 30 phút
    
    /**
     * Lưu vào cache
     */
    public static void put(String key, Object value) {
        put(key, value, DEFAULT_TTL_MINUTES, TimeUnit.MINUTES);
    }
    
    /**
     * Lưu vào cache với TTL tùy chỉnh
     */
    public static void put(String key, Object value, long duration, TimeUnit timeUnit) {
        long expiryTime = System.currentTimeMillis() + timeUnit.toMillis(duration);
        cache.put(key, new CacheEntry(value, expiryTime));
    }
    
    /**
     * Lấy từ cache
     */
    @SuppressWarnings("unchecked")
    public static <T> T get(String key) {
        CacheEntry entry = cache.get(key);
        if (entry == null) {
            return null;
        }
        
        // Kiểm tra xem có hết hạn chưa
        if (entry.isExpired()) {
            cache.remove(key);
            return null;
        }
        
        return (T) entry.value;
    }
    
    /**
     * Xóa khỏi cache
     */
    public static void remove(String key) {
        cache.remove(key);
    }
    
    /**
     * Xóa tất cả cache
     */
    public static void clear() {
        cache.clear();
    }
    
    /**
     * Xóa cache theo pattern
     */
    public static void removePattern(String pattern) {
        cache.keySet().removeIf(key -> key.contains(pattern));
    }
    
    /**
     * Lấy hoặc tính toán nếu không có trong cache
     */
    public static <T> T getOrCompute(String key, CacheSupplier<T> supplier) {
        T value = get(key);
        if (value == null) {
            value = supplier.get();
            if (value != null) {
                put(key, value);
            }
        }
        return value;
    }
    
    /**
     * Interface cho supplier
     */
    @FunctionalInterface
    public interface CacheSupplier<T> {
        T get();
    }
    
    /**
     * Entry trong cache
     */
    private static class CacheEntry {
        private final Object value;
        private final long expiryTime;
        
        CacheEntry(Object value, long expiryTime) {
            this.value = value;
            this.expiryTime = expiryTime;
        }
        
        boolean isExpired() {
            return System.currentTimeMillis() > expiryTime;
        }
    }
    
    /**
     * Cleanup thread để xóa expired entries
     */
    static {
        Thread cleanupThread = new Thread(() -> {
            while (true) {
                try {
                    TimeUnit.MINUTES.sleep(5); // Cleanup mỗi 5 phút
                    
                    // Xóa các entry đã hết hạn
                    cache.entrySet().removeIf(entry -> entry.getValue().isExpired());
                    
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                    break;
                }
            }
        });
        cleanupThread.setDaemon(true);
        cleanupThread.setName("CacheCleanupThread");
        cleanupThread.start();
    }
}
