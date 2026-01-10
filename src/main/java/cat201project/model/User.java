package cat201project.model;

public class User {
    private String name;
    private String email;
    private String password;
    private String role; // "user" or "admin"

    public User () {}

    public User (String name, String email, String password, String role) {
        this.name = name;
        this.email = email;
        this.password = password;
        this.role = role;
    }

    // Getters
    public String getName() { return name; }
    public String getEmail() { return email; }
    public String getPassword() { return password; }
    public String getRole() { return role; }
}
