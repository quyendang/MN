//
//  String.swift
//  musicnow
//
//  Created by Quyen on 10/5/20.
//

import Foundation

extension String {
    func matchingStrings(regex: String) -> [String] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: []) else { return [] }
        let nsString = self as NSString
        return regex.matches(in: self, options: [], range: NSRange(location: 0, length: nsString.length)).map {
            nsString.substring(with: $0.range).replacingOccurrences(of: "\"", with: "")
        }
        
    }
    
    var htmlDecoded: String {
        let decoded = try? NSAttributedString(data: Data(utf8), options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ], documentAttributes: nil).string

        return decoded ?? self
    }
    
    func decode<T: Decodable>(_ type: T.Type, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> T {
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: self)) else {
            fatalError("Failed to load from path.")
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy

        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Failed to decode from bundle due to missing key '\(key.stringValue)' not found – \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Failed to decode from bundle due to type mismatch – \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Failed to decode  from bundle due to missing \(type) value – \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            fatalError("Failed to decode from bundle because it appears to be invalid JSON")
        } catch {
            fatalError("Failed to decode from bundle: \(error.localizedDescription)")
        }
    }
    
}
