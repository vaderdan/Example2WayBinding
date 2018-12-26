//
//  Rx-Ext.swift
//  Example2WayBinding
//
//  Created by Danny on 26.12.18.
//  Copyright © 2018 Danny. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType {
    func currentAndPrevious() -> Observable<(current: E, previous: E)> {
        return self.multicast({ () -> PublishSubject<E> in PublishSubject<E>() }) { (values: Observable<E>) -> Observable<(current: E, previous: E)> in
            let pastValues = Observable.merge(values.take(1), values)
            
            return Observable.combineLatest(values.asObservable(), pastValues) { (current, previous) in
                return (current: current, previous: previous)
            }
        }
    }
}
