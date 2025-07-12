package com.bookreviewhub.backend.application.auth.dto.request;

import lombok.Data;

@Data
public class LoginRequest {
    private String username;
    private String password;
}
