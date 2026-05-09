package dao;

import model.ShippingFeeRule;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.math.BigDecimal;
import java.sql.Timestamp;

public class ShippingFeeRuleDAO extends BaseDAO {

    public java.util.Optional<ShippingFeeRule> getActiveRule() {
        String sql = "SELECT id, name, base_fee, per_km_fee, free_over_amount, peak_start_hour, peak_end_hour, peak_surcharge, active FROM shipping_fee_rule WHERE active = true ORDER BY id DESC LIMIT 1";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                ShippingFeeRule r = new ShippingFeeRule();
                r.setId(rs.getLong("id"));
                r.setName(rs.getString("name"));
                r.setBaseFee(rs.getBigDecimal("base_fee"));
                r.setPerKmFee(rs.getBigDecimal("per_km_fee"));
                r.setFreeOverAmount(rs.getBigDecimal("free_over_amount"));
                int psHour = rs.getInt("peak_start_hour"); if (!rs.wasNull()) r.setPeakStartHour(psHour);
                int peHour = rs.getInt("peak_end_hour"); if (!rs.wasNull()) r.setPeakEndHour(peHour);
                r.setPeakSurcharge(rs.getBigDecimal("peak_surcharge"));
                r.setActive(rs.getBoolean("active"));
                return java.util.Optional.of(r);
            }
        } catch (Exception e) {
            logger.error("Error fetching shipping fee rule", e);
        }
        return java.util.Optional.empty();
    }
}
