//
//  CircularCollectionViewLayout.swift
//  library
//
//  Created by Ranger on 2018/6/1.
//  Copyright © 2018年 hzy. All rights reserved.
//

import UIKit

class CircularCollectionViewLayout: UICollectionViewLayout {

    let  itemSize = CGSize(width: 133, height: 173)
    
    var radius: CGFloat = 500 {
        didSet {
            invalidateLayout()
        }
    }
    
    var anglePerItem: CGFloat {
        return atan(itemSize.width/radius)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView!.numberOfItems(inSection: 0).cgFloat * itemSize.width, height: collectionView!.height)
    }
    
    
    
    
}
