package com.example.pestrecognition.model.vo;

import lombok.Data;

@Data
public class RecognitionResponse {
    private Long pestId;
    private String pestName;
    private String pestNameEn;
    private double confidence;
    private String description;
    private String imageUrl;
    private String harmLevel;
    private String preventionMethods;
}