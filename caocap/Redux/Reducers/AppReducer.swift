//
//  AppReducer.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 08/05/2021.
//  Copyright © 2021 Ficruty. All rights reserved.
//

import ReSwift

/*
 Reducers: Directly change the application state, which is stored in the Store.
 
 - Reducers are the only blocks that can directly change the current value of the AppState held by the Store,
 - The Reducer changes the current value of AppState depending on the type of Action it receives.
 
 appReducer is a function that takes an Action and returns the changed AppState.
 state is the current state of the app
*/
func appReducer(action: Action, state: AppState?) -> AppState {
    var state = state ?? AppState()
    
    switch action {
    case let createCaocapAction as CreateCaocapAction:
        state.openedCaocap = createCaocapAction.caocap
        
    case let openBuilderAction as OpenBuilderAction:
        state.openedCaocap = openBuilderAction.caocap
    case _ as CloseBuilderAction:
        state.openedCaocap = nil
        
    case let loudCaocapVCAction as LoudCaocapVCAction:
        state.caocapVC = loudCaocapVCAction.caocapVC
        
    case let updateBackGroundColorForCaocapVCAction as UpdateBackGroundColorForCaocapVCAction:
        state.caocapVC?.view.backgroundColor = updateBackGroundColorForCaocapVCAction.color
        
    default:
        break
    }
    
    return state
}
