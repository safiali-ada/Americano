Translify

The camera-powered iOS app that identifies objects using machine learning and instantly translates their names into Italian.

🚀 What Translify Does

🔍 Detects objects using a TensorFlow-trained CNN converted to CoreML

📦 Shows class names, with optional bounding boxes

🇮🇹 Translates detected English labels into Italian using a local JSON/dictionary

📱 Runs fully on-device for fast, private inference

🧠 Architecture

Swift / iOS – Built natively for smooth performance

Core ML – Powers the on-device model inference

Vision Framework – Handles image processing + bounding box decoding

Translation Module – Maps English → Italian with a lightweight local dataset

📋 Requirements

Xcode (recent version)

iOS target: 13+ (recommended)

.mlmodel included in the project

Physical iPhone for camera + inference performance

🛠️ How to Build & Run

Clone the repository:

git clone https://github.com/safiali-ada/Americano.git


Open the project in Xcode

Make sure the .mlmodel file is in the Resources folder

Run the app on a real device

Allow camera access

Point the camera at an object → get detection → see the Italian translation

✨ Future Enhancements

🌍 More language options

☁️ Switch between offline and cloud-based translation

🏋️ Custom training for new object categories

⚡ Optimized detection for better battery + performance

🔊 Audio output (“speak the translation”)

🖼️ Detection history, snapshots, and export options

📄 License

This project is released under the MIT License.
