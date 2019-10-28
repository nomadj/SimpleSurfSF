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
    var dayArray : [String] = []
    var daysOnly : [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    var JSONDate = ""
    var pickedTime = ""
    var pickedLocation = ""
    var pickedDay = ""
    let baseURL = "http://api.spitcast.com/api/spot/forecast/"
    let lindaMarForecast = "http://api.spitcast.com/api/spot/forecast/120/"
    let princetonJettyForecast = "http://api.spitcast.com/api/spot/forecast/123/"
    let parameters = ["dcat" : "week"]
    var spotJSON : JSON = []
    var surfJSON : JSON = []
    var dayInteger = 0
    var timeInteger = 0
    var loopVar = 1
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

            return dayArray.count
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
            let currentDate = NSDate()
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateStyle = DateFormatter.Style.full
            var convertedDate = dateFormatter.string(from: currentDate as Date)
            dateFormatter.dateFormat = "EEE"
            convertedDate = dateFormatter.string(from: currentDate as Date)
            dayArray.append(convertedDate)
            while dayArray.count < 7 {
                let tomorrow = Calendar.current.date(byAdding: .day, value: loopVar, to: currentDate as Date)
                convertedDate = dateFormatter.string(from: tomorrow as! Date)
                dayArray.append(convertedDate)
                loopVar += 1
            }
            return dayArray[row]
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
            pickedDay = dayArray[row]
            dayInteger = row * 24
            updateSurfData(json: spotJSON)
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
        let jsonInt = dayInteger + timeInteger
        if let waveHeight = json[jsonInt]["size"].int {
            let daypicked = json[jsonInt]["day"]
            let hour = json[jsonInt]["hour"]
            let spot = json[jsonInt]["spot_name"]
            
            label.text = "Wave Height: \(waveHeight) feet\nDay: \(daypicked)\nTime: \(hour)\nLocation: \(spot)"
        }
        else {
            label.text = "Fuck!!"
        }
        
    }
}

