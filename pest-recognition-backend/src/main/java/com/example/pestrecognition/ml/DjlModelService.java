package com.example.pestrecognition.ml;

import com.example.pestrecognition.model.dto.ClassificationResult;
import org.springframework.stereotype.Service;

import java.awt.image.BufferedImage;
import java.util.List;
import java.util.ArrayList;
import javax.annotation.PreDestroy;
import java.io.IOException;

// Import necessary DJL classes
import ai.djl.ModelException;
import ai.djl.inference.Predictor;
import ai.djl.repository.zoo.ZooModel;
import ai.djl.translate.Translator;
import ai.djl.translate.TranslatorContext;
import ai.djl.modality.cv.Image;
import ai.djl.modality.cv.ImageFactory;
import ai.djl.ndarray.NDList;
import ai.djl.ndarray.NDArray;
import ai.djl.modality.Classifications;
import ai.djl.repository.zoo.ModelZoo;
import ai.djl.repository.zoo.Criteria;

@Service
public class DjlModelService implements ModelService {

    // TODO: Define model path and other necessary configurations
    // Replace with the actual path to your DJL model file(s)
    private static final String MODEL_PATH = "file:///E:/yangyangli/pest_recognize_system/pest-recognition-backend/src/main/resources/model/bestmodel.onnx";

    private ZooModel<Image, Classifications> model; // DJL model object
    private Predictor<Image, Classifications> predictor; // DJL predictor

    public DjlModelService() {
        // TODO: Load the DJL model here
        // You need to define the correct Criteria based on your model type (e.g., framework, model name)
        try {
            Criteria<Image, Classifications> criteria = Criteria.builder()
                    .setTypes(Image.class, Classifications.class)
                    .optModelUrls(MODEL_PATH)
                    .optEngine("OnnxRuntime")
                    .optOption("input_shapes", "[[1, 3, 300, 300]]")
                    .build();
            model = ModelZoo.loadModel(criteria);

            // TODO: Define and set up the Translator based on your model's input/output
            // The translator handles preprocessing the input image and postprocessing the model output
            Translator<Image, Classifications> translator = new Translator<Image, Classifications>() {
                @Override
                public NDList processInput(TranslatorContext ctx, Image input) throws Exception {
                    // 强制将图像调整为 300x300，忽略纵横比
                    Image resizedImage = input.resize(300, 300, false);
                    
                    // 验证图像尺寸
                    if (resizedImage.getHeight() != 300 || resizedImage.getWidth() != 300) {
                        throw new IllegalArgumentException(
                            String.format("Image dimensions must be 300x300, but got %dx%d", 
                                resizedImage.getWidth(), 
                                resizedImage.getHeight())
                        );
                    }
                    
                    NDArray array = resizedImage.toNDArray(ctx.getNDManager());
                    // 转换为 CHW 格式
                    array = array.transpose(2, 0, 1);
                    // 归一化像素值到 [0, 1]
                    array = array.div(255.0f);
                    return new NDList(array);
                }

                @Override
                public Classifications processOutput(TranslatorContext ctx, NDList list) throws Exception {
                    // TODO: Implement model output postprocessing
                    // Example: Convert model output (e.g., probabilities) to Classifications object
                    // NDArray probabilities = list.singletonOrThrow();
                    // return new Classifications(probabilities, your_class_names_list);
                    // Implement model output postprocessing
                    // Example: Convert model output (e.g., probabilities) to Classifications object
                    NDArray probabilities = list.singletonOrThrow();
                    // For demonstration, assuming class names are known or can be retrieved
                    // In a real scenario, you would load your class names (e.g., from a file or configuration)
                    List<String> classNames = new ArrayList<>();
                    // Populate classNames with your actual pest names in the correct order
                    // For example:
                    // classNames.add("pest_1");
                    // classNames.add("pest_2");
                    // ...
                    // Placeholder for class names. You should replace this with your actual class names.
                    // For example, if you have 10 classes, you might have:
                    // classNames.add("Class1");
                    // classNames.add("Class2");
                    // ...
                    // For now, I will add a generic list of 10 classes as a placeholder.
                    for (int i = 0; i < 10; i++) {
                        classNames.add("class_" + i);
                    }
                    return new Classifications(classNames, probabilities);
                }
            };

            predictor = model.newPredictor(translator);

        } catch (ModelException | IOException e) {
            e.printStackTrace();
            // Handle model loading errors
            // Consider throwing a runtime exception or returning a specific error indicator
            throw new RuntimeException("Failed to load DJL model", e);
        }
    }

    @Override
    public List<ClassificationResult> predict(BufferedImage image) throws Exception {
        if (predictor == null) {
            throw new IllegalStateException("Model predictor is not initialized.");
        }

        // Convert BufferedImage to DJL Image
        Image djlImage = ImageFactory.getInstance().fromImage(image);

        // Perform prediction
        Classifications classifications = predictor.predict(djlImage);

        // Process the classification results and map to ClassificationResult DTO
        List<ClassificationResult> results = new ArrayList<>();
        // Assuming the model outputs class names that can be mapped to pest IDs
        // You might need to adjust this based on your model's output format
        for (Classifications.Classification classification : classifications.topK(1)) { // Get top 1 result
            ClassificationResult result = new ClassificationResult();
            // TODO: Implement a method to map model output class name to pest ID
            // This requires a mapping mechanism (e.g., a lookup table, database query, or convention)
            // Example: If class names are like "pest_1", "pest_2", etc.
            try {
                 result.setPestId(getPestIdFromName(classification.getClassName())); // Implement this mapping
                 result.setConfidence(classification.getProbability());
                 results.add(result);
            } catch (NumberFormatException e) {
                 // Handle cases where class name cannot be mapped to a valid pest ID
                 System.err.println("Could not parse pest ID from class name: " + classification.getClassName());
            }
        }

        if (results.isEmpty()) {
             throw new Exception("Model prediction did not return any valid results.");
        }

        return results;
    }

    // TODO: Implement a method to map model output class name to pest ID
    // This method needs to be implemented based on how your model's output class names correspond to your database's pest IDs.
    // Example implementation assuming class names are in the format "pest_ID"
    private Long getPestIdFromName(String className) {
        // Handle class names in format "class_N"
        if (className != null && className.startsWith("class_")) {
            try {
                return Long.parseLong(className.substring("class_".length()));
            } catch (NumberFormatException e) {
                // Handle the case where the part after "class_" is not a valid number
                throw new NumberFormatException("Invalid class ID format in class name: " + className);
            }
        }
        // Handle cases where the class name does not follow the expected format
        throw new IllegalArgumentException("Unexpected class name format: " + className);
    }

    // Close the predictor and model when the application shuts down
    @PreDestroy
    public void close() {
        if (predictor != null) {
            predictor.close();
        }
        if (model != null) {
            model.close();
        }
    }
}