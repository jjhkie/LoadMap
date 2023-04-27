//
//  CircleView.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/24.
//


import UIKit
import SnapKit

class CircleView: UIView{
    var fillBool: Bool?
    var circleColor : UIColor?
    var size: Int
    
    init(size: Int) {
        self.size = size
        super.init(frame: .zero)
        layout()

        layer.cornerRadius = CGFloat(size / 2)
        layer.borderWidth = 1
        layer.borderColor = CGColor(gray: 1, alpha: 1)
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
extension CircleView{
    
    private func layout(){
        self.snp.makeConstraints{
            $0.height.width.equalTo(size)
        }
    }
}
