package model;

public class CardTemplate {
    private int id;
    private String title;
    private String image;
    private String category;
    private String message;

    public CardTemplate() {}

    public CardTemplate(int id, String title, String image,
                        String category, String message) {
        this.id = id;
        this.title = title;
        this.image = image;
        this.category = category;
        this.message = message;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}