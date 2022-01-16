package com.example.presenceserver.service;

import com.example.presenceserver.dto.response.CommonResponse;
import com.example.presenceserver.dto.response.DataResponse;
import org.springframework.stereotype.Service;

@Service
public class ResponseService {

    public CommonResponse getSuccessResponse() {
        CommonResponse response = new CommonResponse();
        response.setIsSuccess(true);
        response.setCode(1000);
        response.setMessage("요청에 성공하였습니다.");
        return response;
    }

    public <T> DataResponse<T> getDataResponse(T data) {
        DataResponse<T> response = new DataResponse<>();
        response.setResult(data);
        response.setIsSuccess(true);
        response.setCode(1000);
        response.setMessage("요청에 성공하였습니다.");
        return response;
    }
}
