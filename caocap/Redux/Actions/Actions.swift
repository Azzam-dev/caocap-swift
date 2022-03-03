//
//  Actions.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 08/05/2021.
//  Copyright © 2021 Ficruty. All rights reserved.
//

import ReSwift

/*
 Actions: Initiate a state change in the app. An Action is handled by a Reducer.
 
 - Only Actions can initiate a Reducer to start changing the current application state
*/
struct CreateCaocapAction: Action {
    let caocap: Caocap
}
struct OpenBuilderAction: Action {
    let caocap: Caocap
}
struct CloseBuilderAction: Action {
    
}
