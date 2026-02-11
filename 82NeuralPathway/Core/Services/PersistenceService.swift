//
//  PersistenceService.swift
//  82NeuralPathway
//

import Foundation

protocol PersistenceServiceProtocol {
    func save<T: Encodable>(_ value: T, forKey key: String)
    func load<T: Decodable>(_ type: T.Type, forKey key: String) -> T?
    func remove(forKey key: String)
}

final class PersistenceService: PersistenceServiceProtocol {
    private let defaults = UserDefaults.standard
    func save<T: Encodable>(_ value: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(value) { defaults.set(data, forKey: key) }
    }
    func load<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
    func remove(forKey key: String) { defaults.removeObject(forKey: key) }
}
