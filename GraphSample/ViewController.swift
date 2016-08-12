//
//  ViewController.swift
//  GraphSample
//
//  Created by TsuyoshiTonobe on 2016/08/11.
//  Copyright © 2016年 TsuyoshiTonobe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var graphView: GraphView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        graphView.setupPoints([10,10,0,1,1,10,100])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

