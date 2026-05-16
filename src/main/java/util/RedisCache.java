package util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Small optional Redis helper. If Redis not configured, null-safe usage expected.
 */
public class RedisCache {
    private static final Logger logger = LoggerFactory.getLogger(RedisCache.class);
    private final String host;
    private final int port;
    private final int ttlSeconds;

    public RedisCache(String host, int port, int ttlSeconds) {
        this.host = host; this.port = port; this.ttlSeconds = ttlSeconds;
    }

    public void set(String key, String value) {
        withJedis(jedis -> { invoke(jedis, "setex", new Class<?>[]{String.class, int.class, String.class}, key, ttlSeconds, value); return null; });
    }

    public String get(String key) {
        final String[] result = new String[1];
        withJedis(jedis -> { result[0] = (String) invoke(jedis, "get", new Class<?>[]{String.class}, key); return null; });
        return result[0];
    }

    private void withJedis(JedisAction action) {
        try {
            Class<?> jedisClass = Class.forName("redis.clients.jedis.Jedis");
            Object jedis = jedisClass.getConstructor(String.class, int.class).newInstance(host, port);
            try (AutoCloseable closeable = (AutoCloseable) jedis) {
                action.run(jedis);
            }
        } catch (ClassNotFoundException e) {
            // Jedis not on classpath: optional Redis support disabled.
        } catch (Exception e) {
            logger.warn("Redis operation failed", e);
        }
    }

    private Object invoke(Object target, String method, Class<?>[] types, Object... args) throws Exception {
        return target.getClass().getMethod(method, types).invoke(target, args);
    }

    @FunctionalInterface
    private interface JedisAction {
        Object run(Object jedis) throws Exception;
    }
}
