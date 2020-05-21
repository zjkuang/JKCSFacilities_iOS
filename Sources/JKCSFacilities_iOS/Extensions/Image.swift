//
//  Image.swift
//  
//
//  Created by Zhengqian Kuang on 2020-05-21.
//

import SwiftUI

extension Image {
    enum ImageName {
        case inBundle(imageName: String)
        case system(systemName: String)
    }
    
    init(imageName: ImageName) {
        switch imageName {
        case .inBundle(let name):
            self.init(name)
        case .system(let systemName):
            self.init(systemName: systemName)
        }
    }
}
