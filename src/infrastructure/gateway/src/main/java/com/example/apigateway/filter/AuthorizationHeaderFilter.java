package com.example.apigateway.filter;

import io.jsonwebtoken.Jwts;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.servlet.error.DefaultErrorAttributes;
import org.springframework.cloud.gateway.filter.GatewayFilter;
import org.springframework.cloud.gateway.filter.factory.AbstractGatewayFilterFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.http.server.reactive.ServerHttpResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;


@Component
@Slf4j
public class AuthorizationHeaderFilter extends AbstractGatewayFilterFactory<AuthorizationHeaderFilter.Config> {


    @Value("${jwt.secret_key}")
    private String secretKey;

    public AuthorizationHeaderFilter() {
        super(Config.class);
    }


    @Override
    public GatewayFilter apply(Config config) {
        return (((exchange, chain) -> {
            ServerHttpRequest request = exchange.getRequest();
            ServerHttpResponse response = exchange.getResponse();

            if (!request.getHeaders().containsKey(HttpHeaders.AUTHORIZATION)) {
                return onError(exchange,"JWT token is not valid",HttpStatus.UNAUTHORIZED);
            }

            String jwt = request.getHeaders().get(HttpHeaders.AUTHORIZATION).get(0);
            if (!isJwtValid(jwt)) {
                log.info("실패");
                return onError(exchange,"JWT token is not valid",HttpStatus.UNAUTHORIZED);
            }

            Integer id = (Integer) Jwts.parser().setSigningKey(secretKey)
                    .parseClaimsJws(jwt).getBody().get("id");

            ServerHttpRequest req = exchange.getRequest().mutate().header("id", String.valueOf(id)).build();

            return chain.filter(exchange.mutate().request(req).build());
        }));
    }
    private boolean isJwtValid(String jwt) {
        boolean returnValue = true;
        String subject = null;
        try {
            subject = Jwts.parser().setSigningKey(secretKey)
                    .parseClaimsJws(jwt).getBody()
                    .getSubject();
        } catch (Exception ex) {
            returnValue = false;
        }

        if (subject == null || subject.isEmpty()) {
            returnValue = false;
        }

        return returnValue;
    }

    private Mono<Void> onError(ServerWebExchange exchange, String err, HttpStatus httpStatus) {
        ServerHttpResponse response = exchange.getResponse();
        response.setStatusCode(httpStatus);
        return response.setComplete();

    }

    public static class Config {

    }
}
