package com.example.authserver.domain.type;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@AllArgsConstructor
@NoArgsConstructor
public enum State {
    online("온라인"),
    step_out("자리비움"),
    other_business("다른 용무중"),
    offline("오프라인");

    private String name;
}
