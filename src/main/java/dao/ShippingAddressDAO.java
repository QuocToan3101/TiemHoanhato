package dao;

import model.ShippingAddress;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;

public class ShippingAddressDAO extends BaseDAO {

    public long insert(ShippingAddress addr) throws Exception {
        String sql = "INSERT INTO shipping_address (user_id, formatted_address, latitude, longitude, place_id, note, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
            if (addr.getUserId() == null) ps.setNull(1, java.sql.Types.BIGINT); else ps.setLong(1, addr.getUserId());
            ps.setString(2, addr.getFormattedAddress());
            ps.setDouble(3, addr.getLatitude());
            ps.setDouble(4, addr.getLongitude());
            ps.setString(5, addr.getPlaceId());
            ps.setString(6, addr.getNote());
            ps.setTimestamp(7, addr.getCreatedAt() == null ? new Timestamp(System.currentTimeMillis()) : addr.getCreatedAt());
            int affected = ps.executeUpdate();
            if (affected == 0) throw new Exception("Insert failed");
            try (ResultSet gk = ps.getGeneratedKeys()) {
                if (gk.next()) return gk.getLong(1);
            }
        }
        throw new Exception("No generated key");
    }
}
