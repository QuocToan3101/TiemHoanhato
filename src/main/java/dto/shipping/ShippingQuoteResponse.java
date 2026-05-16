package dto.shipping;

import java.math.BigDecimal;

public class ShippingQuoteResponse {
    private boolean deliverable;
    private String message;
    private double distanceKm;
    private int etaMinutes;
    private BigDecimal displayFee;
    private BigDecimal estimatedFee;
    private BigDecimal ghtkFee;
    private boolean freeShipping;

    public boolean isDeliverable() { return deliverable; }
    public void setDeliverable(boolean deliverable) { this.deliverable = deliverable; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    public double getDistanceKm() { return distanceKm; }
    public void setDistanceKm(double distanceKm) { this.distanceKm = distanceKm; }
    public int getEtaMinutes() { return etaMinutes; }
    public void setEtaMinutes(int etaMinutes) { this.etaMinutes = etaMinutes; }
    public BigDecimal getDisplayFee() { return displayFee; }
    public void setDisplayFee(BigDecimal displayFee) { this.displayFee = displayFee; }
    public BigDecimal getEstimatedFee() { return estimatedFee; }
    public void setEstimatedFee(BigDecimal estimatedFee) { this.estimatedFee = estimatedFee; }
    public BigDecimal getGhtkFee() { return ghtkFee; }
    public void setGhtkFee(BigDecimal ghtkFee) { this.ghtkFee = ghtkFee; }
    public boolean isFreeShipping() { return freeShipping; }
    public void setFreeShipping(boolean freeShipping) { this.freeShipping = freeShipping; }
}
