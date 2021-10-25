//
//  TableViewController.swift
//  GTSeaLevelApp
//
//  Created by Johnson Amalanathan on 1/20/20.
//  Copyright © 2020 GTSeaLevelApp. All rights reserved.
//
// MARK: - import
import UIKit
import SafariServices

// MARK: - Structure for Sensors
struct Entry: Decodable {
    let value : [Value]
    
    enum CodingKeys: String, CodingKey {
        case value
    }
    
}

struct Value: Decodable {
    let deviceID : String?
    let name : String?
    let properties : Properties?
    let datastreamLink : String?
    let locationLink : String?
    let ID : Int?
    
    enum CodingKeys: String, CodingKey {
        case deviceID = "name"
        case name = "description"
        case properties
        case datastreamLink = "Datastreams@iot.navigationLink"
        case locationLink = "Locations@iot.navigationLink"
        case ID = "@iot.id"
    }
}

struct Properties : Decodable {
    let elevationNAVD88 : String?
    
    enum CodingKeys: String, CodingKey {
        case elevationNAVD88
    }
}

// MARK: - Structure for Datastreams
struct Entry2: Decodable {
    let value : [Value2]
    
    enum CodingKeys: String, CodingKey {
        case value
    }
    
}

struct Value2: Decodable {
    let nameDatastreamLink : String?
    let descriptionDatastreamLink : String?
    let observationsDatastreamLink : String?
    let unitOfMeasurement : UnitOfMeasurement?
    
    enum CodingKeys: String, CodingKey {
        case nameDatastreamLink = "name"
        case descriptionDatastreamLink = "description"
        case observationsDatastreamLink = "Observations@iot.navigationLink"
        case unitOfMeasurement
    }
}

struct UnitOfMeasurement: Decodable {
    let symbol : String?
}

// MARK: - Structure for Data Values
struct Entry3: Decodable {
    let value : [Value3]
}

struct Value3: Decodable {
    let phenomenonTime : String?
    let result : Double?
}

// MARK: - Structure for Location
struct EntryLocationLink: Decodable {
    let value : [ValueLocationLink]?
}

struct ValueLocationLink: Decodable {
    let locationDescription : String?
    let location : Location?
    
    enum CodingKeys: String, CodingKey {
        case locationDescription = "description"
        case location
    }
}

struct Location: Decodable {
    let type : String?
    let coordinates : [Double]
}

// MARK: - Structure for Water Level
struct LatestWater: Decodable {
    
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

struct EntryLatestWater: Decodable {
    let nextLink : String
    let value : [LatestWater]
    
    enum CodingKeys: String, CodingKey {
        case nextLink = "@iot.nextLink"
        case value
    }
}

class TableViewController: UIViewController {
    // MARK: - Outlets to story board
    @IBOutlet weak var SensorSelect: UILabel!
    
    // Outlets for UITableView and other supporting structures
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet var tableViewController: UIView!
    
    // Outlets for menu animation
    @IBOutlet weak var tableLeading: NSLayoutConstraint!
    @IBOutlet weak var tableTrailing: NSLayoutConstraint!
    @IBOutlet weak var searchLeading: NSLayoutConstraint!
    @IBOutlet weak var searchTrailing: NSLayoutConstraint!
    @IBOutlet var instructionsLeading: NSLayoutConstraint!
    @IBOutlet var instructionsTrailing: NSLayoutConstraint!
    
    // Outlet that refreshes UITableView
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    // Outlets that prevent user from touching back of UITableView and pressing outher buttons
    @IBOutlet weak var coverHeight: NSLayoutConstraint!
    @IBOutlet weak var coverWidth: NSLayoutConstraint!
    
    // Preload variables for all sensors
    var nameArrayCount2 = Int()
    var nameArray2 = [String]()
    var deviceIDArray2 = [String]()
    var elevationNAVD88Array2 = [String]()
    var IDArray2 = [String]()
    
    // Variables that holds datastream links
    var locationLinkArray2 = [String]()
    var datastreamLinkArray2 = [String]()
    
    // Variables that holds all sensors first datastream name and link
    var firstObservationsDatastreamLinkArray2 = [String]()
    var firstNameDatastreamLinkArray2 = [String]()
    
    // Variables that holds all sensors second datastream name and link
    var secondNameDatastreamLinkArray2 = [String]()
    var secondObservationsDatastreamLinkArray2 = [String]()
    
    // Variables that holds all sensors third datastream name and link
    var thirdNameDatastreamLinkArray2 = [String]()
    var thirdObservationsDatastreamLinkArray2 = [String]()
    
    // Variables that holds all sensors fourth datastream name and link
    var fourthNameDatastreamLinkArray2 = [String]()
    var fourthObservationsDatastreamLinkArray2 = [String]()
    
    // Variables that contain the sensors location's description and cordinates
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
    
    // Variables used in searching sensors
    var searchingNames = [String()]
    var searchingSignal = [Double()]
    
    // Keeps track of how many sensors the user loaded so it is easier to load when the user clcks on the sensor again in that session
    var doneBefore = [String]()
    
    // Added to the end of datastream link to get top 50 latest values
    var value50 = "?$top=50&$orderby=phenomenonTime%20desc"
    
    // if user is currently searching or not
    var searching = false
    
    // if data is ready for UITableView to update
    var go = false
    
    // Can the user click on cells in the UITable
    var clickable = true
    
    // If it is the first time the page is loading
    var firstTime = true
    
    // If there is internet
    var internet = false
    // If the menu is open
    var menuOut = false
    
    // Variables to know how many network calls back the program is getting and once all network calls return, more code will run
    var ready1 = 0
    var ready2 = 0
    
    // The limit the ready variables must reach before more code runs
    var readyCount = 3
    
    // Menu constants
    let coverHeightLength:CGFloat = 237
    let coverWidthLength:CGFloat = 240
    let movingConstant:CGFloat = 300
    
    // Counts how many sensors we currently preloaded data (reaches the max number of sensors as more network calls comes in)
    var activeSensors = 0
    
    // Other tabs
    var tabBarItem1: UITabBarItem!
    var tabBarItem2: UITabBarItem!
    
    // Can user refresh
    var canRefresh = false
    
    // MARK: - ViewDidLooad
    // Refresh Outlet
    @IBAction func refreshClicked(_ sender: Any) {
        if canRefresh == true || internet == false {
            canRefresh = false
            viewDidLoad()
            tblView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        canRefresh = false
        // Clears all arrays so it can preload all sensors necessary data in order for at least the current status of the sensor to show (No warnings, warnings, etc.)
        ready1 = 0
        ready2 = 0
        activeSensors = 0
        
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
        
        go = false
        firstTime = true
        internet = false
        
        doneBefore = []
        
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.timeoutIntervalForResource = 300

        let session = URLSession(configuration: config)
        // MARK: - Parse Things
        let url = "https://api.sealevelsensors.org/v1.0/Things"
        let urlObj = URL(string: url)
        
        session.dataTask(with: urlObj!) {(data, response, error) in
            self.internet = true
            DispatchQueue.main.async {
                self.tblView.reloadData()
            }
            
            do {
                let entry = try! JSONDecoder().decode(Entry.self, from: data!)
                self.nameArrayCount2 = entry.value.count
                
                // Loops for each sensor
                for i in 0...self.nameArrayCount2-1 {
                    // stores all sensors name, elevation, datastream link
                    self.nameArray2.append(String((entry.value[i].name)!))
                    if ((entry.value[i].properties?.elevationNAVD88) != nil) {
                        self.elevationNAVD88Array2.append(String((entry.value[i].properties?.elevationNAVD88)!))
                    } else {
                        self.elevationNAVD88Array2.append("N/A")
                    }
                    self.datastreamLinkArray2.append(String((entry.value[i].datastreamLink)!))
                }
                
                DispatchQueue.main.async {
                    // Appends random value in array because network calls come in different orders so the netork call will replace the correct posiotions that it is suppoed to be when it comes
                    for _ in 0...self.datastreamLinkArray2.count-1 {
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
                    
                    // MARK: Parsing Each Sensor
                    for link1 in 0...self.datastreamLinkArray2.count-1 {
                        let specificUrl = self.datastreamLinkArray2[link1]
                        URLSession.shared.dataTask(with: URL(string: specificUrl)!) {(data, response, error) in
                            
                            do {
                                // Appends random value to conteract the changge in order from network calls
                                self.differenceWaterLevel[link1] = -1000.1
                                let entry2 = try! JSONDecoder().decode(Entry2.self, from: data!)
                                
                                // Counts how many datastreams each sensor has
                                self.ArrayCount2 = entry2.value.count
                                
                                // In each datstream,the name of stream and link is put in one array (Example, every sensor's first datastream name is put in a specific array, etc.)
                                if (self.ArrayCount2 > 0) {
                                    self.firstNameDatastreamLinkArray2[link1] = (entry2.value[0].nameDatastreamLink!)
                                    self.firstObservationsDatastreamLinkArray2[link1] = (entry2.value[0].observationsDatastreamLink!)
                                } else {
                                    self.firstNameDatastreamLinkArray2[link1] = ("N/A")
                                    self.firstObservationsDatastreamLinkArray2[link1] = ("N/A")
                                }
                                
                                if (self.ArrayCount2 > 1) {
                                    self.secondNameDatastreamLinkArray2[link1] = (entry2.value[1].nameDatastreamLink!)
                                    self.secondObservationsDatastreamLinkArray2[link1] = (entry2.value[1].observationsDatastreamLink!)
                                } else {
                                    self.secondNameDatastreamLinkArray2[link1] = ("N/A")
                                    self.secondObservationsDatastreamLinkArray2[link1] = ("N/A")
                                }
                                
                                if (self.ArrayCount2 > 2) {
                                    self.thirdNameDatastreamLinkArray2[link1] = (entry2.value[2].nameDatastreamLink!)
                                    self.thirdObservationsDatastreamLinkArray2[link1] = (entry2.value[2].observationsDatastreamLink!)
                                } else {
                                    self.thirdNameDatastreamLinkArray2[link1] = ("N/A")
                                    self.thirdObservationsDatastreamLinkArray2[link1] = ("N/A")
                                }
                                
                                if (self.ArrayCount2 > 3) {
                                    self.fourthNameDatastreamLinkArray2[link1] = (entry2.value[3].nameDatastreamLink!)
                                    self.fourthObservationsDatastreamLinkArray2[link1] = (entry2.value[3].observationsDatastreamLink!)
                                    
                                } else {
                                    self.fourthNameDatastreamLinkArray2[link1] = ("N/A")
                                    self.fourthObservationsDatastreamLinkArray2[link1] = ("N/A")
                                }
                                
                                // Once array no longer has the random value, code will continue (this is the prevent code from running before all the network calls values have returned)
                                if self.firstNameDatastreamLinkArray2.contains("a") {
                                } else {
                                    DispatchQueue.main.async {
                                        // Adds ending to each datastream link to make values return the latest top 50 observations
                                        for creation100 in 0...self.datastreamLinkArray2.count-1 {
                                            // Only values that have links will have these endings added; if the value has no link, then the ending will not be added
                                            if self.firstObservationsDatastreamLinkArray2[creation100] != "N/A" {
                                                self.firstObservationsDatastreamLinkArray2[creation100] += self.value50
                                            }
                                            
                                            if self.secondObservationsDatastreamLinkArray2[creation100] != "N/A" {
                                                self.secondObservationsDatastreamLinkArray2[creation100] += self.value50
                                            }
                                            
                                            if self.thirdObservationsDatastreamLinkArray2[creation100] != "N/A" {
                                                self.thirdObservationsDatastreamLinkArray2[creation100] += self.value50
                                            }
                                            
                                            if self.fourthObservationsDatastreamLinkArray2[creation100] != "N/A" {
                                                self.fourthObservationsDatastreamLinkArray2[creation100] += self.value50
                                            }
                                            
                                        }
                                        
                                        // Checks which link is related to water level and adds that link to waterLevelArray
                                        for link2 in 0...self.datastreamLinkArray2.count-1 {
                                            
                                            if self.firstNameDatastreamLinkArray2[link2] == "Water Level" {
                                                self.waterLevelArray[link2] = self.firstObservationsDatastreamLinkArray2[link2]
                                            } else if self.secondNameDatastreamLinkArray2[link2] == "Water Level" {
                                                self.waterLevelArray[link2] = self.secondObservationsDatastreamLinkArray2[link2]
                                            } else if self.thirdNameDatastreamLinkArray2[link2] == "Water Level" {
                                                self.waterLevelArray[link2] = self.thirdObservationsDatastreamLinkArray2[link2]
                                            } else if self.fourthNameDatastreamLinkArray2[link2] == "Water Level" {
                                                self.waterLevelArray[link2] = self.fourthObservationsDatastreamLinkArray2[link2]
                                            } else {
                                                self.waterLevelArray[link2] = "N/A"
                                            }
                                            
                                            // Checks if water level link exists
                                            if self.waterLevelArray[link2] != "N/A" {
                                                guard let url2 = URL(string: self.waterLevelArray[link2]) else {return}
                                                URLSession.shared.dataTask(with: url2) { (data1, response, error) in
                                                    
                                                    guard let data2 = data1 else { return }
                                                    do {
                                                        let initial2 = try? JSONDecoder().decode(EntryLatestWater.self, from: data2)
                                                        
                                                        let v3_count = initial2?.value.count
                                                        
                                                        // Checks if link actually contains observations
                                                        if v3_count != nil {
                                                            // Takes current water level
                                                            self.currentWaterLevel = String(format:"%f", ((initial2?.value[0].result)!))
                                                            self.numberWaterLevel[link2] = self.currentWaterLevel
                                                            
                                                            // If elevation of sensor exists, the difference between water level and elevation is recorded to find actual water level
                                                            if (self.elevationNAVD88Array2[link2] != "N/A") {
                                                                // adds elevation and water level together to get the difference
                                                                let first = Double(self.elevationNAVD88Array2[link2])!
                                                                let second = Double(self.currentWaterLevel)!
                                                                
                                                                self.differenceWaterLevel[link2] = first + second
                                                                
                                                                
                                                            } else { // If elevation doesn not exist, then data will be left as random value which will later represent sensors that only record air quality and not sea level
                                                                self.differenceWaterLevel[link2] = 100
                                                            }
                                                        } else { // If water lavel link doesn't contain observations, then data will be left as random value which will later represent sensors that only record air quality and not sea level
                                                            self.currentWaterLevel = "N/A"
                                                            self.numberWaterLevel[link2] = self.currentWaterLevel
                                                            self.differenceWaterLevel[link2] = 100
                                                        }
                                                        
                                                        // Increase count of how many senors the code preloaded data (parsing all this preliminary data like this)
                                                        self.activeSensors += 1
                                                        
                                                        DispatchQueue.main.async {
                                                            // Updates count to text in the page
                                                            self.SensorSelect.text = "Please select a sensor location below (\(self.activeSensors)/\(self.nameArray2.count))"
                                                            
                                                            if (self.activeSensors/self.nameArray2.count) == 1 {
                                                                self.canRefresh = true
                                                            }
                                                            
                                                            if self.searching {
                                                                // Fills array with random value so data can easily exchange between another array
                                                                if self.searchingNames.count != 0 {
                                                                    // Searching signal only gets values that the searching array has sensors for
                                                                    for i in 0...self.searchingNames.count-1 {
                                                                        let point = self.nameArray2.firstIndex(of: self.searchingNames[i])
                                                                        self.searchingSignal[i] = self.differenceWaterLevel[point!]
                                                                    }
                                                                }
                                                            }
                                                            
                                                            // Refreshes the UITable so the table will update everytime it preloads another sensor
                                                            self.go = true
                                                            self.tblView.reloadData()
                                                            
                                                        
                                                        }
                                                        
                                                    }
                                                }.resume()
                                            } else { // If water lavel link doesn't exist, then data will be left as random value which will later represent sensors that only record air quality and not sea level
                                                self.activeSensors += 1
                                                self.numberWaterLevel[link2] = "N/A"
                                                self.differenceWaterLevel[link2] = 100
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
    }
    
    // MARK: - Menu Animation
    @IBAction func menuTapped(_ sender: Any) {
        if menuOut == false {
            tableLeading.constant = movingConstant
            tableTrailing.constant = movingConstant
            searchLeading.constant = movingConstant
            searchTrailing.constant = -movingConstant
            instructionsLeading.constant = movingConstant
            instructionsTrailing.constant = -movingConstant
            coverWidth.constant = 0
            coverHeight.constant = 0
            tblView.isScrollEnabled = false
            menuOut = true
        } else {
            tableLeading.constant = 0
            tableTrailing.constant = 0
            searchLeading.constant = 0
            searchTrailing.constant = 0
            instructionsLeading.constant = 0
            instructionsTrailing.constant = 0
            coverWidth.constant = coverWidthLength
            coverHeight.constant = coverHeightLength
            tblView.isScrollEnabled = true
            menuOut = false
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }) { (animationComplete) in
            Swift.print("complete")
        }
        
    }
    
    
    // MARK: - Menu Outlets
    @IBAction func contactUsTapped(_ sender: UIButton) {
        showSafariVC(for: "https://forms.gle/PZyqnpUHmhVzC32bA")
    }
    
    @IBAction func dashboardTapped(_ sender: UIButton) {
        showSafariVC(for: "https://dashboard.sealevelsensors.org")
    }
    
    @IBAction func learnMoreTapped(_ sender: UIButton) {
        showSafariVC(for: "https://www.sealevelsensors.org")
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

// MARK: UITableView
extension TableViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    // MARK: - Determines # of Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // If program is ready to present UITableView
        if go == true {
            // If user is searching for sensors
            if searching {
                // Returns array count of the searched array
                return searchingNames.count
            } else {
                return nameArray2.count
            }
        } else {
            return 1
        }
        
    }
    
    // MARK: - Labels for Each Row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CellTableViewCell
        
        // If UITable is presenting data
        if go == true{
            // If User is searching
            if searching {
                // Labels are sensor names that are searched
                cell?.lbl?.text = searchingNames[indexPath.row]
                
                // Based on sensor water level difference for searched sensors, it will present a unique color for what status it is
                if searchingSignal[indexPath.row] != -1000.1 {
                    if searchingSignal[indexPath.row] < 1.2 {
                        cell?.signal.backgroundColor = UIColor.init(red: 52/255, green: 134/255, blue: 255/255, alpha: 1)
                    } else if searchingSignal[indexPath.row] < 1.5 {
                        cell?.signal.backgroundColor = UIColor.init(red: 241/255, green: 255/255, blue: 23/255, alpha: 1)
                    } else if searchingSignal[indexPath.row] < 100 {
                        cell?.signal.backgroundColor = UIColor.init(red: 255/255, green: 22/255, blue: 23/255, alpha: 1)
                    } else if searchingSignal[indexPath.row] == 100 {
                        cell?.signal.backgroundColor = UIColor.init(red: 255/255, green: 22/255, blue: 255/255, alpha: 1)
                    } else {
                        cell?.signal.backgroundColor = UIColor.init(red: 71/255, green: 85/255, blue: 100/255, alpha: 1)
                    }
                } else {
                    // If there is no status, then the signal color will alternate between white and grey
                    if indexPath.row % 2 == 0 {
                        cell?.signal.backgroundColor = UIColor.white
                    } else {
                        cell?.signal.backgroundColor = UIColor.init(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
                    }
                }
                
                // Background color for the cells alternate between grey and white
                if indexPath.row % 2 == 0 {
                    cell?.backgroundColor = UIColor.init(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
                } else {
                    cell?.backgroundColor = UIColor.white
                }
            } else { // If user is not searching, changes list of sensors to all
                cell?.lbl?.text = nameArray2[indexPath.row]
                
                // If there is actual water level, it will present the status
                if differenceWaterLevel[indexPath.row] != -1000.1 {
                    // For all sensors, based on actual water level, a unique status of the sensors will be shown
                    if differenceWaterLevel[indexPath.row] < 1.2 {
                        cell?.signal.backgroundColor = UIColor.init(red: 52/255, green: 134/255, blue: 255/255, alpha: 1)
                    } else if differenceWaterLevel[indexPath.row] < 1.5 {
                        cell?.signal.backgroundColor = UIColor.init(red: 241/255, green: 255/255, blue: 23/255, alpha: 1)
                    } else if differenceWaterLevel[indexPath.row] < 100 {
                        cell?.signal.backgroundColor = UIColor.init(red: 255/255, green: 22/255, blue: 23/255, alpha: 1)
                    } else if differenceWaterLevel[indexPath.row] == 100 {
                        cell?.signal.backgroundColor = UIColor.init(red: 255/255, green: 22/255, blue: 255/255, alpha: 1)
                    } else {
                        cell?.signal.backgroundColor = UIColor.init(red: 71/255, green: 85/255, blue: 100/255, alpha: 1)
                    }
                } else { // If actual water level is not calculated yet, then the status will alternate between white and grey
                    if indexPath.row % 2 == 0 {
                        cell?.signal.backgroundColor = UIColor.init(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
                    } else {
                        cell?.signal.backgroundColor = UIColor.white
                    }
                }
                
                // Background color for each cell will alternate between white and grey
                if indexPath.row % 2 == 0 {
                    cell?.backgroundColor = UIColor.white
                } else {
                    cell?.backgroundColor = UIColor.init(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
                }
            }
            
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        } else if internet == false { // If UITableView isn't ready to present data, it will display "Loading..."
            cell?.lbl.text = "Error: No Internet Connection"
            cell?.signal.backgroundColor = UIColor.init(red: 179/255, green: 163/255, blue: 105/255, alpha: 1)
        } else { // If UITableView isn't ready to present data, it will display "Loading..."
            cell?.lbl.text = "Loading..."
            cell?.signal.backgroundColor = UIColor.init(red: 179/255, green: 163/255, blue: 105/255, alpha: 1)
        }
        
        
        return cell!
    }
    
    // MARK: - Sends Data to Next VC
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // If menu is closed, user can access sensor data
        if menuOut == false {
            if go == true{
                canRefresh = false
                // Prevents user from going to a different tab, while sensors are loading
                let tabBarControllerItems = self.tabBarController?.tabBar.items
                if let tabArray = tabBarControllerItems {
                    tabBarItem1 = tabArray[0]
                    tabBarItem2 = tabArray[2]
                }
                
                // Establishes the user is going to view the sensor's page
                let vc = storyboard?.instantiateViewController(identifier: "SensorDataViewController") as? SensorDataViewController
                // If the user clicks on the cell
                if clickable == true {
                    // Prevents the user from clicking another cell or tab
                    clickable = false
                    tabBarItem1.isEnabled = false
                    tabBarItem2.isEnabled = false
                    
                    // If user is searching, it will get the right sensor the user tapped
                    // I already did comments for parsing JSON in line 310 of TableViewController.swift so view that for reference
                    if searching{
                        // MARK: - Searching Sensors
                        // Converts to the right index to account for searching
                        let person = searchingNames[indexPath.row]
                        let indexOfA = nameArray2.firstIndex(of: person)
                        
                        // If user already loaded a sensors, it will load up the sensor using previous data
                        if doneBefore.contains(nameArray2[indexOfA!]) {
                            vc?.name = nameArray2[indexOfA!]
                            vc?.sensorThingsID = IDArray2[indexOfA!]
                            vc?.deviceID = deviceIDArray2[indexOfA!]
                            
                            vc?.locationDescription = descriptionLocationLinkArray2[indexOfA!]
                            vc?.sensorNAVD88Elevation = elevationNAVD88Array2[indexOfA!]
                            
                            vc?.url1Link = firstObservationsDatastreamLinkArray2[indexOfA!]
                            vc?.url1Name = firstNameDatastreamLinkArray2[indexOfA!]
                            vc?.url1Unit = firstUnitOfMeasurementArray2[indexOfA!]
                            
                            vc?.url2Link = secondObservationsDatastreamLinkArray2[indexOfA!]
                            vc?.url2Name = secondNameDatastreamLinkArray2[indexOfA!]
                            vc?.url2Unit = secondUnitOfMeasurementArray2[indexOfA!]
                            
                            vc?.url3Link = thirdObservationsDatastreamLinkArray2[indexOfA!]
                            vc?.url3Name = thirdNameDatastreamLinkArray2[indexOfA!]
                            vc?.url3Unit = thirdUnitOfMeasurementArray2[indexOfA!]
                            
                            vc?.url4Link = fourthObservationsDatastreamLinkArray2[indexOfA!]
                            vc?.url4Name = fourthNameDatastreamLinkArray2[indexOfA!]
                            vc?.url4Unit = fourthUnitOfMeasurementArray2[indexOfA!]
                            
                            vc?.coordinate1 = coordinates1LocationLinkArray2[indexOfA!]
                            vc?.coordinate2 = coordinates2LocationLinkArray2[indexOfA!]
                            vc?.signalValue = differenceWaterLevel[indexOfA!]
                            
                            // Makes cells and tabs clickable again because cell has finished loading
                            clickable = true
                            tabBarItem1.isEnabled = true
                            tabBarItem2.isEnabled = true
                            
                            canRefresh = true
                            // Takes to sensor view controller
                            self.navigationController?.pushViewController(vc!, animated: true)
                        } else {
                            // If the list is being loaded for the first time, all sensors will have random value in the arrays to counteract the random order of network calls
                            if firstTime {
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
                                // Turns firstTime to false to tell the code that firstTime loading data has been done so it doesn't happen again
                                firstTime = false
                            }
                            
                            // I already did comments for parsing JSON in line 310 of TableViewController.swift so view that for reference
                            let url = "https://api.sealevelsensors.org/v1.0/Things"
                            let urlObj = URL(string: url)
                            
                            URLSession.shared.dataTask(with: urlObj!) {(data, response, error) in
                                do {
                                    let entry = try! JSONDecoder().decode(Entry.self, from: data!)
                                    self.nameArrayCount2 = entry.value.count
                                    self.IDArray2[indexOfA!] = (String((entry.value[indexOfA!].ID)!))
                                    self.deviceIDArray2[indexOfA!] = (String((entry.value[indexOfA!].deviceID)!))
                                    self.descriptionLocationLinkArray2[indexOfA!] = (String((entry.value[indexOfA!].locationLink)!))
                                    self.locationLinkArray2[indexOfA!] = (String((entry.value[indexOfA!].locationLink)!))
                                    
                                    DispatchQueue.main.async {
                                        let specificUrl = self.datastreamLinkArray2[indexOfA!]
                                        URLSession.shared.dataTask(with: URL(string: specificUrl)!) {(data, response, error) in
                                            do {
                                                let entry2 = try! JSONDecoder().decode(Entry2.self, from: data!)
                                                self.ArrayCount2 = entry2.value.count
                                                if (self.ArrayCount2 > 0) {
                                                    self.firstUnitOfMeasurementArray2[indexOfA!] = ((entry2.value[0].unitOfMeasurement?.symbol)!)
                                                } else {
                                                    self.firstUnitOfMeasurementArray2[indexOfA!] = ("N/A")
                                                }
                                                
                                                if (self.ArrayCount2 > 1) {
                                                    self.secondUnitOfMeasurementArray2[indexOfA!] = ((entry2.value[1].unitOfMeasurement?.symbol)!)
                                                } else {
                                                    self.secondUnitOfMeasurementArray2[indexOfA!] = ("N/A")
                                                }
                                                
                                                if (self.ArrayCount2 > 2) {
                                                    self.thirdUnitOfMeasurementArray2[indexOfA!] = ((entry2.value[2].unitOfMeasurement?.symbol)!)
                                                } else {
                                                    self.thirdUnitOfMeasurementArray2[indexOfA!] = ("N/A")
                                                }
                                                
                                                if (self.ArrayCount2 > 3) {
                                                    self.fourthUnitOfMeasurementArray2[indexOfA!] = ((entry2.value[3].unitOfMeasurement?.symbol)!)
                                                } else {
                                                    self.fourthUnitOfMeasurementArray2[indexOfA!] = ("N/A")
                                                }
                                                
                                            }
                                        }.resume()
                                        
                                        let url = self.locationLinkArray2[indexOfA!]
                                        let urlObj = URL(string: url)
                                        
                                        URLSession.shared.dataTask(with: urlObj!) {(data, response, error) in
                                            
                                            do {
                                                let entryLocationLink = try! JSONDecoder().decode(EntryLocationLink.self, from: data!)
                                                _ = entryLocationLink.value!.count
                                                
                                                self.descriptionLocationLinkArray2[indexOfA!] = (entryLocationLink.value![0].locationDescription!)
                                                //                                self.descriptionLocationLinkArray2.append(String((entryLocationLink.value[0].locationDescription)!))
                                                
                                                self.coordinates1LocationLinkArray2[indexOfA!] = (entryLocationLink.value![0].location?.coordinates[0])!
                                                self.coordinates2LocationLinkArray2[indexOfA!] = (entryLocationLink.value![0].location?.coordinates[1])!
                                                //                                self.coordinatesLocationLinkArray2[i] = entryLocationLink.value![0].location?.coordinates![0]
                                                
                                                
                                                DispatchQueue.main.async {
                                                    // Once final network call has been recieved, it will increase count
                                                    self.ready1 += 1
                                                    
                                                    // Once all network calls for the sensor has been recived, it will allow the user to view the sensor data
                                                    if self.ready1 == 2 {
                                                        indexA()
                                                    }
                                                }
                                                
                                            }
                                            
                                        }.resume()
                                    }
                                    guard let url2 = URL(string: self.waterLevelArray[indexOfA!]) else {return}
                                    URLSession.shared.dataTask(with: url2) { (data1, response, error) in
                                        guard let data2 = data1 else { return }
                                        do {
                                            let initial2 = try? JSONDecoder().decode(EntryLatestWater.self, from: data2)
                                            let v3_count = initial2?.value.count
                                            
                                            if v3_count != nil {
                                                self.currentWaterLevel = String(format:"%f", ((initial2?.value[0].result)!))
                                                self.numberWaterLevel[indexOfA!] = self.currentWaterLevel
                                                
                                                if (self.elevationNAVD88Array2[indexOfA!] != "N/A") {
                                                    
                                                    let first = Double(self.elevationNAVD88Array2[indexOfA!])!
                                                    let second = Double(self.currentWaterLevel)!
                                                    
                                                    self.differenceWaterLevel[indexOfA!] = first + second
                                                    
                                                } else {
                                                    self.differenceWaterLevel[indexOfA!] = 100
                                                }
                                            } else {
                                                self.currentWaterLevel = "N/A"
                                                self.numberWaterLevel[indexOfA!] = self.currentWaterLevel
                                                self.differenceWaterLevel[indexOfA!] = 100
                                            }
                                            
                                            DispatchQueue.main.async {
                                                // Once final network call has been recieved, it will increase count
                                                self.ready1 += 1
                                                
                                                // Once all network calls for the sensor has been recived, it will allow the user to view the sensor data
                                                if self.ready1 == 2 {
                                                    indexA()
                                                }
                                            }
                                        }
                                    }.resume()
                                }
                            }.resume()
                            
                            func indexA() { // Gets all the sensor's data using correct index and passes it to next view controller so user can access it
                                self.doneBefore.append(self.nameArray2[indexOfA!])
                                
                                vc?.name = self.nameArray2[indexOfA!]
                                vc?.sensorThingsID = self.IDArray2[indexOfA!]
                                vc?.deviceID = self.deviceIDArray2[indexOfA!]
                                //Do Later
                                vc?.locationDescription = self.descriptionLocationLinkArray2[indexOfA!]
                                vc?.sensorNAVD88Elevation = self.elevationNAVD88Array2[indexOfA!]
                                
                                vc?.url1Link = self.firstObservationsDatastreamLinkArray2[indexOfA!]
                                vc?.url1Name = self.firstNameDatastreamLinkArray2[indexOfA!]
                                vc?.url1Unit = self.firstUnitOfMeasurementArray2[indexOfA!]
                                
                                vc?.url2Link = self.secondObservationsDatastreamLinkArray2[indexOfA!]
                                vc?.url2Name = self.secondNameDatastreamLinkArray2[indexOfA!]
                                vc?.url2Unit = self.secondUnitOfMeasurementArray2[indexOfA!]
                                
                                vc?.url3Link = self.thirdObservationsDatastreamLinkArray2[indexOfA!]
                                vc?.url3Name = self.thirdNameDatastreamLinkArray2[indexOfA!]
                                vc?.url3Unit = self.thirdUnitOfMeasurementArray2[indexOfA!]
                                
                                vc?.url4Link = self.fourthObservationsDatastreamLinkArray2[indexOfA!]
                                vc?.url4Name = self.fourthNameDatastreamLinkArray2[indexOfA!]
                                vc?.url4Unit = self.fourthUnitOfMeasurementArray2[indexOfA!]
                                
                                vc?.coordinate1 = self.coordinates1LocationLinkArray2[indexOfA!]
                                vc?.coordinate2 = self.coordinates2LocationLinkArray2[indexOfA!]
                                vc?.signalValue = self.differenceWaterLevel[indexOfA!]
                                
                                // Resets value for final incoming network calls
                                ready1 = 0
                                
                                // Makes cell and tabs clickable
                                clickable = true
                                tabBarItem1.isEnabled = true
                                tabBarItem2.isEnabled = true
                                canRefresh = true
                                self.navigationController?.pushViewController(vc!, animated: true)
                            }
                            
                        }
                        
                        
                    } else { // If user is not searching
                        // MARK: - All sensors: Done Before
                        // If user already loaded a sensors, it will load up the sensor using that previous loaded data
                        if doneBefore.contains(nameArray2[indexPath.row]) {
                            vc?.name = nameArray2[indexPath.row]
                            vc?.sensorThingsID = IDArray2[indexPath.row]
                            vc?.deviceID = deviceIDArray2[indexPath.row]
                            //Do Later
                            vc?.locationDescription = descriptionLocationLinkArray2[indexPath.row]
                            vc?.sensorNAVD88Elevation = elevationNAVD88Array2[indexPath.row]
                            
                            vc?.url1Link = firstObservationsDatastreamLinkArray2[indexPath.row]
                            vc?.url1Name = firstNameDatastreamLinkArray2[indexPath.row]
                            vc?.url1Unit = firstUnitOfMeasurementArray2[indexPath.row]
                            
                            vc?.url2Link = secondObservationsDatastreamLinkArray2[indexPath.row]
                            vc?.url2Name = secondNameDatastreamLinkArray2[indexPath.row]
                            vc?.url2Unit = secondUnitOfMeasurementArray2[indexPath.row]
                            
                            vc?.url3Link = thirdObservationsDatastreamLinkArray2[indexPath.row]
                            vc?.url3Name = thirdNameDatastreamLinkArray2[indexPath.row]
                            vc?.url3Unit = thirdUnitOfMeasurementArray2[indexPath.row]
                            
                            vc?.url4Link = fourthObservationsDatastreamLinkArray2[indexPath.row]
                            vc?.url4Name = fourthNameDatastreamLinkArray2[indexPath.row]
                            vc?.url4Unit = fourthUnitOfMeasurementArray2[indexPath.row]
                            
                            vc?.coordinate1 = coordinates1LocationLinkArray2[indexPath.row]
                            vc?.coordinate2 = coordinates2LocationLinkArray2[indexPath.row]
                            vc?.signalValue = differenceWaterLevel[indexPath.row]
                            
                            // Makes cells and tab clickable again because loading has finished for the sensor
                            clickable = true
                            tabBarItem1.isEnabled = true
                            tabBarItem2.isEnabled = true
                            canRefresh = true
                            
                            // Pushes user to next view controller so they can see the sensor's data
                            self.navigationController?.pushViewController(vc!, animated: true)
                        } else { // If it is the first time the user is loading a sensor
                            // MARK: - All Sensors First Time
                            // If the list is being loaded for the first time, then all arrays get random value to conteract the effects of random order of network calls
                            if firstTime {
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
                                // Turns firstTime to false to tell the code that firstTime loading data has been done so it doesn't happen again
                                firstTime = false
                            }
                            
                            // I already did comments for parsing JSON in line 310 of TableViewController.swift so view that for reference
                            let url = "https://api.sealevelsensors.org/v1.0/Things"
                            let urlObj = URL(string: url)
                            
                            URLSession.shared.dataTask(with: urlObj!) {(data, response, error) in
                                do {
                                    let entry = try! JSONDecoder().decode(Entry.self, from: data!)
                                    self.nameArrayCount2 = entry.value.count
                                    self.IDArray2[indexPath.row] = (String((entry.value[indexPath.row].ID)!))
                                    self.deviceIDArray2[indexPath.row] = (String((entry.value[indexPath.row].deviceID)!))
                                    self.descriptionLocationLinkArray2[indexPath.row] = (String((entry.value[indexPath.row].locationLink)!))
                                    self.locationLinkArray2[indexPath.row] = (String((entry.value[indexPath.row].locationLink)!))
                                    
                                    DispatchQueue.main.async {
                                        let specificUrl = self.datastreamLinkArray2[indexPath.row]
                                        URLSession.shared.dataTask(with: URL(string: specificUrl)!) {(data, response, error) in
                                            do {
                                                let entry2 = try! JSONDecoder().decode(Entry2.self, from: data!)
                                                self.ArrayCount2 = entry2.value.count
                                                if (self.ArrayCount2 > 0) {
                                                    self.firstUnitOfMeasurementArray2[indexPath.row] = ((entry2.value[0].unitOfMeasurement?.symbol)!)
                                                } else {
                                                    self.firstUnitOfMeasurementArray2[indexPath.row] = ("N/A")
                                                }
                                                
                                                if (self.ArrayCount2 > 1) {
                                                    self.secondUnitOfMeasurementArray2[indexPath.row] = ((entry2.value[1].unitOfMeasurement?.symbol)!)
                                                } else {
                                                    self.secondUnitOfMeasurementArray2[indexPath.row] = ("N/A")
                                                }
                                                
                                                if (self.ArrayCount2 > 2) {
                                                    self.thirdUnitOfMeasurementArray2[indexPath.row] = ((entry2.value[2].unitOfMeasurement?.symbol)!)
                                                } else {
                                                    self.thirdUnitOfMeasurementArray2[indexPath.row] = ("N/A")
                                                }
                                                
                                                if (self.ArrayCount2 > 3) {
                                                    self.fourthUnitOfMeasurementArray2[indexPath.row] = ((entry2.value[3].unitOfMeasurement?.symbol)!)
                                                } else {
                                                    self.fourthUnitOfMeasurementArray2[indexPath.row] = ("N/A")
                                                }
                                                
                                                DispatchQueue.main.async {
                                                    // I already did comments for final network calls in line 822 of TableViewController.swift so view that for reference
                                                    self.ready2 += 1
                                                    if self.ready2 == self.readyCount {
                                                        index()
                                                    }
                                                }
                                            }
                                        }.resume()

                                        let url = self.locationLinkArray2[indexPath.row]
                                        let urlObj = URL(string: url)

                                        URLSession.shared.dataTask(with: urlObj!) {(data, response, error) in
                                            
                                            do {
                                                let entryLocationLink = try! JSONDecoder().decode(EntryLocationLink.self, from: data!)
                                                
                                                self.descriptionLocationLinkArray2[indexPath.row] = (entryLocationLink.value![0].locationDescription!)
                                                
                                                self.coordinates1LocationLinkArray2[indexPath.row] = (entryLocationLink.value![0].location?.coordinates[0])!
                                                self.coordinates2LocationLinkArray2[indexPath.row] = (entryLocationLink.value![0].location?.coordinates[1])!
                                                
                                                
                                                DispatchQueue.main.async {
                                                    // I already did comments for final network calls in line 822 of TableViewController.swift so view that for reference
                                                    self.ready2 += 1
                                                    if self.ready2 == self.readyCount {
                                                        index()
                                                    }
                                                }
                                                
                                            }
                                            
                                        }.resume()
                                    }
                                    
                                    guard let url2 = URL(string: self.waterLevelArray[indexPath.row]) else {return}
                                    
                                    if self.waterLevelArray[indexPath.row] != "N/A" {
                                        URLSession.shared.dataTask(with: url2) { (data1, response, error) in
                                            guard let data2 = data1 else { return }
                                            do {
                                                let initial2 = try? JSONDecoder().decode(EntryLatestWater.self, from: data2)
                                                let v3_count = initial2?.value.count
                                                
                                                if v3_count != nil {
                                                    self.currentWaterLevel = String(format:"%f", ((initial2?.value[0].result)!))
                                                    self.numberWaterLevel[indexPath.row] = self.currentWaterLevel
                                                    
                                                    if (self.elevationNAVD88Array2[indexPath.row] != "N/A") {
                                                        
                                                        let first = Double(self.elevationNAVD88Array2[indexPath.row])!
                                                        let second = Double(self.currentWaterLevel)!
                                                        
                                                        self.differenceWaterLevel[indexPath.row] = first + second
                                                        
                                                    } else {
                                                        self.differenceWaterLevel[indexPath.row] = 100
                                                    }
                                                } else {
                                                    self.currentWaterLevel = "N/A"
                                                    let isThereWaterValue = false
                                                    self.numberWaterLevel[indexPath.row] = self.currentWaterLevel
                                                    self.differenceWaterLevel[indexPath.row] = 100
                                                }
                                                
                                                DispatchQueue.main.async {
                                                    // I already did comments for final network calls in line 822 of TableViewController.swift so view that for reference
                                                    self.ready2 += 1
                                                    
                                                    // readyCount is the number of final network calls it needs so all the data is loaded, so once the program knows that all final network calls has been received then it will display the sensor's data
                                                    if self.ready2 == self.readyCount {
                                                        index()
                                                    }
                                                }
                                            }
                                        }.resume()
                                    } else {
                                        // I already did comments for final network calls in line 822 of TableViewController.swift so view that for reference
                                        self.ready2 += 1
                                        
                                        // readyCount is the number of final network calls it needs so all the data is loaded, so once the program knows that all final network calls has been received then it will display the sensor's data
                                        if self.ready2 == self.readyCount {
                                            index()
                                        }
                                    }
                                    
                                    
                                    
                                }
                            }.resume()
                            
                            // MARK: -All Sensors: Pass Data
                            func index() {  // Gets all the sensor's data using correct index and passes it to next view controller so user can access it
                                
                                self.doneBefore.append(self.nameArray2[indexPath.row])
                                
                                vc?.name = self.nameArray2[indexPath.row]
                                vc?.sensorThingsID = self.IDArray2[indexPath.row]
                                vc?.deviceID = self.deviceIDArray2[indexPath.row]
                                //Do Later
                                vc?.locationDescription = self.descriptionLocationLinkArray2[indexPath.row]
                                vc?.sensorNAVD88Elevation = self.elevationNAVD88Array2[indexPath.row]
                                
                                vc?.url1Link = self.firstObservationsDatastreamLinkArray2[indexPath.row]
                                vc?.url1Name = self.firstNameDatastreamLinkArray2[indexPath.row]
                                vc?.url1Unit = self.firstUnitOfMeasurementArray2[indexPath.row]
                                
                                vc?.url2Link = self.secondObservationsDatastreamLinkArray2[indexPath.row]
                                vc?.url2Name = self.secondNameDatastreamLinkArray2[indexPath.row]
                                vc?.url2Unit = self.secondUnitOfMeasurementArray2[indexPath.row]
                                
                                vc?.url3Link = self.thirdObservationsDatastreamLinkArray2[indexPath.row]
                                vc?.url3Name = self.thirdNameDatastreamLinkArray2[indexPath.row]
                                vc?.url3Unit = self.thirdUnitOfMeasurementArray2[indexPath.row]
                                
                                vc?.url4Link = self.fourthObservationsDatastreamLinkArray2[indexPath.row]
                                vc?.url4Name = self.fourthNameDatastreamLinkArray2[indexPath.row]
                                vc?.url4Unit = self.fourthUnitOfMeasurementArray2[indexPath.row]
                                
                                vc?.coordinate1 = self.coordinates1LocationLinkArray2[indexPath.row]
                                vc?.coordinate2 = self.coordinates2LocationLinkArray2[indexPath.row]
                                vc?.signalValue = self.differenceWaterLevel[indexPath.row]
                                
                                // Reset final network calls counter
                                ready2 = 0
                                
                                // Makes cells and tabs clickable because the program has finished loading the current sensor's data
                                clickable = true
                                tabBarItem1.isEnabled = true
                                tabBarItem2.isEnabled = true
                                canRefresh = true
                                
                                // Takes user to next view controller so they can access the sensor's data
                                self.navigationController?.pushViewController(vc!, animated: true)
                            }
                        }
                    }
                }
            }
            
            
        } else { // If the menu is out and the user clicks on a cell
            // The menu will close
            tableLeading.constant = 0
            tableTrailing.constant = 0
            searchLeading.constant = 0
            searchTrailing.constant = 0
            instructionsLeading.constant = 0
            instructionsTrailing.constant = 0
            tblView.isScrollEnabled = true
            menuOut = false
        }
        
        // Animation to close the menu
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn,animations: {
            self.view.layoutIfNeeded()
        }) { (animationComplete) in
            Swift.print("complete")
        }
        
    }
    
    // MARK: - Search Filter
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // Filter for the searching array
        searchingNames = nameArray2.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        
        // Fills array with random value so data can easily exchange between another array
        if searchingNames.count != 0 {
            searchingSignal.removeAll()
            for _ in 0...searchingNames.count-1 {
                searchingSignal.append(1)
            }
            
            // Searching signal only gets values that the searching array has sensors for
            for i in 0...searchingNames.count-1 {
                let point = nameArray2.firstIndex(of: searchingNames[i])
                searchingSignal[i] = differenceWaterLevel[point!]
            }
        }
        
        // Searching turns to true and reloads UITable
        searching = true
        tblView.reloadData()
    }
    
    // MARK: - Cancel Search
    // If search bar's cancel button gets clicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Searching turns to false
        searching = false
        
        // Search bar gets reset to nothing
        searchBar.text = ""
        self.view.endEditing(true)
        
        // UITableView reloads
        tblView.reloadData()
    }
    
    
    
}
