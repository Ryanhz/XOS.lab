//
//  HzyCarouselView.swift
//  library
//
//  Created by hzf on 2018/9/10.
//  Copyright © 2018年 hzy. All rights reserved.
//

import UIKit

protocol HzyCarouselSoureAble {
    var title: String {get}
}

class HzyCarouselItemView: UIView {
    var imageView: UIImageView?
    var label: UILabel = UILabel(frame: .init(x: 0 , y: 0 ,width: 100, height: 20))
    convenience init(){
        self.init(frame: .zero)
        label.numberOfLines = 0
        self.addSubview(label)
        label.snp.makeConstraints { (maker) in
            maker.left.right.top.equalToSuperview()
        }
    }
}

class HzyCarouselView: UIView {
    enum CarouselDirection {
        case horizontal
        case vertical
    }
    var autoTimeInterval: TimeInterval = 2 {
        didSet {
            guard oldValue != autoTimeInterval else {
                return
            }
            setupTimer()
        }
    }
    var dataSource: [HzyCarouselSoureAble]? {
        didSet {
            guard let _ = dataSource else {
                return
            }
            initData()
        }
    }
    var scrollDirection: CarouselDirection = .vertical {
        didSet{
            guard oldValue != scrollDirection else {
                return
            }
            layoutIfNeeded()
            initData()
            setupTimer()
        }
    }
    
    let scrollView: UIScrollView = UIScrollView()
    var currentIndex: Int = 0
    private var itemViews: [HzyCarouselItemView] = []
    var timer: Timer?
    var isFinishInit: Bool = false
    
   convenience init(dataSource: [HzyCarouselSoureAble]) {
        self.init(frame: .zero)
        self.dataSource = dataSource
    }
    
   convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
         setupSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard self.frame != .zero else {
            return
        }
        scrollView.frame = self.bounds
        switch self.scrollDirection {
        case .horizontal:
           scrollView.contentSize = .init(width: scrollView.width*3, height: scrollView.height)
            for (index, itemView) in itemViews.enumerated() {
                var frame = self.scrollView.bounds
                frame.origin.x = CGFloat(index) * scrollView.width
                itemView.frame = frame
            }
        case .vertical:
             scrollView.contentSize = .init(width: scrollView.width, height: scrollView.height * 3)
            for (index, itemView) in itemViews.enumerated() {
                var frame = self.scrollView.bounds
                frame.origin.y = CGFloat(index) * scrollView.height
                itemView.frame = frame
            }
        }
        
        guard !isFinishInit else {
            return
        }
        isFinishInit = true
        initData()
    }
    
    func setupSubview() {
        setupTimer()
        addSubview(scrollView)
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        for _ in 0...2 {
           let itemView = HzyCarouselItemView()
            itemViews.append(itemView);
            scrollView.addSubview(itemView)
        }
    }
    
    @objc func timerChange(){
        guard self.frame != .zero else {
            return
        }
        UIView.animate(withDuration: autoTimeInterval - 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            switch self.scrollDirection {
            case .horizontal:
                self.scrollView.contentOffset.x = self.scrollView.width*2
            case .vertical:
                 self.scrollView.contentOffset.y = self.scrollView.height*2
            }
        }) { (finished) in
            self.refreshView()
            self.undoScrollViewContentOffSet()
        }
    }
    
    func initData() {
        currentIndex = 0
        undoScrollViewContentOffSet()
        refreshView()
    }
    
    func refreshView(){
        guard self.frame != .zero , let dataSource = dataSource, dataSource.count > 0 else {
            return
        }
        var leftIndex = currentIndex
        var rightIndex = currentIndex
        let offset = scrollView.contentOffset
        
        func calculateHIndex() {
            if offset.x == 2*scrollView.width {
                currentIndex = (currentIndex + 1) % dataSource.count
            } else if offset.x == 0 {
                currentIndex = (currentIndex - 1) % dataSource.count
                if currentIndex < 0 {
                    currentIndex = dataSource.count - 1
                }
            }
        }
        
        func calculateVIndex(){
            if offset.y == 2*scrollView.height {
                currentIndex = (currentIndex + 1) % dataSource.count
            } else if offset.y == 0 {
                currentIndex = (currentIndex - 1) % dataSource.count
                if currentIndex < 0 {
                    currentIndex = dataSource.count - 1
                }
            }
        }
        
        switch scrollDirection {
        case .horizontal:
            calculateHIndex()
        case .vertical:
            calculateVIndex()
        }
        
        if dataSource.count > 1 {
            switch currentIndex {
            case 0:
                leftIndex = dataSource.count - 1
                rightIndex = currentIndex + 1
            case dataSource.count - 1 :
                leftIndex = currentIndex - 1
                rightIndex = 0
            default:
                leftIndex = currentIndex - 1
                rightIndex = currentIndex + 1
            }
        }
        itemViews[0].label.text = dataSource[leftIndex].title
        itemViews[1].label.text = dataSource[currentIndex].title
        itemViews[2].label.text = dataSource[rightIndex].title
    }
    
    func setupTimer() {
        timer = Timer(timeInterval: autoTimeInterval, target: self, selector: #selector(timerChange), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
    }
    
    func undoScrollViewContentOffSet() {
        switch self.scrollDirection {
        case .horizontal:
            self.scrollView.contentOffset.x = self.scrollView.width
        case .vertical:
            self.scrollView.contentOffset.y = self.scrollView.height
        }
    }
}

extension HzyCarouselView : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.timer?.invalidate()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        setupTimer()
        guard !decelerate else {
            return
        }
        scrollViewDidEndDecelerating(scrollView)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        refreshView()
         undoScrollViewContentOffSet()
    }
}
