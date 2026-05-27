package util;

/**
 * Tập hợp tất cả constants của ứng dụng
 * Tránh hard-coded strings và magic numbers
 * 
 * REFACTOR BENEFIT: 
 * - Single source of truth cho configuration
 * - Dễ maintain, dễ thay đổi
 * - Type-safe constants
 */
public final class Constants {
    
    // Prevent instantiation
    private Constants() {
        throw new AssertionError("Constants class cannot be instantiated");
    }
    
    // ============= DATABASE & QUERY CONSTANTS =============
    public static final class DB {
        public static final int QUERY_TIMEOUT = 30; // seconds
        public static final int DEFAULT_PAGE_SIZE = 20;
        public static final int MAX_PAGE_SIZE = 100;
        
        // Table names
        public static final String TABLE_PRODUCTS = "products";
        public static final String TABLE_CATEGORIES = "categories";
        public static final String TABLE_USERS = "users";
        public static final String TABLE_ORDERS = "orders";
        public static final String TABLE_CARTS = "carts";
        
        // Column names for optimized queries
        public static final class PRODUCTS {
            public static final String COLUMNS_ACTIVE = 
                "id, category_id, name, slug, description, short_description, " +
                "price, sale_price, quantity, image, images, is_featured, " +
                "view_count, sold_count, average_rating, review_count, created_at, updated_at";
            
            public static final String COLUMNS_ADMIN = 
                COLUMNS_ACTIVE + ", is_active";
            
            // Pre-built query with JOIN (N+1 fix)
            public static final String QUERY_ACTIVE = 
                "SELECT p.id, p.category_id, p.name, p.slug, p.description, " +
                "p.short_description, p.price, p.sale_price, p.quantity, " +
                "p.image, p.images, p.is_featured, p.view_count, p.sold_count, " +
                "p.average_rating, p.review_count, p.created_at, p.updated_at, " +
                "c.name as category_name, c.slug as category_slug " +
                "FROM products p " +
                "LEFT JOIN categories c ON p.category_id = c.id " +
                "WHERE p.is_active = TRUE";
        }
        
        public static final class CATEGORIES {
            public static final String COLUMNS = 
                "id, name, slug, description, image, parent_id, display_order, is_active";
            
            public static final String COLUMNS_ADMIN = 
                COLUMNS + ", created_at, updated_at";
        }
        
        public static final class USERS {
            public static final String COLUMNS = 
                "id, email, fullname, phone, avatar, role, status";
            
            public static final String COLUMNS_ADMIN = 
                COLUMNS + ", created_at, updated_at";
        }
        
        public static final class ORDERS {
            public static final String COLUMNS = 
                "id, order_code, user_id, receiver_name, receiver_phone, receiver_email, " +
                "shipping_address, note, subtotal, shipping_fee, discount, total, " +
                "payment_method, payment_status, order_status, created_at";
            
            public static final String COLUMNS_ADMIN = 
                COLUMNS + ", cancelled_reason, delivered_at, updated_at";
        }
    }
    
    // ============= BUSINESS LOGIC CONSTANTS =============
    public static final class BUSINESS {
        public static final int MAX_CART_ITEMS = 999;
        public static final int MIN_ORDER_AMOUNT = 0;
        public static final int DEFAULT_SHIPPING_FEE = 0;
        public static final long SESSION_TIMEOUT = 3600000; // 1 hour in milliseconds
        public static final long PASSWORD_RESET_EXPIRY = 3600000; // 1 hour
        public static final int MAX_LOGIN_ATTEMPTS = 5;
        public static final long LOCK_TIME_AFTER_FAILED_ATTEMPTS = 900000; // 15 minutes
    }
    
    // ============= HTTP & RESPONSE CONSTANTS =============
    public static final class HTTP {
        public static final String CONTENT_TYPE_JSON = "application/json";
        public static final String CONTENT_TYPE_HTML = "text/html";
        public static final String CONTENT_TYPE_FORM = "application/x-www-form-urlencoded";
        public static final String CHARSET = "UTF-8";
        public static final String HEADER_CSRF = "X-CSRF-Token";
        public static final int STATUS_OK = 200;
        public static final int STATUS_CREATED = 201;
        public static final int STATUS_BAD_REQUEST = 400;
        public static final int STATUS_UNAUTHORIZED = 401;
        public static final int STATUS_FORBIDDEN = 403;
        public static final int STATUS_NOT_FOUND = 404;
        public static final int STATUS_CONFLICT = 409;
        public static final int STATUS_INTERNAL_ERROR = 500;
    }
    
    // ============= ERROR MESSAGES =============
    public static final class ERRORS {
        public static final String PRODUCT_NOT_FOUND = "Sản phẩm không tồn tại hoặc đã ngừng bán";
        public static final String PRODUCT_OUT_OF_STOCK = "Sản phẩm đã hết hàng";
        public static final String INVALID_QUANTITY = "Số lượng không hợp lệ";
        public static final String QUANTITY_EXCEEDED = "Số lượng vượt quá tồn kho hiện có";
        public static final String CART_EMPTY = "Giỏ hàng trống";
        public static final String USER_NOT_FOUND = "Người dùng không tồn tại";
        public static final String USER_ALREADY_EXISTS = "Email đã được đăng ký";
        public static final String INVALID_EMAIL = "Email không hợp lệ";
        public static final String INVALID_PASSWORD = "Mật khẩu không hợp lệ";
        public static final String ORDER_NOT_FOUND = "Đơn hàng không tồn tại";
        public static final String DATABASE_ERROR = "Lỗi cơ sở dữ liệu";
        public static final String SESSION_EXPIRED = "Phiên làm việc đã hết hạn";
        public static final String INVALID_TOKEN = "Token không hợp lệ hoặc đã hết hạn";
        public static final String UNAUTHORIZED_ACTION = "Bạn không có quyền thực hiện hành động này";
        public static final String COUPON_NOT_FOUND = "Mã giảm giá không tồn tại";
        public static final String COUPON_EXPIRED = "Mã giảm giá đã hết hạn";
        public static final String COUPON_INVALID = "Mã giảm giá không hợp lệ";
        public static final String CATEGORY_NOT_FOUND = "Danh mục không tồn tại";
        public static final String ADDRESS_NOT_FOUND = "Địa chỉ không tồn tại";
    }
    
    // ============= SUCCESS MESSAGES =============
    public static final class SUCCESS {
        public static final String PRODUCT_ADDED_TO_CART = "Đã thêm vào giỏ hàng";
        public static final String CART_UPDATED = "Giỏ hàng đã được cập nhật";
        public static final String CART_CLEARED = "Giỏ hàng đã được xóa";
        public static final String ORDER_CREATED = "Đơn hàng đã được tạo";
        public static final String ORDER_STATUS_UPDATED = "Trạng thái đơn hàng đã được cập nhật";
        public static final String PRODUCT_UPDATED = "Sản phẩm đã được cập nhật";
        public static final String USER_REGISTERED = "Đăng ký thành công";
        public static final String LOGIN_SUCCESS = "Đăng nhập thành công";
        public static final String PASSWORD_RESET = "Mật khẩu đã được đặt lại";
        public static final String PROFILE_UPDATED = "Hồ sơ đã được cập nhật";
    }
    
    // ============= CACHE CONSTANTS =============
    public static final class CACHE {
        public static final long EXPIRY_PRODUCTS = 3600; // 1 hour in seconds
        public static final long EXPIRY_CATEGORIES = 7200; // 2 hours
        public static final long EXPIRY_COUPONS = 1800; // 30 minutes
        public static final long EXPIRY_USERS = 1800; // 30 minutes
        public static final int MAX_SIZE = 1000;
        public static final int MAX_SIZE_SMALL = 100;
    }
    
    // ============= ORDER STATUS =============
    public static final class ORDER_STATUS {
        public static final String PENDING = "pending";
        public static final String CONFIRMED = "confirmed";
        public static final String PROCESSING = "processing";
        public static final String SHIPPING = "shipping";
        public static final String DELIVERED = "delivered";
        public static final String CANCELLED = "cancelled";
        
        public static final String[] ALL = {PENDING, CONFIRMED, PROCESSING, SHIPPING, DELIVERED, CANCELLED};
    }
    
    // ============= PAYMENT STATUS =============
    public static final class PAYMENT_STATUS {
        public static final String PENDING = "pending";
        public static final String PAID = "paid";
        public static final String FAILED = "failed";
        public static final String REFUNDED = "refunded";
        
        public static final String[] ALL = {PENDING, PAID, FAILED, REFUNDED};
    }
    
    // ============= PAYMENT METHODS =============
    public static final class PAYMENT_METHOD {
        public static final String COD = "cod";
        public static final String BANK_TRANSFER = "bank_transfer";
        public static final String VNPAY = "vnpay";
        
        public static final String[] ACTIVE = {COD, BANK_TRANSFER, VNPAY};
    }
    
    // ============= USER ROLES =============
    public static final class USER_ROLE {
        public static final String CUSTOMER = "customer";
        public static final String ADMIN = "admin";
    }
    
    // ============= USER STATUS =============
    public static final class USER_STATUS {
        public static final String PENDING = "pending";
        public static final String ACTIVE = "active";
        public static final String INACTIVE = "inactive";
        public static final String BANNED = "banned";
    }
    
    // ============= REGEX PATTERNS =============
    public static final class REGEX {
        public static final String EMAIL = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";
        public static final String PHONE = "^[0-9]{10,11}$";
        public static final String SLUG = "^[a-z0-9]+(?:-[a-z0-9]+)*$";
        public static final String PASSWORD = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$";
    }
}
