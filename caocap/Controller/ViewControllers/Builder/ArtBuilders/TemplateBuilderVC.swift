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
    @IBOutlet weak var previewTableView: UITableView!
    
    @IBOutlet weak var stylesTableView: UITableView!
    @IBOutlet weak var templatesCollectionView: UICollectionView!
    @IBOutlet weak var structureTableView: UITableView!
    
    
    var caocapTemplates = [["name": "blog", "title" : "failed to load templates", "description" : "this is the blog description"],["":""],["":""],["":""]] // this should be of type Template
    override func viewDidLoad() {
        super.viewDidLoad()
        getCaocapData()
    }
    
    
    func getCaocapData() {
        guard let openedCaocapKey = openedCaocap?.key else { return }
        DataService.instance.REF_CAOCAPS.child(openedCaocapKey).observe(.value) { (caocapSnapshot) in
            guard let caocapSnapshot = caocapSnapshot.value as? [String : Any] else { return }
            let caocap = Caocap(key: openedCaocapKey, dictionary: caocapSnapshot)
//            if let templates = caocap.templates { self.caocapTemplates = templates }
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
            presentSelectedView(structureTableView)
        case 1:
            toolsSelectedIndex = 1
            topToolBarBTNs[1].setImage(#imageLiteral(resourceName: "icons8-module-1"), for: .normal)
            presentSelectedView(templatesCollectionView)
        case 2:
            toolsSelectedIndex = 2
            topToolBarBTNs[2].setImage(#imageLiteral(resourceName: "icons8-pen-1"), for: .normal)
            presentSelectedView(stylesTableView)
        default:
            break
        }
    }
    
    func presentSelectedView(_ selectedView: UIView) {
        structureTableView.isHidden = true
        templatesCollectionView.isHidden = true
        stylesTableView.isHidden = true
        selectedView.isHidden = false
    }
    
    
}

extension TemplateBuilderVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case previewTableView:
            return caocapTemplates.count + 1
        case structureTableView:
            //TODO:- return number of cells in the structureTableView
            return 3
        case stylesTableView:
            //TODO:- return number of cells in the stylesTableView
            return 3
        default:
            return 0
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case previewTableView:
            if indexPath.row == caocapTemplates.count { // if it was the last cell then show add template
                guard let cell = previewTableView.dequeueReusableCell(withIdentifier: "addTemplateCell", for: indexPath) as? AddTemplateCell else { return UITableViewCell() }
                
                return cell
            } else {
                guard let cell = previewTableView.dequeueReusableCell(withIdentifier: "templateCell", for: indexPath) as? TemplateCell else { return UITableViewCell() }
                
                cell.configure(template: Template(type: .blog, content: ["title" : "Blog Title", "description" : "this is the blog description"]))
                return cell
            }
        case structureTableView:
            //TODO:- setup the structure table view cells
            return UITableViewCell()
        case stylesTableView:
            //TODO:- setup the styles table view cells
            return UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
    
    
}

extension TemplateBuilderVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "templateIconCell", for: indexPath) as? TemplateIconCell else { return UICollectionViewCell() }
        
        return cell
    }
    
   
}

