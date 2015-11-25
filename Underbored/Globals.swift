//
//  Globals.swift
//  Underbored
//
//  Created by Peter Guan Li on 9/18/15.
//  Copyright © 2015 Underbored. All rights reserved.
//
import UIKit
import Foundation

struct Globals {
    
    static var DefaultEnvironment : UnderboredEnvironment = UnderboredEnvironment.UnderboredEnvironmentDevelopment
    
    enum UnderboredEnvironment{
        case UnderboredEnvironmentDevelopment
    }
    
    static let baseURL = "http://www.underbored.com/"
    static let amazonURL = "https://s3-us-west-1.amazonaws.com/underbored/"
    static let CustomLoaderTag = 39934598
    static let BackgroundImageTag = 32909234
    
    static func baseURLForEnvironment(environment: UnderboredEnvironment) -> String
    {
        switch environment
        {
        case .UnderboredEnvironmentDevelopment:
            return "https://mighty-spire-6255.herokuapp.com/"
        }
    }
    
    static func versionString() -> String {
        let device: UIDevice = UIDevice.currentDevice()
        let deviceName: String = device.model
        let OSName: String = device.systemName
        let OSVersion: String = device.systemVersion
        let locale: String = NSLocale.currentLocale().localeIdentifier
        let deviceString: String = "\(deviceName); \(OSName) \(OSVersion); \(locale)"
        let infoDictionary: [NSObject : AnyObject]? = NSBundle.mainBundle().infoDictionary
        
        var name : String?
        if let displayName: AnyObject = infoDictionary?["CFBundleName"]{
            name = displayName as? String
        }
        
        var version: String?
        if let versionString: AnyObject = infoDictionary?["CFBundleShortVersionString"] {
            version = versionString as? String
        }
        
        return "\(deviceString) (\(name) \(version))"
    }
    
    static func changeDefaultEnvironment(environment: UnderboredEnvironment) {
        DefaultEnvironment = environment
    }
    
}