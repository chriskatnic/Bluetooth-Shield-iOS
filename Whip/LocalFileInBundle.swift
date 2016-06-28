//
//  LocalFileInBundle.swift
//  Whip
//
//  Created by Christopher Katnic on 5/20/15.
//  Copyright (c) 2015 Christopher Katnic. All rights reserved.
//

import Foundation
class LocalFileInBundle: NSObject {
    
    internal var file_contents: [String]
    internal var file_path: String = ""
    internal let file_name: String = "config.txt"
    internal let file_checker = NSFileManager()
    
    
    override init(){
        //array of three, red, green, blue con
        file_contents = ["", "", "", ""]
        
        //find filepath relative to current device
        if let paths: [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]{
            
            //create filepath to file
            file_path = paths[0].stringByAppendingPathComponent(file_name)
        
        }
    }
    
    //init with custom file not named config.txt
    func init_with_file(file_name: String){
        file_contents = ["", "", "", ""]
        if let paths: [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]{
            
            //create filepath to file
            file_path = paths[0].stringByAppendingPathComponent(file_name)
            
        }
    }
    
    //update with configuration data specific to Whip project
    func update_file_contents_with_config(config: ConfigurationData){
        file_contents[0] = config.red_float.description
        file_contents[1] = config.green_float.description
        file_contents[2] = config.blue_float.description
        file_contents[3] = config.contrast.description
        
    }
    
    //take data that we have already gotten, and write to file
    func write_config_data(){
        //create space delimited string to write
        let file_body = "\(file_contents[0]) \(file_contents[1]) \(file_contents[2]) \(file_contents[3])"
        
        //write space delimited string to file
        file_body.writeToFile(file_path, atomically: false, encoding: NSUTF8StringEncoding, error: nil)
        
        print("Completed writing to local data\n")
    }
    
    
    
    //returns array of space delimited strings from file at file_path
    func read_config_data() -> [String]{
        
            //get space delimited float values from flie
            let data_from_file = String(contentsOfFile: file_path, encoding: NSUTF8StringEncoding, error: nil)
        
            var array_of_data = data_from_file!.componentsSeparatedByString(" ")
        
            //return array[4] of red, green, blue, con floats
            if array_of_data.count == 3{
                array_of_data.append("0.5")}
        return array_of_data
    }
    
    
    //checks if file exists at file_path
    func file_exists() -> Bool{
        return file_checker.fileExistsAtPath(file_path)
    }
}