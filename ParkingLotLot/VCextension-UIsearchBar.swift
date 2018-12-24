//
//  VCextension-UIsearchBar.swift
//  ParkingLotLot
//
//  Created by CharlesLin on 2018/12/24.
//  Copyright © 2018 CharlesLin. All rights reserved.
//

import UIKit


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchController.isActive) {
            return searchArrDict.count
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
        if (searchController.isActive) {
            name.text = searchArrDict[indexPath.row].name
            area.text = searchArrDict[indexPath.row].area
            time.text = searchArrDict[indexPath.row].time
            address.text = searchArrDict[indexPath.row].address
//            print(searchArrDict[indexPath.row])

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
             valueToPass[0] = searchArrDict[indexPath.row].name
             valueToPass[1] = searchArrDict[indexPath.row].area
             valueToPass[2] = searchArrDict[indexPath.row].time
             valueToPass[3] = searchArrDict[indexPath.row].address
                print("你選擇的是 \(searchArrDict[indexPath.row])")
        }else{
            valueToPass[0] = (dataSource[indexPath.row].area)
            valueToPass[1] = (dataSource[indexPath.row].name)
            valueToPass[2] = (dataSource[indexPath.row].time)
            valueToPass[3] = (dataSource[indexPath.row].address)
        }
    }
    
    
}


extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // 取得搜尋文字
        guard let searchText = searchController.searchBar.text else {
            return
        }
        searchArrDict = dataSource.filter{ ($0.area.contains(searchText)||$0.name.contains(searchText)) }
    }
}

