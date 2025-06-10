package com.example.pestrecognition.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PestVO {
    
    private Long id;
    private String nameZh;
    private String nameEn;
    private String category;
    private String description;
    private Integer harmLevel;
    private String symptoms;
    private String preventionMethods;
    private String imageUrl;
    private String family;
    private String distribution;
    private String host;
    private String morphology;
    private String habits;
}