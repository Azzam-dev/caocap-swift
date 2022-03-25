//
//  BlockBuilderVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 25/08/2021.
//  Copyright © 2021 Ficruty. All rights reserved.
//

import UIKit
import ReSwift

class BlockBuilderVC: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var blocksView: DesignableView!
    @IBOutlet weak var blocksTableView: UITableView!
    @IBOutlet weak var blocksCollectionView: UICollectionView!
    
    @IBOutlet weak var logicView: DesignableView!
    @IBOutlet weak var logicTableView: UITableView!
    @IBOutlet weak var logicNodesCollectionView: UICollectionView!
    
    @IBOutlet weak var toolsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var gestureRecognizerView: UIView!
    
    @IBOutlet weak var stylesTableView: UITableView!
    @IBOutlet weak var structureTableView: UITableView!
    
    var toolsSelectedIndex = 0
    var openedCaocap: Caocap?
    
    var caocapBlocks = [Block]()
    
    var blocksArray = BlockService.instance.blocks
    var logicNodesArray = LogicNodeService.instance.logicNodes
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gestureRecognizerSetup()
        getCaocapData()
        registerdUINib()
        
    }
    
    func getCaocapData() {
        guard let openedCaocapKey = openedCaocap?.key else { return }
        DataService.instance.getCaocap(withKey: openedCaocapKey) { caocap in
            if let templates = caocap.blocks { self.caocapBlocks = templates }
        }
    }
    
    func presentSelectedView(_ selectedView: UIView) {
        structureTableView.isHidden = true
        blocksCollectionView.isHidden = true
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
                
                self.blocksView.isHidden = false
                self.blocksCollectionView.isHidden = false
                
                self.logicView.isHidden = true
                self.logicNodesCollectionView.isHidden = true
            } else {
                self.topToolBarBTNs[0].tintColor = #colorLiteral(red: 0.9215686275, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
                self.topToolBarBTNs[1].tintColor = #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1)
                
                
                self.view.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
                self.backgroundImage.tintColor = .white
                
                self.logicView.isHidden = false
                self.logicNodesCollectionView.isHidden = false
                
                self.blocksView.isHidden = true
                self.blocksCollectionView.isHidden = true
            }
        }
    }
    
}


extension BlockBuilderVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case blocksTableView:
            return caocapBlocks.count + 1
        case structureTableView:
            return caocapBlocks.count
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
        case blocksTableView:
            if indexPath.row == caocapBlocks.count { // if it was the last cell then show add template
                guard let cell = blocksTableView.dequeueReusableCell(withIdentifier: "addBlockCell", for: indexPath) as? AddBlockCell else { return UITableViewCell() }
                cell.delegate = self
                return cell
            } else {
                guard let cell = blocksTableView.dequeueReusableCell(withIdentifier: "templateCell", for: indexPath) as? TemplateCell else { return UITableViewCell() }
                
                cell.configure(template: caocapBlocks[indexPath.row])
                return cell
            }
        case structureTableView:
            let cell = UITableViewCell()
            cell.textLabel?.text = caocapBlocks[indexPath.row].type.rawValue
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView == structureTableView {
            let delete = UIContextualAction(style: .destructive, title: "remove") { (_, _, _) in
                self.caocapBlocks.remove(at: indexPath.row)
                self.blocksTableView.reloadData()
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
            let movedTemplate = caocapBlocks[sourceIndexPath.row]
            caocapBlocks.remove(at: sourceIndexPath.row)
            caocapBlocks.insert(movedTemplate, at: destinationIndexPath.row)
        }
    }
    
}


extension BlockBuilderVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case blocksCollectionView:
            return blocksArray.count
        case logicNodesCollectionView:
            return logicNodesArray.count
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case blocksCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "templateTypeCell", for: indexPath) as? TemplateIconCell else { return UICollectionViewCell() }
            cell.configure(template: blocksArray[indexPath.row])
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
        caocapBlocks.append(blocksArray[indexPath.row])
        blocksTableView.reloadData()
        structureTableView.reloadData()
    }
    
   
}

extension BlockBuilderVC: StoreSubscriber {
    
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

extension BlockBuilderVC: AddBlockDelegate {
    
    func didPressAddBlock() {
        let newBlock = BlockService.instance.blocks.first!
        caocapBlocks.append(newBlock)
        blocksTableView.reloadData()
        structureTableView.reloadData()
    }
    
    
    
}

