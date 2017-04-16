//
//  SearchViewController.swift
//  TinoHacks
//
//  Created by Anand Chandra and Michael Wu on 4/15/17.
//  Copyright © 2017 AnandChandraMichaelWu. All rights reserved.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate, UITextFieldDelegate {


    var locationManager = CLLocationManager()
    
    private var searchRadius: Double?
    
    private var longitude: Double?
    private var latitude: Double?
    private var zipCode: String? {
        didSet {
            print("SET ZIP CODE")
        }
    }
        
    private var currentLocationIsPressed = false
    
    private var pickerData = [0.1, 0.5, 1, 5, 10, 25]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.numberOfMiles.delegate = self
        self.numberOfMiles.dataSource = self
        zipCodeTextField.text = ""

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var numberOfMiles: UIPickerView!

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(describing: pickerData[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        searchRadius = Double(pickerData[row])
    }
    
    @IBOutlet weak var restaurantControl: UISegmentedControl!
    
    
    @IBOutlet weak var getLocationButton: RoundedButton!
    
    @IBAction func receiveLocation(_ sender: RoundedButton) {
        currentLocationIsPressed = !currentLocationIsPressed
        if currentLocationIsPressed {
            sender.backgroundColor = UIColor.lightGray
            zipCodeTextField.text = ""
        } else {
            sender.backgroundColor = UIColor.white
        }
        // Ask for Authorization from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            getLocation()
            
        }
    }
    
    @IBOutlet weak var zipCodeTextField: UITextField! {
        didSet {
            zipCodeTextField.delegate = self
            zipCodeTextField.text = zipCode
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        currentLocationIsPressed = false
        getLocationButton.backgroundColor = UIColor.white
        textField.resignFirstResponder()
        zipCode = textField.text
        return true
    }
    
    
    func getLocation(){
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        let long = userLocation.coordinate.longitude;
        let lat = userLocation.coordinate.latitude;
        print(long)
        print(lat)
        latitude = lat
        longitude = long
        
        locationManager.stopUpdatingLocation()
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if latitude == nil && longitude == nil && zipCode == nil {
            return false
        } else {
            return true
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        print("attempting")
        
        var destinationvc = segue.destination
        if let navigationvc = destinationvc as? UINavigationController {
            destinationvc = navigationvc.visibleViewController ?? destinationvc
        }
        if let resultVC = destinationvc as? ResultsViewController {
            if let identifier = segue.identifier {
                if identifier == "Show Results" {
                    print("seguing correctly")
                    if searchRadius == nil {
                        resultVC.radius = 0.1
                    } else {
                        resultVC.radius = searchRadius
                    }

                    if currentLocationIsPressed {
                        resultVC.latitude = latitude
                        resultVC.longitude = longitude
                    }
                    else {
                        resultVC.zipCode = zipCode
                    }
                    
                    resultVC.openOnly = restaurantControl.selectedSegmentIndex == 0
                    print("check is \(restaurantControl.selectedSegmentIndex)")
                    resultVC.navigationItem.title = "Restaurant"
                    
                    print(searchRadius)
                    print(latitude)
                    print(longitude)
                    print(zipCode)
                }
            }
        }
    
    }
    

}
