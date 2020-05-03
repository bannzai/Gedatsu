//
//  ViewController.swift
//  GedatsuExample
//
//  Created by yudai-hirose on 2020/05/03.
//  Copyright © 2020 bannzai. All rights reserved.
//

import UIKit

class CustomView: UIView { }

class ViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var customView: CustomView!
    override func viewDidLoad() {
        super.viewDidLoad()

//        let subview = UIView()
//        subview.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            subview.widthAnchor.constraint(equalToConstant: 100),
//            subview.widthAnchor.constraint(equalToConstant: 10),
//        ])
//        subview.setNeedsLayout()
//        subview.layoutIfNeeded()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        printConstraint()
    }
    
    func printConstraint() {
        print("view: ----")
        func _print(constraint: NSLayoutConstraint) {
            assert(constraint.firstItem != nil)
            print("  ", "constant: ", constraint.constant)
            print("  ", "firstItem: ", String(describing: constraint.firstItem))
            print("  ", "firstItem.frame: ", String(describing: constraint.firstItem?.frame))
            print("  ", "firstAttribute: ", constraint.firstAttribute.rawValue)
            print("  ", "secondItem: ", String(describing: constraint.secondItem))
            print("  ", "secondItem.frame: ", String(describing: constraint.secondItem?.frame))
            print("  ", "secondAttribute: ", constraint.secondAttribute.rawValue)
        }
        view.constraints.enumerated().forEach {
            print("\($0.0) --- ")
            _print(constraint: $0.1)
        }
        print("customView: ----")
        customView.constraints.enumerated().forEach {
            print("\($0): ---")
            _print(constraint: $1)
        }
        print("stackView: ----")
        stackView.constraints.enumerated().forEach {
            print("\($0.0) --- ")
            _print(constraint: $0.1)
        }
    }
}

