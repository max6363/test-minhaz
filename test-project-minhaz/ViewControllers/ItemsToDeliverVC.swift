//
//  ItemsToDeliverVC.swift
//  test-project-minhaz
//
//  Created by Minhaz on 14/09/18.
//

import UIKit
import Alamofire
import AlamofireImage
import MBProgressHUD

class ItemsToDeliverVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var items : [Dictionary<String, Any>] = []
    var theTableView : UITableView? = nil
    var refreshControl : UIRefreshControl? = nil
    
    var offset = 1
    var limit = 20
    
    // Loading
    var loading : MBProgressHUD? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // set title
        self.title = "All Deliveries"
        
        // Tableview
        self.addTableView()
        
        // Refresh View
        self.addPullToRefreshView()
        
        // request data
        self.fetchAllItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addTableView()
    {
        CELL_WIDTH = self.view.frame.width
        theTableView = UITableView(frame: self.view.bounds, style: .plain)
        theTableView?.autoresizingMask =
            [
                .flexibleTopMargin,
                .flexibleLeftMargin,
                .flexibleRightMargin,
                .flexibleBottomMargin,
                .flexibleWidth,
                .flexibleHeight
            ]
        self.view.addSubview(theTableView!)
        theTableView!.setBorderWithColor(.blue, borderWidth: 3)
     
        // set table delegate
        theTableView?.dataSource = self
        theTableView?.delegate = self
        
        // reload table
        self.reloadTableView()
    }
    
    func addPullToRefreshView()
    {
        let f = CGRect(x: 0, y: 0, width: (theTableView?.frame.size.width)!, height: 50)
        refreshControl = UIRefreshControl(frame: f)
        refreshControl?.addTarget(self, action: #selector(onRefreshControlAction), for: .valueChanged)
        theTableView?.addSubview(refreshControl!)
    }
    
    func reloadTableView()
    {
        theTableView?.reloadData()
    }
    
    func startLoading()
    {
        loading = MBProgressHUD.showAdded(to: self.view, animated: true)
        loading?.mode = .indeterminate
        loading?.label.text = "Loading"
    }
    
    func stopLoading()
    {
        loading?.hide(animated: true)
    }
    
    // MARK:- Refresh Control
    @objc func onRefreshControlAction() {
        
    }

    // MARK:- Fetch Data
    
    func fetchAllItems() {
     
        // start loading
        self.startLoading()
        
        let myURLString : String = "http://localhost:8080/deliveries?offset=\(offset)&limit=\(limit)"
        let url = URL(string: myURLString)!
        let urlRequest = URLRequest(url: url)
        Alamofire.request(urlRequest)
            .responseJSON { response in

                // stop loading
                self.stopLoading()
                
                // remove all objects
                self.items.removeAll()
                
                if ((response.error) != nil) {
                    print("error: \(response.error?.localizedDescription ?? "")")
                }
                else {
                    // response
                    self.items = response.value as! [Dictionary<String, Any>]
                    print("array: ",self.items)
                }
                
                // reload table
                self.reloadTableView()
        }
    }
    
    // MARK:- UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CELL_HEIGHT
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? DeliveryItemCell
        if cell == nil {
            cell = deliveryItemCellWithIdentifier(identifier: cellIdentifier) as DeliveryItemCell
        }
        
        let object = self.items[indexPath.row]
        
        cell?.myLabel?.text = object["description"] as? String
        
        let urlString = object["imageUrl"] as? String
        let url = URL(string: urlString!)
        
        cell?.myImageView?.af_setImage(withURL: url!, placeholderImage: nil, filter:  nil, progress: { (Progress) in
            
        }, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.crossDissolve(0.2), runImageTransitionIfCached: true, completion: { (image) in
            
        })
        
        return cell!
    }
    
    
    // MARK:- UITableViewDelegate
    
    
}
