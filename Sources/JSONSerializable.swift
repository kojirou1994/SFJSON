//
//  JSONStringConvertible.swift
//  SFJSON
//
//  Created by 王宇 on 2016/10/11.
//
//

import Foundation

public protocol JSONSerializable {
	var jsonString: String {get}
}

extension Dictionary: JSONSerializable {
	public var jsonString: String {
		var parts: [String] = []
		for (key, value) in self {
			if value is JSONSerializable {
				parts.append("\"\(key)\": \((value as! JSONSerializable).jsonString)")
			}
		}
		return "{" + parts.joined(separator: ",") + "}"
	}
}

extension Array: JSONSerializable {
	public var jsonString: String {
		return "[" + self.map{
			if $0 is JSONSerializable {
				return ($0 as! JSONSerializable).jsonString
			}else {
				return String(describing: $0)
			}}.joined(separator: ",") + "]"
	}
}

extension String: JSONSerializable {
	public var jsonString: String {
		return "\"\(self)\""
	}
}

extension Int: JSONSerializable {
	public var jsonString: String {
		return String(self)
	}
}

extension Double: JSONSerializable {
	public var jsonString: String {
		return String(self)
	}
}

extension Bool: JSONSerializable {
	public var jsonString: String {
		return self ? "true" : "false"
	}
}

extension Date: JSONSerializable {
	public var jsonString: String {
		return "\"\(self.description)\""
	}
}
