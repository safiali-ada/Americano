Translify

Translify is a machine-learning powered iOS application that detects objects using a Core ML model and translates the identified class names into Italian.

Functionality

Object detection using a CNN model trained in TensorFlow and converted to Core ML.

Display of detected class names, optionally with bounding boxes.

Translation of English labels into Italian using a local JSON or dictionary file.

Architecture

Swift / iOS – Implementation using SwiftUI or UIKit.

Core ML – On-device inference using a converted .mlmodel.

Vision – Used for model requests and bounding box decoding (if enabled).

Translation Module – Local English → Italian mapping system.

Requirements

Recent version of Xcode

iOS target (e.g., iOS 13+)

Core ML .mlmodel file included in the project

Physical iOS device for camera functionality and proper inference performance

How to Build & Run

Clone the repository:

git clone https://github.com/safiali-ada/Americano.git


Open the project in Xcode.

Ensure the .mlmodel file is added to the project resources.

Build and run on a physical iOS device.

Grant camera access when requested.

Capture an image to view the detected object and its translated label.

Future Improvements

Support for additional languages.

Optional cloud-based translation in addition to offline mode.

Custom model training for new object classes.

Performance optimizations for lower power consumption.

UI additions such as audio output, detection history, or snapshot export.

License

This project is licensed under the MIT License.
