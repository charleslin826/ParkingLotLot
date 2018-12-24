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
            print("searchController : \(searchController)")
            return searchArrDict.count//searchArr.count
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
            order += 1
            print("cellForRowAt & self.searchController.isActive \(order) \(searchArrDict)")
            print("indexPath.row = \(indexPath.row)")
            name.text = searchArrDict[indexPath.row].name//searchArr[indexPath.row]
            area.text = searchArrDict[indexPath.row].area
            time.text = searchArrDict[indexPath.row].time
            address.text = searchArrDict[indexPath.row].address
            print(searchArrDict[indexPath.row])

        } else {
//            print("self.searchController.is ＮＯＴ Active => \(searchArrDict) indexPath.row = \(indexPath.row)")
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
            print("你選擇的是 \(searchArrDict[indexPath.row])")
        }
        order += 1
        print("didSelectRowAt \(order)")
        
        valueToPass[0] = (dataSource[indexPath.row].area)
        valueToPass[1] = (dataSource[indexPath.row].name)
        valueToPass[2] = (dataSource[indexPath.row].time)
        valueToPass[3] = (dataSource[indexPath.row].address)
        //        print(valueToPass)
    }
    
    
}


extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // 取得搜尋文字
        guard let searchText = searchController.searchBar.text else {
            return
        }
        
        
        searchArrDict = dataSource.filter{ ($0.area.contains(searchText)) }
        print("searchArrDict = \(searchArrDict)")
        
        
        
        
        
//        searchArr = cities.filter { (city) -> Bool in
//            return city.contains(searchText)
//        }
//        print(searchArr)
    }
}
//
//extension ViewController: UISearchBarDelegate {
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        order += 1
//        print("searchBar \(order)")
//        searching = true
//          searchArr = cities.filter(
//            {
//                $0.prefix(searchText.count) == searchText
//            }
//        )
//
//
//
//    }
//
//
//
//}




//extension ViewController: UITableViewDataSource {
//    func tableView(tableView: UITableView,
//                   numberOfRowsInSection section: Int) -> Int {
//        if (self.searchController.active) {
//            return self.searchArr.count
//        } else {
//            return self.cities.count
//        }
//    }
//
//    func tableView(tableView: UITableView,
//                   cellForRowAtIndexPath indexPath: NSIndexPath)
//        -> UITableViewCell {
//            let cell =
//                tableView.dequeueReusableCellWithIdentifier(
//                    "Cell", forIndexPath: indexPath)
//
//            if (self.searchController.active) {
//                cell.textLabel?.text =
//                    self.searchArr[indexPath.row]
//                return cell
//            } else {
//                cell.textLabel?.text =
//                    self.cities[indexPath.row]
//                return cell
//            }
//    }
//}
//
//extension ViewController: UITableViewDelegate {
//    func tableView(tableView: UITableView,
//                   didSelectRowAtIndexPath indexPath: NSIndexPath){
//        tableView.deselectRowAtIndexPath(
//            indexPath, animated: true)
//        if (self.searchController.active) {
//            print(
//                "你選擇的是 \(self.searchArr[indexPath.row])")
//        } else {
//            print(
//                "你選擇的是 \(self.cities[indexPath.row])")
//        }
//    }
//}

//extension ViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//
//    }
//
//    func updateSearchResultsForSearchController(searchController: UISearchController){
//        // 取得搜尋文字
//        guard let searchText =
//            searchController.searchBar.text else {
//                return
//        }
//
//        // 使用陣列的 filter() 方法篩選資料
//        self.searchArr = self.cities.filter(
//            { (city) -> Bool in
//                // 將文字轉成 NSString 型別
//                let cityText:NSString = city
//
//                // 比對這筆資訊有沒有包含要搜尋的文字
//                return (cityText.rangeOfString(
//                    searchText, options:
//                    NSStringCompareOptions.CaseInsensitiveSearch).location)
//                    != NSNotFound
//        })
//    }
//}


