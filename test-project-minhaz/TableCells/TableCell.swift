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
    var myLoading : UIActivityIndicatorView? = nil
    
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
        myImageView?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        myImageView?.setBorderWithColor(.lightGray, borderWidth: 1, cornderRadius: 10.0)
        
        let gap = 10.0 as CGFloat
        let topMarginForLabel = 15 as CGFloat
        let labelX = (myImageView?.frame.origin.x)! + (myImageView?.frame.size.width)! + gap
        let labelWidth = CELL_WIDTH - labelX - CELL_CONTENT_MARGIN
        let labelHeight = CELL_HEIGHT - topMarginForLabel * 2.0
        let labelFrame = CGRect(x: labelX, y: topMarginForLabel, width: labelWidth, height: labelHeight)
        myLabel = UILabel(frame: labelFrame)
        myLabel?.numberOfLines = 0
        myLabel?.lineBreakMode = .byWordWrapping
        self.contentView.addSubview(myLabel!)
//        myLabel?.setBorderWithColor(.green, borderWidth: 1)
        
        myLoading = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        myLoading?.center = CGPoint(x: imageWidth/2.0, y: imageWidth/2.0)
        myImageView?.addSubview(myLoading!)
        myLoading?.hidesWhenStopped = true
        myLoading?.stopAnimating()
    }
}

class NoDeliveryItemCell: UITableViewCell {
    var lblTitle : UILabel? = nil
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let frame = CGRect(x: 0, y: 0, width: 320, height: 50)
        lblTitle = UILabel(frame: frame)
        lblTitle?.autoresizingMask = []
        lblTitle?.textAlignment = .center
        lblTitle?.lineBreakMode = .byWordWrapping
        lblTitle?.numberOfLines = 0
        lblTitle?.text = "No Items to deliver...\nPull down to refresh the list."
        self.addSubview(lblTitle!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        lblTitle?.center = CGPoint(x: self.contentView.frame.size.width/2, y: self.contentView.frame.size.height*0.4)
    }
}

class LoadingCell: UITableViewCell {
    
    var loadingIndicator : UIActivityIndicatorView? = nil
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingIndicator?.autoresizingMask = []
        self.addSubview(loadingIndicator!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        loadingIndicator?.center = CGPoint(x: self.contentView.frame.size.width/2, y: self.contentView.frame.size.height*0.4)
    }
}

func deliveryItemCellWithIdentifier(identifier: String) -> DeliveryItemCell {
    let cell = DeliveryItemCell(style: .default, reuseIdentifier: identifier)
    return cell
}

func noDeliveryItemCellForTable(tableView: UITableView) -> NoDeliveryItemCell {
    let identifier = "NoDelivery"
    var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? NoDeliveryItemCell
    if cell == nil {
        cell = NoDeliveryItemCell(style: .default, reuseIdentifier: identifier)
    }
    return cell!
}

func heightForNoDeliveryItemForTableView(tableView: UITableView) -> CGFloat {
    return tableView.frame.size.height
}

func loadingCellForTableView(tableView: UITableView) -> LoadingCell {
    let identifier = "Loading_Cell"
    var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? LoadingCell
    if cell == nil {
        cell = LoadingCell(style: .default, reuseIdentifier: identifier)
    }
    return cell!
}


