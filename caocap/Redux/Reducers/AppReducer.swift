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
    case let oneAction as OneAction:
        state.currentUser = nil
    case let twoAction as TwoAction:
        state.currentUser = nil
    default:
        break
    }
    
    return state
}
