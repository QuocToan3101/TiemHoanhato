package dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import model.Category;
import model.Product;
import util.CacheManager;
import util.Constants;

/**
 * Optimized and Refactored ProductDAO integrating Caffeine Caching (Phase 2)
 * Extends BaseDAO for unified database connectivity and type-safe query execution.
 * Provides 100% backward compatibility for all 28 original methods.
 */
public class ProductDAO extends BaseDAO {
    
    private static final CacheManager cacheManager = CacheManager.getInstance();
    private static final String CACHE_PREFIX = "products";
    
    // SQL Columns for clean query structures
    private static final String SELECT_COLUMNS_ACTIVE = 
        "SELECT p.id, p.category_id, p.name, p.slug, p.description, p.short_description, " +
        "p.price, p.sale_price, p.quantity, p.image, p.images, p.is_featured, p.view_count, " +
        "p.sold_count, p.average_rating, p.review_count, p.created_at, p.updated_at, " +
        "c.name as category_name, c.slug as category_slug ";
        
    private static final String SELECT_COLUMNS_ADMIN = 
        SELECT_COLUMNS_ACTIVE + ", p.is_active ";

    // ==========================================
    // 1. READ OPERATIONS (CACHED)
    // ==========================================

    /**
     * Lấy tất cả sản phẩm đang active (Cached)
     */
    @SuppressWarnings("unchecked")
    public List<Product> findAll() {
        String cacheKey = CACHE_PREFIX + "_all_active";
        
        Object cached = cacheManager.getProductList(cacheKey);
        if (cached != null) {
            logger.debug("Cache HIT for: {}", cacheKey);
            return (List<Product>) cached;
        }
        
        List<Product> products = new ArrayList<>();
        String sql = Constants.DB.PRODUCTS.QUERY_ACTIVE + " ORDER BY p.created_at DESC";
        
        try {
            products = executeQuery(sql, rs -> mapResultSetToProduct(rs, true));
            if (!products.isEmpty()) {
                cacheManager.putProductList(cacheKey, products);
                logger.info("Cache MISS - Cached {} products for: {}", products.size(), cacheKey);
            }
        } catch (SQLException e) {
            logSQLError("lấy danh sách products", e);
        }
        return products;
    }

    /**
     * Lấy tất cả sản phẩm bao gồm cả inactive cho Admin (Cached)
     */
    @SuppressWarnings("unchecked")
    public List<Product> findAllIncludeInactive() {
        String cacheKey = CACHE_PREFIX + "_all_include_inactive";
        
        Object cached = cacheManager.getProductList(cacheKey);
        if (cached != null) {
            logger.debug("Cache HIT for: {}", cacheKey);
            return (List<Product>) cached;
        }
        
        List<Product> products = new ArrayList<>();
        String sql = SELECT_COLUMNS_ADMIN +
                     "FROM products p " +
                     "LEFT JOIN categories c ON p.category_id = c.id " +
                     "ORDER BY p.created_at DESC";
        
        try {
            products = executeQuery(sql, rs -> mapResultSetToProduct(rs, true));
            if (!products.isEmpty()) {
                cacheManager.putProductList(cacheKey, products);
                logger.info("Cache MISS - Cached {} products for: {}", products.size(), cacheKey);
            }
        } catch (SQLException e) {
            logSQLError("lấy danh sách tất cả products", e);
        }
        return products;
    }

    /**
     * Lấy sản phẩm với phân trang (Cached)
     */
    @SuppressWarnings("unchecked")
    public List<Product> findWithPagination(int page, int limit) {
        String cacheKey = CACHE_PREFIX + "_page_" + page + "_limit_" + limit;
        
        Object cached = cacheManager.getProductList(cacheKey);
        if (cached != null) {
            logger.debug("Cache HIT for: {}", cacheKey);
            return (List<Product>) cached;
        }
        
        List<Product> products = new ArrayList<>();
        String sql = Constants.DB.PRODUCTS.QUERY_ACTIVE + 
                     " ORDER BY p.created_at DESC LIMIT ? OFFSET ?";
        
        Object[] params = {limit, (page - 1) * limit};
        
        try {
            products = executeQueryWithParams(sql, params, rs -> mapResultSetToProduct(rs, true));
            if (!products.isEmpty()) {
                cacheManager.putProductList(cacheKey, products);
                logger.info("Cache MISS - Cached {} products for: {}", products.size(), cacheKey);
            }
        } catch (SQLException e) {
            logSQLError("lấy products với phân trang", e);
        }
        return products;
    }

    /**
     * Lấy sản phẩm theo danh mục với phân trang (Cached)
     */
    @SuppressWarnings("unchecked")
    public List<Product> findByCategoryWithPagination(int categoryId, int page, int limit) {
        String cacheKey = CACHE_PREFIX + "_cat_" + categoryId + "_page_" + page + "_limit_" + limit;
        
        Object cached = cacheManager.getProductList(cacheKey);
        if (cached != null) {
            logger.debug("Cache HIT for: {}", cacheKey);
            return (List<Product>) cached;
        }
        
        List<Product> products = new ArrayList<>();
        String sql = SELECT_COLUMNS_ACTIVE +
                     "FROM products p " +
                     "LEFT JOIN categories c ON p.category_id = c.id " +
                     "WHERE p.is_active = TRUE AND p.category_id = ? " +
                     "ORDER BY p.created_at DESC " +
                     "LIMIT ? OFFSET ?";
        
        Object[] params = {categoryId, limit, (page - 1) * limit};
        
        try {
            products = executeQueryWithParams(sql, params, rs -> mapResultSetToProduct(rs, true));
            if (!products.isEmpty()) {
                cacheManager.putProductList(cacheKey, products);
                logger.info("Cache MISS - Cached {} products for: {}", products.size(), cacheKey);
            }
        } catch (SQLException e) {
            logSQLError("lấy products theo category với phân trang", e);
        }
        return products;
    }

    /**
     * Đếm số sản phẩm theo danh mục (Cached)
     */
    public int countByCategory(int categoryId) {
        String cacheKey = CACHE_PREFIX + "_count_cat_" + categoryId;
        
        Object cached = cacheManager.getProductList(cacheKey);
        if (cached != null) {
            logger.debug("Cache HIT for: {}", cacheKey);
            return (Integer) cached;
        }
        
        String sql = "SELECT COUNT(*) FROM products WHERE is_active = TRUE AND category_id = ?";
        Object[] params = {categoryId};
        
        try {
            int count = executeCountQuery(sql, params);
            cacheManager.putProductList(cacheKey, count);
            return count;
        } catch (SQLException e) {
            logSQLError("đếm products theo category", e);
        }
        return 0;
    }

    /**
     * Lấy sản phẩm theo danh mục (Cached)
     */
    @SuppressWarnings("unchecked")
    public List<Product> findByCategory(int categoryId) {
        String cacheKey = CACHE_PREFIX + "_cat_" + categoryId;
        
        Object cached = cacheManager.getProductList(cacheKey);
        if (cached != null) {
            logger.debug("Cache HIT for: {}", cacheKey);
            return (List<Product>) cached;
        }
        
        List<Product> products = new ArrayList<>();
        String sql = SELECT_COLUMNS_ACTIVE +
                     "FROM products p " +
                     "LEFT JOIN categories c ON p.category_id = c.id " +
                     "WHERE p.category_id = ? AND p.is_active = TRUE " +
                     "ORDER BY p.created_at DESC";
        
        Object[] params = {categoryId};
        
        try {
            products = executeQueryWithParams(sql, params, rs -> mapResultSetToProduct(rs, true));
            if (!products.isEmpty()) {
                cacheManager.putProductList(cacheKey, products);
            }
        } catch (SQLException e) {
            logSQLError("lấy products theo category", e);
        }
        return products;
    }

    /**
     * Lấy sản phẩm theo danh mục (bao gồm cả inactive cho Admin - Cached)
     */
    @SuppressWarnings("unchecked")
    public List<Product> findByCategoryIncludeInactive(int categoryId) {
        String cacheKey = CACHE_PREFIX + "_cat_" + categoryId + "_include_inactive";
        
        Object cached = cacheManager.getProductList(cacheKey);
        if (cached != null) {
            logger.debug("Cache HIT for: {}", cacheKey);
            return (List<Product>) cached;
        }
        
        List<Product> products = new ArrayList<>();
        String sql = SELECT_COLUMNS_ADMIN +
                     "FROM products p " +
                     "LEFT JOIN categories c ON p.category_id = c.id " +
                     "WHERE p.category_id = ? " +
                     "ORDER BY p.created_at DESC";
        
        Object[] params = {categoryId};
        
        try {
            products = executeQueryWithParams(sql, params, rs -> mapResultSetToProduct(rs, true));
            if (!products.isEmpty()) {
                cacheManager.putProductList(cacheKey, products);
            }
        } catch (SQLException e) {
            logSQLError("lấy products theo category include inactive", e);
        }
        return products;
    }

    /**
     * Lấy sản phẩm theo slug danh mục (Cached)
     */
    @SuppressWarnings("unchecked")
    public List<Product> findByCategorySlug(String categorySlug) {
        String cacheKey = CACHE_PREFIX + "_cat_slug_" + categorySlug;
        
        Object cached = cacheManager.getProductList(cacheKey);
        if (cached != null) {
            logger.debug("Cache HIT for: {}", cacheKey);
            return (List<Product>) cached;
        }
        
        List<Product> products = new ArrayList<>();
        String sql = SELECT_COLUMNS_ACTIVE +
                     "FROM products p " +
                     "JOIN categories c ON p.category_id = c.id " +
                     "WHERE c.slug = ? AND p.is_active = TRUE " +
                     "ORDER BY p.created_at DESC";
        
        Object[] params = {categorySlug};
        
        try {
            products = executeQueryWithParams(sql, params, rs -> mapResultSetToProduct(rs, true));
            if (!products.isEmpty()) {
                cacheManager.putProductList(cacheKey, products);
            }
        } catch (SQLException e) {
            logSQLError("lấy products theo category slug", e);
        }
        return products;
    }

    /**
     * Lấy sản phẩm nổi bật (Cached)
     */
    @SuppressWarnings("unchecked")
    public List<Product> findFeatured(int limit) {
        String cacheKey = CACHE_PREFIX + "_featured_limit_" + limit;
        
        Object cached = cacheManager.getProductList(cacheKey);
        if (cached != null) {
            logger.debug("Cache HIT for: {}", cacheKey);
            return (List<Product>) cached;
        }
        
        List<Product> products = new ArrayList<>();
        String sql = SELECT_COLUMNS_ACTIVE +
                     "FROM products p " +
                     "LEFT JOIN categories c ON p.category_id = c.id " +
                     "WHERE p.is_featured = TRUE AND p.is_active = TRUE " +
                     "ORDER BY p.created_at DESC LIMIT ?";
        
        Object[] params = {limit};
        
        try {
            products = executeQueryWithParams(sql, params, rs -> mapResultSetToProduct(rs, true));
            if (!products.isEmpty()) {
                cacheManager.putProductList(cacheKey, products);
            }
        } catch (SQLException e) {
            logSQLError("lấy featured products", e);
        }
        return products;
    }

    /**
     * Lấy sản phẩm mới nhất (Cached)
     */
    @SuppressWarnings("unchecked")
    public List<Product> findLatest(int limit) {
        String cacheKey = CACHE_PREFIX + "_latest_limit_" + limit;
        
        Object cached = cacheManager.getProductList(cacheKey);
        if (cached != null) {
            logger.debug("Cache HIT for: {}", cacheKey);
            return (List<Product>) cached;
        }
        
        List<Product> products = new ArrayList<>();
        String sql = SELECT_COLUMNS_ACTIVE +
                     "FROM products p " +
                     "LEFT JOIN categories c ON p.category_id = c.id " +
                     "WHERE p.is_active = TRUE " +
                     "ORDER BY p.created_at DESC LIMIT ?";
        
        Object[] params = {limit};
        
        try {
            products = executeQueryWithParams(sql, params, rs -> mapResultSetToProduct(rs, true));
            if (!products.isEmpty()) {
                cacheManager.putProductList(cacheKey, products);
            }
        } catch (SQLException e) {
            logSQLError("lấy latest products", e);
        }
        return products;
    }

    /**
     * Lấy sản phẩm bán chạy (Cached)
     */
    @SuppressWarnings("unchecked")
    public List<Product> findBestSellers(int limit) {
        String cacheKey = CACHE_PREFIX + "_bestsellers_limit_" + limit;
        
        Object cached = cacheManager.getProductList(cacheKey);
        if (cached != null) {
            logger.debug("Cache HIT for: {}", cacheKey);
            return (List<Product>) cached;
        }
        
        List<Product> products = new ArrayList<>();
        String sql = SELECT_COLUMNS_ACTIVE +
                     "FROM products p " +
                     "LEFT JOIN categories c ON p.category_id = c.id " +
                     "WHERE p.is_active = TRUE " +
                     "ORDER BY p.sold_count DESC LIMIT ?";
        
        Object[] params = {limit};
        
        try {
            products = executeQueryWithParams(sql, params, rs -> mapResultSetToProduct(rs, true));
            if (!products.isEmpty()) {
                cacheManager.putProductList(cacheKey, products);
            }
        } catch (SQLException e) {
            logSQLError("lấy best sellers", e);
        }
        return products;
    }

    /**
     * Lấy sản phẩm đang giảm giá (Cached)
     */
    @SuppressWarnings("unchecked")
    public List<Product> findOnSale(int limit) {
        String cacheKey = CACHE_PREFIX + "_onsale_limit_" + limit;
        
        Object cached = cacheManager.getProductList(cacheKey);
        if (cached != null) {
            logger.debug("Cache HIT for: {}", cacheKey);
            return (List<Product>) cached;
        }
        
        List<Product> products = new ArrayList<>();
        String sql = SELECT_COLUMNS_ACTIVE +
                     "FROM products p " +
                     "LEFT JOIN categories c ON p.category_id = c.id " +
                     "WHERE p.sale_price IS NOT NULL AND p.sale_price < p.price " +
                     "AND p.is_active = TRUE " +
                     "ORDER BY (p.price - p.sale_price) / p.price DESC LIMIT ?";
        
        Object[] params = {limit};
        
        try {
            products = executeQueryWithParams(sql, params, rs -> mapResultSetToProduct(rs, true));
            if (!products.isEmpty()) {
                cacheManager.putProductList(cacheKey, products);
            }
        } catch (SQLException e) {
            logSQLError("lấy sale products", e);
        }
        return products;
    }

    /**
     * Tìm sản phẩm theo ID (Cached separately using productByIdCache)
     */
    public Product findById(int id) {
        Product cachedProduct = (Product) cacheManager.getProductById(id);
        if (cachedProduct != null) {
            logger.debug("Cache HIT for product ID: {}", id);
            return cachedProduct;
        }
        
        String sql = SELECT_COLUMNS_ADMIN +
                     "FROM products p " +
                     "LEFT JOIN categories c ON p.category_id = c.id " +
                     "WHERE p.id = ?";
        
        Object[] params = {id};
        
        try {
            List<Product> results = executeQueryWithParams(sql, params, rs -> mapResultSetToProduct(rs, true));
            if (!results.isEmpty()) {
                Product product = results.get(0);
                cacheManager.putProductById(id, product);
                logger.info("Cache MISS - Cached product with ID: {}", id);
                return product;
            }
        } catch (SQLException e) {
            logSQLError("tìm product theo ID", e);
        }
        return null;
    }

    /**
     * Tìm sản phẩm theo slug (Cached)
     */
    public Product findBySlug(String slug) {
        String cacheKey = CACHE_PREFIX + "_slug_" + slug;
        
        Object cached = cacheManager.getProductList(cacheKey);
        if (cached != null) {
            logger.debug("Cache HIT for: {}", cacheKey);
            return (Product) cached;
        }
        
        String sql = SELECT_COLUMNS_ACTIVE +
                     "FROM products p " +
                     "LEFT JOIN categories c ON p.category_id = c.id " +
                     "WHERE p.slug = ?";
        
        Object[] params = {slug};
        
        try {
            List<Product> results = executeQueryWithParams(sql, params, rs -> mapResultSetToProduct(rs, true));
            if (!results.isEmpty()) {
                Product product = results.get(0);
                cacheManager.putProductList(cacheKey, product);
                return product;
            }
        } catch (SQLException e) {
            logSQLError("tìm product theo slug", e);
        }
        return null;
    }

    /**
     * Tìm kiếm sản phẩm theo từ khóa (Cached)
     */
    @SuppressWarnings("unchecked")
    public List<Product> search(String keyword) {
        String cacheKey = CACHE_PREFIX + "_search_" + keyword;
        
        Object cached = cacheManager.getProductList(cacheKey);
        if (cached != null) {
            logger.debug("Cache HIT for: {}", cacheKey);
            return (List<Product>) cached;
        }
        
        List<Product> products = new ArrayList<>();
        String sql = SELECT_COLUMNS_ACTIVE +
                     "FROM products p " +
                     "LEFT JOIN categories c ON p.category_id = c.id " +
                     "WHERE (p.name LIKE ? OR p.description LIKE ?) AND p.is_active = TRUE " +
                     "ORDER BY p.name";
        
        String searchPattern = "%" + keyword + "%";
        Object[] params = {searchPattern, searchPattern};
        
        try {
            products = executeQueryWithParams(sql, params, rs -> mapResultSetToProduct(rs, true));
            if (!products.isEmpty()) {
                cacheManager.putProductList(cacheKey, products);
            }
        } catch (SQLException e) {
            logSQLError("tìm kiếm products", e);
        }
        return products;
    }

    /**
     * Tìm kiếm sản phẩm bao gồm cả inactive cho Admin (Cached)
     */
    @SuppressWarnings("unchecked")
    public List<Product> searchIncludeInactive(String keyword) {
        String cacheKey = CACHE_PREFIX + "_search_include_inactive_" + keyword;
        
        Object cached = cacheManager.getProductList(cacheKey);
        if (cached != null) {
            logger.debug("Cache HIT for: {}", cacheKey);
            return (List<Product>) cached;
        }
        
        List<Product> products = new ArrayList<>();
        String sql = SELECT_COLUMNS_ADMIN +
                     "FROM products p " +
                     "LEFT JOIN categories c ON p.category_id = c.id " +
                     "WHERE p.name LIKE ? OR p.description LIKE ? " +
                     "ORDER BY p.name";
        
        String searchPattern = "%" + keyword + "%";
        Object[] params = {searchPattern, searchPattern};
        
        try {
            products = executeQueryWithParams(sql, params, rs -> mapResultSetToProduct(rs, true));
            if (!products.isEmpty()) {
                cacheManager.putProductList(cacheKey, products);
            }
        } catch (SQLException e) {
            logSQLError("tìm kiếm products include inactive", e);
        }
        return products;
    }

    /**
     * Tìm kiếm sản phẩm với giới hạn số lượng cho live search (Cached)
     */
    @SuppressWarnings("unchecked")
    public List<Product> searchWithLimit(String keyword, int limit) {
        String cacheKey = CACHE_PREFIX + "_search_" + keyword + "_limit_" + limit;
        
        Object cached = cacheManager.getProductList(cacheKey);
        if (cached != null) {
            logger.debug("Cache HIT for: {}", cacheKey);
            return (List<Product>) cached;
        }
        
        List<Product> products = new ArrayList<>();
        String sql = SELECT_COLUMNS_ACTIVE +
                     "FROM products p " +
                     "LEFT JOIN categories c ON p.category_id = c.id " +
                     "WHERE (p.name LIKE ? OR p.description LIKE ?) AND p.is_active = TRUE " +
                     "ORDER BY p.sold_count DESC, p.name " +
                     "LIMIT ?";
        
        String searchPattern = "%" + keyword + "%";
        Object[] params = {searchPattern, searchPattern, limit};
        
        try {
            products = executeQueryWithParams(sql, params, rs -> mapResultSetToProduct(rs, true));
            if (!products.isEmpty()) {
                cacheManager.putProductList(cacheKey, products);
            }
        } catch (SQLException e) {
            logSQLError("tìm kiếm products với limit", e);
        }
        return products;
    }

    /**
     * Lọc sản phẩm theo giá (Cached)
     */
    @SuppressWarnings("unchecked")
    public List<Product> findByPriceRange(BigDecimal minPrice, BigDecimal maxPrice) {
        String cacheKey = CACHE_PREFIX + "_price_range_" + minPrice + "_" + maxPrice;
        
        Object cached = cacheManager.getProductList(cacheKey);
        if (cached != null) {
            logger.debug("Cache HIT for: {}", cacheKey);
            return (List<Product>) cached;
        }
        
        List<Product> products = new ArrayList<>();
        String sql = SELECT_COLUMNS_ACTIVE +
                     "FROM products p " +
                     "LEFT JOIN categories c ON p.category_id = c.id " +
                     "WHERE COALESCE(p.sale_price, p.price) BETWEEN ? AND ? " +
                     "AND p.is_active = TRUE " +
                     "ORDER BY COALESCE(p.sale_price, p.price)";
        
        Object[] params = {minPrice, maxPrice};
        
        try {
            products = executeQueryWithParams(sql, params, rs -> mapResultSetToProduct(rs, true));
            if (!products.isEmpty()) {
                cacheManager.putProductList(cacheKey, products);
            }
        } catch (SQLException e) {
            logSQLError("lọc products theo giá", e);
        }
        return products;
    }

    /**
     * Đếm tổng số sản phẩm active (Cached)
     */
    public int countAll() {
        String cacheKey = CACHE_PREFIX + "_count_all";
        
        Object cached = cacheManager.getProductList(cacheKey);
        if (cached != null) {
            logger.debug("Cache HIT for: {}", cacheKey);
            return (Integer) cached;
        }
        
        String sql = "SELECT COUNT(*) FROM products WHERE is_active = TRUE";
        
        try {
            int count = executeCountQuery(sql);
            cacheManager.putProductList(cacheKey, count);
            return count;
        } catch (SQLException e) {
            logSQLError("đếm products", e);
        }
        return 0;
    }

    /**
     * Lấy sản phẩm liên quan cùng category (Cached)
     */
    @SuppressWarnings("unchecked")
    public List<Product> findRelated(int productId, int categoryId, int limit) {
        String cacheKey = CACHE_PREFIX + "_related_" + productId + "_cat_" + categoryId + "_limit_" + limit;
        
        Object cached = cacheManager.getProductList(cacheKey);
        if (cached != null) {
            logger.debug("Cache HIT for: {}", cacheKey);
            return (List<Product>) cached;
        }
        
        List<Product> products = new ArrayList<>();
        String sql = SELECT_COLUMNS_ACTIVE +
                     "FROM products p " +
                     "LEFT JOIN categories c ON p.category_id = c.id " +
                     "WHERE p.category_id = ? AND p.id != ? AND p.is_active = TRUE " +
                     "ORDER BY RAND() LIMIT ?";
        
        Object[] params = {categoryId, productId, limit};
        
        try {
            products = executeQueryWithParams(sql, params, rs -> mapResultSetToProduct(rs, true));
            if (!products.isEmpty()) {
                cacheManager.putProductList(cacheKey, products);
            }
        } catch (SQLException e) {
            logSQLError("lấy related products", e);
        }
        return products;
    }

    /**
     * Đếm tổng số products bao gồm cả inactive (Cached)
     */
    public int getTotalProducts() {
        String cacheKey = CACHE_PREFIX + "_count_total";
        
        Object cached = cacheManager.getProductList(cacheKey);
        if (cached != null) {
            logger.debug("Cache HIT for: {}", cacheKey);
            return (Integer) cached;
        }
        
        String sql = "SELECT COUNT(*) FROM products";
        
        try {
            int count = executeCountQuery(sql);
            cacheManager.putProductList(cacheKey, count);
            return count;
        } catch (SQLException e) {
            logSQLError("đếm tổng products", e);
        }
        return 0;
    }

    /**
     * Lấy danh sách sản phẩm bán chạy nhất tính từ order_items (Cached)
     */
    @SuppressWarnings("unchecked")
    public List<Product> getTopSellingProducts(int limit) {
        String cacheKey = CACHE_PREFIX + "_topselling_aggregated_limit_" + limit;
        
        Object cached = cacheManager.getProductList(cacheKey);
        if (cached != null) {
            logger.debug("Cache HIT for: {}", cacheKey);
            return (List<Product>) cached;
        }
        
        List<Product> products = new ArrayList<>();
        String sql = SELECT_COLUMNS_ADMIN + ", COALESCE(SUM(oi.quantity), 0) as sold_count " +
                     "FROM products p " +
                     "LEFT JOIN categories c ON p.category_id = c.id " +
                     "LEFT JOIN order_items oi ON p.id = oi.product_id " +
                     "LEFT JOIN orders o ON oi.order_id = o.id " +
                     "WHERE o.order_status != 'cancelled' OR o.id IS NULL " +
                     "GROUP BY p.id " +
                     "ORDER BY sold_count DESC, p.created_at DESC " +
                     "LIMIT ?";
        
        Object[] params = {limit};
        
        try {
            products = executeQueryWithParams(sql, params, rs -> {
                Product product = mapResultSetToProduct(rs, true);
                product.setSoldCount(rs.getInt("sold_count"));
                return product;
            });
            if (!products.isEmpty()) {
                cacheManager.putProductList(cacheKey, products);
            }
        } catch (SQLException e) {
            logSQLError("lấy top selling products", e);
        }
        return products;
    }

    // ==========================================
    // 2. WRITE OPERATIONS (CACHE INVALIDATION)
    // ==========================================

    /**
     * Thêm sản phẩm mới (Xóa Cache)
     */
    public boolean insert(Product product) {
        String sql = "INSERT INTO products (category_id, name, slug, description, short_description, " +
                    "price, sale_price, quantity, image, images, is_featured, is_active) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        Object[] params = {
            product.getCategoryId() != null ? product.getCategoryId() : null,
            product.getName(),
            product.getSlug(),
            product.getDescription(),
            product.getShortDescription(),
            product.getPrice(),
            product.getSalePrice(),
            product.getQuantity(),
            product.getImage(),
            product.getImages(),
            product.isFeatured(),
            product.isActive()
        };
        
        try {
            long generatedId = executeInsertAndGetId(sql, params);
            if (generatedId > 0) {
                product.setId((int) generatedId);
                // Clear obsolete cache
                cacheManager.invalidateProductCache();
                logger.info("✓ Product inserted (ID: {}) and product cache invalidated", generatedId);
                return true;
            }
        } catch (SQLException e) {
            logSQLError("thêm product", e);
        }
        return false;
    }

    /**
     * Cập nhật sản phẩm (Xóa Cache)
     */
    public boolean update(Product product) {
        String sql = "UPDATE products SET category_id = ?, name = ?, slug = ?, description = ?, " +
                    "short_description = ?, price = ?, sale_price = ?, quantity = ?, image = ?, " +
                    "images = ?, is_featured = ?, is_active = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        
        Object[] params = {
            product.getCategoryId() != null ? product.getCategoryId() : null,
            product.getName(),
            product.getSlug(),
            product.getDescription(),
            product.getShortDescription(),
            product.getPrice(),
            product.getSalePrice(),
            product.getQuantity(),
            product.getImage(),
            product.getImages(),
            product.isFeatured(),
            product.isActive(),
            product.getId()
        };
        
        try {
            int rowsAffected = executeUpdateQuery(sql, params);
            if (rowsAffected > 0) {
                // Clear obsolete cache
                cacheManager.invalidateProductCache();
                logger.info("✓ Product updated (ID: {}) and product cache invalidated", product.getId());
                return true;
            }
        } catch (SQLException e) {
            logSQLError("cập nhật product", e);
        }
        return false;
    }

    /**
     * Xóa sản phẩm thật khỏi database (Xóa Cache)
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM products WHERE id = ?";
        Object[] params = {id};
        
        try {
            int rowsAffected = executeUpdateQuery(sql, params);
            if (rowsAffected > 0) {
                // Clear obsolete cache
                cacheManager.invalidateProductCache();
                logger.info("✓ Product deleted permanently (ID: {}) and product cache invalidated", id);
                return true;
            }
        } catch (SQLException e) {
            logSQLError("xóa product", e);
        }
        return false;
    }

    /**
     * Tăng view count (Không xóa cache để tránh cache churn)
     */
    public boolean incrementViewCount(int productId) {
        String sql = "UPDATE products SET view_count = view_count + 1 WHERE id = ?";
        Object[] params = {productId};
        
        try {
            int rowsAffected = executeUpdateQuery(sql, params);
            if (rowsAffected > 0) {
                // We deliberately DO NOT invalidate the entire product cache here
                // to prevent cache churning on detail views. Stale views in cache are completely fine.
                logger.debug("View count incremented for product ID: {}", productId);
                return true;
            }
        } catch (SQLException e) {
            logSQLError("tăng view count", e);
        }
        return false;
    }

    /**
     * Cập nhật số lượng đã bán (Xóa Cache)
     */
    public boolean updateSoldCount(int productId, int quantity) {
        String sql = "UPDATE products SET sold_count = sold_count + ?, quantity = quantity - ? WHERE id = ? AND quantity >= ?";
        Object[] params = {quantity, quantity, productId, quantity};
        
        try {
            int rowsAffected = executeUpdateQuery(sql, params);
            if (rowsAffected > 0) {
                // Clear obsolete cache since stock and sold counts changed
                cacheManager.invalidateProductCache();
                logger.info("✓ Stock and sold count updated for product ID: {} and cache invalidated", productId);
                return true;
            }
        } catch (SQLException e) {
            logSQLError("cập nhật sold count", e);
        }
        return false;
    }

    /**
     * Toggle trạng thái active của product (Xóa Cache)
     */
    public boolean toggleActive(int id) {
        String sql = "UPDATE products SET is_active = NOT is_active, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        Object[] params = {id};
        
        try {
            int rowsAffected = executeUpdateQuery(sql, params);
            if (rowsAffected > 0) {
                // Clear obsolete cache
                cacheManager.invalidateProductCache();
                logger.info("✓ Product active state toggled (ID: {}) and cache invalidated", id);
                return true;
            }
        } catch (SQLException e) {
            logSQLError("toggle active product", e);
        }
        return false;
    }

    // ==========================================
    // 3. PRIVATE HELPER METHODS
    // ==========================================

    /**
     * Map ResultSet sang Product object
     */
    private Product mapResultSetToProduct(ResultSet rs, boolean includeCategory) throws SQLException {
        Product product = new Product();
        product.setId(rs.getInt("id"));
        
        int categoryId = rs.getInt("category_id");
        product.setCategoryId(rs.wasNull() ? null : categoryId);
        
        product.setName(rs.getString("name"));
        product.setSlug(rs.getString("slug"));
        product.setDescription(rs.getString("description"));
        product.setShortDescription(rs.getString("short_description"));
        product.setPrice(rs.getBigDecimal("price"));
        product.setSalePrice(rs.getBigDecimal("sale_price"));
        product.setQuantity(rs.getInt("quantity"));
        product.setImage(rs.getString("image"));
        product.setImages(rs.getString("images"));
        product.setFeatured(rs.getBoolean("is_featured"));
        
        // Try mapping role or status parameters if they exist in query
        try {
            product.setActive(rs.getBoolean("is_active"));
        } catch (SQLException ignored) {}
        
        product.setViewCount(rs.getInt("view_count"));
        product.setSoldCount(rs.getInt("sold_count"));
        
        try {
            product.setAverageRating(rs.getBigDecimal("average_rating"));
            product.setReviewCount(rs.getInt("review_count"));
        } catch (SQLException ignored) {}
        
        try {
            product.setCreatedAt(rs.getTimestamp("created_at"));
            product.setUpdatedAt(rs.getTimestamp("updated_at"));
        } catch (SQLException ignored) {}
        
        if (includeCategory) {
            try {
                String categoryName = rs.getString("category_name");
                if (categoryName != null) {
                    Category category = new Category();
                    category.setId(categoryId);
                    category.setName(categoryName);
                    category.setSlug(rs.getString("category_slug"));
                    product.setCategory(category);
                }
            } catch (SQLException ignored) {}
        }
        
        return product;
    }

    /**
     * Execute parameterized query and return list of products
     */
    private List<Product> executeQueryWithParams(String sql, Object[] params, ResultSetMapper mapper) 
            throws SQLException {
        List<Product> results = new ArrayList<>();
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            setParameters(ps, params);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    results.add(mapper.map(rs));
                }
            }
        }
        return results;
    }

    /**
     * Execute raw SELECT query and return list of products
     */
    private List<Product> executeQuery(String sql, ResultSetMapper mapper) throws SQLException {
        List<Product> results = new ArrayList<>();
        
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                results.add(mapper.map(rs));
            }
        }
        return results;
    }

    @FunctionalInterface
    interface ResultSetMapper {
        Product map(ResultSet rs) throws SQLException;
    }
}
