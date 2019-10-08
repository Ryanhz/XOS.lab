//
//  FE_ADecodable.swift
//  Zyme
//
//  Created by hzf on 2017/5/11.
//  Copyright © 2017年 Zyme. All rights reserved.
//

import Foundation

protocol ZymeADecodable {
    static func validate(data: Data?) throws -> Any
    init(json: Any) throws
}

extension ZymeADecodable {
    
    static func validate(data: Data?) throws -> Any {
        guard let data = data, data.count > 0 else {
            throw ZymeNetError.responseValidationFailed(.dataNilOrZeroLength)
        }
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            
            guard let dic = jsonObject as? [String: Any] else{
                throw ZymeNetError.responseValidationFailed(.jsonAnalysisFailed("jsonObject is not [String: Any] type"))
            }
            
            guard let isSuccessful = dic["isSuccessful"] as? Bool else {
                throw ZymeNetError.responseValidationFailed(.jsonAnalysisFailed("jsonObject have not 'isSuccessful' key"))
            }
            
            guard isSuccessful == true else{
                let errMessage = dic["errMessage"] as? String ?? ""
                let warningMessage = dic["warningMessage"] as? String ?? ""
                let prompt = "errMessage: \(errMessage), \n warningMessage: \(warningMessage)"
                throw ZymeNetError.prompt(prompt)
            }
            
            return dic["data"] ?? "null"
        } catch {
            throw ZymeNetError.responseValidationFailed(.jsonSerializationFailed(error))
        }
    }
}
