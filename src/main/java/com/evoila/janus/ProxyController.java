package com.evoila.janus;

import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import java.util.Map;
import java.util.HashMap;

@RestController
@RequestMapping("/api")
public class ProxyController {

    @GetMapping("/health")
    public ResponseEntity<Map<String, String>> health() {
        Map<String, String> response = new HashMap<>();
        response.put("status", "UP");
        response.put("service", "janus-native-test");
        return ResponseEntity.ok(response);
    }

    @PostMapping("/proxy")
    public ResponseEntity<Map<String, Object>> proxy(@RequestBody(required = false) Map<String, Object> request) {
        Map<String, Object> response = new HashMap<>();
        response.put("message", "Proxy request received");
        response.put("received", request != null ? request : Map.of());
        response.put("timestamp", System.currentTimeMillis());
        return ResponseEntity.ok(response);
    }

    @GetMapping("/info")
    public ResponseEntity<Map<String, String>> info() {
        Map<String, String> response = new HashMap<>();
        response.put("application", "Janus Native Test");
        response.put("version", "0.0.1-SNAPSHOT");
        response.put("java.version", System.getProperty("java.version"));
        response.put("native", "true");
        return ResponseEntity.ok(response);
    }
}
