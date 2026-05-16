package dto.shipping;

public class AddressSuggestion {
    private String placeId;
    private String displayName;
    private double lat;
    private double lon;
    private String countryCode;
    private String province;
    private String district;
    private String ward;
    private String street;
    private String osmType;
    private long osmId;

    public String getPlaceId() { return placeId; }
    public void setPlaceId(String placeId) { this.placeId = placeId; }
    public String getDisplayName() { return displayName; }
    public void setDisplayName(String displayName) { this.displayName = displayName; }
    public double getLat() { return lat; }
    public void setLat(double lat) { this.lat = lat; }
    public double getLon() { return lon; }
    public void setLon(double lon) { this.lon = lon; }
    public String getCountryCode() { return countryCode; }
    public void setCountryCode(String countryCode) { this.countryCode = countryCode; }
    public String getProvince() { return province; }
    public void setProvince(String province) { this.province = province; }
    public String getDistrict() { return district; }
    public void setDistrict(String district) { this.district = district; }
    public String getWard() { return ward; }
    public void setWard(String ward) { this.ward = ward; }
    public String getStreet() { return street; }
    public void setStreet(String street) { this.street = street; }
    public String getOsmType() { return osmType; }
    public void setOsmType(String osmType) { this.osmType = osmType; }
    public long getOsmId() { return osmId; }
    public void setOsmId(long osmId) { this.osmId = osmId; }
}
