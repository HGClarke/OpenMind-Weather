//
//  NetworkProcessor.swift
//  OpenMindWeather
//
//  Created by Holland Clarke on 3/4/19.
//  Copyright © 2019 Holland Clarke. All rights reserved.
//

import Foundation

class NetworkProcessor {
    
    let url: URL
    
    lazy var configuration: URLSessionConfiguration = URLSessionConfiguration.default
    lazy var session: URLSession = URLSession(configuration: self.configuration)
    
    init(url: URL) {
        self.url = url
    }
    
    typealias JSONHandler = (([String : Any]?) -> Void)
    
    func downloadJSONFromURL(_ completion: @escaping JSONHandler) {
        
        let request = URLRequest(url: self.url)
        
        let dataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            // Ensure that there was no error in the call
            guard error == nil else {
                print("Error: \(String(describing: error?.localizedDescription))")
                return
            }
            // If case is 200 then we have successfully made a call to the api
            // Otherwise we must handle the cases
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                   // success
                    if let data = data {
                        do {
                            // Try to serialize the json object
                            let dictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                            completion(dictionary as? [String: Any])
                        } catch let err as NSError {
                            print(err.localizedDescription)
                        }
                    }
                    
                    break
                default:
                    print("HTTP Response Code: \(httpResponse.statusCode)")
                }
            }
            
        }
        dataTask.resume()
    }
    
}
