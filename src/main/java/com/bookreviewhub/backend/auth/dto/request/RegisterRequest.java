package com.bookreviewhub.backend.auth.dto.request;

import lombok.Data;

@Data
public class RegisterRequest {
    private String username;
    private String password;
    private String email;
    private String firstName;
    private String middleName;
    private String lastName;
}
