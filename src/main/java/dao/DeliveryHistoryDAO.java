package dao;

import dto.shipping.ShippingQuoteResponse;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Timestamp;

public class DeliveryHistoryDAO extends BaseDAO {

    public void insert(String placeId, String formattedAddress, double lat, double lng, ShippingQuoteResponse quote,
                       String addressStatus, String reason, String clientIp, String userAgent) {
        String sql = "INSERT INTO delivery_history " +
                "(place_id, formatted_address, latitude, longitude, distance_km, fee, ghtk_fee, deliverable, shipping_status, address_status, reason, client_ip, user_agent, created_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, placeId);
            ps.setString(2, formattedAddress);
            ps.setDouble(3, lat);
            ps.setDouble(4, lng);
            ps.setDouble(5, quote != null ? quote.getDistanceKm() : 0d);
            ps.setBigDecimal(6, quote != null ? quote.getDisplayFee() : null);
            ps.setBigDecimal(7, quote != null ? quote.getGhtkFee() : null);
            if (quote != null) {
                ps.setBoolean(8, quote.isDeliverable());
            } else {
                ps.setNull(8, java.sql.Types.BOOLEAN);
            }
            ps.setString(9, quote != null && quote.isDeliverable() ? "quoted" : "rejected");
            ps.setString(10, addressStatus);
            ps.setString(11, reason);
            ps.setString(12, clientIp);
            ps.setString(13, userAgent);
            ps.setTimestamp(14, new Timestamp(System.currentTimeMillis()));
            ps.executeUpdate();
        } catch (Exception e) {
            logger.warn("Unable to insert delivery history", e);
        }
    }
}
