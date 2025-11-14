import SwiftUI

/// The main view for the camera capture flow.
/// It manages the state for showing the camera, processing the image, and displaying results.
struct CameraCaptureView: View {
    
    // 1. STATE
    @State private var showCameraPicker = false
    @State private var processingState: ProcessingState = .idle
    @State private var classificationResult: ClassificationResult?
    
    // State for the source selector
    @State private var showSourceSelector = false
    @State private var pickerSourceType: UIImagePickerController.SourceType = .camera
    
    // Animation state for the button
    @State private var isButtonTapped = false

    /// Manages the different UI states of the capture flow.
    enum ProcessingState {
        case idle
        case processing
    }
    
    // Instance of the classifier
    private let imageClassifier = ImageClassifier()

    // 2. BODY
    var body: some View {
        ZStack {
            // Background
            Color(.systemBackground).edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                // Title
                Text("CapWords")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .padding(.bottom, 20)
                
                Text("Tap the button to capture an object.")
                    .font(.headline)
                    .foregroundColor(.secondary)

                Spacer()
                
                // Camera Button
                cameraButton()
                    .padding(.bottom, 60)
            }
            .padding()
            
            // Show a progress indicator while processing
            if processingState == .processing {
                ProgressView("Classifying...")
                    .padding(30)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
                    .transition(.opacity.combined(with: .scale(scale: 0.8)))
            }
        }
        .animation(.default, value: processingState)
        
        // 3. MODIFIERS
        
        // This dialog asks "Camera" or "Library"
        .confirmationDialog("Choose an image source", isPresented: $showSourceSelector, titleVisibility: .visible) {
            
            // Camera Button
            Button("Take Photo") {
                self.pickerSourceType = .camera
                self.showCameraPicker = true
            }
            
            // Photo Library Button
            Button("Choose from Library") {
                self.pickerSourceType = .photoLibrary
                self.showCameraPicker = true
            }
        }
        
        // This sheet presents the ImagePicker (Camera or Library)
        .sheet(isPresented: $showCameraPicker) {
            ImagePicker(sourceType: pickerSourceType) { image in
                processImage(image)
            }
        }
        
        // This sheet presents the ResultsView
        .sheet(item: $classificationResult) { result in
            ResultsView(result: result)
        }
    } // <-- BODY ENDS

    // MARK: - Views
    
    /// The main camera button with tap animation.
    @ViewBuilder
    private func cameraButton() -> some View {
        Button {
            // Trigger animation and open the *source selector*
            triggerButtonAnimation()
            showSourceSelector = true
        } label: {
            ZStack {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 80, height: 80)
                
                Image(systemName: "camera.fill")
                    .font(.system(size: 36, weight: .medium))
                    .foregroundColor(.white)
            }
        }
        .scaleEffect(isButtonTapped ? 1.2 : 1.0) // Apply scale effect
        .shadow(color: .blue.opacity(0.4), radius: 10, y: 5)
    }
    
    // MARK: - Private Methods
    
    /// Triggers a haptic feedback and a spring animation on the button.
    private func triggerButtonAnimation() {
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        // Spring animation
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
            isButtonTapped = true
        }
        
        // Reset animation state after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.spring()) {
                isButtonTapped = false
            }
        }
    }
    
    /// Kicks off the image classification process.
    private func processImage(_ image: UIImage) {
        // Set state to processing to show ProgressView
        processingState = .processing
        
        Task {
            // Run classification on a background thread
            let result = await imageClassifier.classify(image: image)
            
            // Update UI on the main thread
            await MainActor.run {
                self.classificationResult = result
                self.processingState = .idle
            }
        }
    }
} // <-- STRUCT ENDS

struct CameraCaptureView_Previews: PreviewProvider {
    static var previews: some View {
        CameraCaptureView()
    }
}
