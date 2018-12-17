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
    
    var searchedCountry = [String]()
    var searching = false
    @IBOutlet weak var countrySearch: UISearchBar!
    @IBOutlet weak var tblView: UITableView!
    
    var dataSource = [parkingLot]()
    var areaSubset = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countrySearch.delegate = self
        requestRandomUser()
    }
    
    let baseUrl = URL(string: "http://data.ntpc.gov.tw/api/v1/rest/datastore/382000000A-000225-002")
    
    func requestRandomUser() {
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
        if searching {
            return searchedCountry.count
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
        
        
        if searching {
            cell?.textLabel?.text = searchedCountry[indexPath.row]
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
        valueToPass[0] = (dataSource[indexPath.row].area)
        valueToPass[1] = (dataSource[indexPath.row].name)
        valueToPass[2] = (dataSource[indexPath.row].time)
        valueToPass[3] = (dataSource[indexPath.row].address)
//        print(valueToPass)
    }
    
    
}

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedCountry = areaSubset.filter(
            {
                $0.prefix(searchText.count) == searchText
            }
        )
        searching = true
        tblView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tblView.reloadData()
    }
    
}

