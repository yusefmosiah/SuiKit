//
//  File.swift
//
//
//  Created by Marcus Arnett on 5/11/23.
//

import Foundation
import AnyCodable
import SwiftyJSON

public enum TransactionArgument: KeyProtocol, Codable {
    case input(TransactionBlockInput)
    case gasCoin
    case result(Result)
    case nestedResult(NestedResult)
    
    // TODO: Implement fromJsonObject function
//    public static func fromJsonObject(_ data: JSON, _ type: String) throws -> TransactionArgument {
//        enum TransactionArgumentType: String {
//            case input = "Input"
//            case gasCoin = "GasCoin"
//            case result = "Result"
//            case nestedResult = "NestedResult"
//        }
//
//        guard let txType = TransactionArgumentType(rawValue: type) else { throw SuiError.notImplemented }
//
//        switch txType {
//        case .input:
//            return .input(
//                TransactionBlockInput(
//                    index: , // Int
//                    value: , // SuiJsonValue?
//                    type:  // ValueType?
//                )
//            )
//        case .gasCoin:
//            return .gasCoin
//        case .result:
//            return .result(
//                Result(
//                    index:  // Int
//                )
//            )
//        case .nestedResult:
//            return .nestedResult(
//                NestedResult(
//                    index: , // Int
//                    resultIndex:  // Int
//                )
//            )
//        }
//    }

    public func serialize(_ serializer: Serializer) throws {
        switch self {
        case .input(let transactionBlockInput):
            try Serializer.u8(serializer, UInt8(0))
            try Serializer._struct(serializer, value: transactionBlockInput)
        case .gasCoin:
            try Serializer.u8(serializer, UInt8(1))
        case .result(let result):
            try Serializer.u8(serializer, UInt8(2))
            try Serializer._struct(serializer, value: result)
        case .nestedResult(let nestedResult):
            try Serializer.u8(serializer, UInt8(3))
            try Serializer._struct(serializer, value: nestedResult)
        }
    }
    
    public static func deserialize(from deserializer: Deserializer) throws -> TransactionArgument {
        let type = try Deserializer.u8(deserializer)
        
        switch type {
        case 0:
            return TransactionArgument.input(try Deserializer._struct(deserializer))
        case 1:
            return TransactionArgument.gasCoin
        case 2:
            return TransactionArgument.result(try Deserializer._struct(deserializer))
        case 3:
            return TransactionArgument.nestedResult(try Deserializer._struct(deserializer))
        default:
            throw SuiError.notImplemented
        }
    }
}

public struct TransactionBlockInput: KeyProtocol, TransactionArgumentTypeProtocol, Codable {
    public var index: Int
    public var value: SuiJsonValue?
    public var type: ValueType?
    
    public func serialize(_ serializer: Serializer) throws {
        try Serializer.u64(serializer, UInt64(index))
        if let value { try Serializer._struct(serializer, value: value) }
        if let type { try Serializer._struct(serializer, value: type) }
    }
    
    public static func deserialize(from deserializer: Deserializer) throws -> TransactionBlockInput {
        return TransactionBlockInput(
            index: Int(try Deserializer.u64(deserializer)),
            value: try? Deserializer._struct(deserializer),
            type: try? Deserializer._struct(deserializer)
        )
    }
}

public enum ValueType: String, KeyProtocol, Codable {
    case pure
    case object
    
    public func serialize(_ serializer: Serializer) throws {
        switch self {
        case .pure:
            try Serializer.u8(serializer, UInt8(0))
        case .object:
            try Serializer.u8(serializer, UInt8(1))
        }
    }
    
    public static func deserialize(from deserializer: Deserializer) throws -> ValueType {
        let type = try Deserializer.u8(deserializer)
        
        switch type {
        case 0:
            return ValueType.pure
        case 1:
            return ValueType.object
        default:
            throw SuiError.notImplemented
        }
    }
}

public struct Result: KeyProtocol, TransactionArgumentTypeProtocol, Codable {
    public let index: UInt16
    
    public func serialize(_ serializer: Serializer) throws {
        try Serializer.u16(serializer, index)
    }
    
    public static func deserialize(from deserializer: Deserializer) throws -> Result {
        return Result(
            index: try Deserializer.u16(deserializer)
        )
    }
}

public struct NestedResult: KeyProtocol, TransactionArgumentTypeProtocol, Codable {
    public let index: UInt16
    public let resultIndex: UInt16
    
    public func serialize(_ serializer: Serializer) throws {
        try Serializer.u16(serializer, index)
        try Serializer.u16(serializer, resultIndex)
    }
    
    public static func deserialize(from deserializer: Deserializer) throws -> NestedResult {
        return NestedResult(
            index: try Deserializer.u16(deserializer),
            resultIndex: try Deserializer.u16(deserializer)
        )
    }
}

public struct ObjectTransactionArgument: Codable, KeyProtocol {
    public let argument: TransactionArgument
    public let kind: TransactionArgumentKind
    
    public init(argument: TransactionArgument) {
        self.argument = argument
        self.kind = .object
    }
    
    public func serialize(_ serializer: Serializer) throws {
        try Serializer._struct(serializer, value: argument)
    }
    
    public static func deserialize(from deserializer: Deserializer) throws -> ObjectTransactionArgument {
        return ObjectTransactionArgument(
            argument: try Deserializer._struct(deserializer)
        )
    }
}

public struct PureTransactionArgument: Codable, KeyProtocol {
    public let argument: TransactionArgument
    public let kind: TransactionArgumentKind
    
    public init(argument: TransactionArgument, type: String) {
        self.argument = argument
        self.kind = .pure(type: type)
    }
    
    public func serialize(_ serializer: Serializer) throws {
        try Serializer._struct(serializer, value: argument)
        try Serializer._struct(serializer, value: kind)
    }
    
    public static func deserialize(from deserializer: Deserializer) throws -> PureTransactionArgument {
        let argument: TransactionArgument = try Deserializer._struct(deserializer)
        let kindEnum: TransactionArgumentKind = try Deserializer._struct(deserializer)
        
        switch kindEnum {
        case .pure(let type):
            return PureTransactionArgument(
                argument: argument,
                type: type
            )
        default:
            throw SuiError.notImplemented
        }
    }
}
