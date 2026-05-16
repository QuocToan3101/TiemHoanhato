package model;

public class DeliveryZone {
    private Long id;
    private String name;
    private double maxKm;
    private boolean active = true;

    public DeliveryZone() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public double getMaxKm() { return maxKm; }
    public void setMaxKm(double maxKm) { this.maxKm = maxKm; }
    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
}
