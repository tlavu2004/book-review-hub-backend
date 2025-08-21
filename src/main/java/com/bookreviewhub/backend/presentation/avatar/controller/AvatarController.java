package com.bookreviewhub.backend.presentation.avatar.controller;

import com.bookreviewhub.backend.application.account.avatar.service.AvatarService;
import com.bookreviewhub.backend.shared.constant.SuccessCode;
import com.bookreviewhub.backend.shared.dto.response.SuccessResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;

@RestController
@RequestMapping("/api/v1/avatars")
@RequiredArgsConstructor
public class AvatarController {

    private final AvatarService avatarService;

    @PostMapping("/upload")
    public SuccessResponse<String> uploadAvatar(
            @RequestParam MultipartFile file,
            @RequestParam Long userId,
            @RequestParam int version
    ) {
        try (InputStream inputStream = file.getInputStream()) {
            String url = avatarService.uploadAccountAvatar(inputStream, userId, version);

            // TODO: Fix API path
            return SuccessResponse.created(SuccessCode.AVATAR_UPLOADED, "", url);
        } catch (IOException e) {
            throw new RuntimeException("Avatar upload failed", e);
        }
    }
}
