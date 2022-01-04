package com.example.roomserver.client;

import com.example.roomserver.dto.response.AccountInfoResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(name = "accountFeign", url = "http://localhost:8080/auth-service")
public interface AccountClient {

    @GetMapping("/info")
    AccountInfoResponse getAccountInfo(@PathVariable Long accountId);
}
