//
//  ParentView.swift
//  Quaranmeme
//
//  Created by Mike Sabens on 3/28/20.
//  Copyright © 2020 Slip3 Studios. All rights reserved.
//

import SwiftUI

struct ParentView: View {
    
    @ObservedObject var viewRouter: ViewRouter
    
    var body: some View {
        VStack {
            if viewRouter.currentPage == "page1" {
                ContentView(viewRouter: viewRouter)
            } else if viewRouter.currentPage == "page2" {
                AboutAppView(viewRouter: viewRouter)
                    .transition(.slide)
            }
        }
    }
}

struct ParentView_Previews: PreviewProvider {
    static var previews: some View {
        ParentView(viewRouter: ViewRouter())
    }
}
