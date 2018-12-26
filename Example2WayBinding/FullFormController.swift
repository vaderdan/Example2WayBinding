//
//  FullFormController.swift
//  Example2WayBinding
//
//  Created by Danny on 26.12.18.
//  Copyright © 2018 Danny. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class FullFormController: UIViewController {
    
    @IBOutlet weak var textFieldFirst: UITextField!
    @IBOutlet weak var textFieldSecond: UITextField!
    @IBOutlet weak var textFieldFull: UITextField!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textFull = BehaviorRelay<String?>(value: nil)
        let textFirst = BehaviorRelay<String?>(value: nil)
        let textSecond = BehaviorRelay<String?>(value: nil)
        
        
        
        typealias ItemType = (current: String, previous: String)
        
        Observable.combineLatest(textFirst.map({ $0 ?? "" }).currentAndPrevious(), textSecond.map({ $0 ?? "" }).currentAndPrevious(), textFull.map({ $0 ?? "" }).currentAndPrevious())
            .filter({ (first: ItemType, second: ItemType, full: ItemType) -> Bool in
                return "\(first.current) \(second.current)" != full.current && "\(first.current)" != full.current
            })
            .subscribe(onNext: { (first: ItemType, second: ItemType, full: ItemType) in
                if first.current != first.previous || second.current != second.previous {
                    textFull.accept("\(first.current) \(second.current)")
                }
                else if (full.current != full.previous) {
                    let items = full.current.components(separatedBy: " ")
                    let firstName = items.count > 0 ? items[0] : ""
                    let lastName = items.count > 1 ? items[1] : ""
                    
                    if firstName != first.current {
                        textFirst.accept(firstName)
                    } else if lastName != second.current {
                        textSecond.accept(lastName)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        (textFieldFirst.rx.text <-> textFirst).disposed(by: disposeBag)
        (textFieldSecond.rx.text <-> textSecond).disposed(by: disposeBag)
        (textFieldFull.rx.text <-> textFull).disposed(by: disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}


