//
//  ViewController.swift
//  BluetoothTest
//
//  Created by Rajat Tyagi on 21/07/20.
//  Copyright © 2020 Rajat Tyagi. All rights reserved.
//

import UIKit
import CoreBluetooth
import AVFoundation

class ViewController: UIViewController , CBPeripheralDelegate, CBCentralManagerDelegate{
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
    var peripherals = Array<CBPeripheral>()
    var audioPlayer = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "LP", ofType: "mp3")!))
            createBackgroundAudioSession()
        }
        
        catch{
            print(error)
        }
        
    }
    
        private func createBackgroundAudioSession() {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.allowAirPlay, .defaultToSpeaker, .allowBluetooth, .allowBluetoothA2DP])
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print(error)
            }
            
            var outputVolumeObserve: NSKeyValueObservation? = AVAudioSession.sharedInstance().observe(\.outputVolume) { (audioSession, changes) in
                print("New volume: \(changes.newValue)")
            }
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
        if peripheral.name == "MI Band 2" {
            self.centralManager.connect(self.peripheral, options: nil)
            self.centralManager.stopScan()
        }

        
    }
    

    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == self.peripheral {
            print("Connected to your device: \(String(describing: peripheral.name))")
//            print("Connected to Service : \(String(describing: peripheral.services))")

        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print(error ?? peripheral.services)
        peripheral.services?.forEach { service in
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print(error ?? service.characteristics)
        service.characteristics?.forEach { characteristic in
            if characteristic.properties.contains(.read) {
                peripheral.readValue(for: characteristic)
            }
            if characteristic.properties.contains(.notify) {
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
     
//    private func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
//        print("Services:\(String(describing: peripheral.services)) and error\(String(describing: error))")
//        if let services = peripheral.services {
//            for service in services {
//                print(service)
//            }
//        }
//    }
    
    @IBAction func playTapped(_ sender: Any) {
        audioPlayer.play()
    }
    @IBAction func pauseTapped(_ sender: Any) {
        if audioPlayer.isPlaying {
            audioPlayer.pause()
        }
    }
    
}

