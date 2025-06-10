package com.example.pestrecognition.model.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class RecognitionResponse {
    
    private Long pestId;
    private String pestName;
    private String pestNameEn;
    private Double confidence;
    private String description;
    private String imageUrl;
    private Integer harmLevel;
    private String preventionMethods;
}