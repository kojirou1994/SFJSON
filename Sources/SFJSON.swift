//
//  SFJSON.swift
//  SFMongo
//
//  Created by Kojirou on 16/7/29.
//
//

import Foundation

public enum SFJSONObjectType :Int {
    case number
    case string
    case array
    case dictionary
    case null
}

public struct SFJSON {
    
    fileprivate var object: Any
    
    fileprivate var type: SFJSONObjectType = .null
    
    public init?(data:Data, options opt: JSONSerialization.ReadingOptions = .allowFragments) {
        do {
            let object = try JSONSerialization.jsonObject(with: data, options: opt)
            self.init(object: object)
        }catch {
            return nil
        }
    }
    
    public init?(jsonString: String) {
        if let data = jsonString.data(using: .utf8) {
            self.init(data: data)
        }else {
            return nil
        }
    }
    
    internal init(object: Any) {
        self.object = object
        if let _ = object as? NSNumber {
            type = .number
        }else if let _ = object as? String {
            type = .string
        }else if let _ = object as? NSNull {
            type = .null
        }
        else if let _ = object as? NSArray {
            type = .array
        }
        else if let _ = object as? NSDictionary {
            type = .dictionary
        }
//        print(type)
    }
    
    public static var null: SFJSON {
        return SFJSON(object: NSDictionary())
    }
}

// MARK: - Subscript

extension SFJSON {
    public subscript(index: Int) -> SFJSON {
        if type == .array {
            let array = self.object as! NSArray
            if index>=0 && index < array.count {
                return SFJSON(object: array[index])
            }
        }
        return SFJSON.null
    }
    
    /// If `type` is `.Dictionary`, return json whose object is `dictionary[key]` , otherwise return null json with error.
    public subscript(key: String) -> SFJSON {
        if type == .dictionary {
            let dictionary = self.object as! NSDictionary
            #if os(OSX)
            if let object = dictionary.object(forKey: key) {
                return SFJSON(object: object)
            }
            #else
            if let object = dictionary.objectForKey(key as NSString) {
                return SFJSON(object: object)
            }
            #endif
        }
        return SFJSON.null
    }
}

// MARK: - Print

extension SFJSON: CustomStringConvertible {
    
    public var description: String {
        return rawString ?? ""
    }
    
    public var rawString: String? {
        switch self.type {
        case .array, .dictionary:
            do {
                #if os(OSX)
                let data = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
                #else
                let data = try JSONSerialization.data(withJSONObject: object as! AnyObject, options: .prettyPrinted)
                #endif
                return String(data: data, encoding: .utf8)
            } catch _ {
                return nil
            }
        case .string:
            return self.string
        case .number:
            return self.number?.stringValue
        case .null:
            return nil
        }
    }
}

// MARK: - Int, Double, Number

extension SFJSON {
    
    public var double: Double? {
        return (object as? NSNumber)?.doubleValue
    }
    
    public var doubleValue: Double {
        return (object as? NSNumber)?.doubleValue ?? 0.0
    }
    
    public var int: Int? {
        return (object as? NSNumber)?.intValue
    }
    
    public var intValue: Int {
        return (object as? NSNumber)?.intValue ?? 0
    }
    
    public var number: NSNumber? {
        return object as? NSNumber
    }
    
    public var numberValue: NSNumber? {
        return (object as? NSNumber) ?? NSNumber(value: 0)
    }
}

// MARK: - Bool

extension SFJSON {
    
    //Optional bool
    public var bool: Bool? {
        return (object as? NSNumber)?.boolValue
    }
    
    //Non-optional bool
    public var boolValue: Bool {
        return (object as? NSNumber)?.boolValue ?? true
    }
}

// MARK: - String

extension SFJSON {
    
    //Optional string
    public var string: String? {
        return object as? String
    }
    
    //Non-optional string
    public var stringValue: String {
        return string ?? description
    }
}

// MARK: - Array

extension SFJSON {
    
    //Optional [SFJSON]
    public var array: [SFJSON]? {
        if type == .array {
            return (object as! NSArray).map{SFJSON(object: $0)}
        } else {
            return nil
        }
    }
    
    //Optional [Any]
    public var arrayObject: [Any]? {
        return object as? [Any]
    }
}

// MARK: - Dictionary

extension SFJSON {
    
    //Optional NSDictionary
    public var dictionary: NSDictionary? {
        return object as? NSDictionary
    }
    
    //Optional [String : Any]
    public var dictionaryObject: [String : Any]? {
        return object as? [String: Any]
    }
}
