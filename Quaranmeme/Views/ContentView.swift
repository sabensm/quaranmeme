//
//  ContentView.swift
//  Quaranmeme
//
//  Created by Mike Sabens on 3/25/20.
//  Copyright © 2020 Slip3 Studios. All rights reserved.
//

import SwiftUI
import AppKit

struct MyButtonStyle: ButtonStyle {
    var color: Color = .green
    
    public func makeBody(configuration: MyButtonStyle.Configuration) -> some View {
        
        configuration.label
            .foregroundColor(.white)
            .padding(15)
            .background(RoundedRectangle(cornerRadius: 5).fill(color))
            .compositingGroup()
            .shadow(color: .black, radius: 3)
            .opacity(configuration.isPressed ? 0.5 : 1.0)
    }
}

struct ContentView: View {
    
    let arrayOfImages = ["image0", "image1", "image2", "image3", "image4", "image5"]
    
    func getRandomImage() {
        let random = arrayOfImages.randomElement()!
        
        meme = random
    }
    
    @State private var meme = "image3"
    
    var body: some View {
        VStack() {
            HStack() {
                Text("quaranMEME")
                    .font(Font.custom("norwester", size: 48))
                    .padding(.top, 16)
            }
            Image(meme)
                .resizable()
                .scaledToFit()
                .shadow(color: .black, radius: 3)
                .border(Color.black, width: 2.0)
                .padding(12)
            Button(action : {
                self.getRandomImage()
            }) {
                Text("Get Fresh Meme!")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            .buttonStyle(MyButtonStyle(color: .blue))
            .padding(.bottom, 16)
            HStack {
                Button(action : {
                    NSApplication.shared.terminate(self)
                }) {
                    Text("Quit")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                Button(action : {
                    print("Learn about this app")
                }) {
                    Text("About")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
            }.padding(.bottom, 18)
        }
        .onAppear(perform: getRandomImage)
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
