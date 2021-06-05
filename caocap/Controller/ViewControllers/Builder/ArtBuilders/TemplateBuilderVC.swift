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
    
    
    var caocapTemplates = [Template]()
    var editingTemplate: Template?
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
            return caocapTemplates.count
        case stylesTableView:
            return editingTemplate?.content.count ?? 0
        default:
            return 0
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case previewTableView:
            if indexPath.row == caocapTemplates.count { // if it was the last cell then show add template
                guard let cell = previewTableView.dequeueReusableCell(withIdentifier: "addTemplateCell", for: indexPath) as? AddTemplateCell else { return UITableViewCell() }
                cell.delegate = self
                return cell
            } else {
                guard let cell = previewTableView.dequeueReusableCell(withIdentifier: "templateCell", for: indexPath) as? TemplateCell else { return UITableViewCell() }
                
                cell.configure(template: caocapTemplates[indexPath.row])
                return cell
            }
        case structureTableView:
            let cell = UITableViewCell()
            cell.textLabel?.text = caocapTemplates[indexPath.row].type.rawValue
            return cell
        case stylesTableView:
            let cell = UITableViewCell()
            switch editingTemplate?.type {
            case .blog:
                switch indexPath.row {
                case 0:
                    cell.textLabel?.text = editingTemplate?.content["title"]
                case 1:
                    cell.textLabel?.text = editingTemplate?.content["description"]
                default:
                    break
                }
            default:
                break
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case previewTableView, structureTableView:
            editingTemplate = caocapTemplates[indexPath.row]
            stylesTableView.reloadData()
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView == structureTableView {
            let delete = UIContextualAction(style: .destructive, title: "remove") { (_, _, _) in
                self.caocapTemplates.remove(at: indexPath.row)
                self.previewTableView.reloadData()
                self.structureTableView.reloadData()
            }

            let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
            swipeActionConfig.performsFirstActionWithFullSwipe = false
            return swipeActionConfig
        }
        
        return nil
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


extension TemplateBuilderVC: AddTemplateDelegate {
    
    func didPressAddTemplate() {
        let newTemplate = Template(type: .blog, content: ["title" : "Blog Title", "description" : "this is the blog description"])
        caocapTemplates.append(newTemplate)
        previewTableView.reloadData()
        structureTableView.reloadData()
    }
    
    
    
}
