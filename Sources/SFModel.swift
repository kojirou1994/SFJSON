//
//  SFModel.swift
//  SFJSON
//
//  Created by 王宇 on 2016/10/11.
//
//

import Foundation

public protocol JSONLiteralConvertible {
	init(json: SFJSON) throws
}

public protocol SFModel: JSONLiteralConvertible, JSONSerializable { }

extension SFModel {

	public var jsonString: String {
		let m = Mirror(reflecting: self)
		var jsonDic = Dictionary<String, Any>()
		for (label, value) in m.children {
			if label == nil {
				break
			}
			if let v = cast(value: value, type: Optional<JSONSerializable>.self) {
				jsonDic[label!] = v
			}
		}
		return jsonDic.jsonString
	}
}

fileprivate func cast<A>(value: Any, type: A.Type) -> A? {
	return value as? A
}
