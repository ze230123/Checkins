//
//  TabViewController.swift
//  Checkins
//
//  Created by youzy on 2024/8/13.
//

import UIKit
import UBase

class TabViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func lotteryAction() {
        let vc = LotteryViewController()
        present(vc)
    }
}
