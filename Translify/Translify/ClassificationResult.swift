import UIKit
import SwiftUI

/// A data model to hold the results of the image classification.
///
/// Making it `Identifiable` allows it to be easily used with SwiftUI's `.sheet(item: ...)` modifier.
struct ClassificationResult: Identifiable {
    /// A unique ID for each result, required by `Identifiable`.
    let id = UUID()
    
    /// The top classification label (e.g., "Laptop", "Coffee Mug").
    let label: String
    
    /// The translated version of the label (e.g., "Portátil", "Taza de café").
    let translation: String
    
    /// The original image that was captured and classified.
    let image: UIImage
}
