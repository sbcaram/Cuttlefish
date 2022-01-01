//
//  SophiaSmiling.swift
//  Landscapes
//
//  Created by Sophia Caramanica on 11/28/21.
//

import SwiftUI

struct SophiaSmiling: View {
    var image: Image

    var body: some View {
        image
            .resizable()
            .frame(width: 430, height: 600)
            .clipped()
       
    }
}

struct SophiaSmiling_Previews: PreviewProvider {
    static var previews: some View {
        SophiaSmiling(image: Image("SophiaSmiling"))
    }
}


