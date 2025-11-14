import SwiftUI

/// A clean, modal view to display the classification results.
/// It shows the captured image, the predicted label, and its translation.
struct ResultsView: View {
    
    /// The result data to display.
    let result: ClassificationResult
    
    /// Environment property to dismiss the sheet.
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 1. Captured Image
                Image(uiImage: result.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(16)
                    .shadow(radius: 8)
                    .padding()
                
                // 2. Results
                VStack(spacing: 20) {
                    resultRow(
                        title: "Prediction",
                        value: result.label,
                        color: .primary
                    )
                    
                    Divider()
                    
                    resultRow(
                        title: "Translation",
                        value: result.translation,
                        color: .blue
                    )
                }
                .padding(30)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
                .padding()

                Spacer()
            }
            .navigationTitle("Classification Result")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Done button to dismiss
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.headline)
                }
            }
        }
    }
    
    /// A helper view to create a consistent row for displaying results.
    @ViewBuilder
    private func resultRow(title: String, value: String, color: Color) -> some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .foregroundColor(color)
        }
    }
}

// MARK: - Preview

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView(
            result: ClassificationResult(
                label: "Laptop",
                translation: "Portátil",
                image: UIImage(systemName: "laptopcomputer")! // Use SF Symbol for preview
            )
        )
    }
}
