package com.example.pestrecognition.service;

import com.example.pestrecognition.model.vo.RecognitionResponse;
import org.springframework.web.multipart.MultipartFile;

public interface RecognitionService {
    RecognitionResponse recognizePest(MultipartFile file);
}