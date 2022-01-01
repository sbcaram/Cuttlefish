//
//  PictureProcess.swift
//  Landscapes
//
//  Created by Sophia Caramanica on 11/28/21.
//

//import SwiftUI
//import ARKit
//import Vision
//
//struct PictureProcess: View {
//    var image: Image
//    @State var emotionText = ""
//    @State var confidenceText = ""
//    @State var detailText = ""
//    @State var imageName = "SophiaSmiling"
//    private let model = try! VNCoreMLModel(for: CNNEmotions().model)
//
//    var body: some View {
//        VStack {
//            Button("Check Emotion", action: processClick)
////            SophiaSmiling(image: Image("SophiaSmiling"))
//            Text(emotionText)
//            Text(confidenceText)
//            Text(detailText)
//        }
//    }
//
//    func processClick() {
//        detailText = "button was clicked"
//        checkEmotions()
//    }
//    func checkEmotions() {
//        // let means constant - won't change
//        // var means variable - will change
//
//        var uiImage = UIImage(named: imageName)
//
//        var cgImg = (uiImage?.cgImage)!
//
//        try? VNImageRequestHandler(cgImage: cgImg, orientation: .right, options: [:]).perform([VNCoreMLRequest(model: model) { request, error in
//                //Here we get the first result of the Classification Observation result.
//                guard let firstResult = (request.results as? [VNClassificationObservation])?.first else { return }
//
//                emotionText = "Emotion: " + firstResult.identifier
//                confidenceText = "Confidence: " + firstResult.confidence.description + "%"
//                detailText = "ML Model Checked"
//            }])
//        }
//
//}
//
//
//
//
//struct PictureProcess_Previews: PreviewProvider {
//    static var previews: some View {
//        PictureProcess(image: Image("SophiaSmiling"))
//    }
//}
