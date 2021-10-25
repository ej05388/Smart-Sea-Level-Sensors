//
//  FavoritesViewController.swift
//  GTSeaLevelAPP
//
//  Created by Johnson Amalanathan on 3/20/20.
//  Copyright © 2020 Georgia Tech. All rights reserved.
//

import UIKit
import SafariServices

class FavoritesViewController: UIViewController {
    // MARK: - Outlets
    // Menu outlets
    @IBOutlet weak var regularLeading: NSLayoutConstraint!
    @IBOutlet weak var regularTrailing: NSLayoutConstraint!
    
    // UITable outlet
    @IBOutlet var favoritesTable: UITableView!

    // MARK: - Variables
    // Counts how many sensors are favorited
    var countInt:Int = 0
    
    // Keeps track of how many sensors there are and if there are any we need to add or delete
    var keyArray:Array = [String]()
    var currentNames = [String]()
    var doneBefore = [String]()
    var needToArray = [String]()
    var needToDelete = [String]()
    var nameLocations = [Int]()
    
    // Count of all sensors
    var nameArrayCount2 = Int()
    
    // Arrays used to store all of sensor's primary data
    var nameArray2 = [String]()
    var deviceIDArray2 = [String]()
    var elevationNAVD88Array2 = [String]()
    var IDArray2 = [String]()
    var locationLinkArray2 = [String]()
    
    // Contains datastream link to access a specific sensor
    var datastreamLinkArray2 = [String]()
    
    // Variables that holds all sensors first datastream name and link
    var firstNameDatastreamLinkArray2 = [String]()
    var firstObservationsDatastreamLinkArray2 = [String]()

    // Variables that holds all sensors second datastream name and link
    var secondNameDatastreamLinkArray2 = [String]()
    var secondObservationsDatastreamLinkArray2 = [String]()
    
    // Variables that holds all sensors third datastream name and link
    var thirdNameDatastreamLinkArray2 = [String]()
    var thirdObservationsDatastreamLinkArray2 = [String]()
    
    // Variables that holds all sensors fourth datastream name and link
    var fourthNameDatastreamLinkArray2 = [String]()
    var fourthObservationsDatastreamLinkArray2 = [String]()
    
    // Variables that relate to sensors' location
    var descriptionLocationLinkArray2 = [String]()
    var coordinates1LocationLinkArray2 = [Double]()
    var coordinates2LocationLinkArray2 = [Double]()
    
    // Variables that contains all sensors datastream units
    var firstUnitOfMeasurementArray2 = [String]()
    var secondUnitOfMeasurementArray2 = [String]()
    var thirdUnitOfMeasurementArray2 = [String]()
    var fourthUnitOfMeasurementArray2 = [String]()

    // Number of datastreams that a sensor has
    var ArrayCount2 = Int()
    
    // Variable that contains all the sensors datastream links of water level
    var waterLevelArray = [String]()
    
    // Variable that contains all the sensors latest water level value if it has one
    var numberWaterLevel = [String]()
    
    // Variable that holds the current water Level for a sensor (place holds a value in code)
    var currentWaterLevel = String()
    
    // Variable that contains the difference in water level of all sensors height in relation to sea level
    var differenceWaterLevel = [Double]()
    
    // Contains the actual water level for each sensor that is favorited
    var favoriteSignalArray = [Double()]
    
    // Added to the end of datastream link to get top 50 latest values
    var value50 = "?$top=50&$orderby=phenomenonTime%20desc"
    
    // Where favorite sensors are located
    let defaults = UserDefaults.standard

    // Array that is parsed as a placeholder so the program knows if this array is ready then the other arrays that matter are ready also
    var tracker = [String]()
    
    // Variable to know how many network calls back the program is getting and once all network calls return, more code will run
    var ready2 = 0
    
    // Variables so the program will know what situtation the favorite page is in
    var go = false // If UITableView is ready to update
    var viewLoad = false // If the view (page) has already been loaded before
    var firstTime = true // If this is the first time the sensor is being loaded
    var same = false // if the currentArray and keyArray are the same
    var identicalNumberArray = false // If there are identical number of elements in currentArray and keyArray but the elements are different
    var menuOut = false // If the menu is out
    var internet = false // If there is internet
    // Variable that holds how far the UITableView moves when the menu is out
    let movingConstant:CGFloat = 300
    
    // If view appears (when the user clicks on the favorites tab)
    override func viewDidAppear(_ animated: Bool) {
        // If view has been loaded before then the favorite sensors are preloaded
        if viewLoad { // This is so the sensors aren't preloaded twice the first time the user opens the favorites page
            viewDidLoad()
        }
        
        // After the first time, it changes to true so it can update everytime the user enters this page
        viewLoad = true
    }

    
    override func viewDidLoad() {
        // MARK: - ViewDidLoad
        super.viewDidLoad()
        
        // Counts and records title into keyArray how many sensors are favorited
        self.count()
        self.convertFirebaseToArray()
        
        // MARK: - Parse Things
        let url = "https://api.sealevelsensors.org/v1.0/Things"
        let urlObj = URL(string: url)
        
        // First time page loads, makes currentNames to be equal length to keyArray
        if viewLoad == false {
            if keyArray.count != 0 {
                for i in 0...keyArray.count-1 {
                    currentNames.append("a")
                }
            }
        }
        
        // Checks if currentNames and keyArray are different
        if keyArray.count != 0 {
            if currentNames.count != keyArray.count { // sees if count in both variables are the same, if not then same is false
                same = false
            } else {
                if viewLoad == true { // If page has been loaded before
                    for i in 0...keyArray.count-1 {
                        if (currentNames[i] != keyArray[i]) { // If arrays aren't exactly the same, same is false and identicalNumberArray is true
                            same = false
                            identicalNumberArray = true // This means the number of elements in both arrays are the same but the actual elements are not
                        }
                    }
                } else { // This is the first time the page is loading so the program makes currentNames same to keyArray
                    for i in 0...keyArray.count-1 {
                        currentNames[i] = keyArray[i]
                    }
                }
            }
        }
        
        if currentNames.count < keyArray.count { // Sensors that need to be preloaded
            for i in 0...keyArray.count-1 { // Add sensors that need to be preloaded to needToArray
                if currentNames.contains(self.keyArray[i]) {
                } else {
                    needToArray.append(self.keyArray[i])
                }
            }
            
            if currentNames.count != 0 {
                for i in 0...currentNames.count-1 { // If some sensors need to be deleted
                    if keyArray.contains(currentNames[i]) {
                    } else {
                        needToDelete.append(currentNames[i])
                    }
                }
            }
        }
        
        if currentNames.count > keyArray.count  { // Sensors that need to be deleted
            for i in 0...currentNames.count-1 { // Add sensors that need to be deleted to needToDelte
                if keyArray.contains(self.currentNames[i]) {
                } else {
                    needToDelete.append(self.currentNames[i])
                }
            }
            
            for i in 0...keyArray.count-1 { // If some sensors need to be prelaoded
                if currentNames.contains(keyArray[i]) {
                } else {
                    needToArray.append(keyArray[i])
                }
            }
        }
        
        if identicalNumberArray == true { // If number of both arrays are identical but the sensors are different
            for i in 0...keyArray.count-1 {
                if currentNames.contains(keyArray[i]) { // Sensors that need to be preload are put in needToArray
                } else {
                    needToArray.append(keyArray[i])
                }
                
                if keyArray.contains(currentNames[i]) { // Sensors that need to be deleted are put in needToDelete
                } else {
                    needToDelete.append(currentNames[i])
                }
            }
        }
        
        
        // If list needs to be updated
        if (keyArray.count != 0 && same == false) || (firstTime && keyArray.count != 0) {
            // MARK: - FIrstTime
            // First time the page is loaded
            if firstTime {
                // I already did comments for parsing JSON in line 310 of TableViewController.swift so view that for reference
                
                // Sets all arrays to nothing to clear anything
                nameLocations = []
                
                nameArray2 = []
                deviceIDArray2 = []
                elevationNAVD88Array2 = []
                IDArray2 = []
                locationLinkArray2 = []
                datastreamLinkArray2 = []
                
                firstNameDatastreamLinkArray2 = []
                firstObservationsDatastreamLinkArray2 = []
                firstUnitOfMeasurementArray2 = []
                
                secondNameDatastreamLinkArray2 = []
                secondObservationsDatastreamLinkArray2 = []
                secondUnitOfMeasurementArray2 = []
                
                thirdNameDatastreamLinkArray2 = []
                thirdObservationsDatastreamLinkArray2 = []
                thirdUnitOfMeasurementArray2 = []
                
                fourthNameDatastreamLinkArray2 = []
                fourthObservationsDatastreamLinkArray2 = []
                fourthUnitOfMeasurementArray2 = []
                
                descriptionLocationLinkArray2 = []
                coordinates1LocationLinkArray2 = []
                coordinates2LocationLinkArray2 = []
                
                waterLevelArray = []
                numberWaterLevel = []
                differenceWaterLevel = []
                
                tracker = []
                currentNames = []
                go = false
                same = true
                internet = false
                
                // Makes currentNames identical to keu Array
                for i in 0...keyArray.count-1 {
                    currentNames.append(keyArray[i])
                }

                
                let config = URLSessionConfiguration.default
                config.waitsForConnectivity = true
                config.timeoutIntervalForResource = 300

                let session = URLSession(configuration: config)
                
                session.dataTask(with: urlObj!) {(data, response, error) in // I already did comments for parsing JSON in line 310 of TableViewController.swift so view that for reference
                    // sets firstTime to false because next time it is no longer the first time
                    self.firstTime = false
                    self.internet = true
                    DispatchQueue.main.async {
                        self.favoritesTable.reloadData()
                    }
                    
                    do {
                        let entry = try! JSONDecoder().decode(Entry.self, from: data!)
                        self.nameArrayCount2 = entry.value.count
                        
                        for _ in 0...self.keyArray.count-1 {
                            self.nameLocations.append(-1)
                            self.tracker.append("a")
                        }
                        
                        // Finds the actual locations of the favorited sensors in the total list of sensors
                        for i in 0...self.nameArrayCount2-1 {
                            for j in 0...self.keyArray.count-1 {
                                if (entry.value[i].name == self.keyArray[j]) {
                                    self.nameLocations[j] = i
                                }
                                
                            }
                        }
                        
                        for _ in 0...self.nameArrayCount2-1 {
                            self.nameArray2.append("a")
                            self.elevationNAVD88Array2.append("a")
                            self.datastreamLinkArray2.append("a")
                        }
                        
                        for i in 0...self.keyArray.count-1 {
                            // converts favorite sensors index to actual index so they can be sorted in relation to all sensors for easy overall organization
                            let actualIndex = self.nameLocations[i]
                            self.nameArray2[actualIndex] = (String((entry.value[actualIndex].name)!))
                            
                            if ((entry.value[actualIndex].properties?.elevationNAVD88) != nil) {
                                self.elevationNAVD88Array2[actualIndex] = (String((entry.value[actualIndex].properties?.elevationNAVD88)!))
                            } else {
                                self.elevationNAVD88Array2[actualIndex] = ("N/A")
                            }
                            
                            self.datastreamLinkArray2[actualIndex] = (String((entry.value[actualIndex].datastreamLink)!))
                            
                        }
                        
                        DispatchQueue.main.async {
                            // MARK: - Parse Collection View
                            for _ in 0...self.nameArrayCount2-1 {
                                self.firstNameDatastreamLinkArray2.append("a")
                                self.firstObservationsDatastreamLinkArray2.append("a")
                                
                                self.secondNameDatastreamLinkArray2.append("a")
                                self.secondObservationsDatastreamLinkArray2.append("a")
                                
                                self.thirdNameDatastreamLinkArray2.append("a")
                                self.thirdObservationsDatastreamLinkArray2.append("a")
                                
                                self.fourthNameDatastreamLinkArray2.append("a")
                                self.fourthObservationsDatastreamLinkArray2.append("a")
                                
                                self.waterLevelArray.append("a")
                                self.numberWaterLevel.append("a")
                                self.differenceWaterLevel.append(1000)
                            }
                            
                            for link1 in 0...self.keyArray.count-1 {
                                let actualIndex = self.nameLocations[link1]
                                let specificUrl = self.datastreamLinkArray2[actualIndex]
                                URLSession.shared.dataTask(with: URL(string: specificUrl)!) {(data, response, error) in
                                    
                                    do {
                                        self.differenceWaterLevel[actualIndex] = -1000.1
                                        let entry2 = try! JSONDecoder().decode(Entry2.self, from: data!)
                                        self.ArrayCount2 = entry2.value.count
                                        if (self.ArrayCount2 > 0) {
                                            self.firstNameDatastreamLinkArray2[actualIndex] = (entry2.value[0].nameDatastreamLink!)
                                            self.firstObservationsDatastreamLinkArray2[actualIndex] = (entry2.value[0].observationsDatastreamLink!)
                                            self.tracker[link1] = (entry2.value[0].observationsDatastreamLink!)
                                        } else {
                                            self.firstNameDatastreamLinkArray2[actualIndex] = ("N/A")
                                            self.firstObservationsDatastreamLinkArray2[actualIndex] = ("N/A")
                                        }
                                        
                                        if (self.ArrayCount2 > 1) {
                                            self.secondNameDatastreamLinkArray2[actualIndex] = (entry2.value[1].nameDatastreamLink!)
                                            self.secondObservationsDatastreamLinkArray2[actualIndex] = (entry2.value[1].observationsDatastreamLink!)
                                        } else {
                                            self.secondNameDatastreamLinkArray2[actualIndex] = ("N/A")
                                            self.secondObservationsDatastreamLinkArray2[actualIndex] = ("N/A")
                                        }
                                        
                                        if (self.ArrayCount2 > 2) {
                                            self.thirdNameDatastreamLinkArray2[actualIndex] = (entry2.value[2].nameDatastreamLink!)
                                            self.thirdObservationsDatastreamLinkArray2[actualIndex] = (entry2.value[2].observationsDatastreamLink!)
                                        } else {
                                            self.thirdNameDatastreamLinkArray2[actualIndex] = ("N/A")
                                            self.thirdObservationsDatastreamLinkArray2[actualIndex] = ("N/A")
                                        }
                                        
                                        if (self.ArrayCount2 > 3) {
                                            self.fourthNameDatastreamLinkArray2[actualIndex] = (entry2.value[3].nameDatastreamLink!)
                                            self.fourthObservationsDatastreamLinkArray2[actualIndex] = (entry2.value[3].observationsDatastreamLink!)
                                            
                                        } else {
                                            self.fourthNameDatastreamLinkArray2[actualIndex] = ("N/A")
                                            self.fourthObservationsDatastreamLinkArray2[actualIndex] = ("N/A")
                                        }
                                        
                                        if self.tracker.contains("a"){
                                        } else {
                                            DispatchQueue.main.async {
                                                // MARK: - Get Water Level Array
                                                self.tracker = []
                                                for creation100 in 0...self.keyArray.count-1 {
                                                    self.tracker.append("a")
                                                    let actualIndex1 = self.nameLocations[creation100]
                                                    if self.firstObservationsDatastreamLinkArray2[actualIndex1] != "a" {
                                                        if self.firstObservationsDatastreamLinkArray2[actualIndex1] != "N/A" {
                                                            self.firstObservationsDatastreamLinkArray2[actualIndex1] += self.value50
                                                        }
                                                        
                                                        if self.secondObservationsDatastreamLinkArray2[actualIndex1] != "N/A" {
                                                            self.secondObservationsDatastreamLinkArray2[actualIndex1] += self.value50
                                                        }
                                                        
                                                        if self.thirdObservationsDatastreamLinkArray2[actualIndex1] != "N/A" {
                                                            self.thirdObservationsDatastreamLinkArray2[actualIndex1] += self.value50
                                                        }
                                                        
                                                        if self.fourthObservationsDatastreamLinkArray2[actualIndex1] != "N/A" {
                                                            self.fourthObservationsDatastreamLinkArray2[actualIndex1] += self.value50
                                                        }
                                                    }
                                                }
                                                
                                                for link2 in 0...self.keyArray.count-1 {
                                                    let actualIndex1 = self.nameLocations[link2]
                                                    if self.firstNameDatastreamLinkArray2[actualIndex1] == "Water Level" {
                                                        self.waterLevelArray[actualIndex1] = self.firstObservationsDatastreamLinkArray2[actualIndex1]
                                                    } else if self.secondNameDatastreamLinkArray2[actualIndex1] == "Water Level" {
                                                        self.waterLevelArray[actualIndex1] = self.secondObservationsDatastreamLinkArray2[actualIndex1]
                                                    } else if self.thirdNameDatastreamLinkArray2[actualIndex1] == "Water Level" {
                                                        self.waterLevelArray[actualIndex1] = self.thirdObservationsDatastreamLinkArray2[actualIndex1]
                                                    } else if self.fourthNameDatastreamLinkArray2[actualIndex1] == "Water Level" {
                                                        self.waterLevelArray[actualIndex1] = self.fourthObservationsDatastreamLinkArray2[actualIndex1]
                                                    } else {
                                                        self.waterLevelArray[actualIndex1] = "N/A"
                                                    }
                                                    
                                                    if self.waterLevelArray[actualIndex1] != "N/A" {
                                                        guard let url2 = URL(string: self.waterLevelArray[actualIndex1]) else {return}
                                                        URLSession.shared.dataTask(with: url2) { (data1, response, error) in
                                                            
                                                            guard let data2 = data1 else { return }
                                                            do {
                                                                let initial2 = try? JSONDecoder().decode(EntryLatestWater.self, from: data2)
                                                                
                                                                let v3_count = initial2?.value.count
                                                                
                                                                if v3_count != nil {
                                                                    self.currentWaterLevel = String(format:"%f", ((initial2?.value[0].result)!))
                                                                    self.numberWaterLevel[actualIndex1] = self.currentWaterLevel
                                                                    
                                                                    self.tracker[link2] = String(format:"%f", ((initial2?.value[0].result)!))
                                                                    if (self.elevationNAVD88Array2[actualIndex1] != "N/A") {
                                                                        
                                                                        let first = Double(self.elevationNAVD88Array2[actualIndex1])!
                                                                        let second = Double(self.currentWaterLevel)!
                                                                        
                                                                        self.differenceWaterLevel[actualIndex1] = first + second
                                                                        
                                                                        
                                                                    } else {
                                                                        self.differenceWaterLevel[actualIndex1] = 100
                                                                        
                                                                    }
                                                                } else {
                                                                    self.currentWaterLevel = "N/A"
                                                                    self.numberWaterLevel[actualIndex1] = self.currentWaterLevel
                                                                    self.differenceWaterLevel[actualIndex1] = 100
                                                                    self.tracker[link2] = "done"
                                                                }
                                                                
                                                                
                                                                if self.tracker.contains("a") {
                                                                } else {
                                                                    DispatchQueue.main.async {
                                                                        self.count()
                                                                        self.convertFirebaseToArray()
                                                                        self.getAllArrayData()
                                                                        self.needToArray.removeAll()
                                                                    }
                                                                }
                                                                
                                                            }
                                                        }.resume()
                                                    } else {
                                                        self.numberWaterLevel[actualIndex1] = "N/A"
                                                        self.differenceWaterLevel[actualIndex1] = 100
                                                        self.tracker[link2] = "done"
                                                        if self.tracker.contains("a") {
                                                        } else {
                                                            DispatchQueue.main.async {
                                                                self.count()
                                                                self.convertFirebaseToArray()
                                                                self.getAllArrayData()
                                                                self.needToArray.removeAll()
                                                            }
                                                        }
                                                    }
                                                    
                                                    
                                                }
                                                
                                                
                                                
                                                
                                            }
                                        }
                                        
                                    }
                                }.resume()
                            }
                        }
                    }
                    
                }.resume()
            } else {
                // Sensor removed from favorites
                if (currentNames.count > keyArray.count) || needToDelete.count > 0 {
                    // sets temperary arrays so when deleting elements in array it won't mess up the loops
                    var tempValues = [Int]()
                    var tempCurrentNames = [String]()
                    var tempNeedToDelete = [String]()
                    
                    // Removes sensors from currentNames
                    for j in 0...self.needToDelete.count-1 {
                        tempNeedToDelete.append(needToDelete[j])
                        for i in 0...currentNames.count-1 {
                            if j == 0 {
                                tempCurrentNames.append(currentNames[i])
                            }
                            if currentNames[i] == self.needToDelete[j] {
                                tempValues.append(i)
                            }
                        
                        }
                    }
                    
                    // Reversed tempValues so when deleting elements it won't change other elements location
                    tempValues.reverse()
                    
                    // The sensor is removed from all arrays that relate to favorite sensors but data is still kept in overall array
                    for i in 0...tempValues.count-1 {
                        let index = tempValues[i]
                        self.nameLocations.remove(at: index)
                        self.favoriteSignalArray.remove(at: index)
                        self.currentNames.remove(at: index)
                    }

                    // Clears needToDelte because they have been deleted from currentNames and arrays that relate to favorite sensors
                    self.needToDelete.removeAll()
                    
                    // If there are no sensors to add then UITableView reloads
                    if needToArray.count == 0 {
                        self.favoritesTable.reloadData()
                    }

                }
                
                // Sensor Added to favorites
                if (currentNames.count < keyArray.count) || needToArray.count > 0 {
                    // Resets values
                    identicalNumberArray = false
                    tracker = []
                    
                    URLSession.shared.dataTask(with: urlObj!) {(data, response, error) in // I already did comments for parsing JSON in line 310 of TableViewController.swift so view that for reference
                        
                        do {
                            let entry = try! JSONDecoder().decode(Entry.self, from: data!)
                            self.nameArrayCount2 = entry.value.count
                            
                            for _ in 0...self.needToArray.count-1 {
                                self.nameLocations.append(-1)
                                self.tracker.append("a")
                            }
                            
                            // Finds the actual locations of the favorited sensors in the total list of sensors
                            for j in 0...self.needToArray.count-1 {
                                let b = self.keyArray.firstIndex(of: self.needToArray[j])
                                for i in 0...self.nameArrayCount2-1 {
                                    if (entry.value[i].name == self.needToArray[j]) {
                                        self.nameLocations[b!] = i
                                    }
                                }
                            }

                            
                            for a in 0...self.needToArray.count-1 {
                                let b = self.keyArray.firstIndex(of: self.needToArray[a])
                                let actualIndex1 = self.nameLocations[b!]
                                if actualIndex1 == -1 { // This is to prevent the program from running when all the data has not been received yet
                                } else {
                                    for j in 0...self.needToArray.count-1 {
                                        let c = self.keyArray.firstIndex(of: self.needToArray[j])
                                        let actualIndex = self.nameLocations[c!]
                                        self.nameArray2[actualIndex] = (String((entry.value[actualIndex].name)!))
                                        
                                        if ((entry.value[actualIndex].properties?.elevationNAVD88) != nil) {
                                            self.elevationNAVD88Array2[actualIndex] = (String((entry.value[actualIndex].properties?.elevationNAVD88)!))
                                        } else {
                                            self.elevationNAVD88Array2[actualIndex] = ("N/A")
                                        }
                                        
                                        self.datastreamLinkArray2[actualIndex] = (String((entry.value[actualIndex].datastreamLink)!))
                                        
                                    }
                                }
                                
                            }
                            
                            for a in 0...self.needToArray.count-1 {
                                let b = self.keyArray.firstIndex(of: self.needToArray[a])
                                let actualIndex1 = self.nameLocations[b!]
                                if actualIndex1 == -1 {
                                } else {
                                    DispatchQueue.main.async {
                                        // MARK: - Parse Collection View
                                        self.currentNames.append("a")
                                        self.currentNames[b!] = self.keyArray[b!]
                                        for i in 0...self.needToArray.count-1 {
                                            let link1 = self.keyArray.firstIndex(of: self.needToArray[i])
                                            let actualIndex = self.nameLocations[link1!]
                                            let specificUrl = self.datastreamLinkArray2[actualIndex]
                                            URLSession.shared.dataTask(with: URL(string: specificUrl)!) {(data, response, error) in
                                                
                                                do {
                                                    self.differenceWaterLevel[actualIndex] = -1000.1
                                                    let entry2 = try! JSONDecoder().decode(Entry2.self, from: data!)
                                                    self.ArrayCount2 = entry2.value.count
                                                    if (self.ArrayCount2 > 0) {
                                                        self.firstNameDatastreamLinkArray2[actualIndex] = (entry2.value[0].nameDatastreamLink!)
                                                        self.firstObservationsDatastreamLinkArray2[actualIndex] = (entry2.value[0].observationsDatastreamLink!)
                                                        self.tracker[i] = (entry2.value[0].observationsDatastreamLink!)
                                                    } else {
                                                        self.firstNameDatastreamLinkArray2[actualIndex] = ("N/A")
                                                        self.firstObservationsDatastreamLinkArray2[actualIndex] = ("N/A")
                                                    }
                                                    
                                                    if (self.ArrayCount2 > 1) {
                                                        self.secondNameDatastreamLinkArray2[actualIndex] = (entry2.value[1].nameDatastreamLink!)
                                                        self.secondObservationsDatastreamLinkArray2[actualIndex] = (entry2.value[1].observationsDatastreamLink!)
                                                    } else {
                                                        self.secondNameDatastreamLinkArray2[actualIndex] = ("N/A")
                                                        self.secondObservationsDatastreamLinkArray2[actualIndex] = ("N/A")
                                                    }
                                                    
                                                    if (self.ArrayCount2 > 2) {
                                                        self.thirdNameDatastreamLinkArray2[actualIndex] = (entry2.value[2].nameDatastreamLink!)
                                                        self.thirdObservationsDatastreamLinkArray2[actualIndex] = (entry2.value[2].observationsDatastreamLink!)
                                                    } else {
                                                        self.thirdNameDatastreamLinkArray2[actualIndex] = ("N/A")
                                                        self.thirdObservationsDatastreamLinkArray2[actualIndex] = ("N/A")
                                                    }
                                                    
                                                    if (self.ArrayCount2 > 3) {
                                                        self.fourthNameDatastreamLinkArray2[actualIndex] = (entry2.value[3].nameDatastreamLink!)
                                                        self.fourthObservationsDatastreamLinkArray2[actualIndex] = (entry2.value[3].observationsDatastreamLink!)
                                                        
                                                    } else {
                                                        self.fourthNameDatastreamLinkArray2[actualIndex] = ("N/A")
                                                        self.fourthObservationsDatastreamLinkArray2[actualIndex] = ("N/A")
                                                    }
                                                    
                                                    if self.tracker.contains("a"){
                                                    } else {
                                                        DispatchQueue.main.async {
                                                            // MARK: - Get Water Level Array
                                                            self.tracker = []
                                                            for p in 0...self.needToArray.count-1 {
                                                                self.tracker.append("a")
                                                                let creation100 = self.keyArray.firstIndex(of: self.needToArray[p])
                                                                let actualIndex1 = self.nameLocations[creation100!]
                                                                if self.firstObservationsDatastreamLinkArray2[actualIndex1] != "a" {
                                                                    if self.firstObservationsDatastreamLinkArray2[actualIndex1] != "N/A" {
                                                                        self.firstObservationsDatastreamLinkArray2[actualIndex1] += self.value50
                                                                    }
                                                                    
                                                                    if self.secondObservationsDatastreamLinkArray2[actualIndex1] != "N/A" {
                                                                        self.secondObservationsDatastreamLinkArray2[actualIndex1] += self.value50
                                                                    }
                                                                    
                                                                    if self.thirdObservationsDatastreamLinkArray2[actualIndex1] != "N/A" {
                                                                        self.thirdObservationsDatastreamLinkArray2[actualIndex1] += self.value50
                                                                    }
                                                                    
                                                                    if self.fourthObservationsDatastreamLinkArray2[actualIndex1] != "N/A" {
                                                                        self.fourthObservationsDatastreamLinkArray2[actualIndex1] += self.value50
                                                                    }
                                                                }
                                                            }
                                                            
                                                            for c in 0...self.needToArray.count-1 {
                                                                let link2 = self.keyArray.firstIndex(of: self.needToArray[c])
                                                                let actualIndex1 = self.nameLocations[link2!]
                                                                if self.firstNameDatastreamLinkArray2[actualIndex1] == "Water Level" {
                                                                    self.waterLevelArray[actualIndex1] = self.firstObservationsDatastreamLinkArray2[actualIndex1]
                                                                } else if self.secondNameDatastreamLinkArray2[actualIndex1] == "Water Level" {
                                                                    self.waterLevelArray[actualIndex1] = self.secondObservationsDatastreamLinkArray2[actualIndex1]
                                                                } else if self.thirdNameDatastreamLinkArray2[actualIndex1] == "Water Level" {
                                                                    self.waterLevelArray[actualIndex1] = self.thirdObservationsDatastreamLinkArray2[actualIndex1]
                                                                } else if self.fourthNameDatastreamLinkArray2[actualIndex1] == "Water Level" {
                                                                    self.waterLevelArray[actualIndex1] = self.fourthObservationsDatastreamLinkArray2[actualIndex1]
                                                                } else {
                                                                    self.waterLevelArray[actualIndex1] = "N/A"
                                                                }
                                                                
                                                                
                                                                if self.waterLevelArray[actualIndex1] != "N/A" {
                                                                    guard let url2 = URL(string: self.waterLevelArray[actualIndex1]) else {return}
                                                                    URLSession.shared.dataTask(with: url2) { (data1, response, error) in
                                                                        
                                                                        guard let data2 = data1 else { return }
                                                                        do {
                                                                            let initial2 = try? JSONDecoder().decode(EntryLatestWater.self, from: data2)
                                                                            
                                                                            let v3_count = initial2?.value.count
                                                                            
                                                                            if v3_count != nil {
                                                                                self.currentWaterLevel = String(format:"%f", ((initial2?.value[0].result)!))
                                                                                self.numberWaterLevel[actualIndex1] = self.currentWaterLevel
                                                                                
                                                                                self.tracker[c] = String(format:"%f", ((initial2?.value[0].result)!))
                                                                                if (self.elevationNAVD88Array2[actualIndex1] != "N/A") {
                                                                                    
                                                                                    let first = Double(self.elevationNAVD88Array2[actualIndex1])!
                                                                                    let second = Double(self.currentWaterLevel)!
                                                                                    
                                                                                    self.differenceWaterLevel[actualIndex1] = first + second
                                                                                    
                                                                                    
                                                                                } else {
                                                                                    self.differenceWaterLevel[actualIndex1] = 100
                                                                                }
                                                                            } else {
                                                                                self.currentWaterLevel = "N/A"
                                                                                self.numberWaterLevel[actualIndex1] = self.currentWaterLevel
                                                                                self.differenceWaterLevel[actualIndex1] = 100
                                                                                self.tracker[c] = "done"
                                                                            }
                                                                            
                                                                            if self.tracker.contains("a") {
                                                                            } else {
                                                                                DispatchQueue.main.async {
                                                                                    self.needToArray = []
                                                                                    self.count()
                                                                                    self.convertFirebaseToArray()
                                                                                    self.getAllArrayData()
                                                                                    self.needToArray.removeAll()
                                                                                }
                                                                            }
                                                                        }
                                                                    }.resume()
                                                                } else {
                                                                    self.numberWaterLevel[actualIndex1] = "N/A"
                                                                    self.differenceWaterLevel[actualIndex1] = 100
                                                                    self.tracker[c] = "done"
                                                                    if self.tracker.contains("a") {
                                                                    } else {
                                                                        DispatchQueue.main.async {
                                                                            self.needToArray = []
                                                                            self.count()
                                                                            self.convertFirebaseToArray()
                                                                            self.getAllArrayData()
                                                                            self.needToArray.removeAll()
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                    
                                                }
                                            }.resume()
                                        }
                                    }
                                }
                            }
                        }
                    }.resume()
                }
            }
        }
    }
    
    // MARK: - Counts Favorite Sensors
    // Counts how many sensors are favorited
    func count() {
        let favourites = defaults.object(forKey: "favourites") as? [String] ?? [String]()
        self.countInt = favourites.count
    }
    
    // Appends favorite sensors to keyArray
    func convertFirebaseToArray() {
        let favourites = defaults.object(forKey: "favourites") as? [String] ?? [String]()
        
        if favourites.count == 0 {
            self.go = true
            self.favoritesTable.reloadData()
        } else {
            self.keyArray = favourites
        }
    }
    
    // Creates favoriteSignalArray that contains the actual water level for each favorited sensor
    func getAllArrayData() {
        for each in keyArray {
            let indexOfA = nameArray2.index(of: each)
        }
        
        if keyArray.count != 0 {
            if favoriteSignalArray.count < keyArray.count {
                let difference = keyArray.count - favoriteSignalArray.count
                for _ in 0...difference-1 {
                    favoriteSignalArray.append(1.1)
                }
            }
            
            for i in 0...keyArray.count-1 {
                let actualIndex = self.nameLocations[i]
                favoriteSignalArray[i] = differenceWaterLevel[actualIndex]
            }
        }
        self.go = true
        self.favoritesTable.reloadData()
    }
    
    // MARK: - Moving Menu Animation
    @IBAction func menuTapped(_ sender: Any) {
        if menuOut == false {
            regularLeading.constant = movingConstant
            regularTrailing.constant = movingConstant
            menuOut = true
        } else {
            regularLeading.constant = 0
            regularTrailing.constant = 0
            menuOut = false
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn,animations: {
            self.view.layoutIfNeeded()
        }) { (animationComplete) in
        }
    }
    
    //  MARK: - Menu Outlets
    @IBAction func learnMoreTapped(_ sender: Any) {
        showSafariVC(for: "https://www.sealevelsensors.org")
    }
    
    @IBAction func dashboardTapped(_ sender: Any) {
        showSafariVC(for: "https://dashboard.sealevelsensors.org")
    }
    
    
    @IBAction func contactUsTapped(_ sender: Any) {
        showSafariVC(for: "https://forms.gle/PZyqnpUHmhVzC32bA")
    }
    
    
    @IBAction func aboutUsTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AboutUs", bundle: nil)
        
        let aboutUsVC = storyboard.instantiateViewController(withIdentifier: "AboutUs")as! AboutUs
        
        self.navigationController?.pushViewController(aboutUsVC, animated: true)
    }
    
    // MARK: - Safari Function
    func showSafariVC(for url: String) {
        guard let url = URL(string: url) else{
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
    
}
extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate, FavoriteDelegate {
    func didTapHeart(in cell: FavoritesTableViewCell) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Returns count of how many cells in table
        if go == true {
            if countInt != 0 {
                return countInt
            } else {
                return 1
            }
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell (withIdentifier: "cell", for: indexPath) as? FavoritesTableViewCell
        
        // In TableViewController, line 599, I write about how this code works
        if go == true {
            if countInt != 0 {
                cell?.favoriteLabel?.text = keyArray[indexPath.row]
                
                if favoriteSignalArray[indexPath.row] < 1.2 {
                    cell?.favoriteSignal.backgroundColor = UIColor.init(red: 52/255, green: 134/255, blue: 255/255, alpha: 1)
                } else if favoriteSignalArray[indexPath.row] < 1.5 {
                    cell?.favoriteSignal.backgroundColor = UIColor.init(red: 241/255, green: 255/255, blue: 23/255, alpha: 1)
                } else if favoriteSignalArray[indexPath.row] < 100 {
                    cell?.favoriteSignal.backgroundColor = UIColor.init(red: 255/255, green: 22/255, blue: 23/255, alpha: 1)
                } else if favoriteSignalArray[indexPath.row] == 100 {
                    cell?.favoriteSignal.backgroundColor = UIColor.init(red: 255/255, green: 22/255, blue: 255/255, alpha: 1)
                } else {
                    cell?.favoriteSignal.backgroundColor = UIColor.init(red: 71/255, green: 85/255, blue: 100/255, alpha: 1)
                }
            } else {
                
                cell?.favoriteLabel?.text = "N/A - To add sensors, click on a sensor in the Data Tab and select the heart icon."
                cell?.favoriteSignal.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0)
            }
            
            if indexPath.row % 2 == 0 {
                cell?.backgroundColor = UIColor.white
            } else {
                cell?.backgroundColor = UIColor.init(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
            }
            
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        } else if internet == false {
            cell?.favoriteLabel?.text = "Error: No Internet Connection"
            cell?.favoriteSignal.backgroundColor = UIColor.init(red: 179/255, green: 163/255, blue: 105/255, alpha: 1)
        } else {
            cell?.favoriteLabel?.text = "Loading..."
            cell?.favoriteSignal.backgroundColor = UIColor.init(red: 179/255, green: 163/255, blue: 105/255, alpha: 1)
        }
        
        cell!.delegate = self

        return cell!
    }
    
    // If cell is clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if countInt != 0 {
            // Favorite sensors position in the total array of all sensors
            let correctIndex = nameLocations[indexPath.row]
            
            // If favorite sensor has been clicked before, the stored data will pass
            if doneBefore.contains(nameArray2[correctIndex]) {
                let vc = storyboard?.instantiateViewController(identifier: "SensorDataViewController") as? SensorDataViewController
                vc?.name = nameArray2[correctIndex]
                vc?.sensorThingsID = IDArray2[correctIndex]
                vc?.deviceID = deviceIDArray2[correctIndex]
                
                // Do Later
                vc?.locationDescription = descriptionLocationLinkArray2[correctIndex]
                vc?.sensorNAVD88Elevation = elevationNAVD88Array2[correctIndex]
                
                vc?.url1Link = firstObservationsDatastreamLinkArray2[correctIndex]
                vc?.url1Name = firstNameDatastreamLinkArray2[correctIndex]
                vc?.url1Unit = firstUnitOfMeasurementArray2[correctIndex]
                
                vc?.url2Link = secondObservationsDatastreamLinkArray2[correctIndex]
                vc?.url2Name = secondNameDatastreamLinkArray2[correctIndex]
                vc?.url2Unit = secondUnitOfMeasurementArray2[correctIndex]
                
                vc?.url3Link = thirdObservationsDatastreamLinkArray2[correctIndex]
                vc?.url3Name = thirdNameDatastreamLinkArray2[correctIndex]
                vc?.url3Unit = thirdUnitOfMeasurementArray2[correctIndex]
                
                vc?.url4Link = fourthObservationsDatastreamLinkArray2[correctIndex]
                vc?.url4Name = fourthNameDatastreamLinkArray2[correctIndex]
                vc?.url4Unit = fourthUnitOfMeasurementArray2[correctIndex]
                
                vc?.coordinate1 = coordinates1LocationLinkArray2[correctIndex]
                vc?.coordinate2 = coordinates2LocationLinkArray2[correctIndex]
                
                vc?.signalValue = differenceWaterLevel[correctIndex]
                
                ready2 = 0
                self.navigationController?.pushViewController(vc!, animated: true)
            } else {
                // Load sensor data for the first time and store
                self.doneBefore.append(self.nameArray2[correctIndex])
                for _ in 0...nameArray2.count-1 {
                    IDArray2.append("a")
                    deviceIDArray2.append("a")
                    descriptionLocationLinkArray2.append("a")
                    locationLinkArray2.append("a")
                    firstUnitOfMeasurementArray2.append("a")
                    secondUnitOfMeasurementArray2.append("a")
                    thirdUnitOfMeasurementArray2.append("a")
                    fourthUnitOfMeasurementArray2.append("a")
                    coordinates1LocationLinkArray2.append(0.0)
                    coordinates2LocationLinkArray2.append(0.0)
                }
                
                let url = "https://api.sealevelsensors.org/v1.0/Things"
                let urlObj = URL(string: url)
                
                URLSession.shared.dataTask(with: urlObj!) {(data, response, error) in //I explain this code in TableViewController.swift in line 677 and onwards
                    do {
                        let entry = try! JSONDecoder().decode(Entry.self, from: data!)
                        self.nameArrayCount2 = entry.value.count
                        self.IDArray2[correctIndex] = (String((entry.value[correctIndex].ID)!))
                        self.deviceIDArray2[correctIndex] = (String((entry.value[correctIndex].deviceID)!))
                        self.descriptionLocationLinkArray2[correctIndex] = (String((entry.value[correctIndex].locationLink)!))
                        self.locationLinkArray2[correctIndex] = (String((entry.value[correctIndex].locationLink)!))
                        
                        DispatchQueue.main.async {
                            let specificUrl = self.datastreamLinkArray2[correctIndex]
                            URLSession.shared.dataTask(with: URL(string: specificUrl)!) {(data, response, error) in
                                do {
                                    let entry2 = try! JSONDecoder().decode(Entry2.self, from: data!)
                                    self.ArrayCount2 = entry2.value.count
                                    if (self.ArrayCount2 > 0) {
                                        self.firstUnitOfMeasurementArray2[correctIndex] = ((entry2.value[0].unitOfMeasurement?.symbol)!)
                                    } else {
                                        self.firstUnitOfMeasurementArray2[correctIndex] = ("N/A")
                                    }
                                    
                                    if (self.ArrayCount2 > 1) {
                                        self.secondUnitOfMeasurementArray2[correctIndex] = ((entry2.value[1].unitOfMeasurement?.symbol)!)
                                    } else {
                                        self.secondUnitOfMeasurementArray2[correctIndex] = ("N/A")
                                    }
                                    
                                    if (self.ArrayCount2 > 2) {
                                        self.thirdUnitOfMeasurementArray2[correctIndex] = ((entry2.value[2].unitOfMeasurement?.symbol)!)
                                    } else {
                                        self.thirdUnitOfMeasurementArray2[correctIndex] = ("N/A")
                                    }
                                    
                                    if (self.ArrayCount2 > 3) {
                                        self.fourthUnitOfMeasurementArray2[correctIndex] = ((entry2.value[3].unitOfMeasurement?.symbol)!)
                                    } else {
                                        self.fourthUnitOfMeasurementArray2[correctIndex] = ("N/A")
                                    }
                                    
                                }
                            }.resume()
     
                            let url = self.locationLinkArray2[correctIndex]
                            let urlObj = URL(string: url)
                            
                            URLSession.shared.dataTask(with: urlObj!) {(data, response, error) in
                                
                                do {
                                    let entryLocationLink = try! JSONDecoder().decode(EntryLocationLink.self, from: data!)
                                    _ = entryLocationLink.value!.count
                                    
                                    self.descriptionLocationLinkArray2[correctIndex] = (entryLocationLink.value![0].locationDescription!)
                                    
                                    self.coordinates1LocationLinkArray2[correctIndex] = (entryLocationLink.value![0].location?.coordinates[0])!
                                    self.coordinates2LocationLinkArray2[correctIndex] = (entryLocationLink.value![0].location?.coordinates[1])!
                                    
                                    
                                    DispatchQueue.main.async {
                                        self.ready2 += 1
                                        if self.ready2 == 2 {
                                            index()
                                        }
                                    }
                                    
                                }
                                
                            }.resume()
                        }
                        
                        guard let url2 = URL(string: self.waterLevelArray[correctIndex]) else {return}
                        
                        if self.waterLevelArray[correctIndex] != "N/A" {
                            URLSession.shared.dataTask(with: url2) { (data1, response, error) in
                                guard let data2 = data1 else { return }
                                do {
                                    let initial2 = try? JSONDecoder().decode(EntryLatestWater.self, from: data2)
                                    let v3_count = initial2?.value.count
                                    
                                    if v3_count != nil {
                                        self.currentWaterLevel = String(format:"%f", ((initial2?.value[0].result)!))
                                        self.numberWaterLevel[correctIndex] = self.currentWaterLevel
                                        
                                        if (self.elevationNAVD88Array2[correctIndex] != "N/A") {
                                            
                                            let first = Double(self.elevationNAVD88Array2[correctIndex])!
                                            let second = Double(self.currentWaterLevel)!
                                            
                                            self.differenceWaterLevel[correctIndex] = first + second
                                            
                                        } else {
                                            self.differenceWaterLevel[correctIndex] = 100
                                        }
                                    } else {
                                        self.currentWaterLevel = "N/A"
                                        let isThereWaterValue = false
                                        self.numberWaterLevel[correctIndex] = self.currentWaterLevel
                                        self.differenceWaterLevel[correctIndex] = 100
                                    }
                                    
                                    DispatchQueue.main.async {
                                        self.ready2 += 1
                                        if self.ready2 == 2 {
                                            index()
                                        }
                                    }
                                }
                            }.resume()
                        } else {
                            self.ready2 += 1
                            if self.ready2 == 2 {
                                index()
                            }
                        }
                        
                    }
                }.resume()
                
                // Once sensor finished loading, the sensor's data will pass so the user can view the data
                func index() {
                    let vc = storyboard?.instantiateViewController(identifier: "SensorDataViewController") as? SensorDataViewController
                    vc?.name = nameArray2[correctIndex]
                    vc?.sensorThingsID = IDArray2[correctIndex]
                    vc?.deviceID = deviceIDArray2[correctIndex]
                    
                    // Do Later
                    vc?.locationDescription = descriptionLocationLinkArray2[correctIndex]
                    vc?.sensorNAVD88Elevation = elevationNAVD88Array2[correctIndex]
                    
                    vc?.url1Link = firstObservationsDatastreamLinkArray2[correctIndex]
                    vc?.url1Name = firstNameDatastreamLinkArray2[correctIndex]
                    vc?.url1Unit = firstUnitOfMeasurementArray2[correctIndex]
                    
                    vc?.url2Link = secondObservationsDatastreamLinkArray2[correctIndex]
                    vc?.url2Name = secondNameDatastreamLinkArray2[correctIndex]
                    vc?.url2Unit = secondUnitOfMeasurementArray2[correctIndex]
                    
                    vc?.url3Link = thirdObservationsDatastreamLinkArray2[correctIndex]
                    vc?.url3Name = thirdNameDatastreamLinkArray2[correctIndex]
                    vc?.url3Unit = thirdUnitOfMeasurementArray2[correctIndex]
                    
                    vc?.url4Link = fourthObservationsDatastreamLinkArray2[correctIndex]
                    vc?.url4Name = fourthNameDatastreamLinkArray2[correctIndex]
                    vc?.url4Unit = fourthUnitOfMeasurementArray2[correctIndex]
                    
                    vc?.coordinate1 = coordinates1LocationLinkArray2[correctIndex]
                    vc?.coordinate2 = coordinates2LocationLinkArray2[correctIndex]
                    
                    vc?.signalValue = differenceWaterLevel[correctIndex]
                    
                    ready2 = 0
                    self.navigationController?.pushViewController(vc!, animated: true)
                }
            }
        }
    }
}

