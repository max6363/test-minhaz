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
    
    func setBorderWithColor(_ color: UIColor, borderWidth: CGFloat, cornderRadius: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornderRadius
    }
    
    func copyView<T: UIView>() -> T {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
    }
}

extension UIRefreshControl {
    
    func setText(text: String) {
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        let attr_string = NSAttributedString(string: text, attributes: attributes)
        self.attributedTitle = attr_string
    }
}
