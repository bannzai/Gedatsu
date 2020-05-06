//
//  ViewController.swift
//  GedatsuExample
//
//  Created by yudai-hirose on 2020/05/03.
//  Copyright © 2020 bannzai. All rights reserved.
//

import UIKit
import Gedatsu

class CustomView: UIView { }

class ViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var customView: CustomView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print(#function)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function)
    }
}

