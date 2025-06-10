package com.example.pestrecognition.ml;

import com.example.pestrecognition.model.dto.ClassificationResult;
import org.springframework.stereotype.Service;
import org.springframework.context.annotation.Primary;

import java.awt.image.BufferedImage;
import java.util.List;

@Service
@Primary
public class ModelServiceImpl implements ModelService {

    @Override
    public List<ClassificationResult> predict(BufferedImage image) throws Exception {
        // TODO: Implement actual model prediction logic
        // This is a placeholder implementation
        System.out.println("Performing prediction...");
        // Example dummy result
        ClassificationResult result = new ClassificationResult();
        result.setPestId(1L);
        result.setPestName("Example Pest");
        result.setConfidence(0.95);
        return List.of(result);
    }
}