package com.bookreviewhub.backend.presentation.auth.controller;

import com.bookreviewhub.backend.application.auth.dto.request.RegisterRequest;
import com.bookreviewhub.backend.application.auth.dto.request.LoginRequest;
import com.bookreviewhub.backend.application.auth.dto.response.AuthResponse;
import com.bookreviewhub.backend.shared.dto.response.SuccessResponse;
import com.bookreviewhub.backend.application.auth.service.AuthService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
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
    public SuccessResponse<Void> register(
            @RequestBody RegisterRequest registerRequest,
            HttpServletRequest httpServletRequest
    ) {
        String path = httpServletRequest.getRequestURI();
        return authService.register(registerRequest, path);
    }

    @PostMapping("/login")
    public SuccessResponse<AuthResponse> login(
            @Valid @RequestBody LoginRequest loginRequest,
            HttpServletRequest httpServletRequest) {
        String path = httpServletRequest.getRequestURI();
        return authService.login(loginRequest, path);
    }
}
