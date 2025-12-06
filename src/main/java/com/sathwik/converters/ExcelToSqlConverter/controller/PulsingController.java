package com.sathwik.converters.ExcelToSqlConverter.controller;

import com.sathwik.converters.ExcelToSqlConverter.shedulers.PulsingThread;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

@Controller
@RequestMapping("/api/v1")
public class PulsingController {

    @Value("${pulseServerUrl}")
    private String pulseServerUrl;

    private final RestTemplate restTemplate = new RestTemplate();
    
    private PulsingThread pulsingThread;
    private boolean isRunning = false;

    @GetMapping("/pulse")
    public ResponseEntity<?> pulser(){
        String response = restTemplate.getForObject(pulseServerUrl, String.class);
        System.out.println(response);
        return new ResponseEntity<>("Converter server is running", HttpStatus.OK);
    }

    @PostMapping("/pulse/start")
    public ResponseEntity<?> startPulse() {
        try {
            if (!isRunning) {
                pulsingThread = new PulsingThread();
                pulsingThread.start();
                isRunning = true;
                return ResponseEntity.ok()
                    .body(new ApiResponse(true, "Pulse started successfully"));
            }
            return ResponseEntity.badRequest()
                .body(new ApiResponse(false, "Pulse is already running"));
        } catch (Exception e) {
            return ResponseEntity.internalServerError()
                .body(new ApiResponse(false, "Error starting pulse: " + e.getMessage()));
        }
    }

    @PostMapping("/pulse/stop")
    public ResponseEntity<?> stopPulse() {
        try {
            if (isRunning && pulsingThread != null) {
                pulsingThread.stopPulsing();
                isRunning = false;
                return ResponseEntity.ok()
                    .body(new ApiResponse(true, "Pulse stopped successfully"));
            }
            return ResponseEntity.badRequest()
                .body(new ApiResponse(false, "No pulse is currently running"));
        } catch (Exception e) {
            return ResponseEntity.internalServerError()
                .body(new ApiResponse(false, "Error stopping pulse: " + e.getMessage()));
        }
    }

    @GetMapping("/pulse/status")
    public ResponseEntity<?> getPulseStatus() {
        return ResponseEntity.ok()
            .body(new ApiResponse(true, isRunning ? "Pulse is active" : "Pulse is inactive"));
    }
}

// Response class for consistent API responses
class ApiResponse {
    private boolean success;
    private String message;

    public ApiResponse(boolean success, String message) {
        this.success = success;
        this.message = message;
    }

    // Getters and setters
    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
