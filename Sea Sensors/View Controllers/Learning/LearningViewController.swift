//
//  LearningViewController.swift
//  GTSeaLevelAPP
//
//  Created by Johnson Amalanathan on 3/20/20.
//  Copyright © 2020 Georgia Tech. All rights reserved.
//

import UIKit
import SafariServices
import WebKit

class LearningViewController: UIViewController, WKNavigationDelegate, UIScrollViewDelegate {
    
    var webView: WKWebView!
    
    // MARK: - Overall Structure Values
    
    // Outlets that allows the page to scroll
    @IBOutlet var baseView: UIView!
    @IBOutlet weak var scrollViewsView: UIView!
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    
    // general values used freuqently in this app
    var orgScrollHeight:CGFloat = 1075
    
    let openedWidth:CGFloat = 354
    let closedWidth:CGFloat = 240
    let closedHeight:CGFloat = 148
    
    let closedFromSide:CGFloat = 105
    let openedFromSide:CGFloat = 30
    
    let openedButtonArea:CGFloat = 45
    let closedButtonArea:CGFloat = 60
    
    let openedButtonRadius:CGFloat = 22.5
    let closedButtonRadius:CGFloat = 30
    
    let openedButtonXY:CGFloat = -22.5
    
    let closedButtonX:CGFloat = -30
    let closedButtonY:CGFloat = 44
    
    let closedLabelXY:CGFloat = 38
    
    let buttonHalfLength:CGFloat = 30
    
    var gain:CGFloat = 0
    // MARK: - Menu Outlets
    @IBOutlet weak var scrollLeading: NSLayoutConstraint!
    @IBOutlet weak var scrollTrailing: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let movingConstant:CGFloat = 300
    var menuOut = false
    
    // MARK: - Purpose Section Outlets
    @IBOutlet var purposeView: UIView!
    @IBOutlet weak var purposeEdge: NSLayoutConstraint!
    @IBOutlet var purposeHeight: NSLayoutConstraint!
    
    @IBOutlet var purposeButton: UIButton!
    @IBOutlet var purposeButtonYAxis: NSLayoutConstraint!
    @IBOutlet var purposeButtonWidth: NSLayoutConstraint!
    @IBOutlet var purposeButtonHeight: NSLayoutConstraint!
    @IBOutlet var purposeButtonXAxis: NSLayoutConstraint!
    
    @IBOutlet var purposeLabel: UILabel!
    @IBOutlet var purposeLabelYAxis: NSLayoutConstraint!
    @IBOutlet var purposeLabelXAxis: NSLayoutConstraint!
    
    var purposeYoutube = WKWebView()
    var purposeDescLabel = UILabel()
    var purposePicScroll = UIScrollView()
    var purposePicView = UIView()
    let purposePic = UIImage(named: "Purpose Pic")
    var purposeInstalledLabel = UILabel()
    
    var purposeClosedHeight:CGFloat = 0
    
    var purposeHeightGain:CGFloat = 0
    
    @IBOutlet var purposePointer: UIView!
    @IBOutlet var purposeInvisibleBottom: NSLayoutConstraint!
    
    var purposeOut = false
    
    // MARK: - Why Section Outlets
    
    @IBOutlet var whyView: UIView!
    @IBOutlet var whyEdge: NSLayoutConstraint!
    @IBOutlet var whyHeight: NSLayoutConstraint!
    
    @IBOutlet var whyButton: UIButton!
    @IBOutlet var whyButtonYAxis: NSLayoutConstraint!
    let whyButtonYAxisBase :CGFloat = 302.5
    @IBOutlet var whyButtonWidth: NSLayoutConstraint!
    @IBOutlet var whyButtonHeight: NSLayoutConstraint!
    @IBOutlet var whyButtonXAxis: NSLayoutConstraint!
    
    @IBOutlet var whyLabel: UILabel!
    @IBOutlet var whyLabelYAxis: NSLayoutConstraint!
    @IBOutlet var whyLabelXAxis: NSLayoutConstraint!
    
    var whyPicScroll1 = UIScrollView()
    var whyPicView1 = UIView()
    var whyPic1 = UIImage(named: "whyPhoto1")
    var whyPic1Label = UILabel()
    
    var whyPicScroll2 = UIScrollView()
    var whyPicView2 = UIView()
    var whyPic2 = UIImage(named: "whyPhoto2")
    var whyPic2Label = UILabel()
    
    var whyClosedHeight:CGFloat = 0
    
    var whyHeightGain:CGFloat = 0
    @IBOutlet var whyPointer: UIView!
    
    var whyOut = false
    
    // MARK: - Sensors Section Outlets
    
    @IBOutlet var sensorsView: UIView!
    @IBOutlet var sensorsEdge: NSLayoutConstraint!
    @IBOutlet var sensorsHeight: NSLayoutConstraint!
    
    @IBOutlet var sensorsButton: UIButton!
    @IBOutlet var sensorsButtonYAxis: NSLayoutConstraint!
    @IBOutlet var sensorsButtonXAxis: NSLayoutConstraint!
    
    
    let sensorsButtonYAxisBase :CGFloat = 506.67
    @IBOutlet var sensorsButtonWidth: NSLayoutConstraint!
    @IBOutlet var sensorsButtonHeight: NSLayoutConstraint!
    
    @IBOutlet var sensorsLabel: UILabel!
    @IBOutlet var sensorsLabelYAxis: NSLayoutConstraint!
    @IBOutlet var sensorsLabelXAxis: NSLayoutConstraint!
    
    var sensorsPicScroll1 = UIScrollView()
    var sensorsPicView1 = UIView()
    var sensorsPic1 = UIImage(named: "sensorsPhoto1")
    var sensorsLabel1 = UILabel()
    
    var sensorsPicScroll2 = UIScrollView()
    var sensorsPicView2 = UIView()
    var sensorsPic2 = UIImage(named: "sensorsPhoto2")
    
    var sensorsPicScroll3 = UIScrollView()
    var sensorsPicView3 = UIView()
    var sensorsPic3 = UIImage(named: "sensorsPhoto3")
    var sensorsLabel2 = UILabel()
    
    var sensorsClosedHeight:CGFloat = 0
    
    var sensorsHeightGain:CGFloat = 0
    
    @IBOutlet var sensorsPointer: UIView!
    
    var sensorsOut = false
    
    // MARK: - Storm Section Outlets
    
    @IBOutlet var stormView: UIView!
    @IBOutlet var stormEdge: NSLayoutConstraint!
    @IBOutlet var stormHeight: NSLayoutConstraint!
    
    @IBOutlet var stormButton: UIButton!
    @IBOutlet var stormButtonYAxis: NSLayoutConstraint!
    @IBOutlet var stormButtonWidth: NSLayoutConstraint!
    @IBOutlet var stormButtonHeight: NSLayoutConstraint!
    @IBOutlet var stormButtonXAxis: NSLayoutConstraint!
    
    @IBOutlet var stormLabel: UILabel!
    @IBOutlet var stormLabelYAxis: NSLayoutConstraint!
    
    var stormPicScroll1 = UIScrollView()
    var stormPicView1 = UIView()
    var stormPic1 = UIImage(named: "stormPhoto1")
    var stormLabel1 = UILabel()
    
    var stormPicScroll2 = UIScrollView()
    var stormPicView2 = UIView()
    var stormPic2 = UIImage(named: "stormPhoto2")
    var stormLabel2 = UILabel()
    
    var stormPicScroll3 = UIScrollView()
    var stormPicView3 = UIView()
    var stormPic3 = UIImage(named: "stormPhoto3")
    var stormLabel3 = UILabel()
    
    var stormClosedHeight:CGFloat = 0
    
    var stormHeightGain:CGFloat = 0
    
    var stormOut = false
    
    // MARK: - Behind Section Outlets
    
    @IBOutlet var behindView: UIView!
    @IBOutlet var behindEdge: NSLayoutConstraint!
    @IBOutlet var behindHeight: NSLayoutConstraint!
    
    @IBOutlet var behindButton: UIButton!
    @IBOutlet var behindButtonYAxis: NSLayoutConstraint!
    @IBOutlet var behindButtonWidth: NSLayoutConstraint!
    @IBOutlet var behindButtonHeight: NSLayoutConstraint!
    @IBOutlet var behindButtonXAxis: NSLayoutConstraint!
    
    @IBOutlet var behindLabel: UILabel!
    @IBOutlet var behindLabelYAxis: NSLayoutConstraint!
    @IBOutlet var behindLabelXAxis: NSLayoutConstraint!
    @IBOutlet var behindLabelXAxis2: NSLayoutConstraint!
    
    var behindSubTitleLabel1 = UILabel ()
    var behindSubTitleLabel2 = UILabel ()
    var behindSubTitleLabel3 = UILabel ()
    var behindSubTitleLabel4 = UILabel()
    
    var behindCobbView = UIView()
    var behindCobbLabel = UILabel()
    var behindCobbDesc = UILabel()
    
    var behindClarkView = UIView()
    var behindClarkLabel = UILabel()
    var behindClarkDesc = UILabel()
    
    var behindLorenzoView = UIView()
    var behindLorenzoLabel = UILabel()
    var behindLorenzoDesc = UILabel()
    
    
    var behindConeView = UIView()
    var behindConeLabel = UILabel()
    var behindConeDesc = UILabel()
    
    var behindKovalView = UIView()
    var behindKovalLabel = UILabel()
    var behindKovalDesc = UILabel()
    
    var behindMathewsView = UIView()
    var behindMathewsLabel = UILabel()
    var behindMathewsDesc = UILabel()
    
    var behindDeffleyView = UIView()
    var behindDeffleyLabel = UILabel()
    var behindDeffleyDesc = UILabel()
    
    var behindEnochView = UIView()
    var behindEnochLabel = UILabel()
    var behindEnochDesc = UILabel()
    
    var behindFundersLabel = UILabel()
    var behindSmartView = UIView()
    var behindPicScroll1 = UIScrollView()
    var behindPicView1 = UIView()
    var behindPic1 = UIImage(named: "behindPhoto1")
    var behindSmartLabel = UILabel()
    
    var behindClosedHeight:CGFloat = 0
    
    var behindHeightGain:CGFloat = 0
    var behindCardHeight:CGFloat = 100
    var behindCardWidth:CGFloat = 152
    
    var behindOut = false
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        purposeLabel.layoutIfNeeded()
        purposeClosedHeight = (CGFloat(closedHeight)-purposeLabel.bounds.size.height)/2
        purposeLabelYAxis.constant = purposeClosedHeight
        
        whyLabel.layoutIfNeeded()
        whyClosedHeight = (CGFloat(closedHeight)-whyLabel.bounds.size.height)/2
        whyLabelYAxis.constant = whyClosedHeight
        
        sensorsLabel.layoutIfNeeded()
        sensorsClosedHeight = (CGFloat(closedHeight)-sensorsLabel.bounds.size.height)/2
        sensorsLabelYAxis.constant = sensorsClosedHeight
        
        stormLabel.layoutIfNeeded()
        stormClosedHeight = (CGFloat(closedHeight)-stormLabel.bounds.size.height)/2
        stormLabelYAxis.constant = stormClosedHeight
        
        behindLabel.layoutIfNeeded()
        behindClosedHeight = (CGFloat(closedHeight)-behindLabel.bounds.size.height)/2
        behindLabelYAxis.constant = behindClosedHeight
        
        // Gives each section the ability to sense if it gets tapped
        //        let purposeTap = UITapGestureRecognizer(target: self, action: #selector(LearningViewController.tapPurpose))
        //        purposeView.addGestureRecognizer(purposeTap)
        //
        //        //let whyTap = UITapGestureRecognizer(target: self, action: #selector(LearningViewController.tapWhy))
        //        //whyView.addGestureRecognizer(whyTap)
        //
        //        let sensorsTap = UITapGestureRecognizer(target: self, action: #selector(LearningViewController.tapSensors))
        //        sensorsView.addGestureRecognizer(sensorsTap)
        //
        //        let stormTap = UITapGestureRecognizer(target: self, action: #selector(LearningViewController.tapStorm))
        //        stormView.addGestureRecognizer(stormTap)
        //
        //        let behindTap = UITapGestureRecognizer(target: self, action: #selector(LearningViewController.tapBehind))
        //        behindView.addGestureRecognizer(behindTap)
        
        // Tags on images and min and max zoom that the users can zoom the images
        purposePicScroll.tag = 1
        purposePicScroll.minimumZoomScale = 1
        purposePicScroll.maximumZoomScale = 6
        purposePicScroll.delegate = self
        
        whyPicScroll1.tag = 2
        whyPicScroll1.minimumZoomScale = 1
        whyPicScroll1.maximumZoomScale = 6
        whyPicScroll1.delegate = self
        
        whyPicScroll2.tag = 3
        whyPicScroll2.minimumZoomScale = 1
        whyPicScroll2.maximumZoomScale = 6
        whyPicScroll2.delegate = self
        
        sensorsPicScroll1.tag = 4
        sensorsPicScroll1.minimumZoomScale = 1
        sensorsPicScroll1.maximumZoomScale = 6
        sensorsPicScroll1.delegate = self
        
        sensorsPicScroll2.tag = 5
        sensorsPicScroll2.minimumZoomScale = 1
        sensorsPicScroll2.maximumZoomScale = 6
        sensorsPicScroll2.delegate = self
        
        sensorsPicScroll3.tag = 6
        sensorsPicScroll3.minimumZoomScale = 1
        sensorsPicScroll3.maximumZoomScale = 6
        sensorsPicScroll3.delegate = self
        
        stormPicScroll1.tag = 7
        stormPicScroll1.minimumZoomScale = 1
        stormPicScroll1.maximumZoomScale = 6
        stormPicScroll1.delegate = self
        
        stormPicScroll2.tag = 8
        stormPicScroll2.minimumZoomScale = 1
        stormPicScroll2.maximumZoomScale = 6
        stormPicScroll2.delegate = self
        
        stormPicScroll3.tag = 9
        stormPicScroll3.minimumZoomScale = 1
        stormPicScroll3.maximumZoomScale = 6
        stormPicScroll3.delegate = self
        
        behindPicScroll1.tag = 10
        behindPicScroll1.minimumZoomScale = 1
        behindPicScroll1.maximumZoomScale = 6
        behindPicScroll1.delegate = self
        
    }
    
    // Allows the user to zoom images
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView.tag == 1 {
            
            return purposePicView
            
        } else if scrollView.tag == 2{
            
            return whyPicView1
            
        } else if scrollView.tag == 3{
            
            return whyPicView2
        } else if scrollView.tag == 4{
            
            return sensorsPicView1
        } else if scrollView.tag == 5{
            
            return sensorsPicView2
        } else if scrollView.tag == 6 {
            
            return sensorsPicView3
        } else if scrollView.tag == 7{
            
            return stormPicView1
        } else if scrollView.tag == 8{
            
            return stormPicView2
        } else{
            
            return stormPicView3
        }
    }
    
    // MARK: - Purpose View Animation
    // If button gets tapped, preform purposeFunc()
    @IBAction func purposeButtonTapped(_ sender: Any) {
        purposeFunc()
    }
    
    // If section gets tapped, perform purposeFunc()
    @objc func tapPurpose(tap: UITapGestureRecognizer) {
        purposeFunc()
    }
    
    // Function purposeFunc()
    func purposeFunc() {
        if purposeOut == false {
            var purposeAddedHeight:CGFloat = 0.0
            
            // Open View
            purposeEdge.constant = openedFromSide
            
            
            // Button
            purposeButtonYAxis.constant = -(openedButtonArea/2)
            purposeButtonXAxis.constant = -(openedButtonArea/2)
            purposeButtonWidth.constant = openedButtonArea
            purposeButtonHeight.constant = openedButtonArea
            purposeButton.layer.cornerRadius = openedButtonRadius
            purposeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
            
            // Youtube View
            purposeView.addSubview(purposeYoutube)
            purposeYoutube.backgroundColor = .white
            purposeYoutube.translatesAutoresizingMaskIntoConstraints = false
            purposeYoutube.topAnchor.constraint(equalTo: purposeView.topAnchor, constant: 25).isActive = true
            purposeYoutube.leadingAnchor.constraint(equalTo: purposeView.leadingAnchor, constant: 20).isActive = true
            purposeYoutube.trailingAnchor.constraint(equalTo: purposeView.trailingAnchor, constant: -20).isActive = true
            
            if ( UIDevice.current.userInterfaceIdiom == .pad ) {
                purposeYoutube.heightAnchor.constraint(equalToConstant: 450).isActive = true
            } else {
                purposeYoutube.heightAnchor.constraint(equalToConstant: 225).isActive = true
            }
            
            let request = URLRequest(url: URL.init(string: "https://www.youtube.com/watch?v=J6mO_q-qExA")!)
            self.purposeYoutube.load(request)
            
            // Label
            if ( UIDevice.current.userInterfaceIdiom == .pad ) {
                purposeLabelYAxis.constant = 500
            } else {
                purposeLabelYAxis.constant = 275
            }
            
            purposeLabelXAxis.constant = 20
            purposeLabel.translatesAutoresizingMaskIntoConstraints = false
            purposeLabel.trailingAnchor.constraint(equalTo: purposeView.trailingAnchor, constant: -20).isActive = true
            purposeLabel.font = UIFont.systemFont(ofSize: purposeLabel.font.pointSize)
            purposeLabel.text = "The Smart Sea Level Sensors project is a partnership between Chatham Emergency Management Agency officials, City of Savannah officials, and Georgia Tech scientists and engineers who are working together to install a network of internet-enabled sea level sensors across Chatham County. The real-time data on coastal flooding is being used for emergency planning and response and improve forecasting."
            let attributedString = NSMutableAttributedString(string: purposeLabel.text!)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 2
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            purposeLabel.attributedText = attributedString
            
            purposeLabel.font = purposeLabel.font.withSize(15)
            
            Utilities.styleViewLabel(purposeLabel)
            Utilities.bold(purposeLabel)
            
            // Installed Label
            purposeView.addSubview(purposeInstalledLabel)
            Utilities.styleViewLabel(purposeInstalledLabel)
            purposeInstalledLabel.translatesAutoresizingMaskIntoConstraints = false
            purposeInstalledLabel.topAnchor.constraint(equalTo: purposeLabel.bottomAnchor, constant: 20).isActive = true
            purposeInstalledLabel.leadingAnchor.constraint(equalTo: purposeView.leadingAnchor, constant: 20).isActive = true
            purposeInstalledLabel.trailingAnchor.constraint(equalTo: purposeView.trailingAnchor, constant: -20).isActive = true
            
            if ( UIDevice.current.userInterfaceIdiom == .pad ) {
                purposeLabel.font = purposeLabel.font.withSize(25) /* Device is iPad */
            } else {
                purposeInstalledLabel.font = purposeInstalledLabel.font.withSize(20)
            }
            
            purposeInstalledLabel.text = "Over 50+ sensors installed throughout Chatham County!"
            
            // Pic Scroll
            purposeView.addSubview(purposePicScroll)
            purposePicScroll.translatesAutoresizingMaskIntoConstraints = false
            purposePicScroll.topAnchor.constraint(equalTo: purposeInstalledLabel.bottomAnchor, constant: 10).isActive = true
            purposePicScroll.leadingAnchor.constraint(equalTo: purposeView.leadingAnchor, constant: 20).isActive = true
            purposePicScroll.trailingAnchor.constraint(equalTo: purposeView.trailingAnchor, constant: -20).isActive = true
            purposePicScroll.heightAnchor.constraint(equalToConstant: 200).isActive = true
            
            // Purpose Pic
            purposePicView = UIImageView(image: purposePic!)
            purposePicScroll.addSubview(purposePicView)
            purposePicView.translatesAutoresizingMaskIntoConstraints = false
            purposePicView.topAnchor.constraint(equalTo: purposePicScroll.topAnchor, constant: 0).isActive = true
            purposePicView.leadingAnchor.constraint(equalTo: purposePicScroll.leadingAnchor, constant: 0).isActive = true
            purposePicView.trailingAnchor.constraint(equalTo: purposePicScroll.trailingAnchor, constant: 0).isActive = true
            purposePicView.bottomAnchor.constraint(equalTo: purposePicScroll.bottomAnchor, constant: 0).isActive = true
            purposePicView.heightAnchor.constraint(equalTo: purposePicScroll.heightAnchor).isActive = true
            purposePicView.widthAnchor.constraint(equalTo: purposePicScroll.widthAnchor).isActive = true
            purposePicView.contentMode = .scaleAspectFit
            
            // Configures height of panel view
            purposeYoutube.layoutIfNeeded()
            purposeLabel.layoutIfNeeded()
            purposeInstalledLabel.layoutIfNeeded()
            purposePicScroll.layoutIfNeeded()
            
            purposeAddedHeight += purposeYoutube.bounds.size.height
            purposeAddedHeight += purposeLabel.bounds.size.height
            purposeAddedHeight += purposeInstalledLabel.bounds.size.height
            purposeAddedHeight += purposePicScroll.bounds.size.height
            
            purposeHeight.constant = purposeAddedHeight + 95
            purposeHeightGain = purposeHeight.constant - CGFloat(closedHeight)
            
            scrollHeightfunc()
            
            // Finish
            purposeOut = true
        } else {
            // Scroll Height
            purposeHeightGain = 0
            scrollHeightfunc()
            
            // Close View
            purposeEdge.constant = closedFromSide
            purposeHeight.constant = CGFloat(closedHeight)
            
            // Button
            purposeButtonWidth.constant = closedButtonArea
            purposeButtonHeight.constant = closedButtonArea
            purposeButton.layer.cornerRadius = closedButtonRadius
            purposeButtonYAxis.constant = 44
            purposeButtonXAxis.constant = -30
            purposeButton.setImage(UIImage(systemName: "plus"), for: .normal)
            
            // Youtube
            purposeYoutube.removeFromSuperview()
            
            // Label
            purposeLabel.text = "Our mission is to document real-time data on coastal flooding. Click the button to learn more."
            purposeLabel.font = purposeLabel.font.withSize(15)
            
            if ( UIDevice.current.userInterfaceIdiom == .pad ) {
                purposeLabel.font = purposeLabel.font.withSize(25); /* Device is iPad */
            }
            
            purposeLabel.layoutIfNeeded()
            purposeClosedHeight = (CGFloat(closedHeight)-purposeLabel.bounds.size.height)/2
            purposeLabelYAxis.constant = purposeClosedHeight
            
            let attributedString = NSMutableAttributedString(string: purposeLabel.text!)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 1
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            
            purposeLabel.layoutIfNeeded()
            purposeLabelYAxis.constant = purposeClosedHeight
            purposeLabelXAxis.isActive = true
            purposeLabelXAxis.constant = closedLabelXY
            purposeLabel.textAlignment = .left
            Utilities.bold(purposeLabel)
            
            // Purpose Pic
            purposePicView.removeFromSuperview()
            
            // Installed Label
            purposeInstalledLabel.removeFromSuperview()
            
            // Finish
            purposeOut = false
        }
    }
    
    // MARK: - Why View Animation
    // If button gets tapped, perform whyFunc()
    @IBAction func whyButtonTapped(_ sender: Any) {
        whyFunc()
    }
    
    // If section gets tapped, perfom whyFunc()
    @objc func tapWhy(tap: UITapGestureRecognizer) {
        whyFunc()
    }
    
    // Function whyFunc()
    func whyFunc() {
        if whyOut == false {
            var whyAddedHeight:CGFloat = 0.0
            
            // Open View
            whyEdge.constant = openedFromSide
            
            // Button
            whyButtonYAxis.constant = -(openedButtonArea/2)
            whyButtonXAxis.constant = -(openedButtonArea/2)
            whyButtonWidth.constant = openedButtonArea
            whyButtonHeight.constant = openedButtonArea
            whyButton.layer.cornerRadius = openedButtonRadius
            whyButton.setImage(UIImage(systemName: "xmark"), for: .normal)
            
            // Label
            whyLabelYAxis.constant = 25
            whyLabelXAxis.constant = 20
            whyLabel.text = "Problem: Coastal flooding & not enough flooding data."
            let attributedString = NSMutableAttributedString(string: whyLabel.text!)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 2
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            whyLabel.attributedText = attributedString
            Utilities.styleViewLabel(whyLabel)
            Utilities.bold(whyLabel)
            whyLabel.font = whyLabel.font.withSize(18)
            
            // Scroll 1
            whyView.addSubview(whyPicScroll1)
            whyPicScroll1.translatesAutoresizingMaskIntoConstraints = false
            whyPicScroll1.topAnchor.constraint(equalTo: whyLabel.bottomAnchor, constant: 20).isActive = true
            whyPicScroll1.leadingAnchor.constraint(equalTo: whyView.leadingAnchor, constant: 20).isActive = true
            whyPicScroll1.trailingAnchor.constraint(equalTo: whyView.trailingAnchor, constant: -20).isActive = true
            whyPicScroll1.heightAnchor.constraint(equalToConstant: 200).isActive = true
            
            // Pic 1
            whyPicView1 = UIImageView(image: whyPic1!)
            whyPicScroll1.addSubview(whyPicView1)
            whyPicView1.translatesAutoresizingMaskIntoConstraints = false
            whyPicView1.topAnchor.constraint(equalTo: whyPicScroll1.bottomAnchor, constant: 0).isActive = true
            whyPicView1.leadingAnchor.constraint(equalTo: whyPicScroll1.leadingAnchor, constant: 0).isActive = true
            whyPicView1.trailingAnchor.constraint(equalTo: whyPicScroll1.trailingAnchor, constant: 0).isActive = true
            whyPicView1.heightAnchor.constraint(equalTo: whyPicScroll1.heightAnchor).isActive = true
            whyPicView1.widthAnchor.constraint(equalTo: whyPicScroll1.widthAnchor).isActive = true
            whyPicView1.contentMode = .scaleAspectFit
            
            // Pic 1 Label
            whyView.addSubview(whyPic1Label)
            whyPic1Label.translatesAutoresizingMaskIntoConstraints = false
            whyPic1Label.topAnchor.constraint(equalTo: whyPicScroll1.bottomAnchor, constant: 10).isActive = true
            whyPic1Label.leadingAnchor.constraint(equalTo: whyView.leadingAnchor, constant: 20).isActive = true
            whyPic1Label.trailingAnchor.constraint(equalTo: whyView.trailingAnchor, constant: -20).isActive = true
            whyPic1Label.text = "In recent years, Chatham County has had several close enounters with destructive hurricanes. With the danger of sea level rising and hurricanes, the Smart Sea Level Sensor project aims to document changing sea levels and flooding events and identify areas that are most susceptible to dangerous flooding."
            let attributedString1 = NSMutableAttributedString(string: whyPic1Label.text!)
            attributedString1.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString1.length))
            whyPic1Label.attributedText = attributedString1
            Utilities.styleViewLabel(whyPic1Label)
            
            // Scroll 2
            whyView.addSubview(whyPicScroll2)
            whyPicScroll2.translatesAutoresizingMaskIntoConstraints = false
            whyPicScroll2.topAnchor.constraint(equalTo: whyPic1Label.bottomAnchor, constant: 25).isActive = true
            whyPicScroll2.leadingAnchor.constraint(equalTo: whyView.leadingAnchor, constant: 20).isActive = true
            whyPicScroll2.trailingAnchor.constraint(equalTo: whyView.trailingAnchor, constant: -20).isActive = true
            whyPicScroll2.heightAnchor.constraint(equalToConstant: 200).isActive = true
            
            // Pic 2
            whyPicView2 = UIImageView(image: whyPic2!)
            whyPicScroll2.addSubview(whyPicView2)
            whyPicView2.translatesAutoresizingMaskIntoConstraints = false
            whyPicView2.topAnchor.constraint(equalTo: whyPicScroll2.bottomAnchor, constant: 0).isActive = true
            whyPicView2.leadingAnchor.constraint(equalTo: whyPicScroll2.leadingAnchor, constant: 0).isActive = true
            whyPicView2.trailingAnchor.constraint(equalTo: whyPicScroll2.trailingAnchor, constant: 0).isActive = true
            whyPicView2.heightAnchor.constraint(equalTo: whyPicScroll2.heightAnchor).isActive = true
            whyPicView2.widthAnchor.constraint(equalTo: whyPicScroll2.widthAnchor).isActive = true
            whyPicView2.contentMode = .scaleAspectFit
            
            // Pic 2 Label
            whyView.addSubview(whyPic2Label)
            whyPic2Label.translatesAutoresizingMaskIntoConstraints = false
            whyPic2Label.topAnchor.constraint(equalTo: whyPicScroll2.bottomAnchor, constant: 10).isActive = true
            whyPic2Label.leadingAnchor.constraint(equalTo: whyView.leadingAnchor, constant: 20).isActive = true
            whyPic2Label.trailingAnchor.constraint(equalTo: whyView.trailingAnchor, constant: -20).isActive = true
            whyPic2Label.text = "This image shows different areas that can potentially be flooded by different hurricane categories. As you can see, a majority of Chatham County is susceptible to category 1 & 2 hurricanes. As sea level rise and hurricanes worsen, Chatham County is at a major risk in over flooding. Through this Sea Level Sensor project, we hope to detect which areas of Chatham County are most susceptible and find ways to prepare for hurricane disasters and sea level rise."
            let attributedString2 = NSMutableAttributedString(string: whyPic2Label.text!)
            attributedString2.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString2.length))
            whyPic2Label.attributedText = attributedString2
            Utilities.styleViewLabel(whyPic2Label)
            
            // Configures height of panel view
            whyLabel.layoutIfNeeded()
            whyPicScroll1.layoutIfNeeded()
            whyPic1Label.layoutIfNeeded()
            whyPicScroll2.layoutIfNeeded()
            whyPic2Label.layoutIfNeeded()
            
            whyAddedHeight += whyLabel.bounds.size.height
            whyAddedHeight += whyPicScroll1.bounds.size.height
            whyAddedHeight += whyPic1Label.bounds.size.height
            whyAddedHeight += whyPicScroll2.bounds.size.height
            whyAddedHeight += whyPic2Label.bounds.size.height
            
            whyHeight.constant = whyAddedHeight + 100
            whyHeightGain = whyHeight.constant - CGFloat(closedHeight)
            
            scrollHeightfunc()
            
            // Finish
            whyOut = true
        } else {
            // Scroll Height
            whyHeightGain = 0
            scrollHeightfunc()
            
            // Close View
            whyEdge.constant = closedFromSide
            whyHeight.constant = closedHeight
            
            // Button
            whyButtonWidth.constant = closedButtonArea
            whyButtonHeight.constant = closedButtonArea
            whyButton.layer.cornerRadius = closedButtonRadius
            whyButtonYAxis.constant = 44
            whyButtonXAxis.constant = -30
            whyButton.setImage(UIImage(systemName: "plus"), for: .normal)
            
            // Label
            whyLabel.text = "Why is the Smart Sea Level Sensor project even important? Click the button to learn more."
            whyLabel.font = whyLabel.font.withSize(15)
            whyLabel.layoutIfNeeded()
            whyLabelYAxis.constant = whyClosedHeight
            whyLabelXAxis.constant = closedLabelXY
            whyLabel.textAlignment = .right
            Utilities.bold(whyLabel)
            
            // Pic 1
            whyPicView1.removeFromSuperview()
            whyPicScroll1.removeFromSuperview()
            
            // Pic 1 Label
            whyPic1Label.removeFromSuperview()
            
            // Pic 2
            whyPicView2.removeFromSuperview()
            whyPicScroll2.removeFromSuperview()
            
            // Pic 2 Label
            whyPic2Label.removeFromSuperview()
            
            // Finish
            whyOut = false
        }
    }
    
    // MARK: - Sensors View Animation
    // If button gets tapped, perform sensorsFunc()
    @IBAction func sensorsButtonTapped(_ sender: Any) {
        sensorsFunc()
    }
    
    // If section gets tapped, perform sensorsFunc()
    @objc func tapSensors(tap: UITapGestureRecognizer) {
        sensorsFunc()
    }
    
    // Function sensorsFunc()
    func sensorsFunc() {
        if sensorsOut == false {
            var sensorsAddedHeight:CGFloat = 0.0
            
            // Open View
            sensorsEdge.constant = openedFromSide
            
            // Button
            sensorsButtonYAxis.constant = -(openedButtonArea/2)
            sensorsButtonXAxis.constant = -(openedButtonArea/2)
            sensorsButtonWidth.constant = openedButtonArea
            sensorsButtonHeight.constant = openedButtonArea
            sensorsButton.layer.cornerRadius = openedButtonRadius
            sensorsButton.setImage(UIImage(systemName: "xmark"), for: .normal)
            
            // Label
            sensorsLabelYAxis.constant = 25
            sensorsLabelXAxis.constant = 19
            sensorsLabel.text = "Sensor Tech Specifications"
            sensorsLabel.font = sensorsLabel.font.withSize(19)
            
            // Scroll 1
            sensorsView.addSubview(sensorsPicScroll1)
            sensorsPicScroll1.translatesAutoresizingMaskIntoConstraints = false
            sensorsPicScroll1.topAnchor.constraint(equalTo: sensorsLabel.bottomAnchor, constant: 20).isActive = true
            sensorsPicScroll1.leadingAnchor.constraint(equalTo: sensorsView.leadingAnchor, constant: 20).isActive = true
            sensorsPicScroll1.trailingAnchor.constraint(equalTo: sensorsView.trailingAnchor, constant: -20).isActive = true
            sensorsPicScroll1.heightAnchor.constraint(equalToConstant: 200).isActive = true
            
            // Pic 1
            sensorsPicView1 = UIImageView(image: sensorsPic1!)
            sensorsPicScroll1.addSubview(sensorsPicView1)
            sensorsPicView1.translatesAutoresizingMaskIntoConstraints = false
            sensorsPicView1.topAnchor.constraint(equalTo: sensorsPicScroll1.bottomAnchor, constant: 0).isActive = true
            sensorsPicView1.leadingAnchor.constraint(equalTo: sensorsPicScroll1.leadingAnchor, constant: 0).isActive = true
            sensorsPicView1.trailingAnchor.constraint(equalTo: sensorsPicScroll1.trailingAnchor, constant: 0).isActive = true
            sensorsPicView1.heightAnchor.constraint(equalTo: sensorsPicScroll1.heightAnchor).isActive = true
            sensorsPicView1.widthAnchor.constraint(equalTo: sensorsPicScroll1.widthAnchor).isActive = true
            sensorsPicView1.contentMode = .scaleAspectFit
            
            // Scroll 2
            sensorsView.addSubview(sensorsPicScroll2)
            sensorsPicScroll2.translatesAutoresizingMaskIntoConstraints = false
            sensorsPicScroll2.topAnchor.constraint(equalTo: sensorsPicScroll1.bottomAnchor, constant: 20).isActive = true
            sensorsPicScroll2.leadingAnchor.constraint(equalTo: sensorsView.leadingAnchor, constant: 20).isActive = true
            sensorsPicScroll2.trailingAnchor.constraint(equalTo: sensorsView.trailingAnchor, constant: -20).isActive = true
            sensorsPicScroll2.heightAnchor.constraint(equalToConstant: 200).isActive = true
            
            // Pic 2
            sensorsPicView2 = UIImageView(image: sensorsPic2!)
            sensorsPicScroll2.addSubview(sensorsPicView2)
            sensorsPicView2.translatesAutoresizingMaskIntoConstraints = false
            sensorsPicView2.topAnchor.constraint(equalTo: sensorsPicScroll2.bottomAnchor, constant: 0).isActive = true
            sensorsPicView2.leadingAnchor.constraint(equalTo: sensorsPicScroll2.leadingAnchor, constant: 0).isActive = true
            sensorsPicView2.trailingAnchor.constraint(equalTo: sensorsPicScroll2.trailingAnchor, constant: 0).isActive = true
            sensorsPicView2.heightAnchor.constraint(equalTo: sensorsPicScroll2.heightAnchor).isActive = true
            sensorsPicView2.widthAnchor.constraint(equalTo: sensorsPicScroll2.widthAnchor).isActive = true
            sensorsPicView2.contentMode = .scaleAspectFit
            
            // Pic Label 1
            sensorsView.addSubview(sensorsLabel1)
            sensorsLabel1.translatesAutoresizingMaskIntoConstraints = false
            sensorsLabel1.topAnchor.constraint(equalTo: sensorsPicScroll2.bottomAnchor, constant: 10).isActive = true
            sensorsLabel1.leadingAnchor.constraint(equalTo: sensorsView.leadingAnchor, constant: 20).isActive = true
            sensorsLabel1.trailingAnchor.constraint(equalTo: sensorsView.trailingAnchor, constant: -20).isActive = true
            sensorsLabel1.text = "Georgia Tech IoT sensors are full of new technologies. These sensors are equipped to record air pressure, air temperature, water level, and battery level. These sensors have a ESP32 processor that is dual core 32 bit, 240 Mhz clock. Once these sensors record live data, the sensors leverage a LoRaWAN wireless network to upload data in real-time. Both current and historical data is made available through an API which can be easily viewed through this app or through our dashboard website."
            let attributedString4 = NSMutableAttributedString(string: sensorsLabel1.text!)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 2
            attributedString4.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString4.length))
            sensorsLabel1.attributedText = attributedString4
            Utilities.styleViewLabel(sensorsLabel1)
            
            // Scroll 3
            sensorsView.addSubview(sensorsPicScroll3)
            sensorsPicScroll3.translatesAutoresizingMaskIntoConstraints = false
            sensorsPicScroll3.topAnchor.constraint(equalTo: sensorsLabel1.bottomAnchor, constant: 20).isActive = true
            sensorsPicScroll3.leadingAnchor.constraint(equalTo: sensorsView.leadingAnchor, constant: 20).isActive = true
            sensorsPicScroll3.trailingAnchor.constraint(equalTo: sensorsView.trailingAnchor, constant: -20).isActive = true
            sensorsPicScroll3.heightAnchor.constraint(equalToConstant: 200).isActive = true
            
            // Pic 3
            sensorsPicView3 = UIImageView(image: sensorsPic3!)
            sensorsPicScroll3.addSubview(sensorsPicView3)
            sensorsPicView3.translatesAutoresizingMaskIntoConstraints = false
            sensorsPicView3.topAnchor.constraint(equalTo: sensorsPicScroll3.bottomAnchor, constant: 0).isActive = true
            sensorsPicView3.leadingAnchor.constraint(equalTo: sensorsPicScroll3.leadingAnchor, constant: 0).isActive = true
            sensorsPicView3.trailingAnchor.constraint(equalTo: sensorsPicScroll3.trailingAnchor, constant: 0).isActive = true
            sensorsPicView3.heightAnchor.constraint(equalTo: sensorsPicScroll3.heightAnchor).isActive = true
            sensorsPicView3.widthAnchor.constraint(equalTo: sensorsPicScroll3.widthAnchor).isActive = true
            sensorsPicView3.contentMode = .scaleAspectFit
            
            // Label 2
            sensorsView.addSubview(sensorsLabel2)
            sensorsLabel2.translatesAutoresizingMaskIntoConstraints = false
            sensorsLabel2.topAnchor.constraint(equalTo: sensorsPicScroll3.bottomAnchor, constant: 10).isActive = true
            sensorsLabel2.leadingAnchor.constraint(equalTo: sensorsView.leadingAnchor, constant: 20).isActive = true
            sensorsLabel2.trailingAnchor.constraint(equalTo: sensorsView.trailingAnchor, constant: -20).isActive = true
            sensorsLabel2.text = "Here is an example of the data provided through the API. The code contains a timestamp and current water level reading."
            let attributedString5 = NSMutableAttributedString(string: sensorsLabel2.text!)
            attributedString5.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString5.length))
            sensorsLabel2.attributedText = attributedString5
            Utilities.styleViewLabel(sensorsLabel2)
            
            // Configures height of panel view
            sensorsLabel.layoutIfNeeded()
            sensorsPicScroll1.layoutIfNeeded()
            sensorsPicScroll2.layoutIfNeeded()
            sensorsLabel1.layoutIfNeeded()
            sensorsPicScroll3.layoutIfNeeded()
            sensorsLabel2.layoutIfNeeded()
            
            sensorsAddedHeight += sensorsLabel.bounds.size.height
            sensorsAddedHeight += sensorsPicScroll1.bounds.size.height
            sensorsAddedHeight += sensorsPicScroll2.bounds.size.height
            sensorsAddedHeight += sensorsLabel1.bounds.size.height
            sensorsAddedHeight += sensorsPicScroll3.bounds.size.height
            sensorsAddedHeight += sensorsLabel2.bounds.size.height
            
            sensorsHeight.constant = sensorsAddedHeight + 125
            sensorsHeightGain = sensorsHeight.constant - CGFloat(closedHeight)
            
            scrollHeightfunc()
            
            // Finish
            sensorsOut = true
        } else {
            // Scroll Height
            sensorsHeightGain = 0
            scrollHeightfunc()
            
            // Close View
            sensorsEdge.constant = closedFromSide
            sensorsHeight.constant = CGFloat(closedHeight)
            
            // Button
            sensorsButtonYAxis.constant = 44
            sensorsButtonXAxis.constant = -30
            sensorsButtonWidth.constant = closedButtonArea
            sensorsButtonHeight.constant = closedButtonArea
            sensorsButton.layer.cornerRadius = closedButtonRadius
            sensorsButton.setImage(UIImage(systemName: "plus"), for: .normal)
            
            // Label
            sensorsLabel.text = "Wonder how the Smart Sea Level Sensors record complex data. Click the button to learn more."
            sensorsLabel.font = sensorsLabel.font.withSize(15)
            sensorsLabel.layoutIfNeeded()
            sensorsLabelYAxis.constant = sensorsClosedHeight
            sensorsLabelXAxis.constant = 38
            
            // Pic 1
            sensorsPicView1.removeFromSuperview()
            sensorsPicScroll1.removeFromSuperview()
            
            // Pic 2
            sensorsPicView1.removeFromSuperview()
            sensorsPicScroll2.removeFromSuperview()
            
            // Pic Label
            sensorsLabel1.removeFromSuperview()
            
            // Pic 3
            sensorsPicView3.removeFromSuperview()
            sensorsPicScroll3.removeFromSuperview()
            
            // Label 2
            sensorsLabel2.removeFromSuperview()
            
            // Finish
            sensorsOut = false
        }
    }
    
    // MARK: - Storm View Animation
    // If button gets tapped, perform stormFunc()
    @IBAction func stormButtonTapped(_ sender: Any) {
        stormFunc()
    }
    
    // If section gets tapped, perform stormFunc()
    @objc func tapStorm(tap: UITapGestureRecognizer) {
        stormFunc()
    }
    
    // Function stormFunc()
    func stormFunc() {
        if stormOut == false {
            var stormAddedHeight:CGFloat = 0.0
            
            // Open View
            stormEdge.constant = openedFromSide
            
            // Button
            stormButtonWidth.constant = openedButtonArea
            stormButtonHeight.constant = openedButtonArea
            stormButton.layer.cornerRadius = openedButtonRadius
            stormButtonYAxis.constant = -(openedButtonArea/2)
            stormButtonXAxis.constant = -(openedButtonArea/2)
            stormButton.setImage(UIImage(systemName: "xmark"), for: .normal)
            
            // Label
            stormLabelYAxis.constant = 25
            stormLabel.textAlignment = .left
            stormLabel.text = "Collection of Past Storm Data:"
            stormLabel.font = stormLabel.font.withSize(19)
            
            // Pic 1
            stormView.addSubview(stormPicScroll1)
            stormPicScroll1.translatesAutoresizingMaskIntoConstraints = false
            stormPicScroll1.topAnchor.constraint(equalTo: stormLabel.bottomAnchor, constant: 20).isActive = true
            stormPicScroll1.leadingAnchor.constraint(equalTo: stormView.leadingAnchor, constant: 20).isActive = true
            stormPicScroll1.trailingAnchor.constraint(equalTo: stormView.trailingAnchor, constant: -20).isActive = true
            stormPicScroll1.heightAnchor.constraint(equalToConstant: 200).isActive = true
            stormPicView1 = UIImageView(image: stormPic1)
            stormPicScroll1.addSubview(stormPicView1)
            stormPicView1.translatesAutoresizingMaskIntoConstraints = false
            stormPicView1.topAnchor.constraint(equalTo: stormPicScroll1.bottomAnchor, constant: 0).isActive = true
            stormPicView1.leadingAnchor.constraint(equalTo: stormPicScroll1.leadingAnchor, constant: 0).isActive = true
            stormPicView1.trailingAnchor.constraint(equalTo: stormPicScroll1.trailingAnchor, constant: 0).isActive = true
            stormPicView1.heightAnchor.constraint(equalTo: stormPicScroll1.heightAnchor).isActive = true
            stormPicView1.widthAnchor.constraint(equalTo: stormPicScroll1.widthAnchor).isActive = true
            stormPicView1.contentMode = .scaleAspectFit
            
            // Label 1
            stormView.addSubview(stormLabel1)
            stormLabel1.translatesAutoresizingMaskIntoConstraints = false
            stormLabel1.topAnchor.constraint(equalTo: stormPicScroll1.bottomAnchor, constant: 10).isActive = true
            stormLabel1.leadingAnchor.constraint(equalTo: stormView.leadingAnchor, constant: 20).isActive = true
            stormLabel1.trailingAnchor.constraint(equalTo: stormView.trailingAnchor, constant: -20).isActive = true
            stormLabel1.text = "As you can see in the Estimated Damage of Property, Coastal Bryan - Coastal Chatham - Inland Chatham has an estimated damage of 10.45 million dollars, and Coastal Chatham - Coastal Liberty - Inland Chatham has an estimated damage of 12.9 million dollars. In recent years, storm damages have increased as more violent storms hit costal Georgia."
            let attributedString1 = NSMutableAttributedString(string: stormLabel1.text!)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 2
            attributedString1.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString1.length))
            stormLabel1.attributedText = attributedString1
            Utilities.styleViewLabel(stormLabel1)
            
            // Pic 2
            stormView.addSubview(stormPicScroll2)
            stormPicScroll2.translatesAutoresizingMaskIntoConstraints = false
            stormPicScroll2.topAnchor.constraint(equalTo: stormLabel1.bottomAnchor, constant: 20).isActive = true
            stormPicScroll2.leadingAnchor.constraint(equalTo: stormView.leadingAnchor, constant: 20).isActive = true
            stormPicScroll2.trailingAnchor.constraint(equalTo: stormView.trailingAnchor, constant: -20).isActive = true
            stormPicScroll2.heightAnchor.constraint(equalToConstant: 200).isActive = true
            stormPicView2 = UIImageView(image: stormPic2)
            stormPicScroll2.addSubview(stormPicView2)
            stormPicView2.translatesAutoresizingMaskIntoConstraints = false
            stormPicView2.topAnchor.constraint(equalTo: stormPicScroll2.bottomAnchor, constant: 0).isActive = true
            stormPicView2.leadingAnchor.constraint(equalTo: stormPicScroll2.leadingAnchor, constant: 0).isActive = true
            stormPicView2.trailingAnchor.constraint(equalTo: stormPicScroll2.trailingAnchor, constant: 0).isActive = true
            stormPicView2.heightAnchor.constraint(equalTo: stormPicScroll2.heightAnchor).isActive = true
            stormPicView2.widthAnchor.constraint(equalTo: stormPicScroll2.widthAnchor).isActive = true
            stormPicView2.contentMode = .scaleAspectFit
            
            // Label 2
            stormView.addSubview(stormLabel2)
            stormLabel2.translatesAutoresizingMaskIntoConstraints = false
            stormLabel2.topAnchor.constraint(equalTo: stormPicScroll2.bottomAnchor, constant: 10).isActive = true
            stormLabel2.leadingAnchor.constraint(equalTo: stormView.leadingAnchor, constant: 20).isActive = true
            stormLabel2.trailingAnchor.constraint(equalTo: stormView.trailingAnchor, constant: -20).isActive = true
            stormLabel2.text = "Total damages from hurricane Irma in southeast Georgia were $29,150,000 with Chatham County accounting for $20,000,000 of damages!"
            let attributedString2 = NSMutableAttributedString(string: stormLabel2.text!)
            attributedString2.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString2.length))
            stormLabel2.attributedText = attributedString2
            Utilities.styleViewLabel(stormLabel2)
            
            // Pic 3
            stormView.addSubview(stormPicScroll3)
            stormPicScroll3.translatesAutoresizingMaskIntoConstraints = false
            stormPicScroll3.topAnchor.constraint(equalTo: stormLabel2.bottomAnchor, constant: 20).isActive = true
            stormPicScroll3.leadingAnchor.constraint(equalTo: stormView.leadingAnchor, constant: 20).isActive = true
            stormPicScroll3.trailingAnchor.constraint(equalTo: stormView.trailingAnchor, constant: -20).isActive = true
            stormPicScroll3.heightAnchor.constraint(equalToConstant: 200).isActive = true
            stormPicView3 = UIImageView(image: stormPic3)
            stormPicScroll3.addSubview(stormPicView3)
            stormPicView3.translatesAutoresizingMaskIntoConstraints = false
            stormPicView3.topAnchor.constraint(equalTo: stormPicScroll3.bottomAnchor, constant: 0).isActive = true
            stormPicView3.leadingAnchor.constraint(equalTo: stormPicScroll3.leadingAnchor, constant: 0).isActive = true
            stormPicView3.trailingAnchor.constraint(equalTo: stormPicScroll3.trailingAnchor, constant: 0).isActive = true
            stormPicView3.heightAnchor.constraint(equalTo: stormPicScroll3.heightAnchor).isActive = true
            stormPicView3.widthAnchor.constraint(equalTo: stormPicScroll3.widthAnchor).isActive = true
            stormPicView3.contentMode = .scaleAspectFit
            
            // Label 3
            stormView.addSubview(stormLabel3)
            stormLabel3.translatesAutoresizingMaskIntoConstraints = false
            stormLabel3.topAnchor.constraint(equalTo: stormPicScroll3.bottomAnchor, constant: 10).isActive = true
            stormLabel3.leadingAnchor.constraint(equalTo: stormView.leadingAnchor, constant: 20).isActive = true
            stormLabel3.trailingAnchor.constraint(equalTo: stormView.trailingAnchor, constant: -20).isActive = true
            stormLabel3.text = "Location: Fort Pulaski National Monument"
            let attributedString3 = NSMutableAttributedString(string: stormLabel3.text!)
            attributedString3.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString3.length))
            stormLabel3.attributedText = attributedString3
            Utilities.styleViewLabel(stormLabel3)
            
            // Configures height of panel view
            stormLabel.layoutIfNeeded()
            stormPicScroll1.layoutIfNeeded()
            stormLabel1.layoutIfNeeded()
            stormPicScroll2.layoutIfNeeded()
            stormLabel2.layoutIfNeeded()
            stormPicScroll3.layoutIfNeeded()
            stormLabel3.layoutIfNeeded()
            
            stormAddedHeight += stormLabel.bounds.size.height
            stormAddedHeight += stormPicScroll1.bounds.size.height
            stormAddedHeight += stormLabel1.bounds.size.height
            stormAddedHeight += stormPicScroll2.bounds.size.height
            stormAddedHeight += stormLabel2.bounds.size.height
            stormAddedHeight += stormPicScroll3.bounds.size.height
            stormAddedHeight += stormLabel3.bounds.size.height
            
            stormHeight.constant = stormAddedHeight + 135
            stormHeightGain = stormHeight.constant - CGFloat(closedHeight)
            
            scrollHeightfunc()
            
            // Finish
            stormOut = true
        } else {
            // Scroll Height
            stormHeightGain = 0
            scrollHeightfunc()
            
            // Close View
            stormEdge.constant = closedFromSide
            stormHeight.constant = closedHeight
            
            // Button
            stormButtonWidth.constant = closedButtonArea
            stormButtonHeight.constant = closedButtonArea
            stormButton.layer.cornerRadius = closedButtonRadius
            stormButtonYAxis.constant = 44
            stormButtonXAxis.constant = -30
            stormButton.setImage(UIImage(systemName: "plus"), for: .normal)
            
            // Label
            stormLabel.text = "Interested in past storm data? Click the button to learn more."
            stormLabel.font = stormLabel.font.withSize(15)
            Utilities.bold(stormLabel)
            stormLabel.layoutIfNeeded()
            stormLabelYAxis.constant = stormClosedHeight
            stormLabel.textAlignment = .right
            
            // Pic 1
            stormPicView1.removeFromSuperview()
            stormPicScroll1.removeFromSuperview()
            
            // Pic 1 Label
            stormLabel1.removeFromSuperview()
            
            // Pic 2
            stormPicView2.removeFromSuperview()
            stormPicScroll2.removeFromSuperview()
            
            // Pic 2 Label
            stormLabel2.removeFromSuperview()
            
            // Pic 3
            stormPicView3.removeFromSuperview()
            stormPicScroll3.removeFromSuperview()
            
            stormLabel3.removeFromSuperview()
            
            // Finish
            stormOut = false
        }
    }
    
    // MARK: - Behind View Animation
    // If button gets tapped, perform behindFunc()
    @IBAction func behindButtonTapped(_ sender: Any) {
        behindFunc()
    }
    
    // If section gets tapped, perform behindFunc()
    @objc func tapBehind(tap: UITapGestureRecognizer) {
        behindFunc()
    }
    
    // Function behindFunc()
    func behindFunc () {
        if behindOut == false {
            var behindAddedHeight:CGFloat = 0.0
            
            // Open View
            behindEdge.constant = openedFromSide
            
            // Button
            behindButtonWidth.constant = openedButtonArea
            behindButtonHeight.constant = openedButtonArea
            behindButton.layer.cornerRadius = openedButtonRadius
            behindButtonYAxis.constant = -(openedButtonArea/2)
            behindButtonXAxis.constant = -(openedButtonArea/2)
            behindButton.setImage(UIImage(systemName: "xmark"), for: .normal)
            
            // Label
            behindLabelYAxis.constant = 25
            behindLabel.font = behindLabel.font.withSize(24)
            behindLabelXAxis.isActive = false
            behindLabelXAxis2.isActive = false
            behindLabel.translatesAutoresizingMaskIntoConstraints = false
            behindLabel.centerXAnchor.constraint(equalTo: self.behindView.centerXAnchor).isActive = true
            behindLabel.text = "Project Partners"
            
            // Sub Title 1 - "Georgia Tech"
            behindView.addSubview(behindSubTitleLabel1)
            behindSubTitleLabel1.translatesAutoresizingMaskIntoConstraints = false
            behindSubTitleLabel1.topAnchor.constraint(equalTo: behindLabel.bottomAnchor, constant: 20).isActive = true
            behindSubTitleLabel1.leadingAnchor.constraint(equalTo: behindView.leadingAnchor, constant: 20).isActive = true
            behindSubTitleLabel1.trailingAnchor.constraint(equalTo: behindView.trailingAnchor, constant: -20).isActive = true
            behindSubTitleLabel1.text = "Georgia Tech"
            Utilities.styleViewLabel(behindSubTitleLabel1)
            behindSubTitleLabel1.font = behindSubTitleLabel1.font.withSize(20)
            Utilities.bold(behindSubTitleLabel1)
            
            behindView.layoutIfNeeded()
            let behindViewWidth = behindView.bounds.size.width
            let CardWidth = behindViewWidth - 50
            behindCardWidth = CardWidth/2
            
            // Cobb - L
            behindView.addSubview(behindCobbView)
            behindCobbView.translatesAutoresizingMaskIntoConstraints = false
            behindCobbView.topAnchor.constraint(equalTo: behindSubTitleLabel1.bottomAnchor, constant: 10).isActive = true
            behindCobbView.leadingAnchor.constraint(equalTo: behindView.leadingAnchor, constant: 20).isActive = true
            behindCobbView.heightAnchor.constraint(equalToConstant: behindCardHeight).isActive = true
            behindCobbView.widthAnchor.constraint(equalToConstant: behindCardWidth).isActive = true
            behindCobbView.backgroundColor = .white
            behindCobbView.addSubview(behindCobbLabel)
            behindCobbLabel.translatesAutoresizingMaskIntoConstraints = false
            behindCobbLabel.topAnchor.constraint(equalTo: behindCobbView.topAnchor, constant: 10).isActive = true
            behindCobbLabel.leadingAnchor.constraint(equalTo: behindCobbView.leadingAnchor, constant: 10).isActive = true
            behindCobbLabel.text = "Kim M. Cobb"
            Utilities.behindCardName(behindCobbLabel)
            behindCobbView.addSubview(behindCobbDesc)
            behindCobbDesc.translatesAutoresizingMaskIntoConstraints = false
            behindCobbDesc.topAnchor.constraint(equalTo: behindCobbLabel.bottomAnchor, constant: 5).isActive = true
            behindCobbDesc.leadingAnchor.constraint(equalTo: behindCobbView.leadingAnchor, constant: 10).isActive = true
            behindCobbDesc.trailingAnchor.constraint(equalTo: behindCobbView.trailingAnchor, constant: -10).isActive = true
            behindCobbDesc.text = "Professor, Earth and Atmospheric Sciences"
            Utilities.behindCardDesc(behindCobbDesc)
            Utilities.behindCardView(behindCobbView)
            
            // Clark - R
            behindView.addSubview(behindClarkView)
            behindClarkView.translatesAutoresizingMaskIntoConstraints = false
            behindClarkView.topAnchor.constraint(equalTo: behindSubTitleLabel1.bottomAnchor, constant: 10).isActive = true
            behindClarkView.leadingAnchor.constraint(equalTo: behindCobbView.trailingAnchor, constant: 10).isActive = true
            behindClarkView.heightAnchor.constraint(equalToConstant: behindCardHeight).isActive = true
            behindClarkView.widthAnchor.constraint(equalToConstant: behindCardWidth).isActive = true
            behindClarkView.backgroundColor = .white
            behindClarkView.addSubview(behindClarkLabel)
            behindClarkLabel.translatesAutoresizingMaskIntoConstraints = false
            behindClarkLabel.topAnchor.constraint(equalTo: behindClarkView.topAnchor, constant: 10).isActive = true
            behindClarkLabel.leadingAnchor.constraint(equalTo: behindClarkView.leadingAnchor, constant: 10).isActive = true
            behindClarkLabel.text = "Russell Clark"
            Utilities.behindCardName(behindClarkLabel)
            behindClarkView.addSubview(behindClarkDesc)
            behindClarkDesc.translatesAutoresizingMaskIntoConstraints = false
            behindClarkDesc.topAnchor.constraint(equalTo: behindClarkLabel.bottomAnchor, constant: 5).isActive = true
            behindClarkDesc.leadingAnchor.constraint(equalTo: behindClarkView.leadingAnchor, constant: 10).isActive = true
            behindClarkDesc.trailingAnchor.constraint(equalTo: behindClarkView.trailingAnchor, constant: -10).isActive = true
            behindClarkDesc.text = "Research Faculty, Computer Science"
            Utilities.behindCardDesc(behindClarkDesc)
            Utilities.behindCardView(behindClarkView)
            
            // Lorenzo - L
            behindView.addSubview(behindLorenzoView)
            behindLorenzoView.translatesAutoresizingMaskIntoConstraints = false
            behindLorenzoView.topAnchor.constraint(equalTo: behindCobbView.bottomAnchor, constant: 15).isActive = true
            behindLorenzoView.leadingAnchor.constraint(equalTo: behindView.leadingAnchor, constant: 20).isActive = true
            behindLorenzoView.heightAnchor.constraint(equalToConstant: behindCardHeight).isActive = true
            behindLorenzoView.widthAnchor.constraint(equalToConstant: behindCardWidth).isActive = true
            behindLorenzoView.backgroundColor = .white
            behindLorenzoView.addSubview(behindLorenzoLabel)
            behindLorenzoLabel.translatesAutoresizingMaskIntoConstraints = false
            behindLorenzoLabel.topAnchor.constraint(equalTo: behindLorenzoView.topAnchor, constant: 5).isActive = true
            behindLorenzoLabel.leadingAnchor.constraint(equalTo: behindLorenzoView.leadingAnchor, constant: 10).isActive = true
            behindLorenzoLabel.trailingAnchor.constraint(equalTo: behindLorenzoView.trailingAnchor, constant: -10).isActive = true
            behindLorenzoLabel.text = "Emanuele Di Lorenzo"
            Utilities.behindCardName(behindLorenzoLabel)
            behindLorenzoView.addSubview(behindLorenzoDesc)
            behindLorenzoDesc.translatesAutoresizingMaskIntoConstraints = false
            behindLorenzoDesc.topAnchor.constraint(equalTo: behindLorenzoLabel.bottomAnchor, constant: 5).isActive = true
            behindLorenzoDesc.leadingAnchor.constraint(equalTo: behindLorenzoView.leadingAnchor, constant: 10).isActive = true
            behindLorenzoDesc.trailingAnchor.constraint(equalTo: behindLorenzoView.trailingAnchor, constant: -10).isActive = true
            behindLorenzoDesc.text = "Professor, Earth and Atmospheric Sciences"
            Utilities.behindCardDesc(behindLorenzoDesc)
            Utilities.behindCardView(behindLorenzoView)
            
            // Cone - R
            behindView.addSubview(behindConeView)
            behindConeView.translatesAutoresizingMaskIntoConstraints = false
            behindConeView.topAnchor.constraint(equalTo: behindClarkView.bottomAnchor, constant: 15).isActive = true
            behindConeView.leadingAnchor.constraint(equalTo: behindLorenzoView.trailingAnchor, constant: 10).isActive = true
            behindConeView.heightAnchor.constraint(equalToConstant: behindCardHeight).isActive = true
            behindConeView.widthAnchor.constraint(equalToConstant: behindCardWidth).isActive = true
            behindConeView.backgroundColor = .white
            behindConeView.addSubview(behindConeLabel)
            behindConeLabel.translatesAutoresizingMaskIntoConstraints = false
            behindConeLabel.topAnchor.constraint(equalTo: behindConeView.topAnchor, constant: 10).isActive = true
            behindConeLabel.leadingAnchor.constraint(equalTo: behindConeView.leadingAnchor, constant: 10).isActive = true
            behindConeLabel.text = "Tim Cone"
            Utilities.behindCardName(behindConeLabel)
            behindConeView.addSubview(behindConeDesc)
            behindConeDesc.translatesAutoresizingMaskIntoConstraints = false
            behindConeDesc.topAnchor.constraint(equalTo: behindConeLabel.bottomAnchor, constant: 5).isActive = true
            behindConeDesc.leadingAnchor.constraint(equalTo: behindConeView.leadingAnchor, constant: 10).isActive = true
            behindConeDesc.trailingAnchor.constraint(equalTo: behindConeView.trailingAnchor, constant: -10).isActive = true
            behindConeDesc.text = "Program Director, CEISMC"
            Utilities.behindCardDesc(behindConeDesc)
            Utilities.behindCardView(behindConeView)
            
            // Koval - L
            behindView.addSubview(behindKovalView)
            behindKovalView.translatesAutoresizingMaskIntoConstraints = false
            behindKovalView.topAnchor.constraint(equalTo: behindLorenzoView.bottomAnchor, constant: 15).isActive = true
            behindKovalView.leadingAnchor.constraint(equalTo: behindView.leadingAnchor, constant: 20).isActive = true
            behindKovalView.heightAnchor.constraint(equalToConstant: behindCardHeight).isActive = true
            behindKovalView.widthAnchor.constraint(equalToConstant: behindCardWidth).isActive = true
            behindKovalView.backgroundColor = .white
            behindKovalView.addSubview(behindKovalLabel)
            behindKovalLabel.translatesAutoresizingMaskIntoConstraints = false
            behindKovalLabel.topAnchor.constraint(equalTo: behindKovalView.topAnchor, constant: 10).isActive = true
            behindKovalLabel.leadingAnchor.constraint(equalTo: behindKovalView.leadingAnchor, constant: 10).isActive = true
            behindKovalLabel.text = "Jayma Koval"
            Utilities.behindCardName(behindKovalLabel)
            behindKovalView.addSubview(behindKovalDesc)
            behindKovalDesc.translatesAutoresizingMaskIntoConstraints = false
            behindKovalDesc.topAnchor.constraint(equalTo: behindKovalLabel.bottomAnchor, constant: 5).isActive = true
            behindKovalDesc.leadingAnchor.constraint(equalTo: behindKovalView.leadingAnchor, constant: 10).isActive = true
            behindKovalDesc.trailingAnchor.constraint(equalTo: behindKovalView.trailingAnchor, constant: -10).isActive = true
            behindKovalDesc.text = "Research Faculty, CEISMC"
            Utilities.behindCardDesc(behindKovalDesc)
            Utilities.behindCardView(behindKovalView)
            
            // Sub Title 2  - "Chatham Emergency Management Agency"
            behindView.addSubview(behindSubTitleLabel2)
            behindSubTitleLabel2.translatesAutoresizingMaskIntoConstraints = false
            behindSubTitleLabel2.topAnchor.constraint(equalTo: behindKovalView.bottomAnchor, constant: 20).isActive = true
            behindSubTitleLabel2.leadingAnchor.constraint(equalTo: behindView.leadingAnchor, constant: 20).isActive = true
            behindSubTitleLabel2.trailingAnchor.constraint(equalTo: behindView.trailingAnchor, constant: -20).isActive = true
            behindSubTitleLabel2.text = "Chatham Emergency Management Agency"
            Utilities.styleViewLabel(behindSubTitleLabel2)
            behindSubTitleLabel2.font = behindSubTitleLabel2.font.withSize(20)
            behindSubTitleLabel2.textAlignment = .left
            Utilities.bold(behindSubTitleLabel2)
            
            // Mathews
            behindView.addSubview(behindMathewsView)
            behindMathewsView.translatesAutoresizingMaskIntoConstraints = false
            behindMathewsView.topAnchor.constraint(equalTo: behindSubTitleLabel2.bottomAnchor, constant: 10).isActive = true
            behindMathewsView.leadingAnchor.constraint(equalTo: behindView.leadingAnchor, constant: 20).isActive = true
            behindMathewsView.heightAnchor.constraint(equalToConstant: behindCardHeight-25).isActive = true
            behindMathewsView.widthAnchor.constraint(equalToConstant: behindCardWidth).isActive = true
            behindMathewsView.backgroundColor = .white
            behindMathewsView.addSubview(behindMathewsLabel)
            behindMathewsLabel.translatesAutoresizingMaskIntoConstraints = false
            behindMathewsLabel.topAnchor.constraint(equalTo: behindMathewsView.topAnchor, constant: 10).isActive = true
            behindMathewsLabel.leadingAnchor.constraint(equalTo: behindMathewsView.leadingAnchor, constant: 10).isActive = true
            behindMathewsLabel.trailingAnchor.constraint(equalTo: behindMathewsView.trailingAnchor, constant: -10).isActive = true
            behindMathewsLabel.text = "Randall Mathews"
            Utilities.behindCardName(behindMathewsLabel)
            behindMathewsView.addSubview(behindMathewsDesc)
            behindMathewsDesc.translatesAutoresizingMaskIntoConstraints = false
            behindMathewsDesc.topAnchor.constraint(equalTo: behindMathewsLabel.bottomAnchor, constant: 5).isActive = true
            behindMathewsDesc.leadingAnchor.constraint(equalTo: behindMathewsView.leadingAnchor, constant: 10).isActive = true
            behindMathewsDesc.trailingAnchor.constraint(equalTo: behindMathewsView.trailingAnchor, constant: -10).isActive = true
            behindMathewsDesc.text = "Assistant Director"
            Utilities.behindCardDesc(behindMathewsDesc)
            Utilities.behindCardView(behindMathewsView)
            
            // Sub Title 3 - "City Of Savannah"
            behindView.addSubview(behindSubTitleLabel3)
            behindSubTitleLabel3.translatesAutoresizingMaskIntoConstraints = false
            behindSubTitleLabel3.topAnchor.constraint(equalTo: behindMathewsView.bottomAnchor, constant: 20).isActive = true
            behindSubTitleLabel3.leadingAnchor.constraint(equalTo: behindView.leadingAnchor, constant: 20).isActive = true
            behindSubTitleLabel3.trailingAnchor.constraint(equalTo: behindView.trailingAnchor, constant: -20).isActive = true
            behindSubTitleLabel3.text = "City of Savannah"
            Utilities.styleViewLabel(behindSubTitleLabel3)
            behindSubTitleLabel3.font = behindSubTitleLabel3.font.withSize(20)
            behindSubTitleLabel3.textAlignment = .left
            Utilities.bold(behindSubTitleLabel3)
            
            // Deffley - L
            behindView.addSubview(behindDeffleyView)
            behindDeffleyView.translatesAutoresizingMaskIntoConstraints = false
            behindDeffleyView.topAnchor.constraint(equalTo: behindSubTitleLabel3.bottomAnchor, constant: 10).isActive = true
            behindDeffleyView.leadingAnchor.constraint(equalTo: behindView.leadingAnchor, constant: 20).isActive = true
            behindDeffleyView.heightAnchor.constraint(equalToConstant: behindCardHeight-25).isActive = true
            behindDeffleyView.widthAnchor.constraint(equalToConstant: behindCardWidth).isActive = true
            behindDeffleyView.backgroundColor = .white
            behindDeffleyView.addSubview(behindDeffleyLabel)
            behindDeffleyLabel.translatesAutoresizingMaskIntoConstraints = false
            behindDeffleyLabel.topAnchor.constraint(equalTo: behindDeffleyView.topAnchor, constant: 10).isActive = true
            behindDeffleyLabel.leadingAnchor.constraint(equalTo: behindDeffleyView.leadingAnchor, constant: 10).isActive = true
            behindDeffleyLabel.text = "Nick Deffley"
            Utilities.behindCardName(behindDeffleyLabel)
            behindDeffleyView.addSubview(behindDeffleyDesc)
            behindDeffleyDesc.translatesAutoresizingMaskIntoConstraints = false
            behindDeffleyDesc.topAnchor.constraint(equalTo: behindDeffleyLabel.bottomAnchor, constant: 5).isActive = true
            behindDeffleyDesc.leadingAnchor.constraint(equalTo: behindDeffleyView.leadingAnchor, constant: 10).isActive = true
            behindDeffleyDesc.trailingAnchor.constraint(equalTo: behindDeffleyView.trailingAnchor, constant: -10).isActive = true
            behindDeffleyDesc.text = "Director, Office of Sustainability"
            Utilities.behindCardDesc(behindDeffleyDesc)
            Utilities.behindCardView(behindDeffleyView)
            
            // Sub Title 4 - "App Developer"
            behindView.addSubview(behindSubTitleLabel4)
            behindSubTitleLabel4.translatesAutoresizingMaskIntoConstraints = false
            behindSubTitleLabel4.topAnchor.constraint(equalTo: behindDeffleyView.bottomAnchor, constant: 20).isActive = true
            behindSubTitleLabel4.leadingAnchor.constraint(equalTo: behindView.leadingAnchor, constant: 20).isActive = true
            behindSubTitleLabel4.trailingAnchor.constraint(equalTo: behindView.trailingAnchor, constant: -20).isActive = true
            behindSubTitleLabel4.text = "App Developer"
            Utilities.styleViewLabel(behindSubTitleLabel4)
            behindSubTitleLabel4.font = behindSubTitleLabel4.font.withSize(20)
            behindSubTitleLabel4.textAlignment = .left
            Utilities.bold(behindSubTitleLabel4)
            
            // Enoch - L
            behindView.addSubview(behindEnochView)
            behindEnochView.translatesAutoresizingMaskIntoConstraints = false
            behindEnochView.topAnchor.constraint(equalTo: behindSubTitleLabel4.bottomAnchor, constant: 10).isActive = true
            behindEnochView.leadingAnchor.constraint(equalTo: behindView.leadingAnchor, constant: 20).isActive = true
            behindEnochView.heightAnchor.constraint(equalToConstant: behindCardHeight-25).isActive = true
            behindEnochView.widthAnchor.constraint(equalToConstant: behindCardWidth).isActive = true
            behindEnochView.backgroundColor = .white
            behindEnochView.addSubview(behindEnochLabel)
            behindEnochLabel.translatesAutoresizingMaskIntoConstraints = false
            behindEnochLabel.topAnchor.constraint(equalTo: behindEnochView.topAnchor, constant: 10).isActive = true
            behindEnochLabel.leadingAnchor.constraint(equalTo: behindEnochView.leadingAnchor, constant: 10).isActive = true
            behindEnochLabel.text = "Enoch Johnson"
            Utilities.behindCardName(behindEnochLabel)
            behindEnochView.addSubview(behindEnochDesc)
            behindEnochDesc.translatesAutoresizingMaskIntoConstraints = false
            behindEnochDesc.topAnchor.constraint(equalTo: behindEnochLabel.bottomAnchor, constant: 5).isActive = true
            behindEnochDesc.leadingAnchor.constraint(equalTo: behindEnochView.leadingAnchor, constant: 10).isActive = true
            behindEnochDesc.trailingAnchor.constraint(equalTo: behindEnochView.trailingAnchor, constant: -10).isActive = true
            behindEnochDesc.text = "App Developer, Sea Sensors App"
            Utilities.behindCardDesc(behindEnochDesc)
            Utilities.behindCardView(behindEnochView)
            
            // Funders Label
            behindView.addSubview(behindFundersLabel)
            behindFundersLabel.translatesAutoresizingMaskIntoConstraints = false
            behindFundersLabel.topAnchor.constraint(equalTo: behindEnochView.bottomAnchor, constant: 25).isActive = true
            behindFundersLabel.centerXAnchor.constraint(equalTo: self.behindView.centerXAnchor).isActive = true
            behindFundersLabel.text = "Funders"
            Utilities.styleViewLabel(behindFundersLabel)
            behindFundersLabel.font = behindFundersLabel.font.withSize(24)
            Utilities.bold(behindFundersLabel)
            
            // Smart
            behindView.addSubview(behindSmartView)
            behindSmartView.translatesAutoresizingMaskIntoConstraints = false
            behindSmartView.topAnchor.constraint(equalTo: behindFundersLabel.bottomAnchor, constant: 10).isActive = true
            behindSmartView.leadingAnchor.constraint(equalTo: behindView.leadingAnchor, constant: 20).isActive = true
            behindSmartView.trailingAnchor.constraint(equalTo: behindView.trailingAnchor, constant: -20).isActive = true
            
            // Pic 1
            behindSmartView.addSubview(behindPicScroll1)
            behindPicScroll1.translatesAutoresizingMaskIntoConstraints = false
            behindPicScroll1.topAnchor.constraint(equalTo: behindSmartView.topAnchor, constant: 10).isActive = true
            behindPicScroll1.leadingAnchor.constraint(equalTo: behindSmartView.leadingAnchor, constant: 27.5).isActive = true
            behindPicScroll1.trailingAnchor.constraint(equalTo: behindSmartView.trailingAnchor, constant: -12.5).isActive = true
            behindPicScroll1.heightAnchor.constraint(equalToConstant: 50).isActive = true
            behindPicView1 = UIImageView(image: behindPic1)
            behindPicScroll1.addSubview(behindPicView1)
            behindPicView1.translatesAutoresizingMaskIntoConstraints = false
            behindPicView1.topAnchor.constraint(equalTo: behindPicScroll1.bottomAnchor, constant: 0).isActive = true
            behindPicView1.leadingAnchor.constraint(equalTo: behindPicScroll1.leadingAnchor, constant: 0).isActive = true
            behindPicView1.trailingAnchor.constraint(equalTo: behindPicScroll1.trailingAnchor, constant: 0).isActive = true
            behindPicView1.heightAnchor.constraint(equalTo: behindPicScroll1.heightAnchor).isActive = true
            behindPicView1.widthAnchor.constraint(equalTo: behindPicScroll1.widthAnchor).isActive = true
            behindPicView1.contentMode = .scaleAspectFit
            
            // Smart Label
            behindSmartView.addSubview(behindSmartLabel)
            behindSmartLabel.translatesAutoresizingMaskIntoConstraints = false
            behindSmartLabel.topAnchor.constraint(equalTo: behindPicScroll1.bottomAnchor, constant: 15).isActive = true
            behindSmartLabel.leadingAnchor.constraint(equalTo: behindSmartView.leadingAnchor, constant: 20).isActive = true
            behindSmartLabel.trailingAnchor.constraint(equalTo: behindSmartView.trailingAnchor, constant: -20).isActive = true
            behindSmartLabel.text = "The Smart Sea Level Sensors Project is one of four projects under the Georgia Smart Communities Challenge. The strategies developed by the selected communities are meant to serve as models that could be implemented elsewhere to advance smart technology and improve community well-being across Georgia."
            let attributedString1 = NSMutableAttributedString(string: behindSmartLabel.text!)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 2
            attributedString1.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString1.length))
            behindSmartLabel.attributedText = attributedString1
            Utilities.styleViewLabel(behindSmartLabel)
            behindSmartLabel.textColor = UIColor.black
            
            // Configures height of panel view
            behindLabel.layoutIfNeeded()
            behindSubTitleLabel1.layoutIfNeeded()
            behindCobbView.layoutIfNeeded()
            behindLorenzoView.layoutIfNeeded()
            behindConeView.layoutIfNeeded()
            behindSubTitleLabel2.layoutIfNeeded()
            behindMathewsView.layoutIfNeeded()
            behindSubTitleLabel3.layoutIfNeeded()
            behindDeffleyView.layoutIfNeeded()
            behindSubTitleLabel4.layoutIfNeeded()
            behindEnochView.layoutIfNeeded()
            behindFundersLabel.layoutIfNeeded()
            //            behindSmartView.layoutIfNeeded()
            
            // calculate height of BehindSmartView
            behindPicScroll1.layoutIfNeeded()
            behindSmartLabel.layoutIfNeeded()
            var smartViewHeight:CGFloat = 35
            smartViewHeight += behindPicScroll1.bounds.size.height
            smartViewHeight += behindSmartLabel.bounds.size.height
            
            behindSmartView.heightAnchor.constraint(equalToConstant: smartViewHeight).isActive = true
            behindSmartView.backgroundColor = .white
            Utilities.behindCardView(behindSmartView)
            
            behindAddedHeight += behindLabel.bounds.size.height
            behindAddedHeight += behindSubTitleLabel1.bounds.size.height
            behindAddedHeight += behindCobbView.bounds.size.height
            behindAddedHeight += behindLorenzoView.bounds.size.height
            behindAddedHeight += behindConeView.bounds.size.height
            behindAddedHeight += behindSubTitleLabel2.bounds.size.height
            behindAddedHeight += behindMathewsView.bounds.size.height
            behindAddedHeight += behindSubTitleLabel3.bounds.size.height
            behindAddedHeight += behindDeffleyView.bounds.size.height
            behindAddedHeight += behindSubTitleLabel4.bounds.size.height
            behindAddedHeight += behindEnochView.bounds.size.height
            behindAddedHeight += behindFundersLabel.bounds.size.height
            
            behindAddedHeight += behindPicScroll1.bounds.size.height
            behindAddedHeight += behindSmartLabel.bounds.size.height
            
            //            behindAddedHeight += behindSmartView.bounds.size.height
            
            behindHeight.constant = behindAddedHeight + 265
            behindHeightGain = behindHeight.constant - CGFloat(closedHeight)
            
            scrollHeightfunc()
            
            // Finish
            behindOut = true
        } else {
            // Scroll Height
            behindHeightGain = 0
            scrollHeightfunc()
            
            // Close View
            behindEdge.constant = closedFromSide
            behindHeight.constant = CGFloat(closedHeight)
            
            // Button
            behindButtonWidth.constant = closedButtonArea
            behindButtonHeight.constant = closedButtonArea
            behindButton.layer.cornerRadius = closedButtonRadius
            behindButtonYAxis.constant = 44
            behindButtonXAxis.constant = -30
            behindButton.setImage(UIImage(systemName: "plus"), for: .normal)
            
            // Label
            behindLabel.font = behindLabel.font.withSize(15)
            behindLabel.text = "Want to know who's behind the Smart Sea Level Sensor project? Click the button to learn more."
            behindLabel.layoutIfNeeded()
            behindLabelYAxis.constant = behindClosedHeight
            behindLabelXAxis.isActive = true
            behindLabelXAxis2.isActive = true
            behindLabel.translatesAutoresizingMaskIntoConstraints = false
            behindLabel.centerXAnchor.constraint(equalTo: self.behindView.centerXAnchor).isActive = false
            
            // Sub Title 1 - "Georgia Tech"
            behindSubTitleLabel1.removeFromSuperview()
            
            // Cobb
            behindCobbView.removeFromSuperview()
            behindCobbLabel.removeFromSuperview()
            
            // Clark
            behindClarkView.removeFromSuperview()
            
            // Lorenzo
            behindLorenzoView.removeFromSuperview()
            
            // Cone
            behindConeView.removeFromSuperview()
            
            // Koval
            behindKovalView.removeFromSuperview()
            
            // Sub Title 2 - "Chatham Emergency Management Agency"
            behindSubTitleLabel2.removeFromSuperview()
            
            // Mathews
            behindMathewsView.removeFromSuperview()
            
            // Sub Title 3 - "City of Savannah"
            behindSubTitleLabel3.removeFromSuperview()
            
            // Deffley
            behindDeffleyView.removeFromSuperview()
            
            // Funders Label
            behindFundersLabel.removeFromSuperview()
            
            // Smart
            behindSmartView.removeFromSuperview()
            
            // Sub Title 4 - "App Developer"
            behindSubTitleLabel4.removeFromSuperview()
            
            // Enoch
            behindEnochView.removeFromSuperview()
            
            // Finish
            behindOut = false
        }
    }
    
    // MARK: - Moving Menu Animation
    @IBAction func fixedMenuTapped(_ sender: Any) {
        if menuOut == false {
            scrollLeading.constant = movingConstant
            scrollTrailing.constant = -movingConstant
            menuOut = true
        } else {
            scrollLeading.constant = 0
            scrollTrailing.constant = 0
            menuOut = false
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn,animations: {
            self.view.layoutIfNeeded()
        }) { (animationComplete) in
            print("complete")
        }
    }
    
    //  MARK: - Menu Outlets
    @IBAction func fixedLearnMoreTapped(_ sender: Any) {
        showSafariVC(for: "https://www.sealevelsensors.org")
    }
    
    @IBAction func fixedDashboardTapped(_ sender: Any) {
        showSafariVC(for: "https://dashboard.sealevelsensors.org")
    }
    
    @IBAction func fixedContactUsTapped(_ sender: Any) {
        showSafariVC(for: "https://docs.google.com/forms/d/e/1FAIpQLSdNXpt8COeKYSPTg64uU_ML25Hnd-m0DMsX6ziDYeDhAcfFKw/viewform?usp=sf_link")
    }
    
    @IBAction func test(_ sender: UIButton) {
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
    
    func size(String: UILabel, font: UIFont, width: CGFloat) -> CGFloat {
        let attrString = NSAttributedString(string: String.text!, attributes: [NSAttributedString.Key.font: font])
        let bounds = attrString.boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        var size = CGSize(width: bounds.width, height: bounds.height)
        return size.height
    }
    
    // MARK: - Scroll Height Function
    func scrollHeightfunc() {
        // Scroll Height
        scrollHeight.constant = CGFloat(orgScrollHeight) + purposeHeightGain + whyHeightGain + sensorsHeightGain + stormHeightGain + behindHeightGain
        gain = purposeHeightGain + whyHeightGain + sensorsHeightGain + stormHeightGain + behindHeightGain
        //        purposeButtonYAxis.constant += gain
        //        whyButtonYAxis.constant = gain + whyButtonYAxisBase
        //        sensorsButtonYAxis.constant = gain + sensorsButtonYAxisBase
    }
    
}
