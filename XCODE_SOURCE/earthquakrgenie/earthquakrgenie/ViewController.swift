//
//  ViewController.swift
//  earthquakrgenie
//
//  Created by Ryan Schachte on 11/16/15.
//  Copyright (c) 2015 uberchanger. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController {

    @IBOutlet weak var text_AddressLocation: UITextField!
    @IBOutlet weak var text_Obtained: UILabel!
    var receivedAddress: String = ""
    var northString: String = ""
    var eastString: String = ""
    var southString: String = ""
    var westString: String = ""
    
    var jsonInformation : String! = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func obtainCoordCall(sender: AnyObject) {
        
        self.getCoords(self.text_AddressLocation.text)
    }

    func getCoords(sender: AnyObject) {
        
        let geoCoder = CLGeocoder()

        var locationTest = (sender as! NSString)
        
        geoCoder.geocodeAddressString (locationTest as String, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            if let placemark = placemarks?[0] as? CLPlacemark {
                
                println("long is \(placemark.location!.coordinate.longitude)")
                println("lat is \(placemark.location!.coordinate.latitude)")
                
                self.northString = String(stringInterpolationSegment: placemark.location!.coordinate.latitude + 10)
                
                self.eastString = String(stringInterpolationSegment: placemark.location!.coordinate.longitude + 10)
                
                self.southString = String(stringInterpolationSegment: placemark.location!.coordinate.latitude - 10)
                
                self.westString = String(stringInterpolationSegment: placemark.location!.coordinate.longitude - 10)
            }
        })
        
    }
    
    @IBAction func CoordinateFinder(sender: UIButton) {
    
    }
    
    
    @IBAction func beginJson(sender: AnyObject) {
        
        get_data_from_url("http://api.geonames.org/earthquakesJSON?north=\(northString)&south=\(southString)&east=\(eastString)&west=\(westString)&username=rschachte")
        
        
    }
    
    
    func get_data_from_url(url:String)
    {
        
        println(url)
        let url = NSURL(string: url)!
        let urlSession = NSURLSession.sharedSession()
        
        
        let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            if (error != nil) {
                println(error.localizedDescription)
            }
            var err: NSError?
            
            
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary
            
            let json = NSString(data: data, encoding: NSASCIIStringEncoding)
            self.extract_json(json!)
            
            if (err != nil) {
                println("JSON Error \(err!.localizedDescription)")
            }
        })
        jsonQuery.resume()
        
    }
    
    
    func extract_json(data:NSString)
    {
        var parseError: NSError?
        let jsonData:NSData = data.dataUsingEncoding(NSASCIIStringEncoding)!
        let jsonInformation: AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &parseError)
        if (parseError == nil)
        {
            if let earthquake_data = jsonInformation as? NSDictionary {
            
                
                if let earthquake_sub = earthquake_data["earthquakes"] as? NSArray {
                    
                    
                    for (var i = 0; i < earthquake_sub.count; i++) {
                        
                        if let date = earthquake_sub[i]["datetime"] as! String! {
                        
                            self.jsonInformation! += "Date: \(date)\n"
                            
                            if let EQID = earthquake_sub[i]["eqid"] as! String! {
                                
                                self.jsonInformation! += "Earthquake ID: \(EQID)\n"
                            
                                if let mag = earthquake_sub[i]["magnitude"] {
                             
                                    self.jsonInformation! += "Magnitude: \(mag!)\n"
                                    
                                    if let latit = earthquake_sub[i]["lat"] {
                                        
                                        self.jsonInformation! += "Latitude: \(latit!)\n"
                                        
                                        if let longi = earthquake_sub[i]["lng"] {
                                            
                                            self.jsonInformation! += "Longitude: \(longi!)\n"
                                            
                                            
                                            if let depth = earthquake_sub[i]["depth"] {
                                                
                                                self.jsonInformation! += "Depth: \(depth!)\n------------------------------\n"
                                            }
                                        }
                                    }
                                }
                            }
                        
                        }
                        
                        
                    }
                    

                    
                }
            }
        }
    }
    
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var secondView: SecondViewController = segue.destinationViewController as! SecondViewController

        secondView.receivedJsonInformation = self.jsonInformation
        secondView.receivedAddress = text_AddressLocation.text
        secondView.northString = self.northString
        secondView.eastString = self.eastString
        secondView.southString = self.southString
        secondView.westString = self.westString
    }
}
