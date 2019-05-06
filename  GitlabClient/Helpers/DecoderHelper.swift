//
//  DecoderHelper.swift
//  GitlabClient
//
//  Created by User on 26/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

class DecoderHelper {
    
    static func modelFromData<T: Decodable>(_ data: Data) -> Result<T> {
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
            let decodedData = try decoder.decode(T.self, from: data)
            return .success(decodedData)
        } catch DecodingError.dataCorrupted(let context) {
            return .error(DecodingError.dataCorrupted(context))
        } catch DecodingError.keyNotFound(let key, let context) {
            return .error(DecodingError.keyNotFound(key,context))
        } catch DecodingError.typeMismatch(let type, let context) {
            return .error(DecodingError.typeMismatch(type,context))
        } catch DecodingError.valueNotFound(let value, let context) {
            return .error(DecodingError.valueNotFound(value,context))
        } catch let error {
            return .error(error)
        }
    }
    
}
