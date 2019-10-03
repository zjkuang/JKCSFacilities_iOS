//
//  UIImageExtensions.swift
//  ImagePickerSwiftUI
//
//  Created by Zhengqian Kuang on 2019-09-25.
//  Copyright © 2019 Zhengqian Kuang. All rights reserved.
//

import UIKit

public extension UIImage {

    // https://stackoverflow.com/a/49916464/7455975
    func upOrientationImage() -> UIImage? {
        switch imageOrientation {
        case .up:
            return self
            
        default:
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            draw(in: CGRect(origin: .zero, size: size))
            let result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return result
        }
    }

}
