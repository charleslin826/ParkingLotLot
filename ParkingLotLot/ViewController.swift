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
    
    var countryNameArr = [] as [String]
    
//    var searchedCountry = [String]()
//    var searching = false
//    @IBOutlet weak var countrySearch: UISearchBar!
    @IBOutlet weak var tblView: UITableView!
    
    var refreshControl: UIRefreshControl!
    
    var searchController: UISearchController!
    var searchArr: [String] = [String](){
        didSet {
            // 重設 searchArr 後重整 tableView
            self.tblView.reloadData()
        }
    }
    
    var dataSource = [parkingLot]()
    var areaSubset = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        countrySearch.delegate = self
        requestParkingInfo()
        
        //add refresh listener
        refreshControl = UIRefreshControl()
        self.tblView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(getData), for: UIControl.Event.valueChanged)

        // 建立 UISearchController 並設置搜尋控制器為 nil
        searchController = UISearchController(searchResultsController: nil)
        
        // 將更新搜尋結果的對象設為 self
        searchController.searchResultsUpdater = self
        
        // 搜尋時是否隱藏 NavigationBar
        // 這個範例沒有使用 NavigationBar 所以設置什麼沒有影響
        searchController.hidesNavigationBarDuringPresentation = false
        
        // 搜尋時是否使用燈箱效果 (會將畫面變暗以集中搜尋焦點)
        searchController.dimsBackgroundDuringPresentation = false
        
        // 搜尋框的樣式
        searchController.searchBar.searchBarStyle = .prominent
        
        // 設置搜尋框的尺寸為自適應
        // 因為會擺在 tableView 的 header
        // 所以尺寸會與 tableView 的 header 一樣
        searchController.searchBar.sizeToFit()
        
        // 將搜尋框擺在 tableView 的 header
        self.tblView.tableHeaderView = searchController.searchBar
        
    }
    
    let baseUrl = URL(string: "http://data.ntpc.gov.tw/api/v1/rest/datastore/382000000A-000225-002")
    
    @objc func getData() {
    requestParkingInfo()
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
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
                                self.areaSubset.append(Area)
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
//                            print(self.areaSubset)
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

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if searching {
//            return searchedCountry.count
        if (searchController.isActive) {
            return searchArr.count
        } else {
            return dataSource.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell")
        
        let area = cell?.viewWithTag(1) as! UILabel
        let name = cell?.viewWithTag(2) as! UILabel
        let time = cell?.viewWithTag(3) as! UILabel
        let address = cell?.viewWithTag(4) as! UILabel
        
        
//        if searching {
//            cell?.textLabel?.text = searchedCountry[indexPath.row]
        if (searchController.isActive) {
            name.text = searchArr[indexPath.row]
//            return cell
        } else {
            area.text = dataSource[indexPath.row].area
            name.text = dataSource[indexPath.row].name
            time.text = dataSource[indexPath.row].time
            address.text = dataSource[indexPath.row].address
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        if (searchController.isActive) {
            print("你選擇的是 \(searchArr[indexPath.row])")
        }
        valueToPass[0] = (dataSource[indexPath.row].area)
        valueToPass[1] = (dataSource[indexPath.row].name)
        valueToPass[2] = (dataSource[indexPath.row].time)
        valueToPass[3] = (dataSource[indexPath.row].address)
//        print(valueToPass)
    }
    
    
}
//
//extension ViewController: UISearchBarDelegate {
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        searchedCountry = areaSubset.filter(
//            {
//                $0.prefix(searchText.count) == searchText
//            }
//        )
//        searching = true
//        tblView.reloadData()
//    }
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searching = false
//        searchBar.text = ""
//        tblView.reloadData()
//    }
//
//}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // 取得搜尋文字
        guard let searchText = searchController.searchBar.text else {
            return
        }
        
        searchArr = areaSubset.filter { (city) -> Bool in
            return city.contains(searchText)
        }
    }
}
