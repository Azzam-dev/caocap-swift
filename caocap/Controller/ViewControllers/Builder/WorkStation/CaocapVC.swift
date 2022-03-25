//
//  CaocapVC.swift
//  caocap
//
//  Created by CAOCAP inc on 22/08/1443 AH.
//  Copyright © 1443 Ficruty. All rights reserved.
//

import UIKit
import ReSwift

class CaocapVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("caocap did load")
        // Do any additional setup after loading the view.
    }

    func load(caocap: Caocap) {
        print(caocap.name)
    }
    
}


extension CaocapVC: StoreSubscriber {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }
    
    func newState(state: AppState) {
        if let openedCaocap = state.openedCaocap {
            load(caocap: openedCaocap)
        }
        
    }
    
}

