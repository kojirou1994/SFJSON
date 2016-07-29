//
//  SFJSON.swift
//  SFMongo
//
//  Created by Kojirou on 16/7/29.
//
//

import Foundation

public enum SFJSONObjectType :Int{
    case number
    case string
    case array
    case dictionary
    case null
}

public struct SFJSON {
    
    private var object: Any
    
    private var type: SFJSONObjectType = .null
    
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
    
    private init(object: Any) {
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
        print(type)
    }
    
    public static var null: SFJSON {
        return SFJSON(object: NSDictionary())
    }
}

// MARK: - Subscript

extension SFJSON {
    public subscript(index: Int) -> SFJSON {
        if type == .array {
            let array = object as! NSArray
            if index>=0 && index < array.count {
                return SFJSON(object: array[index])
            }
        }
        return SFJSON.null
    }
    
    /// If `type` is `.Dictionary`, return json whose object is `dictionary[key]` , otherwise return null json with error.
    public subscript(key: String) -> SFJSON {
        if type == .dictionary {
            let dictionary = object as! NSDictionary
            if let object = dictionary.object(forKey: key) {
                return SFJSON(object: object)
            }
        }
        return SFJSON.null
    }
}

// MARK: - Print

extension SFJSON: CustomStringConvertible {
    
    public var description: String {
        return rawString() ?? "Null"
    }
    
    public func rawString(_ encoding: String.Encoding = String.Encoding.utf8, options opt: JSONSerialization.WritingOptions = .prettyPrinted) -> String? {
        switch self.type {
        case .array, .dictionary:
            do {
                let data = try JSONSerialization.data(withJSONObject: object, options: opt)
                return String(data: data, encoding: encoding)
            } catch _ {
                return nil
            }
        case .string:
            return self.string
        case .number:
            return self.number?.stringValue
        case .null:
            return "null"
        }
    }
}

// MARK: - Int, Double, Number

extension SFJSON {
    
    public var double: Double? {
        return (self.object as? NSNumber)?.doubleValue
    }
    
    public var doubleValue: Double {
        return (self.object as? NSNumber)?.doubleValue ?? 0.0
    }
    
    public var int: Int? {
        return (self.object as? NSNumber)?.intValue
    }
    
    public var intValue: Int {
        return (self.object as? NSNumber)?.intValue ?? 0
    }
    
    public var number: NSNumber? {
        return self.object as? NSNumber
    }
    
    public var numberValue: NSNumber? {
        return (self.object as? NSNumber) ?? NSNumber()
    }
}

// MARK: - Bool

extension SFJSON {
    
    //Optional bool
    public var bool: Bool? {
        return (self.object as? NSNumber)?.boolValue
    }
    
    //Non-optional bool
    public var boolValue: Bool {
        return (self.object as? NSNumber)?.boolValue ?? true
    }
}

// MARK: - String

extension SFJSON {
    
    //Optional string
    public var string: String? {
        return self.object as? String

    }
    
    //Non-optional string
    public var stringValue: String {
        return self.object as? String ?? self.description
    }
}
