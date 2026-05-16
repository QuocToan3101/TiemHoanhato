package util;

public class GeoUtils {
    private static final double EARTH_RADIUS_KM = 6371.0;

    // Haversine formula to compute distance in kilometers
    public static double haversine(double lat1, double lon1, double lat2, double lon2) {
        double dLat = Math.toRadians(lat2 - lat1);
        double dLon = Math.toRadians(lon2 - lon1);
        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(dLon / 2) * Math.sin(dLon / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return EARTH_RADIUS_KM * c;
    }

    // Rough ETA minutes by assuming average speed (km/h)
    public static int estimateMinutes(double km, double avgKmph) {
        if (avgKmph <= 0) avgKmph = 30; // default
        double hours = km / avgKmph;
        return (int) Math.max(5, Math.round(hours * 60));
    }
}
