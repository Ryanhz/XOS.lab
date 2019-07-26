//
//  FE_ADecodable.swift
//  Hzy
//
//  Created by hzf on 2017/5/11.
//  Copyright © 2017年 Hzy. All rights reserved.
//

import Foundation

protocol HzyADecodable {
    static func validate(data: Data?) throws -> Any
    init(json: Any) throws
}

extension HzyADecodable {
    
    static func validate(data: Data?) throws -> Any {
        guard let data = data, data.count > 0 else {
            throw HzyNetError.responseValidationFailed(.dataNilOrZeroLength)
        }
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            
            guard let dic = jsonObject as? [String: Any] else{
                throw HzyNetError.responseValidationFailed(.jsonAnalysisFailed("jsonObject is not [String: Any] type"))
            }
            
            guard let isSuccessful = dic["isSuccessful"] as? Bool else {
                throw HzyNetError.responseValidationFailed(.jsonAnalysisFailed("jsonObject have not 'isSuccessful' key"))
            }
            
            guard isSuccessful == true else{
                let errMessage = dic["errMessage"] as? String ?? ""
                let warningMessage = dic["warningMessage"] as? String ?? ""
                let prompt = "errMessage: \(errMessage), \n warningMessage: \(warningMessage)"
                throw HzyNetError.prompt(prompt)
            }
            
            return dic["data"] ?? "null"
        } catch {
            throw HzyNetError.responseValidationFailed(.jsonSerializationFailed(error))
        }
    }
}
