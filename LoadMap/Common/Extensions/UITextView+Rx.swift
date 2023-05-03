//
//  UITextView+Rx.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/05/01.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UITextView {
    var textAndView: ControlEvent<(String, Base)> {
        let source = Observable.combineLatest(self.didChange, self.base.rx.text.orEmpty.asObservable(), resultSelector: { ($0, $1) })
            .map { ($0.1, self.base) }
        return ControlEvent(events: source)
    }

    var textWithBase: ControlEvent<(String,Base)> {
        let source = self.text.orEmpty
            .map { ($0, self.base) }
        return ControlEvent(events: source)
    }
    
}
