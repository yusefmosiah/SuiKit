//
//  File.swift
//  
//
//  Created by Marcus Arnett on 5/11/23.
//

import Foundation
import AnyCodable

public struct Transactions {
    public static func moveCall(input: MoveCallTransactionInput) -> MoveCallTransaction {
        return MoveCallTransaction(
            kind: "MoveCall",
            target: input.target,
            typeArguments: input.typeArguments ?? [],
            arguments: input.arguments ?? []
        )
    }
    
    public static func transferObjects(objects: [ObjectTransactionArgument], address: PureTransactionArgument) -> TransferObjectsTransaction {
        return TransferObjectsTransaction(
            kind: "TransferObject",
            objects: objects,
            address: address
        )
    }
    
    public static func splitCoins(coins: ObjectTransactionArgument, amounts: [TransactionArgument]) -> SplitCoinsTransaction {
        return SplitCoinsTransaction(
            kind: "SplitCoins",
            coin: coins,
            amounts: amounts.map { PureTransactionArgument(argument: $0, type: "u64") }
        )
    }
    
    public static func mergeCoins(destination: ObjectTransactionArgument, sources: [ObjectTransactionArgument]) -> MergeCoinsTransaction {
        return MergeCoinsTransaction(
            kind: "MergeCoins",
            destination: destination,
            sources: sources
        )
    }
    
    public static func publish(modules: [[UInt8]], dependencies: [objectId]) -> PublishTransaction {
        return PublishTransaction(
            kind: "Publish",
            modules: modules,
            dependencies: dependencies
        )
    }
    
    public static func publish(modules: [String], dependencies: [objectId]) -> PublishTransaction {
        return PublishTransaction(
            kind: "Publish",
            modules: modules.compactMap { module in
                guard let result = Data.fromBase64(module) else { return nil }
                return [UInt8](result)
            },
            dependencies: dependencies
        )
    }
    
    public static func upgrade(modules: [[UInt8]], dependencies: [objectId], packageId: objectId, ticket: ObjectTransactionArgument) -> UpgradeTransaction {
        return UpgradeTransaction(
            kind: "Upgrade",
            modules: modules,
            dependencies: dependencies,
            packageId: packageId,
            ticket: ticket
        )
    }
    
    public static func upgrade(modules: [String], dependencies: [objectId], packageId: objectId, ticket: ObjectTransactionArgument) -> UpgradeTransaction {
        return UpgradeTransaction(
            kind: "Upgrade",
            modules: modules.compactMap { module in
                guard let result = Data.fromBase64(module) else { return nil }
                return [UInt8](result)
            },
            dependencies: dependencies,
            packageId: packageId,
            ticket: ticket
        )
    }
    
    public static func makeMoveVec(type: String? = nil, objects: [ObjectTransactionArgument]) -> MakeMoveVecTransaction {
        return MakeMoveVecTransaction(
            kind: "MakeMoveVec",
            objects: objects,
            type: type
        )
    }
}
