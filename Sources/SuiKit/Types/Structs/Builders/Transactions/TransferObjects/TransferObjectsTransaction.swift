//
//  File.swift
//  
//
//  Created by Marcus Arnett on 5/12/23.
//

import Foundation

public struct TransferObjectsTransaction: KeyProtocol, Codable {
    public let kind: String
    public let objects: [ObjectTransactionArgument]
    public let address: PureTransactionArgument
    
    public func serialize(_ serializer: Serializer) throws {
        try Serializer.str(serializer, kind)
        try serializer.sequence(objects, Serializer._struct)
        try Serializer._struct(serializer, value: address)
        print("DEBUG: TX OBJECT DATA - \([UInt8](serializer.output()))")
    }
    
    public static func deserialize(from deserializer: Deserializer) throws -> TransferObjectsTransaction {
        let kind = try Deserializer.string(deserializer)
        return TransferObjectsTransaction(
            kind: kind,
            objects: try deserializer.sequence(valueDecoder: Deserializer._struct),
            address: try Deserializer._struct(deserializer)
        )
    }
}
