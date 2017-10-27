//
//  NetworkService.swift
//  Trip-Planner
//
//  Created by Elmer Astudillo on 10/17/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

import Foundation
import KeychainSwift

// Basic authorization to have access to the database
struct BasicAuth
{
    // Function to generate basic auth header.
    static func generateBasicAuthHeader(username: String, password: String) -> String
    {
        // Creating a formatted string username:password
        let loginString = String(format: "%@:%@", username, password)
        // Encoding the loggin string into a UTF8 format
        let longinData: Data = loginString.data(using: String.Encoding.utf8)!
        // Encoding the UTF8 Format into a base64 String
        let base64LoginString = longinData.base64EncodedString(options: .init(rawValue: 0))
        // Setting the base64 string as a auth header by using Basic auth
        let authHeaderString = "Basic \(base64LoginString)"
        return authHeaderString
    }
}

enum Route
{
    case users()
    case trips()
    
    // Path to use for route
    func path() -> String
    {
        switch self {
        case .users():
            return "/users"
        case .trips():
            return "/trips"
            
        }
    }
    
    // URL Parameters to pass if any
    func urlParameters() -> [String: String]
    {
        switch self {
        case .trips():
            return ["":""]
        case .users():
            return ["":""]
        }
    }
    
    // JSON body to post
    func postBody(user: User? = nil, trip: Trip? = nil) -> Data?
    {
        switch self
        {
        case .trips():
            var jsonBody = Data()
            do {
                // Encoding the trip object into a JSON Object
                jsonBody = try JSONEncoder().encode(trip)
            } catch {}
            return jsonBody
        case .users():
            var jsonBody = Data()
            do {
                // Encoding the user object into a JSON Object
                jsonBody = try JSONEncoder().encode(user)
            } catch {}
            return jsonBody
        }
    }
}

// HTTP Methods
enum HTTPMethods: String
{
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}



class NetworkService
{
    
    
    // Networking function
    static func fetch(route: Route, user: User? = nil, trip: Trip? = nil, httpMethod: HTTPMethods, completionHandler: @escaping (Data, Int) -> Void)
    {
        let keychain = KeychainSwift()
        let credential = keychain.get("credential")
        // Setting the url string and appending the path
        let baseURL = "http://127.0.0.1:5000"
        //let baseURL = "https://desolate-meadow-39483.herokuapp.com"
        let fullURLString = URL(string: baseURL.appending(route.path()))
        // Appending the parameters
        let requestURLString = fullURLString?.appendingQueryParameters(route.urlParameters())
        var request = URLRequest(url: requestURLString!)
        // Adding the headers to the URLRequest
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue((credential)!, forHTTPHeaderField: "Authorization")
        // If not nil then use postbody
        if user != nil && httpMethod.rawValue == "POST" {
            request.httpBody = route.postBody(user: user)
        }
        if trip != nil && httpMethod.rawValue == "POST" {
            request.httpBody = route.postBody(trip: trip)
        }
        // Setting the http method
        request.httpMethod = httpMethod.rawValue
        
        //Creating the URL Session
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, erroe) in
            guard let resp = response else {return}
            // Downcast to get the HTTP status code
            let statusCode: Int = (resp as! HTTPURLResponse).statusCode
            if let data = data {
                completionHandler(data, statusCode)
            }
        }.resume()
        
    }
}

//This is essentially what we call the sanitizing code to be able to implement the parametersrr
extension URL {
    func appendingQueryParameters(_ parametersDictionary : Dictionary<String, String>) -> URL {
        let URLString : String = String(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
        return URL(string: URLString)!
    }
    // This is formatting the query parameters with an ascii table reference therefore we can be returned a json file
}

protocol URLQueryParameterStringConvertible {
    var queryParameters: String {get}
}


extension Dictionary : URLQueryParameterStringConvertible {
    /**
     This computed property returns a query parameters string from the given NSDictionary. For
     example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
     string will be @"day=Tuesday&month=January".
     @return The computed parameters string.
     */
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                              String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                              String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }
    
}
