//
//  FE_Error.swift
//  FETools
//
//  Created by hzf on 2017/11/2.
//  Copyright © 2017年 hzf. All rights reserved.
//

import UIKit

enum ZymeNetError: Error {
    
    enum ResponseValidationException {
        case dataNilOrZeroLength
        case jsonSerializationFailed(Error)
        case jsonAnalysisFailed(String)
    }
    
    enum jsonTransformModelException{
        case dataTypeNotMatch(String)
        case deserialize(String)
    }
    
    case prompt(String) //返回的数据里要显示的错误信息
    case responseValidationFailed(ResponseValidationException)
    case jsonTransformModelFailed(jsonTransformModelException)
}

extension ZymeNetError {
    var isPrompt: Bool {
        if case .prompt = self { return true }
        return false
    }
}

extension ZymeNetError: LocalizedError {
    
    var localizedDescription: String {
        switch self {
        case .prompt(let reason):
            return reason
        case .jsonTransformModelFailed(let reason):
            zymeNetDebugLog(reason)
            return ZymeNet.defaultExcepotionDescription
        case .responseValidationFailed(let reason):
            zymeNetDebugLog(reason)
            return ZymeNet.defaultExcepotionDescription
        }
    }
    
    var errorDescription: String? {
      return self.localizedDescription
    }
}
