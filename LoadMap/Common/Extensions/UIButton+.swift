//
//  UIButton+.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/05/02.
//


import UIKit

extension UIButton{
    var fillCustomButtony:UIButton.Configuration{
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .layerFourColor
        config.baseForegroundColor = .layerOneColor
        config.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
        return config
    }
}
