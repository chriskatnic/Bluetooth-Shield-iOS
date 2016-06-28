//
//  ColorChoiceViewController.swift
//  Whip
//
//  Created by Christopher Katnic on 5/19/15.
//  Copyright (c) 2015 Christopher Katnic. All rights reserved.
//
import UIKit


//TODO: Preset colors, save color config as new preset
class ColorChoiceViewController: UIViewController {
    
    @IBOutlet weak var contrast_slider: UISlider!
    @IBOutlet weak var resultant_label: UILabel!
    @IBOutlet weak var red_slider: UISlider!
    @IBOutlet weak var blue_slider: UISlider!
    @IBOutlet weak var green_slider: UISlider!
    var needs_update : Bool = false
    var previous_contrast: Float = 0.0
    
    
    //shared data between 
    var config : ConfigurationData?
    var delegate: PassbackProtocol?

    //init
    override func viewDidLoad() {
        super.viewDidLoad()
        load_config_color()
        previous_contrast = contrast_slider.value
    }
    
    //deinit
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //updates color every time a color slider is slid
    @IBAction func update_resultant_color(sender: UISlider) {
        
        //the needs_update flag is set, so that when
        //the time comes, the delegate is synced
        needs_update = true
        
        
        config!.update_colors(red_slider.value, green: green_slider.value, blue: blue_slider.value, con: contrast_slider.value)
            resultant_label.backgroundColor = config!.rgb_color
    }
    
    @IBAction func adjust_contrast(sender: UISlider){
        
        //whenever contrast moves, move everything else
        //but adjust only by the delta
        needs_update = true
        let delta: Float = sender.value - previous_contrast
        previous_contrast = sender.value
        
            red_slider.value += delta
            green_slider.value += delta
            blue_slider.value += delta
 
        
        config!.update_colors(red_slider.value, green: green_slider.value, blue: blue_slider.value, con: contrast_slider.value)
        resultant_label.backgroundColor = config!.rgb_color
    }
    
    //load color from previous work
    func load_config_color(){
        resultant_label.backgroundColor = config!.rgb_color
        red_slider.value = Float(config!.red_float)
        green_slider.value = Float(config!.green_float)
        blue_slider.value = Float(config!.blue_float)
        contrast_slider.value = Float(config!.contrast)
        
        //initial values loaded, will not update unless values change
        needs_update = false
    }
    
    
    
    func sync_data_with_delegate(){
        if needs_update{
            print("Update required. Syncing with delegate\n")
            self.delegate!.set_configuration_data(config!)}
        else{
            print("Update not required. No sync occurred\n")}
    }
    
    override func viewWillDisappear(animated: Bool) {
        print("Passing back\n")
        sync_data_with_delegate()
    }
    
}
