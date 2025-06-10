package com.example.pestrecognition.ml;

import com.example.pestrecognition.model.dto.ClassificationResult;

import java.awt.image.BufferedImage;
import java.util.List;

public interface ModelService {
    List<ClassificationResult> predict(BufferedImage image) throws Exception;
}