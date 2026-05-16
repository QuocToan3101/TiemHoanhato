package dao;

import model.DeliveryZone;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DeliveryZoneDAO extends BaseDAO {

    public DeliveryZone findActiveZoneForDistance(double km) {
        String sql = "SELECT id, name, max_km, active FROM delivery_zone WHERE active = true AND max_km >= ? ORDER BY max_km ASC LIMIT 1";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDouble(1, km);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                DeliveryZone z = new DeliveryZone();
                z.setId(rs.getLong("id"));
                z.setName(rs.getString("name"));
                z.setMaxKm(rs.getDouble("max_km"));
                z.setActive(rs.getBoolean("active"));
                return z;
            }
        } catch (Exception e) {
            logger.error("Error fetching delivery zone", e);
        }
        return null;
    }
}
