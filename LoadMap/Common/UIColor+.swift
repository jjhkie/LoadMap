//
//  UIColor+.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/27.
//


import UIKit

extension UIColor{
    
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
