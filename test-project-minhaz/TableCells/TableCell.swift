//
//  TableCell.swift
//  test-project-minhaz
//
//  Created by Minhaz on 15/09/18.
//

import Foundation
import UIKit

class DeliveryItemCell: UITableViewCell {
    
    var myImageView : UIImageView? = nil
    var myLabel : UILabel? = nil
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let imageWidth = CELL_HEIGHT - CELL_CONTENT_MARGIN * 2.0
        let frame = CGRect(x: CELL_CONTENT_MARGIN, y: CELL_CONTENT_MARGIN, width: imageWidth, height: imageWidth)
        myImageView = UIImageView(frame: frame)
        myImageView?.contentMode = .scaleAspectFill
        myImageView?.clipsToBounds = true
        self.contentView.addSubview(myImageView!)
//        myImageView?.setBorderWithColor(.red, borderWidth: 2)
        
        let gap = 10.0 as CGFloat
        let topMarginForLabel = 20 as CGFloat
        let labelX = (myImageView?.frame.origin.x)! + (myImageView?.frame.size.width)! + gap
        let labelWidth = CELL_WIDTH - labelX - CELL_CONTENT_MARGIN
        let labelHeight = CELL_HEIGHT - topMarginForLabel * 2.0
        let labelFrame = CGRect(x: labelX, y: topMarginForLabel, width: labelWidth, height: labelHeight)
        myLabel = UILabel(frame: labelFrame)
        self.contentView.addSubview(myLabel!)
        myLabel?.setBorderWithColor(.green, borderWidth: 1)
    }
}

func deliveryItemCellWithIdentifier(identifier: String) -> DeliveryItemCell {
    let cell = DeliveryItemCell(style: .default, reuseIdentifier: identifier)
    return cell
}
