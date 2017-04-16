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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restaurantNameLabel.text = ""
        searchForRestaurant()
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
    
    private var restaurantAPI: String?
    
    private var begOfSearchString = "https://api.eatstreet.com/publicapi/v1/restaurant/search?"
    private var endOfSearchStringBeforeRadius = "&method=pickup&pickup-"
    
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
    @IBOutlet weak var restaurantNameLabel: UILabel!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private func updateUI(restaurantData: [String: Any?]) {
        print(restaurantData["name"])
        spinner?.stopAnimating()
        //restaurant name
        restaurantNameLabel.text = restaurantData["name"] as! String
        
        //restaurant hours
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD"
        let result = formatter.string(from: date)
        print(result)
        
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
