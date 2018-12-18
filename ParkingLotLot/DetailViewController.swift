//
//  DetailViewController.swift
//  ParkingLotLot
//
//  Created by CharlesLin on 2018/12/17.
//  Copyright © 2018 CharlesLin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DetailViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var Map: MKMapView!
    var myLocationManager :CLLocationManager!
    
    
    var lotTitle = ["區域","停車場名稱","營業時間","地址"]
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return valueToPass.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.detailTextLabel?.text = valueToPass[indexPath.row]
        cell?.textLabel?.text = lotTitle[indexPath.row]
        return cell!
    }
    
    func getCoordinate(_ address:String, completion: @escaping (CLLocationCoordinate2D?) -> ()) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            guard error == nil else {
                print("error: \(error)")
                completion(nil)
                return
            }
            completion(placemarks?.first?.location?.coordinate)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 首次使用 向使用者詢問定位自身位置權限
        if CLLocationManager.authorizationStatus()
            == .notDetermined {
            // 取得定位服務授權
            myLocationManager.requestWhenInUseAuthorization()
            
            // 開始定位自身位置
            myLocationManager.startUpdatingLocation()
        }
            // 使用者已經拒絕定位自身位置權限
        else if CLLocationManager.authorizationStatus()
            == .denied {
            // 提示可至[設定]中開啟權限
            let alertController = UIAlertController(
                title: "定位權限已關閉",
                message:
                "如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟",
                preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "確認", style: .default, handler:nil)
            alertController.addAction(okAction)
            self.present(
                alertController,
                animated: true, completion: nil)
        }
            // 使用者已經同意定位自身位置權限
        else if CLLocationManager.authorizationStatus()
            == .authorizedWhenInUse {
            // 開始定位自身位置
            myLocationManager.startUpdatingLocation()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // 停止定位自身位置
        myLocationManager.stopUpdatingLocation()
    }

    
    func locationManager(manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        // 印出目前所在位置座標
        let currentLocation :CLLocation =
            locations[0] as CLLocation
        print("\(currentLocation.coordinate.latitude)")
        print(", \(currentLocation.coordinate.longitude)")
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 建立一個 CLLocationManager
        myLocationManager = CLLocationManager()
        
        // 設置委任對象
        myLocationManager.delegate = self
        
        // 距離篩選器 用來設置移動多遠距離才觸發委任方法更新位置
        myLocationManager.distanceFilter =
        kCLLocationAccuracyNearestTenMeters
        
        // 取得自身定位位置的精確度
        myLocationManager.desiredAccuracy =
        kCLLocationAccuracyBest
        
        
        // 開始設定地圖
        getCoordinate(valueToPass[3]) { (location) in
            guard let location = location else { return }
            let xScale:CLLocationDegrees = 0.01
            let yScale:CLLocationDegrees = 0.01
            let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: xScale, longitudeDelta: yScale)
            let region:MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
            self.Map.setRegion(region, animated: true)
            self.Map.showsUserLocation = true
            self.Map.isZoomEnabled = true
            
            // 設定地圖標記，標題為公司名稱，副標題為公司地址
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = "\(valueToPass[1])"
            annotation.subtitle = "\(valueToPass[3])"
            self.Map.addAnnotation(annotation)
            
//            locationManager(manager: myLocationManager, didUpdateLocations: location)

        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
