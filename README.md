📸 Translify: Object Recognition & Instant Translation
Translify is an iOS application that leverages on-device Machine Learning to identify real-world objects in real-time using the device's camera and instantly translates their names into Italian.

✨ Core Features
🔍 Object Detection: Utilizes a TensorFlow-trained Convolutional Neural Network (CNN), optimized and converted into the Core ML format for fast, on-device inference.

🇮🇹 Instant Translation: Automatically translates the detected English object labels into Italian using a lightweight, local JSON/dictionary for quick, offline results.

📱 On-Device Performance: The entire pipeline—from camera capture to detection and translation—runs fully on-device, ensuring fast inference speeds and prioritizing user privacy.

📦 Visual Feedback: Provides clear class names, with optional bounding boxes shown around the detected objects.

🧠 Architecture & Technology Stack
Translify is built natively for optimal performance on the Apple ecosystem.

Swift / iOS: The primary language and platform, ensuring smooth, native app performance.

Core ML: Powers the efficient execution of the trained Machine Learning model directly on the device.

Vision Framework: Apple's dedicated framework for handling image processing tasks and decoding the model's output into manageable bounding box coordinates and confidence scores.

Translation Module: A custom module managing the English-to-Italian label mapping via a local dataset.

📋 Requirements
To build and run Translify, you will need:

Xcode: A recent, stable version is required.

iOS Target: Recommended minimum of iOS 13+.

.mlmodel: The Core ML model file must be included in the project resources.

Device: A physical iPhone is necessary to utilize the camera and experience optimal inference performance.

🛠️ Build & Run Instructions
Follow these steps to get the app running on your device:

Clone the repository:

Bash

git clone https://github.com/safiali-ada/Americano.git
Open the Project: Open the cloned project directory in Xcode.

Verify Model Inclusion: Ensure the necessary .mlmodel file is correctly placed within the Resources folder of the project.

Run on Device: Select your physical iPhone as the target and run the app.

Usage:

Allow camera access when prompted.

Point the camera at any object.

View the real-time object detection and the corresponding Italian translation!

✨ Future Development
We are planning the following enhancements to expand Translify's capabilities:

🌍 Language Expansion: Adding support for more translation language options.

☁️ Translation Modes: Implementing a toggle to switch between the local, offline dictionary and a potentially more comprehensive cloud-based translation service.

🏋️ Custom Training: Tools or guides for users to train and integrate new object categories into the model.

⚡ Optimization: Further performance enhancements focused on battery efficiency and faster detection speeds.

🔊 Audio Output: A feature to audibly "speak the translation" for learning purposes.

🖼️ History & Export: Functionality for detection history, taking snapshots, and exporting the results.

📄 License
This project is open-source and released under the MIT License.
