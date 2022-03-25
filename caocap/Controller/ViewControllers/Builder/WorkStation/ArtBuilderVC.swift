//
//  ArtBuilderVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 30/04/2021.
//  Copyright © 2021 Ficruty. All rights reserved.
//

import UIKit
import ReSwift

class ArtBuilderVC: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var userInterfaceView: DesignableView!
    @IBOutlet weak var logicView: DesignableView!
    
    @IBOutlet weak var userInterfaceTableView: UITableView!
    @IBOutlet weak var logicTableView: UITableView!
    
    @IBOutlet weak var toolsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var gestureRecognizerView: UIView!
    
    
    @IBOutlet weak var templatesCollectionView: UICollectionView!
    @IBOutlet weak var logicNodesCollectionView: UICollectionView!
    
    @IBOutlet weak var stylesTableView: UITableView!
    @IBOutlet weak var structureTableView: UITableView!
    
    var toolsSelectedIndex = 0
    var openedCaocap: Caocap?
    
    var caocapTemplates = [Template]() //TODO: NT - rename
    
    var templatesArray = TemplateService.instance.templates
    var logicNodesArray = LogicNodeService.instance.logicNodes
    
    var editingTemplate: Template?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gestureRecognizerSetup()
        getCaocapData()
        registerdUINib()
        
    }
    
    
    func getCaocapData() {
        guard let openedCaocapKey = openedCaocap?.key else { return }
        DataService.instance.getCaocap(withKey: openedCaocapKey) { caocap in
            if let templates = caocap.templates { self.caocapTemplates = templates }
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
    
    func gestureRecognizerSetup() {
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        upSwipe.direction = .up
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        downSwipe.direction = .down
        
        gestureRecognizerView.addGestureRecognizer(upSwipe)
        gestureRecognizerView.addGestureRecognizer(downSwipe)
    }
    
    func toolsViewAnimation(_ hight: Int) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: .curveLinear, animations: {
            self.toolsViewHeightConstraint.constant = CGFloat(hight)
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            switch sender.direction {
            case .up:
                if self.toolsViewHeightConstraint.constant == 75 {
                    toolsViewAnimation(135)
                } else {
                    toolsViewAnimation(350)
                }
            case .down:
                if self.toolsViewHeightConstraint.constant == 135 {
                    toolsViewAnimation(75)
                } else {
                    toolsViewAnimation(135)
                }
            default:
                break
            }
        }
    }
    
    @IBOutlet var topToolBarBTNs: [UIButton]!
    @IBAction func topToolBarBTNs(_ sender: UIButton) {
        toolsSelectedIndex = sender.tag
        
        UIView.animate(withDuration: 0.5) {
            if self.toolsSelectedIndex == 0 {
                self.topToolBarBTNs[1].tintColor = #colorLiteral(red: 0.9215686275, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
                self.topToolBarBTNs[0].tintColor = #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1)
                
                self.view.backgroundColor = .white
                self.backgroundImage.tintColor = .black
                
                self.userInterfaceView.isHidden = false
                self.templatesCollectionView.isHidden = false
                
                self.logicView.isHidden = true
                self.logicNodesCollectionView.isHidden = true
            } else {
                self.topToolBarBTNs[0].tintColor = #colorLiteral(red: 0.9215686275, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
                self.topToolBarBTNs[1].tintColor = #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1)
                
                
                self.view.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
                self.backgroundImage.tintColor = .white
                
                self.logicView.isHidden = false
                self.logicNodesCollectionView.isHidden = false
                
                self.userInterfaceView.isHidden = true
                self.templatesCollectionView.isHidden = true
            }
        }
    }
    
}

extension ArtBuilderVC: StoreSubscriber {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }
    
    func newState(state: AppState) {
        openedCaocap = state.openedCaocap
    }
    
}


extension ArtBuilderVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case userInterfaceTableView:
            return caocapTemplates.count + 1
        case structureTableView:
            return caocapTemplates.count
        case stylesTableView:
            return 0 //TODO: - fix stylesTableView count
        case logicTableView:
            return 3 //TODO: - fix logicTableView count
        default:
            return 0
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case userInterfaceTableView:
            if indexPath.row == caocapTemplates.count { // if it was the last cell then show add template
                guard let cell = userInterfaceTableView.dequeueReusableCell(withIdentifier: "addTemplateCell", for: indexPath) as? AddTemplateCell else { return UITableViewCell() }
                cell.delegate = self
                return cell
            } else {
                guard let cell = userInterfaceTableView.dequeueReusableCell(withIdentifier: "templateCell", for: indexPath) as? TemplateCell else { return UITableViewCell() }
                
                cell.configure(template: caocapTemplates[indexPath.row])
                return cell
            }
        case structureTableView:
            let cell = UITableViewCell()
            cell.textLabel?.text = caocapTemplates[indexPath.row].type.rawValue
            return cell
        case stylesTableView:
            return UITableViewCell() //TODO: - getStyleCell
        case logicTableView:
            let cell = logicTableView.dequeueReusableCell(withIdentifier: "logicCell", for: indexPath)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case userInterfaceTableView, structureTableView:
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
                self.userInterfaceTableView.reloadData()
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


extension ArtBuilderVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case templatesCollectionView:
            return templatesArray.count
        case logicNodesCollectionView:
            return logicNodesArray.count
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case templatesCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "templateTypeCell", for: indexPath) as? TemplateIconCell else { return UICollectionViewCell() }
            cell.configure(template: templatesArray[indexPath.row])
            return cell
        case logicNodesCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "logicNodeTypeCell", for: indexPath) as? LogicNodeTypeCell else { return UICollectionViewCell() }
            cell.configure(logicNode: logicNodesArray[indexPath.row])
            return cell
        default:
            return UICollectionViewCell()
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        caocapTemplates.append(templatesArray[indexPath.row])
        userInterfaceTableView.reloadData()
        structureTableView.reloadData()
    }
    
   
}


extension ArtBuilderVC: AddTemplateDelegate {
    
    func didPressAddTemplate() {
        let newTemplate = TemplateService.instance.templates.first!
        caocapTemplates.append(newTemplate)
        userInterfaceTableView.reloadData()
        structureTableView.reloadData()
    }
    
    
    
}
