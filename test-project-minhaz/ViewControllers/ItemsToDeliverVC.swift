//
//  ItemsToDeliverVC.swift
//  test-project-minhaz
//
//  Created by Minhaz on 14/09/18.
//

import UIKit
import Alamofire

class ItemsToDeliverVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var items = NSMutableArray()
    var theTableView : UITableView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.addTableView()
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
    
    func reloadTableView()
    {
        theTableView?.reloadData()
    }

    // MARK:- Fetch Data
    
    func fetchAllItems() {
        
    }
    
    // MARK:- UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CELL_HEIGHT
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return items.count
        return 25
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = deliveryItemCellWithIdentifier(identifier: cellIdentifier)
        }
        
        return cell!
    }
    
    // MARK:- UITableViewDelegate
    
    
}
