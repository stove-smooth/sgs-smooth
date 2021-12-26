package com.example.authserver.configure.security.jwt;

import com.example.authserver.configure.exception.CustomExceptionStatus;
import com.example.authserver.domain.RoleType;
import io.jsonwebtoken.*;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;
import java.util.Base64;
import java.util.Date;

@RequiredArgsConstructor
@Component
public class JwtTokenProvider {

    private final UserDetailsService userDetailsService;

    @Value("${jwt.secret_key}")
    private String secretKey;

    // 24시간
    private long tokenTime = 24 * 60 * 60 * 1000L;

    @PostConstruct
    protected void init() {
        secretKey = Base64.getEncoder().encodeToString(secretKey.getBytes());
    }

    public String createToken(String username, RoleType role) {
        Claims claims = Jwts.claims().setSubject(username);
        claims.put("role",role);
        Date now =new Date();
        return Jwts.builder()
                .setClaims(claims)
                .setIssuedAt(now)
                .setExpiration(new Date(now.getTime() + tokenTime))
                .signWith(SignatureAlgorithm.HS256,secretKey)
                .compact();
    }

    public String getUsername(String token){
        return Jwts.parser().setSigningKey(secretKey).parseClaimsJws(token).getBody().getSubject();
    }

    public Authentication getAuthentication(String token){
        UserDetails userDetails = userDetailsService.loadUserByUsername(this.getUsername(token));
        return  new UsernamePasswordAuthenticationToken(userDetails,"",userDetails.getAuthorities());
    }

    public String resolveToken(HttpServletRequest req){
        return req.getHeader("X-ACCESS-TOKEN");
    }

    public boolean validateToken(String jwtToken, HttpServletRequest req) {
        try {
            if (jwtToken.isEmpty()) throw new JwtException("empty jwtToken");
            Jws<Claims> claimsJws = Jwts.parser().setSigningKey(secretKey).parseClaimsJws(jwtToken);
            return !claimsJws.getBody().getExpiration().before(new Date());
        } catch (JwtException e) {
            if (jwtToken.isEmpty()) {
                req.setAttribute("exception", CustomExceptionStatus.EMPTY_JWT.getMessage());
            }
            else req.setAttribute("exception", CustomExceptionStatus.INVALID_JWT.getMessage());
            return false;
        }
    }
}
