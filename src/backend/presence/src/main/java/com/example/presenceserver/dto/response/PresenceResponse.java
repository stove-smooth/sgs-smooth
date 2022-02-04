package com.example.presenceserver.dto.response;

import lombok.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class PresenceResponse {
    Map<Long,Boolean> check = new HashMap<>();
    List<Long> alarm = new ArrayList<>();
}
