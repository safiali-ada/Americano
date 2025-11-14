import UIKit
import Vision
import CoreML // Import CoreML to recognize the model type

/// A classifier that uses the user's CoreML + Vision workflow.
/// This is set up to use the 'stl10_model'.
class ImageClassifier {
    
    /// Classifies an image using the real model.
    /// - Parameter image: The `UIImage` captured by the user.
    /// - Returns: A `ClassificationResult` with the findings.
    func classify(image: UIImage) async -> ClassificationResult {
        
        // --- START: REAL IMPLEMENTATION ---
        
        do {
            // Call the real classification function
            return try await performRealClassification(image: image)
        } catch {
            // If classification fails, return a default error result
            // This is important so the UI can still update
            print("Error during classification: \(error)")
            return ClassificationResult(
                label: "Error",
                translation: "Failed to classify",
                image: image
            )
        }
        
        // --- END: REAL IMPLEMENTATION ---
    }

    // --- VISION + COREML IMPLEMENTATION ---
     
    // 1. Load your CoreML model
    private lazy var coreMLModel: VNCoreMLModel? = {
        do {
            // This is the line you asked about:
            // It now uses your 'stl10_model' class, which
            // Xcode auto-generates when you add the .mlmodel file.
            let model = try stl10_model(configuration: MLModelConfiguration()).model
            return try VNCoreMLModel(for: model)
        } catch {
            print("Failed to load CoreML model (stl10_model): \(error)")
            return nil
        }
    }()

    /// Performs image classification using Vision and CoreML.
    func performRealClassification(image: UIImage) async throws -> ClassificationResult {
        guard let model = coreMLModel else {
            throw ClassificationError.modelLoadingFailed
        }
        
        guard let cgImage = image.cgImage else {
            throw ClassificationError.imageProcessingFailed
        }

        // 2. Create the Vision request
        let request = VNCoreMLRequest(model: model)
        
        // --- FIX #1: ASPECT RATIO ---
        // Tell Vision how to handle rectangular photos for your square model.
        // .scaleFit ensures the whole image is seen, "letterboxing" it.
        request.imageCropAndScaleOption = .centerCrop
        
        // 3. Create the request handler
        // --- FIX #2: ORIENTATION ---
        // Get the image's "up" orientation from its metadata
        let imageOrientation = CGImagePropertyOrientation(image.imageOrientation)
        // Pass that orientation to the handler
        let handler = VNImageRequestHandler(cgImage: cgImage, orientation: imageOrientation, options: [:])

        // 4. Perform the request (this is synchronous, so we wrap it in an async func)
        try handler.perform([request])

        // 5. Process the results
        guard let results = request.results as? [VNClassificationObservation],
              let topResult = results.first else {
            throw ClassificationError.noResultsFound
        }
        
        // We got a result!
        // ... inside performRealClassification
        let label = topResult.identifier

        // --- DEBUGGING ---
        print("--- MODEL'S RAW GUESS ---")
        print("Label: \(label)")
        print("Confidence: \(topResult.confidence)")
        print("--------------------------")
        // --- END DEBUGGING ---

        // 6. Get the translation
        // This is the NEW line
        let translation = TranslationLibrary.translateToItalian(className: label)
        // ...// Call your translation service
        
        return ClassificationResult(
            label: label,
            translation: translation,
            image: image
        )
    }
    
    /// Helper function for translation.


    /// Custom errors for classification failures.
    enum ClassificationError: Error {
        case modelLoadingFailed
        case imageProcessingFailed
        case noResultsFound
    }
}

// MARK: - Helper Extension

// This extension converts UIImage.Orientation to the CGImagePropertyOrientation
// that the Vision framework requires.
extension CGImagePropertyOrientation {
    init(_ orientation: UIImage.Orientation) {
        switch orientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        @unknown default: self = .up
        }
    }
}
