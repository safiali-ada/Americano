##Translify

A machine-learning powered iOS application that detects objects and translates their identified names into Italian.


##Functionality

Object Detection using a CNN model trained on TensorFlow and converted to Core ML.

Bounding Boxes to display detected objects (if implemented).

Translation Module that maps English class labels to Italian using a local JSON or dictionary file.

##Architecture / Key Components

Swift / iOS – App built using Swift (SwiftUI or UIKit).

Core ML – Handles on-device inference using the converted .mlmodel.

Vision Framework – Optional integration for bounding-box decoding and model handling.

Translation Module – Local lookup system for English → Italian translation.

##Requirements

Xcode (recent stable version)

iOS Target: e.g., iOS 13+

Core ML .mlmodel included in the project

Physical iOS device for full camera + ML performance

##How to Build & Run

Clone the repository:

git clone https://github.com/safiali-ada/Americano.git


Open the project in Xcode (.xcodeproj or .xcworkspace).

Ensure the Core ML model is included in the Resources folder.

Build and run the application on a real iOS device.

Grant camera permission when requested.

Capture an image and view the detected class along with its Italian translation.

##Future Improvements

Additional language support.

Option to switch between offline translation and API-based translation.

Custom model training for new object categories.

Performance optimizations for lower FPS or reduced power usage.

UI enhancements such as audio output, detection history, or image snapshots.

##License

This project is released under the MIT License.
