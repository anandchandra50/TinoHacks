//
//  ResultsViewController.swift
//  TinoHacks
//
//  Created by Rohit Chandra on 4/15/17.
//  Copyright © 2017 AnandChandraMichaelWu. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController, UIScrollViewDelegate {
    
    var longitude: Double?
    var latitude: Double?
    var radius: Double?
    var zipCode: String?
    
    
    private var restaurantAPI: String?
    
    private var toSendLatitude: Double?
    private var toSendLongitude: Double?
    
    private var begOfSearchString = "https://api.eatstreet.com/publicapi/v1/restaurant/search?"
    private var endOfSearchStringBeforeRadius = "&method=pickup&pickup-"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        runProgram()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        longitude = nil
        latitude = nil
        radius = nil
        zipCode = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func runProgram() {
        restaurantNameLabel.text = ""
        restaurantPhoneNumber.setTitle("", for: UIControlState.normal)
        restaurantHours.text = ""
        restaurantAddress.setTitle("", for: UIControlState.normal)
        restaurantImage.image = nil
        restaurantUrl.setTitle("", for: .normal)
        tapOnMapLabel.text = ""
        
        searchForRestaurant()
    }
    
    /*
     private var restaurantView = RestaurantDataView()
     
     
     private var restaurantName: String?
     private var restaurantHours: String?
     private var restaurantPhoneNumber: String?
     private var restaurantStreetAddress: String?
     private var restaurantZipCode: String?
     
     private var testView = UIView()
     */
    
    
    
    private func searchForRestaurant() {
        
        spinner?.startAnimating()
        
        print("called method")
        if (longitude == nil) {
            print(zipCode)
            let url = URL(string: "https://www.zipcodeapi.com/rest/58t0U3koaVm4GR0cjatzVHNoHxAASNkXWNYQRje2eB7Us77MhBmdiaC0HcAz0UxW/info.json/" + zipCode! + "/degrees")
            var searchResults: [String: Any?]?
            
            let task = URLSession.shared.dataTask(with: url!) { (data: Data?, response: URLResponse?, error: Error?) in
                print("tried running")
                searchResults = self.convertToDictionary(text: (NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as! String))
                print(searchResults?["lat"]);
                print(searchResults?["lng"]); print(); print();
                if let lat = searchResults!["lat"] {
                    self.latitude = lat as! Double
                }
                if let long = searchResults!["lng"] {
                    self.longitude = long as! Double
                }
                print(error)
                
                let urlString = self.begOfSearchString + "latitude=\(String(describing: self.latitude!))&longitude=\(String(describing: self.longitude!))" + self.endOfSearchStringBeforeRadius + "radius=\(String(describing: self.radius!))"
                
                /*if let url = URL(string: "https://api.eatstreet.com/publicapi/v1/restaurant/search?latitude=37.4419&longitude=-122.1430&method=pickup&pickup-radius=10") {
                 print("url success")*/
                
                if let url = URL(string: urlString) {
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "GET" //Or GET if that's what you need
                    request.addValue("a2a548552d490151", forHTTPHeaderField: "X-Access-Token")
                    
                    print(request)
                    
                    let session = URLSession.shared
                    
                    var searchResults: [String: Any?]?
                    
                    let task2 = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                        print("tried running")
                        searchResults = self.convertToDictionary(text: (NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as! String))
                        //print(searchResults); print(); print();
                        
                        if let restaurantResults = searchResults!["restaurants"] as? NSArray {
                            
                            if (restaurantResults.count > 0) {
                                print("successful as array")
                                
                                let index = self.randomInRange(end: restaurantResults.count)
                                
                                DispatchQueue.main.async {
                                    self.updateUI(restaurantData: restaurantResults[index] as! [String : Any?])
                                }
                                
                                print(restaurantResults[index])
                            }
                            else {
                                print("none found in range")
                            }
                        }
                        
                        print(error)
                    }
                    task2.resume()
                    
                }
                
            }
            
            task.resume()
            
        }
            
        else {
            let urlString = begOfSearchString + "latitude=\(String(describing: latitude!))&longitude=\(String(describing: longitude!))" + endOfSearchStringBeforeRadius + "radius=\(String(describing: radius!))"
            
            /*if let url = URL(string: "https://api.eatstreet.com/publicapi/v1/restaurant/search?latitude=37.4419&longitude=-122.1430&method=pickup&pickup-radius=10") {
             print("url success")*/
            
            if let url = URL(string: urlString) {
                
                var request = URLRequest(url: url)
                request.httpMethod = "GET" //Or GET if that's what you need
                request.addValue("a2a548552d490151", forHTTPHeaderField: "X-Access-Token")
                
                print(request)
                
                let session = URLSession.shared
                
                var searchResults: [String: Any?]?
                
                let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                    print("tried running")
                    searchResults = self.convertToDictionary(text: (NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as! String))
                    //print(searchResults); print(); print();
                    
                    if let restaurantResults = searchResults!["restaurants"] as? NSArray {
                        
                        if (restaurantResults.count > 0) {
                            print("successful as array")
                            
                            let index = self.randomInRange(end: restaurantResults.count)
                            
                            print(restaurantResults[index])
                            
                            DispatchQueue.main.async {
                                self.updateUI(restaurantData: restaurantResults[index] as! [String : Any?])
                            }
                            
                        }
                        else {
                            print("none found in range")
                        }
                    }
                    
                    print(error)
                }
                task.resume()
                
            }
            
        }
    }
    
    @IBOutlet weak var tapOnMapLabel: UILabel!

    @IBAction func redoSearch(_ sender: RoundedButton) {
        runProgram()
    }
    
    @IBOutlet weak var restaurantUrl: UIButton!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    
    @IBAction func openRestaurantWebsite(_ sender: UIButton) {
        print(sender.currentTitle)
        UIApplication.shared.open(URL(string: sender.currentTitle!)!, options: [:], completionHandler: nil)

    }
    
    @IBAction func callRestaurant(_ sender: UIButton) {
        print("trying to call phone")
        
        var phoneNumber = sender.currentTitle!
        phoneNumber = phoneNumber.replacingOccurrences(of: "(", with: "", options: NSString.CompareOptions.literal, range: nil)
        phoneNumber = phoneNumber.replacingOccurrences(of: ")", with: "", options: NSString.CompareOptions.literal, range: nil)
        phoneNumber = phoneNumber.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
        phoneNumber = phoneNumber.replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literal, range: nil)
        
        print(phoneNumber)
        
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            print("successfully calling")
            let application: UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
        
    }
    

    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var restaurantPhoneNumber: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var restaurantHours: UILabel!
    @IBOutlet weak var restaurantAddress: UIButton!
    
    private func updateUI(restaurantData: [String: Any?]) {
        spinner?.stopAnimating()
        
        //advise label
        tapOnMapLabel.text = "Tap on address to see map!"
        
        //restaurant name
        restaurantNameLabel.text = restaurantData["name"] as! String
        
        //restaurant hours
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        print(result)
        let day = getDayOfWeek(result)!
        print(day)
        print(daysOfWeek[day-1])
        let textDay = daysOfWeek[day-1]
        let allHours = restaurantData["hours"]!
        if let dayHours = allHours as? [String: Any?] {
            print("have day hours")
            
            if let todayHours = dayHours[textDay] {
                print(todayHours)
                if let printArray = todayHours as? NSArray, let printString = printArray[0] as? String{
                    restaurantHours.text = textDay + ": " + printString
                    print(restaurantHours.text)
                } else {
                    restaurantHours.text = "closed"
                }
            }
            else {
                restaurantHours.text = "closed"
            }
        }
        
        //restaurantUrl
        let urlOfRestaurant = restaurantData["url"] as! String
        restaurantUrl.setTitle(urlOfRestaurant, for: .normal)
        
        //restaurant image
        let textURL = restaurantData["logoUrl"] as! String
        print(textURL)
        let imageURL = URL(string: textURL)
        if imageURL != nil {
            let serialQueue = DispatchQueue(label: "com.queue.Serial")
            serialQueue.async {
                
                do {
                    let contents = try Data(contentsOf: imageURL!)
                    DispatchQueue.main.async {
                        self.restaurantImage.image = UIImage(data: contents)
                        
                    }
                }
                catch {
                    print("unable to print")
                }
                
            }
        }
        
        
        //restaurant address
        let street = restaurantData["streetAddress"] as! String; let city = restaurantData["city"] as! String; let state = restaurantData["state"] as! String
        let address = street + "\n" + city + ", " + state
        
        print(address)
        
        restaurantAddress.titleLabel!.lineBreakMode = .byWordWrapping
        restaurantAddress.titleLabel!.textAlignment = .center
        restaurantAddress.setTitle(address, for: .normal)
        //restaurantAddress.setAttributedTitle(str, for: UIControlState.normal)
        //restaurantAddress.setTitle(address, for: UIControlState.normal)
        
        //restaurant number
        restaurantPhoneNumber.setTitle(restaurantData["phone"] as! String, for: UIControlState.normal)
        
        //restaurant location for map
        toSendLatitude = restaurantData["latitude"]! as? Double
        toSendLongitude = restaurantData["longitude"]! as? Double
        
        //restaurant key for menu
        restaurantAPI = restaurantData["apiKey"]! as? String
        
    }
    
    private var daysOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    private func getDayOfWeek(_ today:String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
    
    private func randomInRange(end: Int) -> Int {
        let B = UInt32(end)
        return Int(arc4random_uniform(B))
    }
    
    private func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        var destinationvc = segue.destination
        if let navigationvc = destinationvc as? UINavigationController {
            destinationvc = navigationvc.visibleViewController ?? destinationvc
        }
        if let mapVC = destinationvc as? MapViewController {
            if let identifier = segue.identifier {
                if identifier == "Show Map" {
                    print("seguing correctly")
                    
                    mapVC.latitude = toSendLatitude
                    mapVC.longitude = toSendLongitude
                    
                    mapVC.navigationItem.title = restaurantAddress.currentTitle!
                    
                }
            }
        }
        
        
    }
    
    
}
