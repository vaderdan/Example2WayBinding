//
//  Operaotors.swift
//  Example2WayBinding
//
//  Created by Danny on 26.12.18.
//  Copyright © 2018 Danny. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

infix operator <->

func <-> <T: Equatable>(lhs: BehaviorRelay<T>, rhs: BehaviorRelay<T>) -> Disposable {
    typealias ItemType = (current: T, previous: T)
    
    return Observable.combineLatest(lhs.currentAndPrevious(), rhs.currentAndPrevious())
        .filter({ (first: ItemType, second: ItemType) -> Bool in
            return first.current != second.current
        })
        .subscribe(onNext: { (first: ItemType, second: ItemType) in
            if first.current != first.previous {
                rhs.accept(first.current)
            }
            else if (second.current != second.previous) {
                lhs.accept(second.current)
            }
        })
}

func <-> <T: Equatable>(lhs: ControlProperty<T>, rhs: BehaviorRelay<T>) -> Disposable {
    typealias ItemType = (current: T, previous: T)
    
    return Observable.combineLatest(lhs.currentAndPrevious(), rhs.currentAndPrevious())
        .filter({ (first: ItemType, second: ItemType) -> Bool in
            return first.current != second.current
        })
        .subscribe(onNext: { (first: ItemType, second: ItemType) in
            if first.current != first.previous {
                rhs.accept(first.current)
            }
            else if (second.current != second.previous) {
                lhs.onNext(second.current)
            }
        })
}
