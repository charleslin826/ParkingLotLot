//
//  DetailViewController.swift
//  ParkingLotLot
//
//  Created by CharlesLin on 2018/12/17.
//  Copyright © 2018 CharlesLin. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var Map: MKMapView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 開始設定地圖
        getCoordinate(valueToPass[3]) { (location) in
            guard let location = location else { return }
            let xScale:CLLocationDegrees = 0.01
            let yScale:CLLocationDegrees = 0.01
            let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: xScale, longitudeDelta: yScale)
            let region:MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
            self.Map.setRegion(region, animated: true)
            self.Map.isZoomEnabled = true
            
            // 設定地圖標記，標題為公司名稱，副標題為公司地址
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = "\(valueToPass[1])"
            annotation.subtitle = "\(valueToPass[3])"
            self.Map.addAnnotation(annotation)
            
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
