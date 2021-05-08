//
//  Store.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 08/05/2021.
//  Copyright © 2021 Ficruty. All rights reserved.
//

import ReSwift

/*
 Store: Stores the current value of the application state. Other modules like Views can subscribe and react to its changes.
 Note: There’s only one Store in the app, and it has only one main Reducer.
 
*/

let store = Store<AppState>(
    reducer: appReducer,
    state: nil,
    middleware: []
)
