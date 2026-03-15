import org.mindrot.jbcrypt.BCrypt;

public class GeneratePassword {
    public static void main(String[] args) {
        String password = "your-password-here"; // Đổi password tại đây
        String hashed = BCrypt.hashpw(password, BCrypt.gensalt(10));
        System.out.println("Password: " + password);
        System.out.println("BCrypt Hash: " + hashed);
        System.out.println("\nSQL Command:");
        System.out.println("INSERT INTO users (email, password, fullname, role, status) VALUES");
        System.out.println("('youremail@example.com', '" + hashed + "', 'Your Name', 'admin', 'active');");
    }
}
