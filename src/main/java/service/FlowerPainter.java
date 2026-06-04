package service;

/**
 * Premium SVG Vector Flower Artist
 * Generates highly artistic, sharp SVG vector coordinates for rose, tulip, sunflower, etc.
 * Designed to scale cleanly to any resolution on the A6/SVG canvas.
 */
public class FlowerPainter {

    private static FlowerPainter instance;

    private FlowerPainter() {}

    public static synchronized FlowerPainter getInstance() {
        if (instance == null) {
            instance = new FlowerPainter();
        }
        return instance;
    }

    /**
     * Generates SVG group for a specific flower type centered at (0, 0)
     */
    public String getFlowerSvg(String flowerType, String themeColor, String themeBorderColor) {
        StringBuilder svg = new StringBuilder();
        
        // Color defaults if not specified
        String mainColor = themeColor != null ? themeColor : "#C97B84";
        String strokeColor = themeBorderColor != null ? themeBorderColor : "#632d34";
        String leafColor = "#88B04B";
        String leafStroke = "#4A6B22";

        switch (flowerType.toLowerCase().trim()) {
            case "rose":
                svg.append("<!-- Rose Art -->");
                svg.append("<g>");
                // Stem & Leaves
                svg.append("<path d='M0,0 Q10,50 0,100' fill='none' stroke='").append(leafStroke).append("' stroke-width='4' stroke-linecap='round'/>");
                svg.append("<path d='M0,40 C-20,30 -30,50 -10,60 C-5,50 -2,45 0,40' fill='").append(leafColor).append("' stroke='").append(leafStroke).append("' stroke-width='2'/>");
                svg.append("<path d='M0,60 C20,50 30,70 10,80 C5,70 2,65 0,60' fill='").append(leafColor).append("' stroke='").append(leafStroke).append("' stroke-width='2'/>");
                // Rose Petals (detailed layered curves)
                svg.append("<path d='M-30,-20 C-50,-40 -10,-60 0,-40 C10,-60 50,-40 30,-20 C50,10 0,50 -30,-20 Z' fill='").append(mainColor).append("' stroke='").append(strokeColor).append("' stroke-width='3'/>");
                svg.append("<path d='M-20,-15 C-35,-25 -10,-40 0,-25 C10,-40 35,-25 20,-15 C30,5 0,30 -20,-15 Z' fill='none' stroke='").append(strokeColor).append("' stroke-width='2'/>");
                svg.append("<path d='M-10,-10 C-15,-15 0,-25 0,-15 C0,-25 15,-15 10,-10 C15,0 0,15 -10,-10 Z' fill='none' stroke='").append(strokeColor).append("' stroke-width='2'/>");
                svg.append("</g>");
                break;

            case "red_rose":
                svg.append("<!-- Red Rose Art -->");
                svg.append("<g>");
                svg.append("<path d='M0,0 Q-10,50 0,100' fill='none' stroke='").append(leafStroke).append("' stroke-width='4' />");
                svg.append("<path d='M0,45 C-25,35 -30,55 -15,65 Z' fill='").append(leafColor).append("' stroke='").append(leafStroke).append("' stroke-width='2'/>");
                svg.append("<path d='M-40,-30 C-60,-50 -20,-70 0,-50 C20,-70 60,-50 40,-30 C60,0 0,40 -40,-30 Z' fill='#C92A2A' stroke='#5c0e0e' stroke-width='3.5'/>");
                svg.append("<path d='M-25,-20 C-40,-35 -10,-50 0,-35 C10,-50 40,-35 25,-20 C35,0 0,25 -25,-20 Z' fill='#E03131' stroke='#5c0e0e' stroke-width='2'/>");
                svg.append("<circle cx='0' cy='-35' r='8' fill='#FF8787' />");
                svg.append("</g>");
                break;

            case "tulip":
                svg.append("<!-- Tulip Art -->");
                svg.append("<g>");
                svg.append("<path d='M0,0 Q-5,60 0,110' fill='none' stroke='").append(leafStroke).append("' stroke-width='4'/>");
                svg.append("<path d='M0,60 C-30,40 -20,10 -5,20 C-5,50 -2,55 0,60' fill='").append(leafColor).append("' stroke='").append(leafStroke).append("' stroke-width='2'/>");
                // Tulip Cup petals
                svg.append("<path d='M-25,-30 C-35,-5 25,-5 15,-30 C5,-55 -25,-55 -25,-30' fill='").append(mainColor).append("' stroke='").append(strokeColor).append("' stroke-width='3'/>");
                svg.append("<path d='M-25,-30 C-10,-50 10,-50 25,-30 C15,0 -15,0 -25,-30' fill='").append(mainColor).append("' opacity='0.9' stroke='").append(strokeColor).append("' stroke-width='2.5'/>");
                svg.append("<path d='M-10,-35 C-5,-55 5,-55 10,-35 C5,-10 -5,-10 -10,-35' fill='").append(mainColor).append("' opacity='0.95' stroke='").append(strokeColor).append("' stroke-width='2'/>");
                svg.append("</g>");
                break;

            case "sunflower":
                svg.append("<!-- Sunflower Art -->");
                svg.append("<g>");
                svg.append("<path d='M0,0 L0,100' fill='none' stroke='").append(leafStroke).append("' stroke-width='5'/>");
                // Petals rotation
                for (int i = 0; i < 16; i++) {
                    double angle = i * (360.0 / 16.0);
                    svg.append("<path d='M0,-20 C-10,-55 10,-55 0,-20' fill='#FFD95A' stroke='#E29578' stroke-width='1.5' transform='rotate(").append(angle).append(")'/>");
                    svg.append("<path d='M0,-20 C-7,-40 7,-40 0,-20' fill='#FFAD33' transform='rotate(").append(angle + 11.25).append(")'/>");
                }
                // Center Seed Disc
                svg.append("<circle cx='0' cy='0' r='25' fill='#5C3D2E' stroke='#3E2723' stroke-width='3'/>");
                svg.append("<circle cx='0' cy='0' r='18' fill='#3E2723' stroke='#271206' stroke-dasharray='3,3' stroke-width='2'/>");
                svg.append("</g>");
                break;

            case "baby_flower":
                svg.append("<!-- Baby Flower (Gypsophila) -->");
                svg.append("<g>");
                // Stems
                svg.append("<path d='M0,100 Q10,50 0,0' fill='none' stroke='").append(leafStroke).append("' stroke-width='3'/>");
                svg.append("<path d='M3,50 Q40,20 30,-20' fill='none' stroke='").append(leafStroke).append("' stroke-width='2'/>");
                svg.append("<path d='M-3,60 Q-40,30 -20,-10' fill='none' stroke='").append(leafStroke).append("' stroke-width='2'/>");
                // Scattered little blossoms
                String[] points = {"0,0", "30,-20", "-20,-10", "15,20", "-10,30", "25,10", "-25,15", "5,-25", "-8,-30"};
                for (String p : points) {
                    String[] xy = p.split(",");
                    svg.append("<g transform='translate(").append(xy[0]).append(",").append(xy[1]).append(")'>");
                    svg.append("<circle cx='0' cy='0' r='8' fill='#FFFFFF' stroke='").append(strokeColor).append("' stroke-width='1.5'/>");
                    svg.append("<circle cx='0' cy='0' r='2' fill='#D4AF37'/>");
                    svg.append("</g>");
                }
                svg.append("</g>");
                break;

            case "carnation":
                svg.append("<!-- Carnation Art -->");
                svg.append("<g>");
                svg.append("<path d='M0,0 C5,40 -5,70 0,100' fill='none' stroke='").append(leafStroke).append("' stroke-width='3.5'/>");
                // Jagged layered circles using polygons
                for (int layer = 3; layer >= 1; layer--) {
                    double r = layer * 15.0;
                    svg.append("<path d='");
                    for (int i = 0; i < 24; i++) {
                        double angle = Math.toRadians(i * (360.0 / 24.0));
                        double offset = (i % 2 == 0) ? r : r - 6;
                        double x = Math.cos(angle) * offset;
                        double y = Math.sin(angle) * offset;
                        if (i == 0) {
                            svg.append("M").append(x).append(",").append(y - 20);
                        } else {
                            svg.append(" L").append(x).append(",").append(y - 20);
                        }
                    }
                    svg.append(" Z' fill='").append(mainColor).append("' stroke='").append(strokeColor).append("' stroke-width='2' opacity='").append(1.0 - (layer * 0.1)).append("'/>");
                }
                svg.append("</g>");
                break;

            case "peony":
                svg.append("<!-- Peony Art -->");
                svg.append("<g>");
                svg.append("<path d='M0,0 Q-10,60 0,105' fill='none' stroke='").append(leafStroke).append("' stroke-width='4'/>");
                // Outer large petals
                for (int i = 0; i < 8; i++) {
                    double angle = i * 45;
                    svg.append("<path d='M0,-25 C-30,-65 30,-65 0,-25' fill='").append(mainColor).append("' opacity='0.7' stroke='").append(strokeColor).append("' stroke-width='2' transform='rotate(").append(angle).append(")'/>");
                }
                // Middle layers
                for (int i = 0; i < 6; i++) {
                    double angle = i * 60 + 30;
                    svg.append("<path d='M0,-25 C-20,-50 20,-50 0,-25' fill='").append(mainColor).append("' opacity='0.85' stroke='").append(strokeColor).append("' stroke-width='1.5' transform='rotate(").append(angle).append(")'/>");
                }
                // Golden center
                svg.append("<circle cx='0' cy='-25' r='10' fill='#FFD95A' stroke='#F4B400' stroke-width='1'/>");
                svg.append("</g>");
                break;

            case "hydrangea":
                svg.append("<!-- Hydrangea Art -->");
                svg.append("<g>");
                svg.append("<path d='M0,0 Q10,50 0,100' fill='none' stroke='").append(leafStroke).append("' stroke-width='4'/>");
                svg.append("<circle cx='0' cy='0' r='50' fill='").append(mainColor).append("' opacity='0.25' stroke='none'/>");
                
                // Cluster of 4-petaled flowers
                String[] coords = {
                    "0,-20", "-20,-10", "20,-10", "-10,15", "10,15", 
                    "-25,-30", "25,-30", "0,-40", "-35,0", "35,0", 
                    "-20,30", "20,30", "0,40"
                };
                for (String c : coords) {
                    String[] xy = c.split(",");
                    svg.append("<g transform='translate(").append(xy[0]).append(",").append(xy[1]).append(") scale(0.6)'>");
                    // 4 petals
                    svg.append("<path d='M0,0 C-15,-15 -15,15 0,0 C15,15 15,-15 0,0' fill='").append(mainColor).append("' stroke='").append(strokeColor).append("' stroke-width='2'/>");
                    svg.append("<path d='M0,0 C-15,15 15,15 0,0 C-15,-15 15,-15 0,0' fill='").append(mainColor).append("' stroke='").append(strokeColor).append("' stroke-width='2'/>");
                    svg.append("<circle cx='0' cy='0' r='3' fill='#FFFFFF'/>");
                    svg.append("</g>");
                }
                svg.append("</g>");
                break;

            case "sunflower_eucalyptus":
                svg.append("<!-- Sunflower with Eucalyptus leaves -->");
                svg.append("<g>");
                // Eucalyptus branch under the sunflower
                svg.append("<path d='M-40,80 Q20,20 60,-40' fill='none' stroke='#8FA597' stroke-width='3.5'/>");
                svg.append("<circle cx='-20' cy='60' r='12' fill='#B2C2B9' stroke='#8FA597' stroke-width='1.5'/>");
                svg.append("<circle cx='5' cy='35' r='14' fill='#B2C2B9' stroke='#8FA597' stroke-width='1.5'/>");
                svg.append("<circle cx='35' cy='10' r='12' fill='#B2C2B9' stroke='#8FA597' stroke-width='1.5'/>");
                
                // Sunflower stem
                svg.append("<path d='M0,0 Q-10,50 -20,100' fill='none' stroke='").append(leafStroke).append("' stroke-width='4'/>");
                // Sunflower Head
                for (int i = 0; i < 12; i++) {
                    double angle = i * (360.0 / 12.0);
                    svg.append("<path d='M0,-16 C-8,-45 8,-45 0,-16' fill='#FFD95A' stroke='#E29578' stroke-width='1.5' transform='rotate(").append(angle).append(")'/>");
                }
                svg.append("<circle cx='0' cy='0' r='20' fill='#5C3D2E' stroke='#3E2723' stroke-width='2.5'/>");
                svg.append("</g>");
                break;

            case "christmas":
                svg.append("<!-- Christmas Pine/Holly Art -->");
                svg.append("<g>");
                svg.append("<path d='M0,40 L0,100' fill='none' stroke='#5C3D2E' stroke-width='4'/>");
                svg.append("<polygon points='0,0 -35,50 35,50' fill='#1E5631' stroke='#143F22' stroke-width='1.5'/>");
                svg.append("<polygon points='0,-25 -28,20 28,20' fill='#1E5631' stroke='#143F22' stroke-width='1.5'/>");
                svg.append("<polygon points='0,-45 -20,-5 20,-5' fill='#1E5631' stroke='#143F22' stroke-width='1.5'/>");
                svg.append("<path d='M0,-52 L2,-46 L8,-46 L3,-42 L5,-36 L0,-40 L-5,-36 L-3,-42 L-8,-46 L-2,-46 Z' fill='#FFD700' stroke='#DAA520' stroke-width='1'/>");
                svg.append("<circle cx='-12' cy='40' r='4' fill='#EF4444'/>");
                svg.append("<circle cx='12' cy='40' r='4' fill='#3B82F6'/>");
                svg.append("<circle cx='-8' cy='12' r='4' fill='#FFD700'/>");
                svg.append("<circle cx='8' cy='15' r='4' fill='#EF4444'/>");
                svg.append("</g>");
                break;

            default:
                // Default elegant geometric floral rosette
                svg.append("<!-- Default Rosette Art -->");
                svg.append("<g>");
                svg.append("<path d='M0,0 Q0,50 0,95' fill='none' stroke='").append(leafStroke).append("' stroke-width='3'/>");
                for (int i = 0; i < 8; i++) {
                    double angle = i * 45;
                    svg.append("<circle cx='0' cy='-25' r='15' fill='").append(mainColor).append("' opacity='0.8' stroke='").append(strokeColor).append("' stroke-width='2' transform='rotate(").append(angle).append(")'/>");
                }
                svg.append("<circle cx='0' cy='0' r='10' fill='#FFFFFF' stroke='").append(strokeColor).append("' stroke-width='2'/>");
                svg.append("</g>");
        }

        return svg.toString();
    }
}
