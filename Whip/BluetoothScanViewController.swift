//
//  BluetoothScanViewController.swift
//  Whip
//
//  Created by Christopher Katnic on 5/19/15.
//  Copyright (c) 2015 Christopher Katnic. All rights reserved.
//




//TODO: Select which device you want to connect with
//      Check to see if there is a way to get names with devices after connecting


import UIKit
import CoreBluetooth

class BluetoothScanViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate{
    
    @IBOutlet weak var toggle_button: UIButton!
    @IBOutlet weak var output_label: UILabel!
    @IBOutlet weak var scan_button: UIButton!
    @IBOutlet weak var stop_button: UIButton!
    
    //ID to connect to shield, service for UART, characteristic for tx
    let BLE_ID = NSUUID(UUIDString: "D3F79759-15F2-27B4-CE4F-5BEBFFE32E60")
    let UART_SERVICE = NSUUID(UUIDString: "713D0000-503E-4C75-BA94-3148F18D941E")
    
    
    var central_manager_object: CBCentralManager!
    var desired_peripheral: CBPeripheral!
    var rx_characteristic: CBCharacteristic!
    
    var num_devices: Int = 0
    
    
    var config: ConfigurationData?
    var delegate: PassbackProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // initializations
        num_devices = 0
        output_label.text = "Output"
        central_manager_object = CBCentralManager(delegate:self, queue:nil)
        scan_button.enabled = true
        stop_button.enabled = false

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func peripheralManagerDidUpdateState(_peripheral: CBPeripheralManager!){
        switch(_peripheral.state){
        case .PoweredOn:
            print("Peripheral On")
        default:
            print("Peripheral state: \(_peripheral.state)")
        }
    }
    
    //this function allows the view controller to be a cbcentralmanagerdelegate
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        print("Checking state...\n")
        
        switch (central.state){
        case .PoweredOff:
            output_label.text = "Bluetooth hardware is off...\n"
        
        case .PoweredOn:
            output_label.text = "Bluetooth hardware is on...\n"
            
        case .Resetting:
            output_label.text = "Hardware resetting...\n"
            
        case .Unauthorized:
            output_label.text = "Unauthorized state...\n"
        
        case .Unsupported:
            output_label.text = "Unsupported state...\n"
        
        case .Unknown:
            output_label.text = "Unknown state...\n"
            
        }
    }
    
    
    //Delegation
    func sync_data_with_delegate(){
        self.delegate!.set_configuration_data(config!)
    }
    
    override func viewWillDisappear(animated: Bool) {
        sync_data_with_delegate()
    }
    
    
    @IBAction func scan_pressed(sender: UIButton) {
        output_label.text = "Scan starting...\n"
        print("Scan starting...\n")
        //TODO: Connect to specific hardware instead of nil
        central_manager_object.scanForPeripheralsWithServices(nil, options: nil)
        scan_button.enabled = false
        stop_button.enabled = true
    }
    
    //must use ! to unwrap
    @IBAction func stop_pressed(sender: UIButton) {
        output_label.text = "\(output_label.text!)Scan stopped\n"
        print("Scan stopped!\n")
        central_manager_object.stopScan()
        scan_button.enabled = true
        stop_button.enabled = false
    }
    
    //what happens when a peripheral is discovered?
    //TODO: Send connection request to the bluetooth reciever
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        
        
        output_label.text = "Found Device \(peripheral.name)\n"
        print("Name: \(peripheral.name)\nID: \(peripheral.identifier)\n")
        
        
        if peripheral.identifier == BLE_ID
        {
            
            print("found BLE Shield!\n")
            central.stopScan()
            central.connectPeripheral(peripheral, options: nil)
            desired_peripheral = peripheral
            desired_peripheral.delegate = self
        }
        
    }
    
    
    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
        print("Connected to Peripheral!\n")
        //0x17002a100
        peripheral.discoverServices(nil)
        
    }
    
    func centralManager(central: CBCentralManager!, didFailToConnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        print("\nError: \(error)")
    }
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        print("Discovered services\n")
            if let actualError = error{
                print("Error\n")
            }
            else {
                for service in peripheral.services as! [CBService]{
                    if service.UUID.UUIDString == BLE_DEVICE_SERVICE_UUID                        {peripheral.discoverCharacteristics(nil, forService: service)}
                }

            }
        }
    

    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!)
    
    {
        print("\nDiscovered characteristics for service: \(service.UUID.UUIDString)\n")
        output_label.text = output_label.text!.stringByAppendingString("\nDiscovered characteristics for service: \(service.UUID.UUIDString)\n")
        if let actualError = error{
            print("found error\n")
        }
        else {
            print("Characteristics:\n")
            for characteristic in service.characteristics as! [CBCharacteristic]{
                print("\(characteristic.UUID)\n")
                output_label.text = output_label.text!.stringByAppendingString("\(characteristic.UUID.UUIDString)\n")
                    peripheral.readValueForCharacteristic(characteristic)
            
                if characteristic.UUID.UUIDString == BLE_DEVICE_RX_UUID
                {
                    print("Found RX char\n")
                    rx_characteristic = characteristic
                }
            }
        }
            
        }
    


    //write function that will toggle the pin from high to low on peripheral
    
    @IBAction func toggle()
    {
        var io = [1]
        var send_data: NSData = NSData(bytes:io, length: 1)

        
        desired_peripheral.writeValue(send_data, forCharacteristic: rx_characteristic, type: CBCharacteristicWriteType.WithoutResponse)
        
        print("Sent toggle\n")
        
    }

    func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        
        if let actualError = error{
            
        }else {
            var data = NSString(data: characteristic.value, encoding: NSUTF8StringEncoding)
            
            if((data) != nil)   {print("\(characteristic.UUID.UUIDString): \(data!)\n")}
            else                {print("NIL for encoding")}
        }
    }

}








    
    

    









