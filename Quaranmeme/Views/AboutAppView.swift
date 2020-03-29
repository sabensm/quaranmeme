//
//  AboutAppView.swift
//  Quaranmeme
//
//  Created by Mike Sabens on 3/26/20.
//  Copyright © 2020 Slip3 Studios. All rights reserved.
//

import SwiftUI

struct AboutAppView: View {
    var body: some View {
        VStack {
           Text("Staying at home due to COVID-19 is tough. But memes are fun. I wanted an app that with one click could bring some fun in otherwise difficult times. So I built it.")
            .font(.headline)
            .fontWeight(.semibold)
            .lineLimit(nil)
            .multilineTextAlignment(.leading)
            .frame(width: 500, height: 500, alignment: .center)
            .padding(.bottom)
            Text("I'm not sure how often, if at all I will update this, but if you have ideas on how to improve it, visit the Github repo or my Twitter")
                .font(.subheadline)
                .fontWeight(.medium)
            .lineLimit(nil)
            .multilineTextAlignment(.leading)
        }
        
    }
}

struct AboutAppView_Previews: PreviewProvider {
    static var previews: some View {
        AboutAppView()
    }
}
