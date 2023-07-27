//
//  BluetoothDevices.swift
//  bluetooth
//
//  Created by Muhammad Waqar on 27/07/2023.
//

import Foundation
import CoreBluetooth

@objc(BluetoothDevices) class BluetoothDevices: NSObject, CBCentralManagerDelegate {
  private var centralManager: CBCentralManager!
  
  @objc static func requiresMainQueueSetup() -> Bool {
    return true
  }
  
  @objc public func fetchBluetoothDevices(
    _ callback: @escaping RCTResponseSenderBlock
  ) {
    // Initialize the CoreBluetooth central manager
    centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
    
    // Empty array to store the discovered devices
    var devices: [String] = []
    
    // Callback function to pass the list of devices to React Native
    let sendDevices = {
      callback([devices])
    }
    
    // Callback function when Bluetooth scanning is finished
    let scanCompletion = { (error: Error?) in
      if error != nil {
        // Handle any error if necessary
        print("Error scanning for Bluetooth devices: \(error!.localizedDescription)")
      }
      // Call the sendDevices callback to pass the list of devices to React Native
      sendDevices()
    }
    
    // Start scanning for Bluetooth devices
    centralManager.scanForPeripherals(withServices: nil, options: nil)
    
    // Schedule a timer to stop scanning after a specific duration (e.g., 10 seconds)
    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
      // Stop scanning after 10 seconds
      self.centralManager.stopScan()
      
      // Call the scanCompletion callback when scanning is finished
      scanCompletion(nil)
    }
  }
  
  // MARK: - CBCentralManagerDelegate Methods
  
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    // This delegate method is called when the central manager's state changes.
    // You can check the state to ensure Bluetooth is powered on before initiating any scanning.
    if central.state == .poweredOn {
      // Bluetooth is ready to use, you can initiate scanning here if necessary.
    } else {
      // Bluetooth is not available or powered off.
      // Handle the situation accordingly if needed.
    }
  }
}

