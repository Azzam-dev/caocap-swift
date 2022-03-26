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

        
        // Do any additional setup after loading the view.
    }

    func load(caocap: Caocap) {
        store.dispatch(LoudCaocapVCAction(caocapVC: self))
        DataService.instance.getCaocap(withKey: caocap.key) { liveCaocap in
            guard let loudFile = liveCaocap.code?["main"]?[0] else { return }
            guard let updateFile = liveCaocap.code?["main"]?[1] else { return }
            guard let drawFile = liveCaocap.code?["main"]?[2] else { return }
            
            LuaService(script: loudFile.code)
            LuaService(script: updateFile.code) //TODO: - update Caocap work every frame
            LuaService(script: drawFile.code) //TODO: - redraw Caocap work every frame
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

