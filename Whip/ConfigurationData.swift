//
//  ConfigurationData.swift
//  
//
//  Created by Christopher Katnic on 5/19/15.
//
//

import Foundation
import UIKit
public class ConfigurationData {
    
    var red_float: CGFloat!
    var green_float: CGFloat!
    var blue_float: CGFloat!
    var contrast: CGFloat!
    var rgb_color: UIColor!
    
    
    
    
    func update_colors(red: Float, green: Float, blue: Float, con: Float)
        {
            self.red_float = CGFloat(red)
            self.green_float = CGFloat(green)
            self.blue_float = CGFloat(blue)
            self.contrast = CGFloat(con)
            self.rgb_color = UIColor(red:red_float, green:green_float, blue:blue_float, alpha:1.0)
        
        }

    init(){
        self.update_colors(1.0, green: 1.0, blue: 1.0, con: 0.5)
    }
    
    
     func update_with_existing_data(data: [String]){
        var n = NSNumberFormatter()
        
        self.update_colors(n.numberFromString(data[0])!.floatValue, green: n.numberFromString(data[1])!.floatValue, blue: n.numberFromString(data[2])!.floatValue, con: n.numberFromString(data[3])!.floatValue)
        
        
    }
}