package Model;

import java.io.Serializable;

public class User implements Serializable{
    private int id;
    private String name;
    private String email;
    private String address;
    private String userLoginName;

    // Constructors
    public User() {}

    public User(int id, String name, String email, String address) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.address = address;
    }

    // Getters & Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }
    
    public String getUserLoginName(){
        return userLoginName;
    }
    
    public void setUserLoginName(String userLoginName){
        this.userLoginName = userLoginName;
    }
}
