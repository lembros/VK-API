//
//  NewsfeedFetcher.swift
//  VK API
//
//  Created by Егор Губанов on 29.09.2022.
//

import Foundation

enum DataFetcherError: Error {
    case unexpectedData
}

class DataFetcher {
    static func parseData<T: Decodable>(_ data: Data, of type: T.Type) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return try? decoder.decode(T.self, from: data)
    }
}
