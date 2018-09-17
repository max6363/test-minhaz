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

class ItemsToDeliverVC: UIViewController, UITableViewDataSource, UITableViewDelegate, APIDataDelegate, UIScrollViewDelegate {

    var items : [Dictionary<String, Any>] = []
    var theTableView : UITableView? = nil
    var refreshControl : UIRefreshControl? = nil
    
    var offset = 1
    var limit = DEFAULT_LIMIT
    
    // Loading
    var loading : MBProgressHUD? = nil
    
    // API Sequence Number
    var API_sequence_number = 0
    
    // Flag
    var hasDataRequested : Bool = false
    var shouldAllowLoadMore : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        API_sequence_number = 0
        
        // set title
        self.title = "All Deliveries"
        
        // Tableview
        self.addTableView()
        
        // Refresh View
        self.addPullToRefreshView()
        
        // reset request parameters
        self.resetRequestParams()
        
        // request data
        self.fetchAllItems(showLoading: true, offset_value: offset, limit_value: limit, isLoadMore: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK:- Action Events
extension ItemsToDeliverVC {
    
    @objc func onRefreshControlAction() {
        
        // reet request params
        resetRequestParams()
        
        // set refreshing status
        refreshControl?.setText(text: "Refreshing...")
        
        // fetch items without loading view
        self.fetchAllItems(showLoading: false, offset_value: offset, limit_value: limit, isLoadMore: false)
    }
}

// MARK:- Setup
extension ItemsToDeliverVC {
    
    func addTableView()
    {
        CELL_WIDTH = self.view.frame.width
        theTableView = UITableView(frame: self.view.bounds, style: .plain)
        theTableView?.separatorStyle = .none
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
}


//MARK: - UITableViewDataSource

extension ItemsToDeliverVC {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // For No-Item State
        if items.count == 0 {
            return heightForNoDeliveryItemForTableView(tableView: tableView)
        }
        // Item cell height
        return CELL_HEIGHT
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // For No-Item State
        if items.count == 0 {
            return 1
        }
        // Do not allow if error comes
        if shouldAllowLoadMore == false {
            return items.count
        }
        // Adding 1 for loading cell at the end of list
        return items.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // check item count
        // show table state based on items availability
        
        if items.count == 0 {
            
            // "No-Delivery" cell when no items available
            let cell = noDeliveryItemCellForTable(tableView: tableView)
            return cell
            
        } else {
            
            if items.count > 0 && indexPath.row == items.count {
                
                // loading cell
                let cell = loadingCellForTableView(tableView: tableView)
                cell.loadingIndicator?.startAnimating()
                return cell
                
            } else {
                
                let cellIdentifier = "cell"
                
                // reuse cell (if available)
                var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? DeliveryItemCell
                if cell == nil {
                    cell = deliveryItemCellWithIdentifier(identifier: cellIdentifier) as DeliveryItemCell
                }
                
                // delivery object
                let object = self.items[indexPath.row]
                cell?.setDeliveryDataWithObject(object: object, indexPath: indexPath)
                
                return cell!
            }
        }
    }
}

// MARK:- API Calling & Response Handling
extension ItemsToDeliverVC {
    
    func startLoading()
    {
        if loading == nil {
            loading = MBProgressHUD.showAdded(to: self.view, animated: true)
        } else {
            loading?.show(animated: true)
        }
        loading?.mode = .indeterminate
        loading?.label.text = "Loading"
    }
    
    func stopLoading()
    {
        loading?.hide(animated: true)
    }
    
    func stopLoadingWithErrorMessage(message: String)
    {
        if loading == nil {
            loading = MBProgressHUD.showAdded(to: self.view, animated: true)
        } else {
            loading?.show(animated: true)
        }
        loading?.mode = .text
        loading?.label.text = message
        loading?.hide(animated: true, afterDelay: 2)
    }
    
    func resetRequestParams()
    {
        offset = 1
        limit = DEFAULT_LIMIT
        shouldAllowLoadMore = true
        hasDataRequested = false
    }
    
    func nextOffset() {
        offset = offset + limit
    }
    
    // MARK:- Fetch Data
    func fetchAllItems(showLoading: Bool, offset_value: Int, limit_value: Int, isLoadMore: Bool) {
        
        // increase number
        API_sequence_number += 1
        
        if showLoading == true {
            // start loading
            self.startLoading()
        }
        
        let api_obj = APIData()
        api_obj.delegate = self
        api_obj.isLoadMore = isLoadMore
        api_obj.tag = API_sequence_number
        api_obj.getAllDeliveriesWithOffset(offset_value, limit: limit_value)
    }
    
    // MARK:- APIDataDelegate
    func didReceiveResponse(response: DataResponse<Any>, api_object: APIData) {
        
        if api_object.isLoadMore {
            hasDataRequested = false
        }
        print("--> SEQ : \(API_sequence_number)   TAG : \(api_object.tag)")
        if API_sequence_number == api_object.tag {
            
            // stop refreshing (only if need to be)
            if (self.refreshControl?.isRefreshing)! {
                self.refreshControl?.endRefreshing()
            }
            
            if api_object.isLoadMore == false {
                // remove all objects
                self.items.removeAll()
            }
            
            if ((response.error) != nil) {
                print("error: \(response.error?.localizedDescription ?? "")")
                let message = response.error?.localizedDescription
                self.stopLoadingWithErrorMessage(message: message!)
                shouldAllowLoadMore = false
            }
            else {
                // stop loading
                self.stopLoading()
                
                // assign item if refreshing
                if api_object.isLoadMore == false {
                    // response
                    self.items = response.value as! [Dictionary<String, Any>]
                    
                } else {
                    // append items if load-more
                    for item in response.value as! [Dictionary<String, Any>] {
                        self.items.append(item)
                    }
                }
            }
            
            // reload table
            self.reloadTableView()
        }
    }
    
    func reloadTableView()
    {
        theTableView?.reloadData()
    }
}


// MARK:- UIScrollViewDelegate

extension ItemsToDeliverVC {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if !scrollView.isDragging {
            self.scrollViewStoppedScrolling()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollViewStoppedScrolling()
        }
    }
    
    func scrollViewStoppedScrolling()
    {
        self.callAPIForNextPage()
    }
    
    func callAPIForNextPage()
    {
        let page = (items.count / limit) as Int - 1
        let contentOffset = Int((theTableView?.contentOffset.y)!)
        let v = Int((theTableView?.frame.size.height)!)
        if contentOffset >= (page * v) {
            
            if hasDataRequested == false && shouldAllowLoadMore == true {
                hasDataRequested = true
                
                self.nextOffset()
                self.fetchAllItems(showLoading: false, offset_value: offset, limit_value: limit, isLoadMore: true)
            }
        }
    }
}

// MARK:- UITableViewDelegate
extension ItemsToDeliverVC {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if items.count > 0 && indexPath.row < items.count {
            
            let object = self.items[indexPath.row]
            let vc = DeliveryDetailsVC()
            vc.automaticallyAdjustsScrollViewInsets = true
            vc.deliveryObject = object
            vc.myIndexPath = indexPath
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
