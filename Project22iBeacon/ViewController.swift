//
//  ViewController.swift
//  Project22iBeacon
//
//  Created by Ana Caroline de Souza on 27/02/20.
//  Copyright © 2020 Ana e Leo Corp. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var distanceReading: UILabel!
    var locationManager: CLLocationManager?
    @IBOutlet var circleView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        circleView.layer.cornerRadius = 128
        circleView.backgroundColor = .black
        
        view.backgroundColor = .gray
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
        
    }
    
    func startScanning(){
        
        guard let uuid = UUID(uuidString: "unique beancon here ex: 43FDH13-D1231D-FSDV1-CQDFQ3-GQWDFQED3") else {
            return
        }
        
        let beaconRegion = CLBeaconRegion(uuid: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
        
        
    }

    func update(distance: CLProximity){
        UIView.animate(withDuration: 1) {
            switch distance {
            case .far:
                self.view.backgroundColor = .blue
                self.distanceReading.text = "FAR"
                self.circleView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
                self.circleView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            case .immediate:
                self.view.backgroundColor = .red
                self.distanceReading.text = "RIGHT HERE"
                self.circleView.transform = CGAffineTransform(scaleX: 1, y: 1)
            default:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
                self.circleView.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            let ac = UIAlertController(title: "Beacon Found", message: "the beacon distance is being updated", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac,animated: true)
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }
    
}

