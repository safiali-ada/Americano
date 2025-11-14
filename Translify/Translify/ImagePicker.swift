import SwiftUI
import UIKit

/// A SwiftUI view that wraps `UIImagePickerController`.
/// This allows us to present the native iOS camera or photo library.
struct ImagePicker: UIViewControllerRepresentable {
    
    // 1. PROPERTIES
    
    /// The source type for the picker (e.g., camera, photo library).
    var sourceType: UIImagePickerController.SourceType
    
    /// A closure to be called when an image is selected.
    /// This is how we pass the captured `UIImage` back to the SwiftUI view.
    var onImageSelected: (UIImage) -> Void
    
    // 2. COORDINATOR
    
    /// The coordinator acts as the delegate for the `UIImagePickerController`.
    /// It handles events and communicates them back to the SwiftUI view.
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        /// Called when the user finishes picking media (e.g., takes a photo).
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            // Extract the captured image from the info dictionary
            if let uiImage = info[.originalImage] as? UIImage {
                // Pass the image back to our parent SwiftUI view
                parent.onImageSelected(uiImage)
            }
            
            // Dismiss the picker
            picker.dismiss(animated: true)
        }
        
        /// Called when the user cancels the picker.
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            // Dismiss the picker
            picker.dismiss(animated: true)
        }
    }
    
    // 3. UIViewControllerRepresentable METHODS
    
    /// Creates the `Coordinator` instance.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    /// Creates and configures the `UIImagePickerController` instance.
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        
        // If using the camera, set preferred camera type if available
        if sourceType == .camera {
             picker.cameraDevice = .rear // Default to rear camera
        }
        
        return picker
    }
    
    /// Updates the `UIImagePickerController` (not needed for this simple case).
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        // No update logic needed here
    }
}
