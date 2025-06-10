package com.example.pestrecognition.model.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class RecognitionRequest {
    // 此类可能为空，因为我们使用MultipartFile直接接收文件
    // 如果需要额外参数，可以在这里添加
}