//
//  UIView+Utils.swift
//  test-project-minhaz
//
//  Created by Minhaz on 15/09/18.
//

import Foundation
import UIKit

extension UIView {
    
    func setBorderWithColor(_ color: UIColor) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 1
    }
    
    func setBorderWithColor(_ color: UIColor, borderWidth: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = borderWidth
    }
    
}
