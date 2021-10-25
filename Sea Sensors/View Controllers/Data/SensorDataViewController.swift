//
//  SensorDataViewController.swift
//  GTSeaLevelAPP
//
//  Created by Johnson Amalanathan on 1/21/20.
//  Copyright © 2020 Georgia Tech. All rights reserved.
//

import UIKit
import Foundation
import MapKit

// MARK: - Structures of Datastream Values
struct Blue: Decodable {
    
    let phenomenonTime : String
    let resultTime : String
    let result : Double
    let Datastream : String
    let FeatureOfInterest : String
    let id : Int
    let selfLink : String
    
    enum CodingKeys: String, CodingKey {
        case phenomenonTime
        case resultTime
        case result
        case Datastream = "Datastream@iot.navigationLink"
        case FeatureOfInterest = "FeatureOfInterest@iot.navigationLink"
        case id = "@iot.id"
        case selfLink = "@iot.selfLink"
    }
}

struct Initial: Decodable {
    let nextLink : String
    let value : [Blue]
    
    enum CodingKeys: String, CodingKey {
        case nextLink = "@iot.nextLink"
        case value
    }
}

class SensorDataViewController: UIViewController {
    // MARK: Outlets
    
    // Height of total view
    @IBOutlet var totalViewHeight: NSLayoutConstraint!
    var totalViewHeightConstant:CGFloat = 1425
    
    // Basic data of the sensor
    @IBOutlet weak var lbl: UILabel! // Name
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var sensorThingsIDLabel: UILabel!
    @IBOutlet weak var deviceIDLabel: UILabel!
    @IBOutlet weak var locationDescriptionLabel: UILabel!
    @IBOutlet weak var sensorNAVD88ElevationLabel: UILabel!
    
    // For each collectionView (datastream), it will show what time the latest update was
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var day2: UILabel!
    @IBOutlet weak var day3: UILabel!
    @IBOutlet weak var day4: UILabel!
    
    // Connects to each collectionView so the data can be presented on there
    @IBOutlet weak var pressureView: UICollectionView!
    @IBOutlet weak var temperatureView: UICollectionView!
    @IBOutlet weak var waterView: UICollectionView!
    @IBOutlet weak var batteryView: UICollectionView!
    
    // Connects to heart button
    @IBOutlet var heartButton: UIBarButtonItem!
    var heartFilled = false
    var image = UIImage()
    
    // Connects to each subtitle for each collectionView
    @IBOutlet weak var firstTitle: UILabel!
    @IBOutlet weak var secondTitle: UILabel!
    @IBOutlet weak var thirdTitle: UILabel!
    @IBOutlet weak var fourthTitle: UILabel!
    
    // Connects to signal and label to displays the status for each sensor
    @IBOutlet weak var signal: UIView!
    @IBOutlet weak var signalDescription: UILabel!
    var signalValue = Double()
    
    // Receives values from the data that is sent to this view controller
    var name = ""
    var sensorThingsID = ""
    var deviceID = ""
    var locationDescription = ""
    var sensorNAVD88Elevation = ""
    var url1Link = "", url1Name = "", url1Description = "", url1Unit = ""
    var url2Link = "", url2Name = "", url2Description = "", url2Unit = ""
    var url3Link = "", url3Name = "", url3Description = "", url3Unit = ""
    var url4Link = "", url4Name = "", url4Description = "", url4Unit = ""
    
    // Variables of the sensor's coordinates
    var coordinate1 = Double()
    var coordinate2 = Double()
    
    // Counts how many values in each datastream
    var v_count = Int()
    var v2_count = Int()
    var v3_count = Int()
    var v4_count = Int()
    
    // Appends each value and time for the first collection view
    var a_time = [String]()
    var a_result = [String]()
    
    // Appends each value and time for the second collection view
    var t_time = [String]()
    var t_result = [String]()
    
    // Appends each value and time for the third collection view
    var w_time = [String]()
    var w_result = [String]()
    
    // Appends each value and time for the fourth collection view
    var b_time = [String]()
    var b_result = [String]()
    var b_resultfix = [String]()
    
    // Formats API time format to normal time format
    var formatter2 = String()
    var simpleTime = String()
    
    // Placeholder variable that holds a value one by one as they are being displayed in collection view
    var url1Value = Double()
    var url2Value = Double()
    var url3Value = Double()
    var url4Value = Double()
    
    // Keeps track of time
    var gameTimer: Timer?
    
    // Used for storing sensors that user favorites
    let defaults = UserDefaults.standard
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uses coordinates to display sensor location
        let annontation = MKPointAnnotation()
        annontation.coordinate = CLLocationCoordinate2D(latitude: coordinate2, longitude: coordinate1)
        mapView.addAnnotation(annontation)
        
        let region = MKCoordinateRegion(center: annontation.coordinate, latitudinalMeters: 250, longitudinalMeters: 250)
        mapView.setRegion(region, animated: true)
        
        // Displays sensor's status
        let shortValue = Double(round(1000*signalValue)/1000)
        
        // Based on actual water level, the status changes
        if shortValue < 1.2 {
            signal.backgroundColor = UIColor.init(red: 52/255, green: 134/255, blue: 255/255, alpha: 1)
            signalDescription.text = "No Warnings: Water Level (\(shortValue) m) < 1.2 m"
        } else if shortValue < 1.5 {
            signal.backgroundColor = UIColor.init(red: 241/255, green: 255/255, blue: 23/255, alpha: 1)
            signalDescription.text = "Warning: Water Level (\(shortValue) m) > 1.2 m"
        } else if shortValue < 100 {
            signal.backgroundColor = UIColor.init(red: 255/255, green: 22/255, blue: 23/255, alpha: 1)
            signalDescription.text = "Severe Warning: Water Level (\(shortValue) m) > 1.5 m"
        } else {
            signal.backgroundColor = UIColor.init(red: 255/255, green: 22/255, blue: 255/255, alpha: 1)
            signalDescription.text = "Air Quality Sensor"
        }
        
        // Tests if user selected this sensor as one of their favorites
        testHeart()
        
        // Every 5 seconds, function runTimedCode will run
        gameTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        
        // Assigns labels to values that have been sent from the UITableView that pertain to this sensor
        lbl.text = "\(name)"
        sensorThingsIDLabel.text = "  \(sensorThingsID)"
        deviceIDLabel.text = "  \(deviceID)"
        locationDescriptionLabel.text = "  \(locationDescription)"
        sensorNAVD88ElevationLabel.text = "  \(sensorNAVD88Elevation)"
        
        locationDescriptionLabel.layoutIfNeeded()
        totalViewHeight.constant = totalViewHeightConstant + (locationDescriptionLabel.bounds.size.height-20.33)
        
        firstTitle.text = url1Name
        secondTitle.text = url2Name
        thirdTitle.text = url3Name
        fourthTitle.text = url4Name
        
        // Connects collection views to page
        pressureView.delegate = self
        pressureView.dataSource = self
        
        temperatureView.delegate = self
        temperatureView.dataSource = self
        
        waterView.delegate = self
        waterView.dataSource = self
        
        batteryView.delegate = self
        batteryView.dataSource = self
        
        // If any datastream contains celsius temperature, it will change to fahrenheit
        if (url1Unit == "degC") {
            url1Unit = "°F"
        }
        
        if (url2Unit == "degC") {
            url2Unit = "°F"
        }
        
        if (url3Unit == "degC") {
            url3Unit = "°F"
        }
        
        if (url4Unit == "degC") {
            url4Unit = "°F"
        }
        
        // MARK: - Parses First Datastream
        guard let url1 = URL(string: url1Link) else {return}
        URLSession.shared.dataTask(with: url1) { (data, response, error) in
            
            guard let data = data else { return }
            
            do {
                let initial = try? JSONDecoder().decode(Initial.self, from: data)
                let v_count = initial?.value.count
                
                // if datastream contains values
                if v_count != nil {
                    for i in 0...v_count!-1 {
                        // Append each value and time to arrays
                        self.a_result.append(String(format:"%f", ((initial?.value[i].result)!)))
                        self.a_time.append((initial?.value[i].phenomenonTime)!)
                    }
                }
                
                
                DispatchQueue.main.async {
                    // If there is a datastream link but no values then print the title of datastream with "- N/A"
                    if self.a_result.count == 0 {
                        self.firstTitle.text = ("\(self.url1Name) - N/A")
                    }
                    
                    // Reloads collection view
                    self.pressureView.reloadData()
                }
                
            }
        }.resume()
        
        
        // MARK: - Parses Second Datastream
        guard let url2 = URL(string: url2Link) else {return}
        URLSession.shared.dataTask(with: url2) { (data1, response, error) in
            
            // If error, print error
            if let error = error {
                print(error)
                return
            }
            
            guard let data2 = data1 else { return }
            
            do {
                let initial2 = try? JSONDecoder().decode(Initial.self, from: data2)
                let v3_count = initial2?.value.count
                
                // if datastream contains values
                if v3_count != nil {
                    for i in 0...v3_count!-1 {
                        // Append each value and time to arrays
                        self.t_result.append(String(format:"%f", ((initial2?.value[i].result)!)))
                        self.t_time.append((initial2?.value[i].phenomenonTime)!)
                    }
                }

                DispatchQueue.main.async {
                    // If there is a datastream link but no values then print the title of datastream with "- N/A"
                    if self.t_result.count == 0 {
                        self.secondTitle.text = ("\(self.url2Name) - N/A")
                    }
                    
                    // Reloads collection view
                    self.temperatureView.reloadData()
                }
            }
        }.resume()
        
        
        // MARK: - Parses Third Datastream
        guard let url3 = URL(string: url3Link) else {return}
        URLSession.shared.dataTask(with: url3) { (data1, response, error) in
            
            // If error, print error
            if let error = error {
                print(error)
                return
            }
            
            guard let data2 = data1 else { return }
            
            do {
                let initial2 = try? JSONDecoder().decode(Initial.self, from: data2)
                let v2_count = initial2?.value.count
                
                // if datastream contains values
                if v2_count != nil {
                    for i in 0...v2_count!-1 {
                        // Append each value and time to arrays
                        self.w_result.append(String(format:"%f", ((initial2?.value[i].result)!)))
                        self.w_time.append((initial2?.value[i].phenomenonTime)!)
                    }
                }
                
                DispatchQueue.main.async {
                    // If there is a datastream link but no values then print the title of datastream with "- N/A"
                    if self.w_result.count == 0 {
                        self.thirdTitle.text = ("\(self.url3Name) - N/A")
                    }
                    
                    // Reloads collection view
                    self.waterView.reloadData()
                }
            }
        }.resume()
        
        
        // MARK: - Parses Third Datastream
        guard let url4 = URL(string: url4Link) else {return}
        URLSession.shared.dataTask(with: url4) { (data1, response, error) in
            
            // If error, print error
            if let error = error {
                print(error)
                return
            }
            
            guard let data2 = data1 else { return }
            
            do {
                let initial2 = try? JSONDecoder().decode(Initial.self, from: data2)
                let v2_count = initial2?.value.count
                
                // if datastream contains values
                if v2_count != nil {
                    for i in 0...v2_count!-1 {
                        // Append each value and time to arrays
                        self.b_result.append(String(format:"%.3f", ((initial2?.value[i].result)!)))
                        self.b_time.append((initial2?.value[i].phenomenonTime)!)
                    }
                }
                
                DispatchQueue.main.async {
                    // If there is a datastream link but no values then print the title of datastream with "- N/A"
                    if self.b_result.count == 0 {
                        self.fourthTitle.text = ("\(self.url4Name) - N/A")
                    }
                    
                    // Reloads collection view
                    self.batteryView.reloadData()
                }
            }
        }.resume()
    }
    
    // MARK: - Heart Tapped
    @IBAction func heartTapped(_ sender: Any) {
        // Access favorites
        var favourites = defaults.object(forKey: "favourites") as? [String] ?? [String]()
        
        // If heart is tapped and it is already a favorite, it will unfavorite the sensor
        if favourites.contains(self.name) {
            favourites = favourites.filter { $0 != self.name }
            self.heartButton.image = UIImage(systemName: "heart")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            defaults.set(favourites, forKey: "favourites")
        } else { // If heart is tapped and it is not a favorite, it will favorite the sensor
            favourites.append(self.name)
            self.heartButton.image = UIImage(systemName: "heart.fill")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            defaults.set(favourites, forKey: "favourites")
        }
    }
    
    func testHeart() {
        // Tests if sensor is favorited
        let favourites = defaults.object(forKey: "favourites") as? [String] ?? [String]()
        if favourites.contains(self.name) {
            self.heartButton.image = UIImage(systemName: "heart.fill")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        }
    }
    
    // MARK: - Date Code
    @objc func runTimedCode() {
        // Flashes scroll wheel so the user knows the collection view are scrollable
        pressureView.flashScrollIndicators()
        temperatureView.flashScrollIndicators()
        waterView.flashScrollIndicators()
        batteryView.flashScrollIndicators()
    }
    
    
    // MARK: - Display Time
    // Converts API time format to normal time format for collection view 1
    func getCurrentDateTime(simpleTime:Date){
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MMM d, yyyy"
        let str = formatter.string(from:(simpleTime))
        
        if Calendar.current.isDateInToday(simpleTime) {
            dayLabel.text = "Today"
        } else if Calendar.current.isDateInYesterday(simpleTime) {
            dayLabel.text = "Yesterday"
        } else if a_time.isEmpty{
            dayLabel.text = "N/A"
        }else {
            dayLabel.text = str
        }
    }
    
    // Converts API time format to normal time format for collection view 2
    func getCurrentDateTime(simpleTime2:Date){
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MMM d, yyyy"
        let str = formatter.string(from:(simpleTime2))
        
        if Calendar.current.isDateInToday(simpleTime2) {
            day2.text = "Today"
        } else if Calendar.current.isDateInYesterday(simpleTime2) {
            day2.text = "Yesterday"
        } else if t_time.isEmpty{
            day2.text = "N/A"
        }else {
            day2.text = str
        }
    }
    
    // Converts API time format to normal time format for collection view 3
    func getCurrentDateTime(simpleTime3:Date){
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MMM d, yyyy"
        let str = formatter.string(from:(simpleTime3))
        
        if Calendar.current.isDateInToday(simpleTime3) {
            day3.text = "Today"
        } else if Calendar.current.isDateInYesterday(simpleTime3) {
            day3.text = "Yesterday"
        } else if w_time.isEmpty{
            day3.text = "N/A"
        }else {
            day3.text = str
        }
    }
    
    // Converts API time format to normal time format for collection view 4
    func getCurrentDateTime(simpleTime4:Date){
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MMM d, yyyy"
        let str = formatter.string(from:(simpleTime4))
        
        if Calendar.current.isDateInToday(simpleTime4) {
            day4.text = "Today"
        } else if Calendar.current.isDateInYesterday(simpleTime4) {
            day4.text = "Yesterday"
        } else if w_time.isEmpty{
            day4.text = "N/A"
        }else {
            day4.text = str
        }
    }
}


extension SensorDataViewController:UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Determines Number of Rows
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Based on each collection view, the number of cells are put
        if (collectionView == pressureView){
            return a_result.count
        }
        
        if (collectionView == temperatureView){
            return t_result.count
        }
        
        if (collectionView == waterView){
            return w_result.count
        }
        
        // The last collection view
        return b_result.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // MARK: - Display First Collection View Data
        if (collectionView == pressureView){
            // Connects to cell
            let a_cell = pressureView.dequeueReusableCell(withReuseIdentifier: "check", for: indexPath) as? PressureCollectionViewCell
            
            // Formats time
            let formatter1 = DateFormatter()
            formatter1.locale = Locale(identifier: "en_US_POSIX")
            formatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let simpleTime1 = formatter1.date(from: a_time[indexPath.row])
            formatter1.dateFormat = "h:mm a"
            let correctedSimpleTime1 = formatter1.string(from: simpleTime1!)
            
            getCurrentDateTime(simpleTime: simpleTime1!)
            
            // Each value is rounded to 2 decimal places
            url1Value = (Double(a_result[indexPath.row]))!.rounded(toPlaces: 2)
            
            // Changes font size of value dependent on what type of data it is
            if (url1Name == "Air Pressure") {
                a_cell?.number.font = UIFont.systemFont(ofSize: 15)
            } else if (url1Name == "Battery Level") {
                a_cell?.number.font = UIFont.systemFont(ofSize: 19)
            } else if (url1Name == "Water Level") {
                a_cell?.number.font = UIFont.systemFont(ofSize: 17)
            } else if (url1Name == "Air Temperature"){
                // Converts celsius to fahrenheit
                let fahrenheitTemperature = url1Value * 9 / 5 + 32
                self.url1Value = (fahrenheitTemperature.rounded(toPlaces: 2))
                a_cell?.number.font = UIFont.systemFont(ofSize: 18)
            } else {
                a_cell?.number.font = UIFont.systemFont(ofSize: 19)
            }
            
            // Final prints of cell
            a_cell?.number.text = "\(url1Value) \(url1Unit)"
            a_cell?.time.text = "\(correctedSimpleTime1)"
            
            
            return a_cell!
            
        }
        // MARK: - Display Second Collection View Data
        if (collectionView == temperatureView){
            // Connects to cell
            let t_cell = temperatureView.dequeueReusableCell(withReuseIdentifier: "Temperature check", for: indexPath) as? TemperatureCollectionViewCell
            
            // Formats time
            let formatter2 = DateFormatter()
            formatter2.locale = Locale(identifier: "en_US_POSIX")
            formatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let simpleTime2 = formatter2.date(from: t_time[indexPath.row])
            formatter2.dateFormat = "h:mm a"
            let correctedSimpleTime2 = formatter2.string(from: simpleTime2!)
            
            getCurrentDateTime(simpleTime2: simpleTime2!)

            // If there is no values then texts will print "N/A"
            if t_result.isEmpty{
                t_cell?.t_number.text = "N/A"
                t_cell?.t_time.text = "N/A"
                return t_cell!
            }else{
                
                // Each value is rounded to 2 decimal places
                url2Value = (Double(t_result[indexPath.row]))!.rounded(toPlaces: 2)
                
                // Changes font size of value dependent on what type of data it is
                if (url2Name == "Air Pressure") {
                    t_cell?.t_number.font = UIFont.systemFont(ofSize: 15)
                } else if (url2Name == "Battery Level") {
                    t_cell?.t_number.font = UIFont.systemFont(ofSize: 19)
                } else if (url2Name == "Water Level") {
                    t_cell?.t_number.font = UIFont.systemFont(ofSize: 17)
                } else if (url2Name == "Air Temperature"){
                    // Converts celsius to fahrenheit
                    let fahrenheitTemperature = url2Value * 9 / 5 + 32
                    self.url2Value = (fahrenheitTemperature.rounded(toPlaces: 2))
                    t_cell?.t_number.font = UIFont.systemFont(ofSize: 18)
                } else {
                    t_cell?.t_number.font = UIFont.systemFont(ofSize: 19)
                }
                
                // Final prints of cell
                t_cell?.t_number.text = "\(url2Value) \(url2Unit)"
                t_cell?.t_time.text = "\(correctedSimpleTime2)"
                
                return t_cell!
            }
        }
        
        // MARK: - Display Third Collection View Data
        if (collectionView == waterView){
            // Connects to cell
            let w_cell = waterView.dequeueReusableCell(withReuseIdentifier: "Water check", for: indexPath) as? WaterCollectionViewCell
            
            // Formats time
            let formatter3 = DateFormatter()
            formatter3.locale = Locale(identifier: "en_US_POSIX")
            formatter3.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let simpleTime3 = formatter3.date(from: w_time[indexPath.row])
            formatter3.dateFormat = "h:mm a"
            let correctedSimpleTime3 = formatter3.string(from: simpleTime3!)
            
            getCurrentDateTime(simpleTime3: simpleTime3!)
            
            // If there is no values then texts will print "N/A"
            if w_result.isEmpty{
                w_cell?.w_number.text = "N/A"
                w_cell?.w_time.text = "N/A"
                return w_cell!
            }else{
                // Each value is rounded to 2 decimal places
                url3Value = (Double(w_result[indexPath.row]))!.rounded(toPlaces: 2)
                
                // Changes font size of value dependent on what type of data it is
                if (url3Name == "Air Pressure") {
                    w_cell?.w_number.font = UIFont.systemFont(ofSize: 15)
                } else if (url3Name == "Battery Level") {
                    w_cell?.w_number.font = UIFont.systemFont(ofSize: 19)
                } else if (url3Name == "Water Level") {
                    w_cell?.w_number.font = UIFont.systemFont(ofSize: 17)
                } else if (url3Name == "Air Temperature"){
                    // Converts celsius to fahrenheit
                    let fahrenheitTemperature = url3Value * 9 / 5 + 32
                    self.url3Value = (fahrenheitTemperature.rounded(toPlaces: 2))
                    w_cell?.w_number.font = UIFont.systemFont(ofSize: 18)
                } else {
                    w_cell?.w_number.font = UIFont.systemFont(ofSize: 19)
                }
                
                // Final prints of cell
                w_cell?.w_number.text = "\(url3Value) \(url3Unit)"
                w_cell?.w_time.text = "\(correctedSimpleTime3)"
                
                
                return w_cell!
            }
        }
        
        // MARK: - Display Third Collection View Data
        // Connects to cell
        let b_cell = batteryView.dequeueReusableCell(withReuseIdentifier: "Battery check", for: indexPath) as? BatteryCollectionViewCell
        
        // Formats time
        let formatter4 = DateFormatter()
        formatter4.locale = Locale(identifier: "en_US_POSIX")
        formatter4.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let simpleTime4 = formatter4.date(from: b_time[indexPath.row])
        formatter4.dateFormat = "h:mm a"
        let correctedSimpleTime4 = formatter4.string(from: simpleTime4!)
        
        getCurrentDateTime(simpleTime4: simpleTime4!)
        
        // If there is no values then texts will print "N/A"
        if b_result.isEmpty{
            b_cell?.b_number.text = "N/A"
            b_cell?.b_time.text = "N/A"
            return b_cell!
        }else{
            // Each value is rounded to 2 decimal places
            url4Value = (Double(b_result[indexPath.row]))!.rounded(toPlaces: 2)
            
            // Changes font size of value dependent on what type of data it is
            if (url4Name == "Air Pressure") {
                b_cell?.b_number.font = UIFont.systemFont(ofSize: 15)
            } else if (url4Name == "Battery Level") {
                b_cell?.b_number.font = UIFont.systemFont(ofSize: 19)
            } else if (url4Name == "Water Level") {
                b_cell?.b_number.font = UIFont.systemFont(ofSize: 17)
            } else if (url4Name == "Air Temperature"){
                // Converts celsius to fahrenheit
                let fahrenheitTemperature = url4Value * 9 / 5 + 32
                self.url4Value = (fahrenheitTemperature.rounded(toPlaces: 2))
                b_cell?.b_number.font = UIFont.systemFont(ofSize: 18)
            } else {
                b_cell?.b_number.font = UIFont.systemFont(ofSize: 19)
            }
            
            // Final prints of cell
            b_cell?.b_number.text = "\(url4Value) \(url4Unit)"
            b_cell?.b_time.text = "\(correctedSimpleTime4)"
            
            return b_cell!
        }
    }
    
}

// MARK: - Prints Values with Correct Decimal Value
extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
