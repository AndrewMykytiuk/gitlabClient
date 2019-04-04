//
//  DecoderHelper.swift
//  GitlabClient
//
//  Created by User on 26/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

class DecoderHelper {
    
    private enum ConstantExpressions {
        static let pattern = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
    }
    
    static func modelFromData<T: Decodable>(_ data: Data) -> Result<T> {
        
        do {
            let decoder = JSONDecoder()
            let userData = try decoder.decode(T.self, from: data)
            return .success(userData)
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
    
    static func urlsInString(with string: String) ->Result<[String]> {
        
        guard let regex = try? NSRegularExpression(pattern: ConstantExpressions.pattern) else {
            return .error(ParsingError.wrongInstrumentsFor(ConstantExpressions.pattern))
        }
        
        let matches = regex.matches(in: string, options: [], range: NSRange(string.startIndex..., in: string))
        
        var code: [String] = []
        
        for match in matches {
            let range = match.range(at: 0)
            let stringArray = (Array(string)[range.location...(range.location + range.length - 1)])
            code.append(String(stringArray))
        }
        
        return .success(code)
        
    }
    
}
