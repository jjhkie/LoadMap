//
//  DotProgressBar.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/27.
//

import UIKit

class CustomProgressView: UIProgressView {
    
    let dotView = CircleView(size: 20)
    let dotViewArr :[CircleView] = [CircleView(size: 10),CircleView(size: 10),CircleView(size: 10),CircleView(size: 10),CircleView(size: 10)]
    var dotCount: [TaskItem] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // UIProgressView 생성
        self.progressViewStyle = .default
        self.clipsToBounds = false
        self.progress = 0.5
        // dotView 생성 및 추가
        //dotView.backgroundColor = .black
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for (index,value) in dotCount.enumerated(){
            
            let view = dotViewArr[index]
            if value.itemComplete{
                view.backgroundColor = .gray
            }else{
                view.backgroundColor = .red
            }
            
            self.addSubview(view)
            
            // dotView 위치 조정
            let progressWidth = self.frame.width * (CGFloat(1 + index) / CGFloat(dotCount.count))
            view.center = CGPoint(x: progressWidth, y: self.frame.height / 2)

        }
        // dotView 위치 조정
//        let progressWidth = self.frame.width * CGFloat(self.progress)
//        dotView.center = CGPoint(x: progressWidth, y: self.frame.height / 2)
    }
}
