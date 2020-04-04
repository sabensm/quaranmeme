//
//  ViewRouter.swift
//  Quaranmeme
//
//  Created by Mike Sabens on 3/28/20.
//  Copyright © 2020 Slip3 Studios. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class ViewRouter: ObservableObject {
    
    let objectWillChange = PassthroughSubject<ViewRouter,Never>()
    
    var currentPage: String = "page1" {
        didSet {
            withAnimation() {
                objectWillChange.send(self)
            }
        }
    }
    
}
