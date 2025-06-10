package com.example.pestrecognition.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class HistoryVO {
    
    private Long id;
    private Long pestId;
    private String pestName;
    private Double confidence;
    private String imageUrl;
    private LocalDateTime createTime;
}