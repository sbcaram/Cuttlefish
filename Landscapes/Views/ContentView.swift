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
import MLKit

struct ContentView: View {
    
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var isImagePickerDisplay = false
    @State private var showingAlert = false
    
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
    
    @State var alertTitleText = ""
    @State var alertMessageText = ""
    
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
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitleText),
                      message: Text(alertMessageText),
                      dismissButton: .default(Text("OK")))
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
    
    func detectFacesViaGoogle(uiImage: UIImage) {

      // Create a face detector with options.
      // [START config_face]
      let options = FaceDetectorOptions()
      options.landmarkMode = .all
      options.classificationMode = .all
      options.performanceMode = .accurate
      options.contourMode = .all
      // [END config_face]
      // [START init_face]
      let faceDetector = FaceDetector.faceDetector(options: options)
      // [END init_face]
      // Initialize a `VisionImage` object with the given `UIImage`.
      let visionImage = VisionImage(image: uiImage)
      visionImage.orientation = uiImage.imageOrientation

      // [START detect_faces]
      faceDetector.process(visionImage) { faces, error in
        guard error == nil, let faces = faces, !faces.isEmpty else {
          // [START_EXCLUDE]
          let errorString = error?.localizedDescription ?? "No Faces Found"
          detailText = "Error Occurred: \(errorString)"
          // [END_EXCLUDE]
            
          // If in Foreground - send an alert
          showAlert(titleText: "Cuttlefish Eyes In-App", messageText: "No Faces Found")
            
          return
        }

        // Faces detected
        
        // 1st face
        let face = faces[0]
        let headEulerAngleX = face.hasHeadEulerAngleX ? face.headEulerAngleX.description : "NA"
        let headEulerAngleY = face.hasHeadEulerAngleY ? face.headEulerAngleY.description : "NA"
        let headEulerAngleZ = face.hasHeadEulerAngleZ ? face.headEulerAngleZ.description : "NA"
        let leftEyeOpenProbability = face.hasLeftEyeOpenProbability ? face.leftEyeOpenProbability.description : "NA"
        let rightEyeOpenProbability = face.hasRightEyeOpenProbability ? face.rightEyeOpenProbability.description : "NA"
        let smilingProbability = face.hasSmilingProbability ? face.smilingProbability.description : "NA"
        let output = """
        Frame: \(face.frame)
        Head Euler Angle X: \(headEulerAngleX)
        Head Euler Angle Y: \(headEulerAngleY)
        Head Euler Angle Z: \(headEulerAngleZ)
        Left Eye Open Probability: \(leftEyeOpenProbability)
        Right Eye Open Probability: \(rightEyeOpenProbability)
        Smiling Probability: \(smilingProbability)
        """
          
          if (face.hasSmilingProbability) {
              emotionText = "Smiling"
              
              let confidenceRawData = face.smilingProbability.description
              let confidenceRawFloat = Float(confidenceRawData) ?? Float(-99)
              let confidenceFloatBy100 = confidenceRawFloat * 100
              let confidenceStringForDisplay = String(format: "%.6f", confidenceFloatBy100)
              
              confidenceText = confidenceStringForDisplay
              
              if (confidenceRawFloat < 0.5) {
                  showAlert(titleText: "Cuttlefish Eyes In-App", messageText: "BE AWARE - Person NOT Smiling strongly")
              }
          } else {
              emotionText = "NOT smiling"
              
              showAlert(titleText: "Cuttlefish Eyes In-App", messageText: "BE AWARE - Person NOT Smiling")
          }
          
          detailText = output
        // [END_EXCLUDE]
      }
      // [END detect_faces]
    }
    
    func showAlert(titleText: String, messageText: String) {
        alertTitleText = titleText
        alertMessageText = messageText
        showingAlert = true
    }
    
//    func sendTestNotification() {
//
//        // lock notification - make sure to have phone locked to see this
//        let content = UNMutableNotificationContent()
//        content.title = "Cuttlefish Test Notification"
//        content.subtitle = "Beware of the eyes...."
//        content.sound = UNNotificationSound.default
//
//        // show this notification five seconds from now
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//
//        // choose a random identifier
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//
//        // add our notification request
//        UNUserNotificationCenter.current().add(request)
//
//        // If in Foreground - send an alert
//        showAlert(titleText: "Cuttlefish Test Notification In-App", messageText: "Beware of the eyes....")
//    }
    
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






                
