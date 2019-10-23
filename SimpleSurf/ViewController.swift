//
//  ViewController.swift
//  SimpleSurf
//
//  Created by Bryan Albert on 12/23/18.
//  Copyright © 2018 Bryan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    //MARK: Class variables
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var label: UILabel!
    
    let model = Model()
    let surfSpot = ["LM", "HMB", "OB", "Bol", "PP", "Hook", "Jacks", "SL"]
    //let surfSpot = ["Linda Mar", "Princeton Jetty", "OB - Sloat", "Bolinas", "Pleasure Point", "The Hook", "Jack's House", "Steamers"]
    let time = ["6am", "7am", "8am", "9am", "10am", "11am", "12pm", "1pm", "2pm", "3pm", "4pm", "5pm", "6pm", "7pm", "8pm"]
    var day : [String] = []
    var dayParsed : [String] = []
    var dayArray : [[String]] = [[]]
    var daysOnly : [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    var JSONDate = ""
    var pickedTime = ""
    var pickedLocation = ""
    let baseURL = "http://api.spitcast.com/api/spot/forecast/"
    let lindaMarForecast = "http://api.spitcast.com/api/spot/forecast/120/"
    let princetonJettyForecast = "http://api.spitcast.com/api/spot/forecast/123/"
    let parameters = ["dcat" : "week"]
    var spotJSON : JSON = []
    var surfJSON : JSON = []
//    let URL = "https://www.ncdc.noaa.gov/cdo-web/api/v2/locations/FIPS:06"
//    let token = ["token" : "CzEuEErYJEOTbkIeRYSSCiRXntQTKEMx"]
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
       
        picker.dataSource = self
        picker.delegate = self
        pickedTime = time[0]
        pickedLocation = surfSpot[0]
        print(pickedTime)
        print(pickedLocation)
        getData(url: lindaMarForecast, parameters: parameters)
    }
    
    //MARK: pickerView protocol methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return surfSpot.count
        }
        else if component == 1 {

            return daysOnly.count
        }
        else {
            return time.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return surfSpot[row]
        }
            //TODO: populate component 1 and 2 with JSON data
        else if component == 1 {
            
            return daysOnly[row]
        }
        else {
            return time[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if component == 0 {
            pickedLocation = surfSpot[row]
            let finalURL = baseURL + "\(model.spotID(spot: pickedLocation))"
            getData(url: finalURL, parameters: parameters)
        }
            
        // TODO: enable component 1
        else if component == 2 {
            pickedTime = time[row]
            updateSurfData(json: spotJSON)
//            let finalURL = baseURL + "\(model.spotID(spot: pickedLocation))"
//            getData(url: finalURL, parameters: parameters)
        }
        
        else {
            
        }
    }
    //MARK: API Request
    func getData(url: String, parameters: [String : String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
                if response.result.isSuccess {
                    
                    self.surfJSON = JSON(response.result.value!)
                    
                    self.spotJSON = self.surfJSON
                    
                    print(self.surfJSON)
                    self.updateSurfData(json: self.surfJSON)
                    
                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.label.text = "Connection Issues"
                }
        }
    }
    //MARK: Data Update
    func updateSurfData(json : JSON) {
        
        if let waveHeight = json[model.timeIndex(time: pickedTime)]["size"].int {
            let hour = json[model.timeIndex(time: pickedTime)]["hour"]
            let spot = json[model.timeIndex(time: pickedTime)]["spot_name"]
            var JSONInt = 0
    
            while JSONInt < 144 {
                JSONInt += 24
                day.append(json[JSONInt]["day"].string!)
            }
            for date in day {
                self.dayParsed = (date.components(separatedBy: " "))
                dayArray.append(self.dayParsed)
            }
            dayArray.remove(at: 0)
            for array in dayArray {
                if daysOnly.count < 7 {
                    daysOnly.append(array[0])
                }
            }
            label.text = "Wave Height: \(waveHeight) feet \nTime: \(hour) \nLocation: \(spot)"
        }
        else {
            label.text = "Fuck!!"
        }
        
    }
}

