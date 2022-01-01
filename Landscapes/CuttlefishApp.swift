//
//  LandscapesApp.swift
//  Landscapes
//
//  Created by Sophia Caramanica on 11/26/21.
//

import SwiftUI

@main
struct CuttlefishApp: App {
    @StateObject private var modelData = ModelData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}
