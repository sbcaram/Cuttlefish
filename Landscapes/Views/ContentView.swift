//
//  ContentView.swift
//  Landscapes
//
//  Created by Sophia Caramanica on 11/26/21.
//

import SwiftUI
import ARKit
import Vision
import UIKit

struct ContentView: View {
    
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var isImagePickerDisplay = false
    
    //    @State private var selection: Tab = .featured
    var image = UIImage()
    @State var emotionText = ""
    @State var confidenceText = ""
    @State var detailText = ""
    @State var imageName = "Selected Image"
    private let cnnModel = try! VNCoreMLModel(for: CNNEmotions().model)
    private let priyaModel = try! VNCoreMLModel(for: model_v6().model)
    var resultsText = ""
    //    enum Tab {
    //        case featured
    //        case list
    //    }
    
    var body: some View {
        //        PictureProcess(image: Image("SophiaSmiling"))
        NavigationView {
            VStack {
                Button("Camera") {
                    self.sourceType = .camera
                    self.isImagePickerDisplay.toggle()
                }.padding()
                
                Button("photo") {
                    self.sourceType = .photoLibrary
                    self.isImagePickerDisplay.toggle()
                }.padding()
                
                if selectedImage != nil {
                    Image(uiImage: selectedImage!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .frame(width: 400, height: 400)
                } else {
                    Image(systemName: "snow")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .frame(width: 300, height: 300)
                }
                
                Button("Check Emotion", action: processClick)
                    .padding()
                Text(emotionText)
                Text(confidenceText)
                Text(detailText)
            }
            .navigationBarTitle("Demo")
            .sheet(isPresented: self.$isImagePickerDisplay) {
                ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.sourceType)
            }
        
        }
        //        TabView(selection: $selection) {
        //            CategoryHome()
        //
        //                .tabItem{
        //                    Label("Featured", systemImage: "star")
        //                }
        //                .tag(Tab.featured)
        //
        //            LandmarkList()
        //                .tabItem {
        //                    Label("List", systemImage: "list.bullet")
        //                }
        //                .tag(Tab.list)
    }
    func processClick() {
        detailText = "button was clicked"
        let result = checkEmotions()
        emotionText = result.emotionText
        confidenceText = result.confidenceText
        detailText = result.detailText
    }
    func checkEmotions() -> EmotionResults {
        // let means constant - won't change
        // var means variable - will change
        
//        var uiImage = UIImage(named: imageName)
        
        var cgImg = (self.selectedImage?.cgImage)!
        var result = EmotionResults(emotionText: "Not Found", confidenceText: "Not Found", confidenceRaw: -1, detailText: "Not Found")
        
        let checkType = "CNN"
        
        if (checkType == "CNN") {
            result = checkEmotionsWithCnnModel(cgImg)
        } else if (checkType == "PRIYA") {
            result = checkEmotionsWithPriyaModel(cgImg)
        } else {
            result.detailText = "Wrong type - nothing done"
        }

        return result
//
//        try? VNImageRequestHandler(cgImage: cgImg, orientation: .right, options: [:]).perform([VNCoreMLRequest(model: model) { request, error in
//                //Here we get the first result of the Classification Observation result.
//                guard let firstResult = (request.results as? [VNClassificationObservation])?.first else { return }
//
//                let confidenceFloatValue = (Float(firstResult.confidence.description) ?? -0.99) * 100
//                let confidenceStringValue = NSString(format: "%.2f", confidenceFloatValue)
//
//                emotionText = "Emotion: " + firstResult.identifier
//                confidenceText = "Confidence: " + (confidenceStringValue as String) + "%"
//                detailText = "ML Model Checked"
//            }])
        

        }
    
    func checkEmotionsWithPriyaModel(_ cgImage: CGImage) -> EmotionResults {
        // https://github.com/priya-dwivedi/face_and_emotion_detection
        // https://medium.com/apple-developer-academy-federico-ii/emotion-detection-with-apple-technologies-b782beaa5c44
         
        var emotionText = ""
        var confidenceText = ""
        var detailText = ""
        var confidenceRawFloat = Float(-99)
        
        try? VNImageRequestHandler(cgImage: cgImage, orientation: .right, options: [:]).perform([VNCoreMLRequest(model: priyaModel) { request, error in
                       
            //Here we get the first result of the Classification Observation result.
            guard let firstResult = (request.results as? [VNClassificationObservation])?.first else { return }
        
            let confidenceRawData = firstResult.confidence.description
            confidenceRawFloat = Float(confidenceRawData) ?? Float(-99)
            let confidenceFloatBy100 = (confidenceRawFloat ?? -0.9999) * 100
            let confidenceStringForDisplay = String(format: "%.6f", confidenceFloatBy100)

            emotionText = "Emotion: " + firstResult.identifier
            confidenceText = "Confidence: " + confidenceStringForDisplay + "%"
            detailText = "ML Model Checked"
        
        }])
        
        let result = EmotionResults(emotionText: emotionText, confidenceText: confidenceText, confidenceRaw: confidenceRawFloat ?? 0, detailText: detailText)
        
        return result
    }
    
    func checkEmotionsWithCnnModel(_ cgImage: CGImage) -> EmotionResults {
        // https://betterprogramming.pub/emotion-classification-and-face-detection-using-arkit-and-coreml-6f4582363e7d
        
        var emotionText = ""
        var confidenceText = ""
        var detailText = ""
        var confidenceRawFloat = Float(-99)
        
        try? VNImageRequestHandler(cgImage: cgImage, orientation: .right, options: [:]).perform([VNCoreMLRequest(model: cnnModel) { request, error in
                       
            //Here we get the first result of the Classification Observation result.
            guard let firstResult = (request.results as? [VNClassificationObservation])?.first else { return }
        
            let confidenceRawData = firstResult.confidence.description
            confidenceRawFloat = Float(confidenceRawData) ?? Float(-99)
            let confidenceFloatBy100 = (confidenceRawFloat ?? -0.9999) * 100
            let confidenceStringForDisplay = String(format: "%.6f", confidenceFloatBy100)

            emotionText = "Emotion: " + firstResult.identifier
            confidenceText = "Confidence: " + confidenceStringForDisplay + "%"
            detailText = "ML Model Checked"
        
        }])
        
        let result = EmotionResults(emotionText: emotionText, confidenceText: confidenceText, confidenceRaw: confidenceRawFloat ?? 0, detailText: detailText)
        
        return result
    }
    
    struct EmotionResults {
        var emotionText: String
        var confidenceText: String
        var confidenceRaw: Float
        var detailText: String
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(image:
//                UIImage(selectedImage))
//    }
//}






                
