//
//  Controller.swift
//  server-side-api
//
//  Created by mohit kotie on 14/04/18.
//
//

import Foundation
import Kitura
import SwiftyJSON
import LoggerAPI
import CloudFoundryEnv
#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

public class Controller {
    
    let router: Router
    let appEnv: AppEnv
    
    var url: String {
        get { return appEnv.url }
    }
    
    var port: Int {
        get { return appEnv.port }
    }
    
    let vehicleArray: [Dictionary<String, Any>] = [
        ["make":"Nissan", "model":"Murano", "year": 2017],
        ["make":"Nissan", "model":"Rogue", "year":2016],
        ["make":"Dodge", "model":"Ram", "year":2012]
    ]
    
    init() throws {
        appEnv = try CloudFoundryEnv.getAppEnv()
        
        router = Router()
        
        router.get("/", handler: getMain)
        router.get("/vehicles", handler: getAllVehicles)
        router.get("/vehicles/random", handler: getRandomVehicle)
    }
    
    public func getMain(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        Log.debug("GET - / router handler...")
        var json = JSON([:])
        json["make"].stringValue = "company name"
        json["model"].stringValue = "car model"
        json["year"].stringValue = "car parchased year"
        
        try response.status(.OK).send(json: json).end()
    }
    
    public func getAllVehicles(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        let json = JSON(vehicleArray)
        try response.status(.OK).send(json: json).end()
    }
    
    public func getRandomVehicle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        #if os(Linux)
            srandom(UInt32(NSDate().timeIntervalSince1970))
            let index = random() % vehicleArray.count
        #else
            let index = Int(arc4random_uniform(UInt32(vehicleArray.count)))
        #endif
        
        let json = JSON(vehicleArray[index])
        try response.status(.OK).send(json: json).end()
    }
}
