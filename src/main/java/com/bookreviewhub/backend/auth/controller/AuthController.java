package com.bookreviewhub.backend.auth.controller;

import com.bookreviewhub.backend.auth.dto.request.RegisterRequest;
import com.bookreviewhub.backend.auth.dto.request.LoginRequest;
import com.bookreviewhub.backend.common.dto.response.SuccessResponse;
import com.bookreviewhub.backend.auth.service.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.PostMapping;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {
    private final AuthService authService;

    @PostMapping("/register")
    public SuccessResponse<Void> register(@RequestBody RegisterRequest registerRequest) {
        return authService.register(registerRequest);
    }

    @PostMapping("/login")
    public SuccessResponse<Map<String, String>> login(@RequestBody LoginRequest loginRequest) {
        return authService.login(loginRequest);
    }
}
