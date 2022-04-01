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
    
    var openedCaocap: Caocap?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let openedCaocap = openedCaocap {
            load(caocap: openedCaocap)
        }
        // Do any additional setup after loading the view.
    }

    func load(caocap: Caocap) {
        store.dispatch(LoudCaocapVCAction(caocapVC: self))
        DataService.instance.getCaocap(withKey: caocap.key) { liveCaocap in
            
//            LuaService(script: )
//TODO: - update Caocap work every frame
//TODO: - redraw Caocap work every frame
        }
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
        if openedCaocap ==  nil { // MARK: - fixed duplicate execution
            openedCaocap = state.openedCaocap
            load(caocap: openedCaocap!)
        }
        
    }
    
}

