//
//  UIColor+.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/27.
//


import UIKit

extension UIColor{
    
    static var layerOneColor: UIColor{
        return UIColor(red: 255/255.0, green: 243/255.0, blue: 226/255.0, alpha: 1.0)
    }
    
    static var layerThreeColor: UIColor{
        return UIColor(red: 250/255.0, green: 152/255.0, blue: 132/255.0, alpha: 1.0)
    }
    
    static var layerFourColor : UIColor{
        return UIColor(red: 231/255.0, green: 70/255.0, blue: 70/255.0, alpha: 1.0)
    }
    
    var rgbValue: GoalColor{
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0

        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        
        let value = GoalColor(red: red, green: green, blue: blue, alpha: alpha)

        return value
    }
    
}
