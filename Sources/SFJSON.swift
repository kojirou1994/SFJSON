//
//  SFJSON.swift
//  SFMongo
//
//  Created by Kojirou on 16/7/29.
//
//

import Foundation

public enum SFJSONObjectType :Int {
    ///NSNumber
    case number
    ///String
    case string
    ///Array<Any>
    case array
    ///Dictionary<String, Any>
    case dictionary
    ///NSNull
    case null
    ///Bool
    case bool
}

public enum SFJSONError: Error {
	case invalidData
}

public struct SFJSON {
    
    fileprivate var object: Any
    
    fileprivate var type: SFJSONObjectType = .null

    public init(data: Data, options opt: JSONSerialization.ReadingOptions = .allowFragments) throws {
		let object = try JSONSerialization.jsonObject(with: data, options: opt)
		self.init(object: object)
    }

    public init(jsonString: String) throws {
        if let data = jsonString.data(using: .utf8) {
            try self.init(data: data)
        }else {
            throw SFJSONError.invalidData
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
        else if let _ = object as? [Any] {
            type = .array
        }
        else if let _ = object as? [String: Any] {
            type = .dictionary
        }
//        print(type)
    }
    
    public static var null: SFJSON {
        return SFJSON(object: NSNull())
    }
}

// MARK: - Subscript

extension SFJSON {
    public subscript(index: Int) -> SFJSON {
        if type == .array {
            let array = self.array!
            if index>=0 && index < array.count {
                return SFJSON(object: array[index])
            }
        }
        return SFJSON.null
    }
    
    /// If `type` is `.Dictionary`, return json whose object is `dictionary[key]` , otherwise return null json with error.
    public subscript(key: String) -> SFJSON {
        if type == .dictionary {
            let dictionary = self.dictionary!
            if let object = dictionary[key] {
                return SFJSON(object: object)
            }
        }
        return SFJSON.null
    }
}


// MARK: - Print

extension SFJSON: CustomStringConvertible {
    
    public var description: String {
        return self.stringValue
    }
    /***
    public var rawString: String? {
        switch self.type {
        case .array:
            do {
                let data = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
                return String(data: data, encoding: .utf8)
            } catch _ {
                return nil
            }
        case .dictionary:
            do {
                let data = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
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
    */
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
    
    public var numberValue: NSNumber {
        return (object as? NSNumber) ?? NSNumber(value: 0)
    }
}

// MARK: - Bool

extension SFJSON {
	
    //Optional bool
    public var bool: Bool? {
        return number?.boolValue
    }
    
    //Non-optional bool
    public var boolValue: Bool {
        return bool ?? true
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
        return string ?? ""
    }
}

// MARK: - Array

extension SFJSON {

    //Optional [Any]
    public var array: [Any]? {
        return object as? [Any]
    }
    //Optional [SFJSON]
    public var arrayObject: [SFJSON]? {
        if type == .array {
            return (object as! NSArray).map{SFJSON(object: $0)}
        } else {
            return nil
        }
    }
	
}

// MARK: - Dictionary

extension SFJSON {
    
    //Optional NSDictionary
    public var dictionaryObject: NSDictionary? {
        return object as? NSDictionary
    }

    //Optional [String : Any]
    public var dictionary: [String : Any]? {
        return object as? [String: Any]
    }
	
}

// MARK: - Date

extension SFJSON {
	
	//Optional Date
	public var date: Date? {
		if let timeInterval = self["$date"].int {
			return Date(timeIntervalSince1970: Double(timeInterval) / 1000)
		}else {
			return nil
		}
	}
}
