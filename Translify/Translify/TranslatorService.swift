import Foundation

struct TranslationLibrary {
    
    // Define your translations here.
    // The Key is your Model's output (English), the Value is the Italian translation.
    static let dictionary: [String: String] = [
        "airplane": "Aereo",
        "bird": "Uccello",
        "car": "Automobile",
        "cat": "Gatto",
        "deer": "Cervo",
        "dog": "Cane",
        "horse": "Cavallo",
        "monkey": "Scimmia",
        "ship": "Nave",
        "truck": "Camion"
    ]
    
    static func translateToItalian(className: String) -> String {
        // 1. Try to find the exact match
        if let italianWord = dictionary[className] {
            return italianWord
        }
        
        // 2. Try to find it lowercase if exact match fails
        if let italianWord = dictionary[className.lowercased()] {
            return italianWord
        }
        
        // 3. Fallback if not found in your list
        return "Traduzione non trovata" // "Translation not found"
    }
}
