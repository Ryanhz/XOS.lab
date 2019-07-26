//
//  TF_PhotoPick.swift
//  Hzy
//
//  Created by hzf on 2017/5/31.
//  Copyright © 2017年 Hzy. All rights reserved.
//

import UIKit

class TF_AvatarPick: NSObject {
    
    weak var targetVC: UIViewController?
    
    var block: (([String : Any])->Void)?
    
    static let shared: TF_AvatarPick = TF_AvatarPick()

    class func showImagPick(_ showVC: UIViewController, sourceType: UIImagePickerController.SourceType,allowsEditing: Bool = true, didFinishPickingMediaWithInfo info: @escaping ([String : Any])->Void){
        let helper = TF_AvatarPick.shared
        helper.targetVC = showVC
        helper.block = info
        let photoPick = UIImagePickerController()
        photoPick.allowsEditing = allowsEditing
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            photoPick.sourceType = sourceType
        } else {
//            helper.targetVC?.makeToast("source:\(sourceType)不能使用")
        }
        photoPick.delegate = helper
        
        helper.targetVC?.navigationController?.present(photoPick, animated: true, completion: {
        })
    }
}

extension TF_AvatarPick: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true) {
        }
        block?(info)
        block = nil
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
        }
    }
}

