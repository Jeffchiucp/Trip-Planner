//
//  Trip.swift
//  Trip-Planner
//
//  Created by Elmer Astudillo on 10/16/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

import Foundation

struct Trip
{
    let destination : String?
    let completed : Bool?
    let email : String?
    let startDate : String?
    let endDate : String?
    let waypointDestination : String?
    let latitude : Double?
    let longitude : Double?
}

extension Trip : Decodable
{
    enum TripKeys: String, CodingKey
    {
        case destination
        case completed
        case username
        case startDate = "start_date"
        case endDate = "end_date"
        case waypoint
    }
    
    enum Waypoint: String, CodingKey
    {
        case waypointDestination = "waypoint_destination"
        case latitude = "lat"
        case longitude = "long"
    }
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: TripKeys.self)
        let destination = try container.decodeIfPresent(String.self, forKey: .destination) ?? "Destination"
        let completed = try container.decodeIfPresent(Bool.self, forKey: .completed) ?? false
        let email = try container.decodeIfPresent(String.self, forKey: .username) ?? "No email"
        let startDate = try container.decodeIfPresent(String.self, forKey: .startDate) ?? "empty"
        let endDate = try container.decodeIfPresent(String.self, forKey: .endDate) ?? "empty"
        let waypointContainer = try container.nestedContainer(keyedBy: Waypoint.self,  forKey: .waypoint)
        let waypointDestination = try waypointContainer.decodeIfPresent(String.self, forKey: .waypointDestination) ?? "No waypoint destination"
        let latitude = try waypointContainer.decodeIfPresent(Double.self, forKey: .latitude) ??  0
        let longitude = try waypointContainer.decodeIfPresent(Double.self, forKey: .longitude) ?? 0
        self.init(destination: destination, completed: completed, email: email, startDate: startDate, endDate: endDate, waypointDestination: waypointDestination, latitude: latitude, longitude: longitude)
    }
    
//    init(to encoder: Encoder) throws
//    {
//        var container = try encoder.container(keyedBy: TripKeys.self)
//        let destination = try container.encodeIfPresent(String.self, forKey: .destination) ?? "Destination"
//        let completed = try container.encodeIfPresent(Bool.self, forKey: .completed) ?? false
//        let email = try container.encodeIfPresent(String.self, forKey: .email) ?? "No email"
//        let startDate = try container.encodeIfPresent(String.self, forKey: .startDate) ?? "empty"
//        let endDate = try container.encodeIfPresent(String.self, forKey: .endDate) ?? "empty"
//        let waypointContainer = try container.nestedContainer(keyedBy: Waypoint.self,  forKey: .waypoint)
//        let waypointDestination = try waypointContainer.decodeIfPresent(String.self, forKey: .waypointDestination) ?? "No waypoint destination"
//        let latitude = try waypointContainer.decodeIfPresent(Double.self, forKey: .latitude) ??  0
//        let longitude = try waypointContainer.decodeIfPresent(Double.self, forKey: .longitude) ?? 0
//        self.init(destination: destination, completed: completed, email: email, startDate: startDate, endDate: endDate, waypointDestination: waypointDestination, latitude: latitude, longitude: longitude)
//    }
    
}

//struct TripList : Decodable
//{
//    let trips : [Trip]
//}

