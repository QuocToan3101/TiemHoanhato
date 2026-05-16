package model;

import java.math.BigDecimal;

public class ShippingFeeRule {
    private Long id;
    private String name;
    private BigDecimal baseFee;
    private BigDecimal perKmFee;
    private BigDecimal freeOverAmount; // nullable
    private Integer peakStartHour; // 24h
    private Integer peakEndHour;
    private BigDecimal peakSurcharge;
    private boolean active = true;

    public ShippingFeeRule() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public BigDecimal getBaseFee() { return baseFee; }
    public void setBaseFee(BigDecimal baseFee) { this.baseFee = baseFee; }
    public BigDecimal getPerKmFee() { return perKmFee; }
    public void setPerKmFee(BigDecimal perKmFee) { this.perKmFee = perKmFee; }
    public BigDecimal getFreeOverAmount() { return freeOverAmount; }
    public void setFreeOverAmount(BigDecimal freeOverAmount) { this.freeOverAmount = freeOverAmount; }
    public Integer getPeakStartHour() { return peakStartHour; }
    public void setPeakStartHour(Integer peakStartHour) { this.peakStartHour = peakStartHour; }
    public Integer getPeakEndHour() { return peakEndHour; }
    public void setPeakEndHour(Integer peakEndHour) { this.peakEndHour = peakEndHour; }
    public BigDecimal getPeakSurcharge() { return peakSurcharge; }
    public void setPeakSurcharge(BigDecimal peakSurcharge) { this.peakSurcharge = peakSurcharge; }
    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
}
