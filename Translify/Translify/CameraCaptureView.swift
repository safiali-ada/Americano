import SwiftUI

/// The main view for the camera capture flow.
/// It manages the state for showing the camera, processing the image, and displaying results.
struct CameraCaptureView: View {
    
    // 1. STATE
    @State private var isAnimating: Bool = false
    @State private var showCameraPicker = false
    @State private var processingState: ProcessingState = .idle
    @State private var classificationResult: ClassificationResult?
    
    // State for the source selector
    @State private var pickerSourceType: UIImagePickerController.SourceType = .camera
    
    // Animation state for the button
    @State private var isButtonTapped = false
    
    // New tab selection state
    @State private var selectedTab: Tab = .camera
    enum Tab: Hashable { case camera, gallery }
    
    /// Manages the different UI states of the capture flow.
    enum ProcessingState {
        case idle
        case processing
    }
    
    // Instance of the classifier
    private let imageClassifier = ImageClassifier()
    
    // MARK: - Background View
    
    @ViewBuilder
    private func animatedBackground() -> some View {
        ZStack {
            // Light base color
            Color(.systemBackground)
                .ignoresSafeArea()

            // Floating blob 1
            Circle()
                .fill(Color.blue.opacity(0.35))
                .frame(width: 450, height: 450)
                .blur(radius: 140)
                .offset(x: isAnimating ? 140 : -150, y: isAnimating ? -120 : 130)
                .animation(.easeInOut(duration: 18).repeatForever(autoreverses: true), value: isAnimating)

            // Floating blob 2
            Circle()
                .fill(Color.cyan.opacity(0.25))
                .frame(width: 380, height: 380)
                .blur(radius: 120)
                .offset(x: isAnimating ? -160 : 150, y: isAnimating ? 140 : -130)
                .animation(.easeInOut(duration: 20).repeatForever(autoreverses: true), value: isAnimating)
        }
        .onAppear { isAnimating = true }
    }


    // 2. BODY
    var body: some View {
        TabView(selection: $selectedTab) {
            // Camera tab
            ZStack {
                animatedBackground()
                
                VStack {
                    Spacer()
                    
                    // Title
                    Text("Translify")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .padding(.bottom, 20)
                    
                    Text("Capture an object!")
                        .foregroundStyle(.black)
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
            .tag(Tab.camera)
            .tabItem {
                Image(systemName: "camera.fill")
                Text("Camera")
            }
            
            // Gallery tab
            ZStack {
                animatedBackground()
            }
            .tag(Tab.gallery)
            .tabItem {
                Image(systemName: "photo.on.rectangle")
                Text("Gallery")
            }
            .animation(.default, value: processingState)
            .sheet(isPresented: $showCameraPicker){
                ImagePicker(sourceType: pickerSourceType) { image in
                    processImage(image)
                    showCameraPicker = false
                    selectedTab = .camera // Return to camera tab after picking
                }
            }
        }
        .onChange(of: selectedTab) { newValue in
            if newValue == .gallery {
                pickerSourceType = .photoLibrary
                showCameraPicker = true
            }
        }
        .sheet(item: $classificationResult) { result in
            ResultsView(result: result)
        }
    }
    
    // MARK: - Views
    
    /// The main camera button with tap animation.
    @ViewBuilder
    private func cameraButton() -> some View {
        Button {
            // Always open camera directly
            triggerButtonAnimation()
            pickerSourceType = .camera
            showCameraPicker = true
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
    
    struct CameraCaptureView_Previews: PreviewProvider {
        static var previews: some View {
            CameraCaptureView()
        }
    }
}
