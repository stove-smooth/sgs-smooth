package com.example.communityserver.util;

import org.springframework.stereotype.Component;

@Component
public class Base62 {

    private final int BASE62 = 62;
    private final String BASE62_CHAR = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

    public String encode(Long id) {
        String encodeStr = encoding(id);
        return encodeStr;
    }

    private String encoding(long param) {
        StringBuffer sb = new StringBuffer();
        while(param > 0) {
            sb.append(BASE62_CHAR.charAt((int) (param % BASE62)));
            param /= BASE62;
        }
        return sb.toString();
    }

    public long decode(String encodeStr) {
        long decodeVal = decoding(encodeStr);
        return decodeVal;
    }

    private long decoding(String param) {
        long sum = 0;
        long power = 1;
        for (int i = 0; i < param.length(); i++) {
            sum += BASE62_CHAR.indexOf(param.charAt(i)) * power;
            power *= BASE62;
        }
        return sum;
    }
}
