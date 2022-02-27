//
//  TemplateBuilderVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 07/04/2021.
//  Copyright © 2021 Ficruty. All rights reserved.
//

import UIKit
import Firebase

class TemplateBuilderVC: ArtBuilderVC {
    
    @IBOutlet weak var previewTableView: UITableView!
    
    @IBOutlet weak var stylesTableView: UITableView!
    @IBOutlet weak var templatesCollectionView: UICollectionView!
    @IBOutlet weak var structureTableView: UITableView!
    
    var caocapTemplates = [Template]() //TODO: NT - rename
    
    var templatesArray = [Template]()
    var editingTemplate: Template?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAllTemplates()
        getCaocapData()
        registerdUINib()
    }
    
    
    func getCaocapData() {
        guard let openedCaocapKey = openedCaocap?.key else { return }
        DataService.instance.getCaocap(withKey: openedCaocapKey) { caocap in
            if let templates = caocap.templates { self.caocapTemplates = templates }
        }
    }
    
    func getAllTemplates() {
        TemplateService.instance.getAllTemplates { (templates) in
            self.templatesArray = templates
            self.templatesCollectionView.reloadData()
        }
    }
    
    
    func presentSelectedView(_ selectedView: UIView) {
        structureTableView.isHidden = true
        templatesCollectionView.isHidden = true
        stylesTableView.isHidden = true
        selectedView.isHidden = false
    }
    
    private func registerdUINib() {
        stylesTableView.register(UINib.init(nibName: "EditTitleStylesCell", bundle: nil), forCellReuseIdentifier: "editTitleStylesCell")
        stylesTableView.register(UINib.init(nibName: "EditDescriptionStylesCell", bundle: nil), forCellReuseIdentifier: "editDescriptionStylesCell")
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
            return editingTemplate?.dictionary.count ?? 0 //TODO: NT
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
            cell.textLabel?.text = caocapTemplates[indexPath.row].key
            return cell
        case stylesTableView:
            return getStyleCell(with: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    
    private func getStyleCell(with indexPath: IndexPath) -> UITableViewCell {
        guard let editingTemplate = editingTemplate else { return UITableViewCell() }
        //TODO: NT
//        switch editingTemplate.type {
//        case .blog:
//            switch indexPath.row {
//            case 0:
//                guard let cell = stylesTableView.dequeueReusableCell(withIdentifier: "editTitleStylesCell", for: indexPath) as? EditTitleStylesCell else { return UITableViewCell() }
//                cell.configure(title: editingTemplate.content["title"] ?? "")
//                return cell
//            case 1:
//                guard let cell = stylesTableView.dequeueReusableCell(withIdentifier: "editDescriptionStylesCell", for: indexPath) as? EditDescriptionStylesCell else { return UITableViewCell() }
//                cell.configure(description: editingTemplate.content["description"] ?? "")
//                return cell
//            default:
//                break
//            }
//        default:
//            break
//        }
        return UITableViewCell()
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
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if tableView == structureTableView {
            let movedTemplate = caocapTemplates[sourceIndexPath.row]
            caocapTemplates.remove(at: sourceIndexPath.row)
            caocapTemplates.insert(movedTemplate, at: destinationIndexPath.row)
        }
    }
    
}

extension TemplateBuilderVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return templatesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "templateIconCell", for: indexPath) as? TemplateIconCell else { return UICollectionViewCell() }
        cell.configure(template: templatesArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        caocapTemplates.append(templatesArray[indexPath.row])
        previewTableView.reloadData()
        structureTableView.reloadData()
    }
    
   
}


extension TemplateBuilderVC: AddTemplateDelegate {
    
    func didPressAddTemplate() {
        let newTemplate = Template(key: "blog", dictionary: ["title" : "Blog Title", "description" : "this is the blog description"])
        caocapTemplates.append(newTemplate)
        previewTableView.reloadData()
        structureTableView.reloadData()
    }
    
    
    
}
