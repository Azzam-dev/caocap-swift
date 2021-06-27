//
//  TemplateService.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 27/06/2021.
//  Copyright © 2021 Ficruty. All rights reserved.
//

import Foundation
import Firebase

class TemplateService {
    static let instance = TemplateService()
    
    // DB references
    private var _REF_TEMPLATE = DB_BASE.child("components").child("templates")
    
    //DatabaseReference
    var REF_TEMPLATE: DatabaseReference { return _REF_TEMPLATE }
    
    func getAllTemplates(handler: @escaping (_ templatesArray: [Template]) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            self.REF_TEMPLATE.observeSingleEvent(of: .value) { (templatesSnapshot) in
                guard let templatesSnapshot = templatesSnapshot.children.allObjects as? [DataSnapshot] else { return }
                var templatesArray = [Template]()
                for template in templatesSnapshot {
                    let template = Template(key: template.key, dictionary: template.value as! [String : Any] )
                    templatesArray.append(template)
                }
                DispatchQueue.main.async {
                    handler(templatesArray)
                }
            }
        }
    }
}
