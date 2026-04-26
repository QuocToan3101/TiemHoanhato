package controller;

import com.google.gson.Gson;
import dao.ProductDAO;
import model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/api/carousel-images")
public class ImageCarouselServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        
        try {
            ProductDAO productDAO = new ProductDAO();
            // Ưu tiên sản phẩm nổi bật cho hero-card, fallback sang sản phẩm mới.
            List<Product> sourceProducts = productDAO.findFeatured(8);
            if (sourceProducts == null || sourceProducts.isEmpty()) {
                sourceProducts = productDAO.findLatest(8);
            }
            
            List<CarouselImage> carouselImages = new ArrayList<>();
            
            // Lọc các sản phẩm có hình ảnh
            for (Product product : sourceProducts) {
                if (product.getImage() != null && !product.getImage().isEmpty()) {
                    CarouselImage img = new CarouselImage();
                    img.setUrl(product.getImage());
                    img.setTitle(product.getName());
                    img.setProductId(product.getId());
                    img.setSlug(product.getSlug());
                    img.setDisplayPrice(product.getFormattedDisplayPrice());
                    carouselImages.add(img);
                }
            }
            
            // Lấy 5-8 hình ảnh ngẫu nhiên
            int limit = Math.min(8, carouselImages.size());
            if (limit > 0) {
                carouselImages = carouselImages.subList(0, limit);
            }
            
            // Set cache headers - cache 24 hours for carousel images
            response.setHeader("Cache-Control", "public, max-age=86400, immutable");
            response.setHeader("Expires", String.valueOf(System.currentTimeMillis() + 86400000L));
            
            // Trả về JSON
            Gson gson = new Gson();
            response.getWriter().write(gson.toJson(carouselImages));
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
    
    // Inner class để biểu diễn hình ảnh carousel
    public static class CarouselImage {
        private String url;
        private String title;
        private int productId;
        private String slug;
        private String displayPrice;
        
        public String getUrl() {
            return url;
        }
        
        public void setUrl(String url) {
            this.url = url;
        }
        
        public String getTitle() {
            return title;
        }
        
        public void setTitle(String title) {
            this.title = title;
        }
        
        public int getProductId() {
            return productId;
        }
        
        public void setProductId(int productId) {
            this.productId = productId;
        }

        public String getSlug() {
            return slug;
        }

        public void setSlug(String slug) {
            this.slug = slug;
        }

        public String getDisplayPrice() {
            return displayPrice;
        }

        public void setDisplayPrice(String displayPrice) {
            this.displayPrice = displayPrice;
        }
    }
}
