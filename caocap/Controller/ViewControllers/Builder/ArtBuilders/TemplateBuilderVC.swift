//
//  TemplateBuilderVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 07/04/2021.
//  Copyright © 2021 Ficruty. All rights reserved.
//

import UIKit
import WebKit
import Firebase

class TemplateBuilderVC: ArtBuilderVC {
    @IBOutlet weak var structureTableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var caocapTemplates = [["name": "blog", "title" : "failed to load templates", "description" : "this is the blog description"]] // this should be of type Template
    override func viewDidLoad() {
        super.viewDidLoad()
        getCaocapData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

    }
    
    func getCaocapData() {
        DataService.instance.REF_CAOCAPS.child(openedCaocapKey).observe(.value) { (caocapSnapshot) in
            guard let caocapSnapshot = caocapSnapshot.value as? [String : Any] else { return }
            let caocap = Caocap(key: self.openedCaocapKey, dictionary: caocapSnapshot)
            if let templates = caocap.templates { self.caocapTemplates = templates }
        }
    }
    
    @IBOutlet var topToolBarBTNs: [UIButton]!
    @IBAction func topToolBarBTNs(_ sender: UIButton) {
        topToolBarBTNs[0].setImage(#imageLiteral(resourceName: "icons8-layers"), for: .normal)
        topToolBarBTNs[1].setImage(#imageLiteral(resourceName: "icons8-module"), for: .normal)
        topToolBarBTNs[2].setImage(#imageLiteral(resourceName: "icons8-pen"), for: .normal)
        switch sender.tag {
        case 0:
            toolsSelectedIndex = 0
            topToolBarBTNs[0].setImage(#imageLiteral(resourceName: "icons8-layers-1"), for: .normal)
        case 1:
            toolsSelectedIndex = 1
            topToolBarBTNs[1].setImage(#imageLiteral(resourceName: "icons8-module-1"), for: .normal)
        case 2:
            toolsSelectedIndex = 2
            topToolBarBTNs[2].setImage(#imageLiteral(resourceName: "icons8-pen-1"), for: .normal)
        default:
            break
        }
    }
    
    
}

extension TemplateBuilderVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        caocapTemplates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = structureTableView.dequeueReusableCell(withIdentifier: "templateCell", for: indexPath) as? TemplateCell else { return UITableViewCell() }
        
        cell.configure(template: Template(type: .blog, content: ["title" : "Blog Title", "description" : "this is the blog description"]))
        return cell
    }
    
    
}

extension TemplateBuilderVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

