//
//  AboutAppView.swift
//  Quaranmeme
//
//  Created by Mike Sabens on 3/26/20.
//  Copyright © 2020 Slip3 Studios. All rights reserved.
//

import SwiftUI

struct AboutAppView: View {
    
    @ObservedObject var viewRouter: ViewRouter
    
    var gitHubURL = "https://github.com/sabensm/quaranmeme"
    var twitterURL = "https://twitter.com/mgsabens"
    
    var body: some View {
        VStack {
           Text("Being stuck at home all day due to COVID-19 is no fun. Looking at memes is fun. I wanted to learn a bit about macOS development, so I made this app. It just shows you random memes right in your menu bar. Nothing more, nothing less.")
                .font(.headline)
                .fontWeight(.semibold)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .frame(width: 500, height: 100, alignment: .center)
                .padding(.all, 16)
            Text("I probably won't update the app itself anytime soon, but will continue to add fresh new memes. If you want to contribute and add more functionality or fix bugs head over to Github. If you have memes you want to see in the app, reach out on Twitter.")
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .frame(width: 500, height: 100, alignment: .top)
            HStack(spacing: 50) {
                Button(action : {
                    self.openExternalWebpage(siteURL: self.gitHubURL)
                }) {
                    Image("GitHub")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                }.buttonStyle(PlainButtonStyle())
                Button(action : {
                    self.openExternalWebpage(siteURL: self.twitterURL)
                }) {
                    Image("Twitter")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                }.buttonStyle(PlainButtonStyle())
            }
            .padding(.bottom, 30)
            Button(action : {
                self.viewRouter.currentPage = "page1"
            }) {
                Text("Bring me back to the memes!")
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            Spacer()
        }
        
    }
    
    func openExternalWebpage(siteURL: String) {
        if let url = URL(string: siteURL) {
            NSWorkspace.shared.open(url)
        }
    }
}

struct AboutAppView_Previews: PreviewProvider {
    static var previews: some View {
        AboutAppView(viewRouter: ViewRouter())
    }
}
