//
//  ViewController.swift
//  BluetoothTest
//
//  Created by Rajat Tyagi on 21/07/20.
//  Copyright © 2020 Rajat Tyagi. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController , CBPeripheralDelegate, CBCentralManagerDelegate{
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
    var peripherals = Array<CBPeripheral>()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if (central.state == .poweredOn){
            print("Central state update")
            if central.state != .poweredOn {
                print("Central is not powered on")
            }
            self.centralManager?.scanForPeripherals(withServices: nil, options: nil)
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {

        if !peripherals.contains(peripheral) {
            let localName = peripheral.name
            print("\(String(describing: localName))" )
            peripherals.append(peripheral)

        }
        self.peripheral = peripheral
               self.peripheral.delegate = self
        if peripheral.name == "OnePlus Bullets Wireless Z" {
            self.centralManager.connect(self.peripheral, options: nil)
            self.centralManager.stopScan()
        }

        
    }
    

    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == self.peripheral {
            print("Connected to your \(String(describing: peripheral.name))")
        
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                print("Service : \(service)")
            }
        }
    }

}

