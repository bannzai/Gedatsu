//
//  ViewController.swift
//  GedatsuExample
//
//  Created by yudai-hirose on 2020/05/03.
//  Copyright © 2020 bannzai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let subview = UIView()
        NSLayoutConstraint.activate([
            subview.widthAnchor.constraint(equalToConstant: 100),
            subview.widthAnchor.constraint(equalToConstant: 10),
        ])
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.layoutIfNeeded()
        
        print("aaaaa")
    }
}

