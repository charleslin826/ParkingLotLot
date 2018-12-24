//
//  ViewController.swift
//  ParkingLotLot
//
//  Created by CharlesLin on 2018/12/17.
//  Copyright © 2018 CharlesLin. All rights reserved.
//

import UIKit

var valueToPass = ["","","",""]
class ViewController: UIViewController {
    //    @IBOutlet weak var countrySearch: UISearchBar!
    var order = 0
    var searching = false
    @IBOutlet weak var tblView: UITableView!
    var refreshControl: UIRefreshControl!
    var searchController: UISearchController!
    var cities = [String]()
//    var searchArr: [String] = [String](){
//        didSet {
//            self.tblView.reloadData()
//        }
//    }
    
    var dataSource = [parkingLot]()
    var searchArrDict = [parkingLot](){
        didSet {
            print("searchArrDict _ self.tblView.reloadData() , searchArrDict=\(searchArrDict)")
            self.tblView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestParkingInfo()
        configureSearchController()
        addRefreshDataListener()
    }
    
    let baseUrl = URL(string: "http://data.ntpc.gov.tw/api/v1/rest/datastore/382000000A-000225-002")
    
    @objc func getData() {
    requestParkingInfo()
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
    }
    
    func addRefreshDataListener(){
        //add refresh listener
        refreshControl = UIRefreshControl()
        self.tblView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(getData), for: UIControl.Event.valueChanged)
    }
    
    func configureSearchController() {
        // 建立 UISearchController 並設置搜尋控制器為 nil
        self.searchController = UISearchController(searchResultsController: nil)
        
        // 將更新搜尋結果的對象設為 self
        self.searchController.searchResultsUpdater = self
        
        // 搜尋時是否隱藏 NavigationBar
        self.searchController.hidesNavigationBarDuringPresentation = true
        
        // 搜尋時是否使用燈箱效果 (會將畫面變暗以集中搜尋焦點)
        self.searchController.dimsBackgroundDuringPresentation = true
        
        // 搜尋框的樣式
        self.searchController.searchBar.searchBarStyle = .prominent
        
        // 將搜尋框擺在 tableView 的 header
        self.tblView.tableHeaderView = searchController.searchBar
        
        // 設置搜尋框的尺寸為自適應與 tableView 的 header 一致
        searchController.searchBar.sizeToFit()
    }
    
    @objc func requestParkingInfo() {
        var lot = parkingLot()
        
        let request = URLRequest(url: baseUrl!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            //            print("The data size of info which is fetched from randomUser's api => \(data)")
            
            if error != nil {
                print("ERROR HERE..")
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    //                    print("Transfer data to the json => \(json)")
                    
                    enum FetchUserError: Error {
                        case invalidObject, missingTotal, missingImageUrl, missingEmail
                    }
                    
                    guard let dictionary = json as? [String: Any] else {
                        throw FetchUserError.invalidObject
                    }
                    
                    guard let objectObj = dictionary["result"] as? [String: Any] else {
                        throw FetchUserError.invalidObject
                    }
                    
                    //                    guard let recordTotal = objectObj["total"] as? Int  else {
                    //                        throw FetchUserError.missingTotal
                    //                    }
                    //                    print(recordTotal)
                    
                    
                    if let recordArr = objectObj["records"] as? [[String: Any]] {
                        //                        dump(recordArr)
                        
                        for value in recordArr {
                            if let Area = value["AREA"] as? String{
                                lot.area = Area

                                if !self.cities.contains(Area){ self.cities.append(Area) }
                            }
                            
                            if let Time = value["SERVICETIME"] as? String{
                                lot.time = Time
                            }
                            
                            if let Name = value["NAME"] as? String{
                                //                                print(Area)
                                lot.name = Name
                            }
                            
                            if let Address = value["ADDRESS"] as? String{
                                //                                print(Area)
                                lot.address = Address
                            }
                            self.dataSource.append(lot)
                            
                        } // end for loop
                        
                        //GCD - update UI table view
                        DispatchQueue.main.async {
                            self.tblView.reloadData()
                            print(self.cities)
                        }
                        
                    }else{
                        throw FetchUserError.invalidObject
                    }
                } catch let error {
                    print(error)
                }
            }
        }
        task.resume()
        
    }
}
