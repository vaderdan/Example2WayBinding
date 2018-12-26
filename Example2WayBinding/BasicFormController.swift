//
//  BasicFormController.swift
//  Example2WayBinding
//
//  Created by Danny on 26.12.18.
//  Copyright © 2018 Danny. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BasicFormController: UIViewController {
    
    @IBOutlet weak var textFieldFirst: UITextField!
    @IBOutlet weak var textFieldSecond: UITextField!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textFirst = BehaviorRelay<String?>(value: nil)
        let textSecond = BehaviorRelay<String?>(value: nil)
        
        (textFirst <-> textSecond).disposed(by: disposeBag)
        
        (textFieldFirst.rx.text <-> textFirst).disposed(by: disposeBag)
        (textFieldSecond.rx.text <-> textSecond).disposed(by: disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}


