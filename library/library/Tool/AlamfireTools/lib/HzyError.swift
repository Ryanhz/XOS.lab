//
//  FE_Error.swift
//  FETools
//
//  Created by hzf on 2017/11/2.
//  Copyright © 2017年 hzf. All rights reserved.
//

import UIKit

enum HzyNetError: Error {
    
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

extension HzyNetError {
    var isPrompt: Bool {
        if case .prompt = self { return true }
        return false
    }
}

extension HzyNetError: LocalizedError {
    
    var localizedDescription: String {
        switch self {
        case .prompt(let reason):
            return reason
        case .jsonTransformModelFailed(let reason):
            hzyNetDebugLog(reason)
            return HzyNet.defaultExcepotionDescription
        case .responseValidationFailed(let reason):
            hzyNetDebugLog(reason)
            return HzyNet.defaultExcepotionDescription
        }
    }
    
    var errorDescription: String? {
      return self.localizedDescription
    }
}
