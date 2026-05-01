package service;

import dao.CartDAO;
import dao.ProductDAO;
import model.CartItem;
import model.CartOperationResult;
import model.Product;
import model.SessionCartItem;

import javax.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * Service layer for cart business logic supporting both guest and logged-in users.
 */
public class CartService {
    public static final String SESSION_CART_KEY = "cart";

    private final CartDAO cartDAO;
    private final ProductDAO productDAO;

    public CartService() {
        this.cartDAO = new CartDAO();
        this.productDAO = new ProductDAO();
    }

    public List<CartItem> getUserCartItems(int userId) {
        return cartDAO.findByUserId(userId);
    }

    @SuppressWarnings("unchecked")
    public List<SessionCartItem> getSessionCartItems(HttpSession session) {
        if (session == null) {
            return new ArrayList<>();
        }
        Object raw = session.getAttribute(SESSION_CART_KEY);
        if (raw instanceof List<?>) {
            try {
                return (List<SessionCartItem>) raw;
            } catch (ClassCastException ex) {
                return new ArrayList<>();
            }
        }
        return new ArrayList<>();
    }

    public CartOperationResult addToCart(HttpSession session, Integer userId, int productId, int quantity) {
        int safeQuantity = Math.max(1, quantity);
        Product product = productDAO.findById(productId);

        if (product == null || !product.isActive()) {
            return new CartOperationResult(false, "Sản phẩm không tồn tại hoặc đã ngừng bán");
        }

        if (product.getQuantity() <= 0) {
            return new CartOperationResult(false, "Sản phẩm đã hết hàng");
        }

        if (userId != null) {
            int currentQty = cartDAO.getCurrentQuantity(userId, productId);
            if (currentQty + safeQuantity > product.getQuantity()) {
                return new CartOperationResult(false, "Số lượng vượt quá tồn kho hiện có");
            }

            boolean success = cartDAO.addToCart(userId, productId, safeQuantity);
            if (!success) {
                return new CartOperationResult(false, "Không thể thêm vào giỏ hàng");
            }

            return buildDbResult(userId, "Đã thêm vào giỏ hàng");
        }

        if (session == null) {
            return new CartOperationResult(false, "Phiên làm việc đã hết hạn");
        }

        List<SessionCartItem> items = getSessionCartItems(session);
        SessionCartItem existing = findSessionItem(items, productId);
        int newQuantity = safeQuantity;

        if (existing != null) {
            newQuantity = existing.getQuantity() + safeQuantity;
        }

        if (newQuantity > product.getQuantity()) {
            return new CartOperationResult(false, "Số lượng vượt quá tồn kho hiện có");
        }

        if (existing == null) {
            SessionCartItem newItem = new SessionCartItem(
                product.getId(),
                product.getName(),
                product.getDisplayPrice(),
                safeQuantity,
                product.getImage()
            );
            items.add(newItem);
        } else {
            existing.setQuantity(newQuantity);
            existing.setPrice(product.getDisplayPrice());
            existing.setName(product.getName());
            existing.setImage(product.getImage());
        }

        session.setAttribute(SESSION_CART_KEY, items);
        return buildSessionResult(items, "Đã thêm vào giỏ hàng");
    }

    public CartOperationResult updateQuantity(HttpSession session, Integer userId, int productId, int quantity) {
        if (quantity < 0) {
            return new CartOperationResult(false, "Số lượng không hợp lệ");
        }

        Product product = productDAO.findById(productId);
        if (product == null || !product.isActive()) {
            return new CartOperationResult(false, "Sản phẩm không tồn tại hoặc đã ngừng bán");
        }

        if (userId != null) {
            boolean success;
            if (quantity == 0) {
                success = cartDAO.removeFromCart(userId, productId);
            } else {
                if (quantity > product.getQuantity()) {
                    return new CartOperationResult(false, "Số lượng vượt quá tồn kho hiện có");
                }
                success = cartDAO.updateQuantity(userId, productId, quantity);
            }

            if (!success && quantity != 0) {
                return new CartOperationResult(false, "Không thể cập nhật giỏ hàng");
            }
            return buildDbResult(userId, "Đã cập nhật giỏ hàng");
        }

        if (session == null) {
            return new CartOperationResult(false, "Phiên làm việc đã hết hạn");
        }

        List<SessionCartItem> items = getSessionCartItems(session);
        SessionCartItem existing = findSessionItem(items, productId);

        if (existing == null) {
            return buildSessionResult(items, "Sản phẩm không tồn tại trong giỏ");
        }

        if (quantity == 0) {
            items.remove(existing);
        } else {
            if (quantity > product.getQuantity()) {
                return new CartOperationResult(false, "Số lượng vượt quá tồn kho hiện có");
            }
            existing.setQuantity(quantity);
            existing.setPrice(product.getDisplayPrice());
        }

        session.setAttribute(SESSION_CART_KEY, items);
        return buildSessionResult(items, "Đã cập nhật giỏ hàng");
    }

    public CartOperationResult removeFromCart(HttpSession session, Integer userId, int productId) {
        if (userId != null) {
            cartDAO.removeFromCart(userId, productId);
            return buildDbResult(userId, "Đã xóa khỏi giỏ hàng");
        }

        if (session == null) {
            return new CartOperationResult(false, "Phiên làm việc đã hết hạn");
        }

        List<SessionCartItem> items = getSessionCartItems(session);
        SessionCartItem existing = findSessionItem(items, productId);
        if (existing != null) {
            items.remove(existing);
            session.setAttribute(SESSION_CART_KEY, items);
        }
        return buildSessionResult(items, "Đã xóa khỏi giỏ hàng");
    }

    public CartOperationResult clearCart(HttpSession session, Integer userId) {
        if (userId != null) {
            boolean success = cartDAO.clearCart(userId);
            if (!success) {
                return new CartOperationResult(false, "Không thể xóa giỏ hàng");
            }
            return new CartOperationResult(true, "Đã xóa giỏ hàng", 0, BigDecimal.ZERO);
        }

        if (session != null) {
            session.removeAttribute(SESSION_CART_KEY);
        }
        return new CartOperationResult(true, "Đã xóa giỏ hàng", 0, BigDecimal.ZERO);
    }

    public void mergeSessionCartToDb(HttpSession session, int userId) {
        if (session == null) {
            return;
        }

        List<SessionCartItem> items = getSessionCartItems(session);
        if (items.isEmpty()) {
            return;
        }

        for (SessionCartItem item : items) {
            if (item == null || item.getProductId() <= 0 || item.getQuantity() <= 0) {
                continue;
            }

            Product product = productDAO.findById(item.getProductId());
            if (product == null || !product.isActive() || product.getQuantity() <= 0) {
                continue;
            }

            int currentQty = cartDAO.getCurrentQuantity(userId, item.getProductId());
            int mergedQty = Math.min(currentQty + item.getQuantity(), product.getQuantity());

            if (mergedQty <= 0) {
                continue;
            }

            if (currentQty > 0) {
                cartDAO.updateQuantity(userId, item.getProductId(), mergedQty);
            } else {
                cartDAO.addToCart(userId, item.getProductId(), mergedQty);
            }
        }

        session.removeAttribute(SESSION_CART_KEY);
    }

    private CartOperationResult buildDbResult(int userId, String message) {
        List<CartItem> cartItems = cartDAO.findByUserId(userId);
        BigDecimal total = BigDecimal.ZERO;
        int count = 0;

        for (CartItem item : cartItems) {
            total = total.add(item.getSubtotal());
            count += item.getQuantity();
        }

        return new CartOperationResult(true, message, count, total);
    }

    private CartOperationResult buildSessionResult(List<SessionCartItem> items, String message) {
        BigDecimal total = BigDecimal.ZERO;
        int count = 0;

        for (SessionCartItem item : items) {
            if (item == null) {
                continue;
            }
            total = total.add(item.getSubtotal());
            count += Math.max(0, item.getQuantity());
        }

        return new CartOperationResult(true, message, count, total);
    }

    private SessionCartItem findSessionItem(List<SessionCartItem> items, int productId) {
        for (SessionCartItem item : items) {
            if (item != null && item.getProductId() == productId) {
                return item;
            }
        }
        return null;
    }
}
