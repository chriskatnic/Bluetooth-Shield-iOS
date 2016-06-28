//
//  ViewController.swift
//  Whip
//
//  Created by Christopher Katnic on 5/19/15.
//  Copyright (c) 2015 Christopher Katnic. All rights reserved.
//

import UIKit


//TODO: Save configuration in bundle, load configuration from bundle
class ViewController: UIViewController, PassbackProtocol {

    @IBOutlet weak var output_label: UILabel!
    @IBOutlet weak var color_display: UILabel!
    
    //configuration data, shared among all view controllers
    var config: ConfigurationData?
    let config_data_file = LocalFileInBundle()
    
    
    //initialize
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load from previous!
        if(config == nil)
        {
            config = ConfigurationData()
            //If you have had the app before, and the file exists, read
            if config_data_file.file_exists()
            {
                var existing_data = config_data_file.read_config_data()
                config!.update_with_existing_data(existing_data)
                
                print("Loading info from file\n")
                
            }
        }
    }

    //deinit
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //prepare for segue, and set self as delegate object for dest
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationVC = segue.destinationViewController as? ColorChoiceViewController{
            destinationVC.config = self.config
            destinationVC.delegate = self
        }
        if let destinationVC = segue.destinationViewController as? BluetoothScanViewController{
            destinationVC.config = self.config
            destinationVC.delegate = self
        }
        
    }
    
    
    func set_configuration_data(data: ConfigurationData) {
        
        //update local config
        self.config = data
        
        //update config file
        config_data_file.update_file_contents_with_config(data)
        config_data_file.write_config_data()
    }
    
    
    
    
    
    
    
    

}

