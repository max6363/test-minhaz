//
//  DeliveryDetailsVC.swift
//  test-project-minhaz
//
//  Created by Minhaz on 14/09/18.
//

import UIKit
import MapKit

class DeliveryDetailsVC: UIViewController, MKMapViewDelegate {

    var deliveryObject: Dictionary<String, Any>? = nil
    var descriptionView: UIView? = nil
    var myIndexPath : IndexPath? = nil
    
    private var myImageView : UIImageView? = nil
    private var myLabel : UILabel? = nil
    private var myLabelSubtitle : UILabel? = nil
    private var myLoading : UIActivityIndicatorView? = nil
    
    private var myMapView: MKMapView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
        // Details: Title
        self.title = "Details"
        
        // initial setup
        self.setupMapView()
        
        let y = (myMapView?.frame.origin.y)! + (myMapView?.frame.size.height)! + 10
        let f = CGRect(x: 0, y: y, width: CELL_WIDTH, height: CELL_HEIGHT)
        descriptionView = UIView(frame: f)
        self.view.addSubview(descriptionView!)
        descriptionView?.setBorderWithColor(.gray, borderWidth: 1)
        
        self.detailSetup()
        self.setDeliveryDataWithObject(object: self.deliveryObject!, indexPath: self.myIndexPath!)
        
        self.updateMap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- Setup Map
extension DeliveryDetailsVC {
    
    func setupMapView()
    {
        let width = self.view.frame.size.width
        let y = self.navigationController?.navigationBar.frame.size.height
        let f = CGRect(x: 0, y: y! + 20, width: width, height: width)
        myMapView = MKMapView(frame: f)
        self.view.addSubview(myMapView!)
//        myMapView?.setBorderWithColor(.red, borderWidth: 2)
    }
     func detailSetup()
     {
        let imageWidth = CELL_HEIGHT - CELL_CONTENT_MARGIN * 2.0
        let frame = CGRect(x: CELL_CONTENT_MARGIN, y: CELL_CONTENT_MARGIN, width: imageWidth, height: imageWidth)
        myImageView = UIImageView(frame: frame)
        myImageView?.contentMode = .scaleAspectFill
        myImageView?.clipsToBounds = true
        self.descriptionView?.addSubview(myImageView!)
        myImageView?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        myImageView?.setBorderWithColor(.lightGray, borderWidth: 1, cornderRadius: 10.0)
        
        let gap = 10.0 as CGFloat
        
        var topMarginForLabel = 20 as CGFloat
        let labelX = (myImageView?.frame.origin.x)! + (myImageView?.frame.size.width)! + gap
        let labelWidth = CELL_WIDTH - labelX - CELL_CONTENT_MARGIN
        let labelHeight = 25 as CGFloat
        
        var labelFrame = CGRect(x: labelX, y: topMarginForLabel, width: labelWidth, height: labelHeight)
        myLabel = UILabel(frame: labelFrame)
        myLabel?.font = UIFont(name: "HelveticaNeue", size: 20)
        myLabel?.numberOfLines = 0
        myLabel?.lineBreakMode = .byWordWrapping
        self.descriptionView?.addSubview(myLabel!)
        
        let gap_between_labels = 5 as CGFloat
        let detailLabelHeight = 25 as CGFloat
        
        topMarginForLabel = topMarginForLabel + labelHeight + gap_between_labels
        labelFrame = CGRect(x: labelX, y: topMarginForLabel, width: labelWidth, height: detailLabelHeight)
        myLabelSubtitle = UILabel(frame: labelFrame)
        myLabelSubtitle?.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        myLabelSubtitle?.numberOfLines = 0
        myLabelSubtitle?.lineBreakMode = .byWordWrapping
        self.descriptionView?.addSubview(myLabelSubtitle!)
        
        myLoading = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        myLoading?.center = CGPoint(x: imageWidth/2.0, y: imageWidth/2.0)
        myImageView?.addSubview(myLoading!)
        myLoading?.hidesWhenStopped = true
        myLoading?.stopAnimating()
    }
    
    func setDeliveryDataWithObject(object: Dictionary<String, Any>, indexPath: IndexPath)
    {
        // set description
        let description = object["description"] as? String
        //        self.myLabel?.text = "\(indexPath.row + 1): \(description ?? "")"
        self.myLabel?.text = description
        
        let urlString = object["imageUrl"] as? String
        let url = URL(string: urlString!)
        
        // cancel previous image loading
        self.myImageView?.af_cancelImageRequest()
        // set image nil
        self.myImageView?.image = nil
        // start animating (before image begin downloading)
        self.myLoading?.startAnimating()
        // set image from url (now download starts)
        self.myImageView?.af_setImage(withURL: url!, placeholderImage: nil, filter:  nil, progress: { (Progress) in
            
        }, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.crossDissolve(0.2), runImageTransitionIfCached: true, completion: { (image) in
            
            // stop loading indicator
            self.myLoading?.stopAnimating()
        })
        
        let location = object["location"] as! Dictionary<String, Any>
        let address = location["address"] as! String
        self.myLabelSubtitle?.text = address
    }
}

//MARK:- MKMapViewDelegate
extension DeliveryDetailsVC {
    
    func updateMap()
    {
        let location_obj = self.deliveryObject!["location"] as! Dictionary<String, Any>
        let address = location_obj["address"] as! String
        let lattitude = location_obj["lat"] as! NSNumber
        let longitude = location_obj["lng"] as! NSNumber
        let coord = CLLocationCoordinate2D(latitude: CLLocationDegrees(lattitude.doubleValue), longitude: CLLocationDegrees(longitude.doubleValue))
        
        let center = coord
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        myMapView?.setRegion(region, animated: true)
        
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = coord
        myAnnotation.title = address
        myMapView?.addAnnotation(myAnnotation)
    }
}
