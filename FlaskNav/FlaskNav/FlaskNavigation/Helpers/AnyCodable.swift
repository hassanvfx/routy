import Foundation

/**
 A type-erased `Codable` value.
 
 The `AnyCodable` type forwards encoding and decoding responsibilities
 to an underlying value, hiding its specific underlying type.
 
 You can encode or decode mixed-type values in dictionaries
 and other collections that require `Encodable` or `Decodable` conformance
 by declaring their contained type to be `AnyCodable`.
 
 - SeeAlso: `AnyEncodable`
 - SeeAlso: `AnyDecodable`
 */
public struct AnyCodable: Codable {
    public let value: Any
    
    public init<T>(_ value: T?) {
        self.value = value ?? ()
    }
}

extension AnyCodable: _AnyEncodable, _AnyDecodable {}

extension AnyCodable: Equatable {
    public static func ==(lhs: AnyCodable, rhs: AnyCodable) -> Bool {
        switch (lhs.value, rhs.value) {
        case is (Void, Void):
            return true
        case let (lhs as Bool, rhs as Bool):
            return lhs == rhs
        case let (lhs as Int, rhs as Int):
            return lhs == rhs
        case let (lhs as Int8, rhs as Int8):
            return lhs == rhs
        case let (lhs as Int16, rhs as Int16):
            return lhs == rhs
        case let (lhs as Int32, rhs as Int32):
            return lhs == rhs
        case let (lhs as Int64, rhs as Int64):
            return lhs == rhs
        case let (lhs as UInt, rhs as UInt):
            return lhs == rhs
        case let (lhs as UInt8, rhs as UInt8):
            return lhs == rhs
        case let (lhs as UInt16, rhs as UInt16):
            return lhs == rhs
        case let (lhs as UInt32, rhs as UInt32):
            return lhs == rhs
        case let (lhs as UInt64, rhs as UInt64):
            return lhs == rhs
        case let (lhs as Float, rhs as Float):
            return lhs == rhs
        case let (lhs as Double, rhs as Double):
            return lhs == rhs
        case let (lhs as String, rhs as String):
            return lhs == rhs
        case (let lhs as [String: AnyCodable], let rhs as [String: AnyCodable]):
            return lhs == rhs
        case (let lhs as [AnyCodable], let rhs as [AnyCodable]):
            return lhs == rhs
        default:
            return false
        }
    }
}

extension AnyCodable: CustomStringConvertible {
    public var description: String {
        switch value {
        case is Void:
            return String(describing: nil as Any?)
        case let value as CustomStringConvertible:
            return value.description
        default:
            return String(describing: value)
        }
    }
}

extension AnyCodable: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch value {
        case let value as CustomDebugStringConvertible:
            return "AnyCodable(\(value.debugDescription))"
        default:
            return "AnyCodable(\(self.description))"
        }
    }
}

extension AnyCodable: ExpressibleByNilLiteral, ExpressibleByBooleanLiteral, ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral, ExpressibleByStringLiteral, ExpressibleByArrayLiteral, ExpressibleByDictionaryLiteral {}


import Foundation

/**
 A type-erased `Decodable` value.
 
 The `AnyDecodable` type forwards decoding responsibilities
 to an underlying value, hiding its specific underlying type.
 
 You can decode mixed-type values in dictionaries
 and other collections that require `Decodable` conformance
 by declaring their contained type to be `AnyDecodable`:
 
 let json = """
 {
 "boolean": true,
 "integer": 1,
 "double": 3.14159265358979323846,
 "string": "string",
 "array": [1, 2, 3],
 "nested": {
 "a": "alpha",
 "b": "bravo",
 "c": "charlie"
 }
 }
 """.data(using: .utf8)!
 
 let decoder = JSONDecoder()
 let dictionary = try! decoder.decode([String: AnyCodable].self, from: json)
 */
public struct AnyDecodable: Decodable {
    public let value: Any
    
    public init<T>(_ value: T?) {
        self.value = value ?? ()
    }
}

protocol _AnyDecodable {
    var value: Any { get }
    init<T>(_ value: T?)
}

extension AnyDecodable: _AnyDecodable {}

extension _AnyDecodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if container.decodeNil() {
            self.init(())
        } else if let bool = try? container.decode(Bool.self) {
            self.init(bool)
        } else if let int = try? container.decode(Int.self) {
            self.init(int)
        } else if let uint = try? container.decode(UInt.self) {
            self.init(uint)
        } else if let double = try? container.decode(Double.self) {
            self.init(double)
        } else if let string = try? container.decode(String.self) {
            self.init(string)
        } else if let array = try? container.decode([AnyCodable].self) {
            self.init(array.map { $0.value })
        } else if let dictionary = try? container.decode([String: AnyCodable].self) {
            self.init(dictionary.mapValues { $0.value })
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "AnyCodable value cannot be decoded")
        }
    }
}

extension AnyDecodable: Equatable {
    public static func ==(lhs: AnyDecodable, rhs: AnyDecodable) -> Bool {
        switch (lhs.value, rhs.value) {
        case is (Void, Void):
            return true
        case let (lhs as Bool, rhs as Bool):
            return lhs == rhs
        case let (lhs as Int, rhs as Int):
            return lhs == rhs
        case let (lhs as Int8, rhs as Int8):
            return lhs == rhs
        case let (lhs as Int16, rhs as Int16):
            return lhs == rhs
        case let (lhs as Int32, rhs as Int32):
            return lhs == rhs
        case let (lhs as Int64, rhs as Int64):
            return lhs == rhs
        case let (lhs as UInt, rhs as UInt):
            return lhs == rhs
        case let (lhs as UInt8, rhs as UInt8):
            return lhs == rhs
        case let (lhs as UInt16, rhs as UInt16):
            return lhs == rhs
        case let (lhs as UInt32, rhs as UInt32):
            return lhs == rhs
        case let (lhs as UInt64, rhs as UInt64):
            return lhs == rhs
        case let (lhs as Float, rhs as Float):
            return lhs == rhs
        case let (lhs as Double, rhs as Double):
            return lhs == rhs
        case let (lhs as String, rhs as String):
            return lhs == rhs
        case (let lhs as [String: AnyDecodable], let rhs as [String: AnyDecodable]):
            return lhs == rhs
        case (let lhs as [AnyDecodable], let rhs as [AnyDecodable]):
            return lhs == rhs
        default:
            return false
        }
    }
}

extension AnyDecodable: CustomStringConvertible {
    public var description: String {
        switch value {
        case is Void:
            return String(describing: nil as Any?)
        case let value as CustomStringConvertible:
            return value.description
        default:
            return String(describing: value)
        }
    }
}

extension AnyDecodable: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch value {
        case let value as CustomDebugStringConvertible:
            return "AnyDecodable(\(value.debugDescription))"
        default:
            return "AnyDecodable(\(self.description))"
        }
    }
}
import Foundation

/**
 A type-erased `Encodable` value.
 
 The `AnyEncodable` type forwards encoding responsibilities
 to an underlying value, hiding its specific underlying type.
 
 You can encode mixed-type values in dictionaries
 and other collections that require `Encodable` conformance
 by declaring their contained type to be `AnyEncodable`:
 
 let dictionary: [String: AnyEncodable] = [
 "boolean": true,
 "integer": 1,
 "double": 3.14159265358979323846,
 "string": "string",
 "array": [1, 2, 3],
 "nested": [
 "a": "alpha",
 "b": "bravo",
 "c": "charlie"
 ]
 ]
 
 let encoder = JSONEncoder()
 let json = try! encoder.encode(dictionary)
 */
public struct AnyEncodable: Encodable {
    public let value: Any
    
    public init<T>(_ value: T?) {
        self.value = value ?? ()
    }
}

protocol _AnyEncodable {
    var value: Any { get }
    init<T>(_ value: T?)
}


extension AnyEncodable: _AnyEncodable {}

// MARK: - Encodable

extension _AnyEncodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self.value {
        case is Void:
            try container.encodeNil()
        case let bool as Bool:
            try container.encode(bool)
        case let int as Int:
            try container.encode(int)
        case let int8 as Int8:
            try container.encode(int8)
        case let int16 as Int16:
            try container.encode(int16)
        case let int32 as Int32:
            try container.encode(int32)
        case let int64 as Int64:
            try container.encode(int64)
        case let uint as UInt:
            try container.encode(uint)
        case let uint8 as UInt8:
            try container.encode(uint8)
        case let uint16 as UInt16:
            try container.encode(uint16)
        case let uint32 as UInt32:
            try container.encode(uint32)
        case let uint64 as UInt64:
            try container.encode(uint64)
        case let float as Float:
            try container.encode(float)
        case let double as Double:
            try container.encode(double)
        case let string as String:
            try container.encode(string)
        case let date as Date:
            try container.encode(date)
        case let url as URL:
            try container.encode(url)
        case let array as [Any?]:
            try container.encode(array.map { AnyCodable($0) })
        case let dictionary as [String: Any?]:
            try container.encode(dictionary.mapValues { AnyCodable($0) })
        default:
            let context = EncodingError.Context(codingPath: container.codingPath, debugDescription: "AnyCodable value cannot be encoded")
            throw EncodingError.invalidValue(self.value, context)
        }
    }
}

extension AnyEncodable: Equatable {
    public static func ==(lhs: AnyEncodable, rhs: AnyEncodable) -> Bool {
        switch (lhs.value, rhs.value) {
        case is (Void, Void):
            return true
        case let (lhs as Bool, rhs as Bool):
            return lhs == rhs
        case let (lhs as Int, rhs as Int):
            return lhs == rhs
        case let (lhs as Int8, rhs as Int8):
            return lhs == rhs
        case let (lhs as Int16, rhs as Int16):
            return lhs == rhs
        case let (lhs as Int32, rhs as Int32):
            return lhs == rhs
        case let (lhs as Int64, rhs as Int64):
            return lhs == rhs
        case let (lhs as UInt, rhs as UInt):
            return lhs == rhs
        case let (lhs as UInt8, rhs as UInt8):
            return lhs == rhs
        case let (lhs as UInt16, rhs as UInt16):
            return lhs == rhs
        case let (lhs as UInt32, rhs as UInt32):
            return lhs == rhs
        case let (lhs as UInt64, rhs as UInt64):
            return lhs == rhs
        case let (lhs as Float, rhs as Float):
            return lhs == rhs
        case let (lhs as Double, rhs as Double):
            return lhs == rhs
        case let (lhs as String, rhs as String):
            return lhs == rhs
        case (let lhs as [String: AnyEncodable], let rhs as [String: AnyEncodable]):
            return lhs == rhs
        case (let lhs as [AnyEncodable], let rhs as [AnyEncodable]):
            return lhs == rhs
        default:
            return false
        }
    }
}

extension AnyEncodable: CustomStringConvertible {
    public var description: String {
        switch value {
        case is Void:
            return String(describing: nil as Any?)
        case let value as CustomStringConvertible:
            return value.description
        default:
            return String(describing: value)
        }
    }
}

extension AnyEncodable: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch value {
        case let value as CustomDebugStringConvertible:
            return "AnyEncodable(\(value.debugDescription))"
        default:
            return "AnyEncodable(\(self.description))"
        }
    }
}

extension AnyEncodable: ExpressibleByNilLiteral, ExpressibleByBooleanLiteral, ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral, ExpressibleByStringLiteral, ExpressibleByArrayLiteral, ExpressibleByDictionaryLiteral {}

extension _AnyEncodable {
    public init(nilLiteral: ()) {
        self.init(nil as Any?)
    }
    
    public init(booleanLiteral value: Bool) {
        self.init(value)
    }
    
    public init(integerLiteral value: Int) {
        self.init(value)
    }
    
    public init(floatLiteral value: Double) {
        self.init(value)
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(value)
    }
    
    public init(stringLiteral value: String) {
        self.init(value)
    }
    
    public init(arrayLiteral elements: Any...) {
        self.init(elements)
    }
    
    public init(dictionaryLiteral elements: (AnyHashable, Any)...) {
        self.init(Dictionary<AnyHashable, Any>(elements, uniquingKeysWith: { (first, _) in first }))
    }
}
