//
//  Protocol.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/22.
//


protocol ViewModelBasic{
    
    associatedtype Input
    
    associatedtype Output
    
    func inOut(input: Input) -> Output
}
