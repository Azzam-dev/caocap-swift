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
    var caocapLogicNodes = [LogicNode]()
    var logicTreeClimber = [Int]()
    
    var blocksArray = BlockService.instance.blocks
    var logicNodesArray = LogicNodeService.logicNodes.events
    
    var editingBlock: Block?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gestureRecognizerSetup()
        getCaocapData()
        registerdUINib()
        addSubViews()
        
        logicTableView.contentInset.bottom = 400
        structureTableView.setEditing(true, animated: false)
    }
    
    func getCaocapData() {
        guard let openedCaocapKey = openedCaocap?.key else { return }
        DataService.instance.getCaocap(withKey: openedCaocapKey) { caocap in
            //TODO: - get caocapBlocks and caocapLogicNodes
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
    
    func addSubViews() {
        view.addSubview(controlsViewContainer)
        view.addSubview(leftViewContainer)
        view.addSubview(rightViewContainer)
        controlsViewContainer.frame = view.frame
        leftViewContainer.frame = view.frame
        rightViewContainer.frame = view.frame
        controlsViewContainer.alpha = 0
        leftViewContainer.alpha = 0
        rightViewContainer.alpha = 0
        controlsViewTopConstraint.constant = -200
        leftViewLeadingConstraint.constant = -view.frame.width
        rightViewTrailingConstraint.constant = -view.frame.width
    }
    
    func toolsViewAnimation(_ hight: Int) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: .curveLinear, animations: {
            self.toolsViewHeightConstraint.constant = CGFloat(hight)
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func didPressShowHideBottomViewButton(_ sender: UIButton) {
        if self.toolsViewHeightConstraint.constant < 350 {
            toolsViewAnimation(350)
        } else {
            toolsViewAnimation(135)
        }
    }
    
    @IBOutlet var controlsViewContainer: DesignableView!
    @IBOutlet weak var controlsViewTopConstraint: NSLayoutConstraint!
    
    @IBAction func didPressShowHideTopViewButton(_ sender: Any) {
        if self.controlsViewContainer.isHidden {
            self.controlsViewContainer.isHidden = false
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: .curveLinear) {
                self.controlsViewContainer.alpha = 1
                self.controlsViewTopConstraint.constant = -20
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: .curveLinear) {
                self.controlsViewContainer.alpha = 0
                self.controlsViewTopConstraint.constant = -200
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.controlsViewContainer.isHidden = true
            }
        }
    }
    
    
    @IBOutlet var leftViewContainer: DesignableView!
    @IBOutlet weak var leftViewLeadingConstraint: NSLayoutConstraint!
    
    @IBAction func didPressShowHideLeftViewButton(_ sender: Any) {
        if self.leftViewContainer.isHidden {
            self.leftViewContainer.isHidden = false
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: .curveLinear) {
                self.leftViewContainer.alpha = 1
                self.leftViewLeadingConstraint.constant = -20
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: .curveLinear) {
                self.leftViewContainer.alpha = 0
                self.leftViewLeadingConstraint.constant = -self.view.frame.width
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.leftViewContainer.isHidden = true
            }
        }
    }
    
    @IBOutlet var rightViewContainer: DesignableView!
    @IBOutlet weak var rightViewTrailingConstraint: NSLayoutConstraint!
    
    @IBAction func didPressShowHideRightViewButton(_ sender: Any) {
        if self.rightViewContainer.isHidden {
            self.rightViewContainer.isHidden = false
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: .curveLinear) {
                self.rightViewContainer.alpha = 1
                self.rightViewTrailingConstraint.constant = -20
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: .curveLinear) {
                self.rightViewContainer.alpha = 0
                self.rightViewTrailingConstraint.constant = -self.view.frame.width
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.rightViewContainer.isHidden = true
            }
        }
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


// MARK: - UITableViewDelegate UITableViewDataSource
extension BlockBuilderVC: UITableViewDelegate, UITableViewDataSource {
    
    func getNumberOfLogicNodes() -> Int {
        switch logicTreeClimber.count {
        case 0:
            return caocapLogicNodes.count
        case 1:
            return caocapLogicNodes[logicTreeClimber[0]].content.count
        case 2:
            return caocapLogicNodes[logicTreeClimber[0]].content[logicTreeClimber[1]].content.count
        case 3:
            return caocapLogicNodes[logicTreeClimber[0]].content[logicTreeClimber[1]].content[logicTreeClimber[2]].content.count
        case 4:
            return caocapLogicNodes[logicTreeClimber[0]].content[logicTreeClimber[1]].content[logicTreeClimber[2]].content[logicTreeClimber[3]].content.count
        default:
            return 0
        }
    }
    
    func getLogicNodeFor(index: Int) -> LogicNode? {
        switch logicTreeClimber.count {
        case 0:
            return caocapLogicNodes[index]
        case 1:
            return caocapLogicNodes[logicTreeClimber[0]].content[index]
        case 2:
            return caocapLogicNodes[logicTreeClimber[0]].content[logicTreeClimber[1]].content[index]
        case 3:
            return caocapLogicNodes[logicTreeClimber[0]].content[logicTreeClimber[1]].content[logicTreeClimber[2]].content[index]
        case 4:
            return caocapLogicNodes[logicTreeClimber[0]].content[logicTreeClimber[1]].content[logicTreeClimber[2]].content[logicTreeClimber[3]].content[index]
        default:
            return nil
        }
    }
    
    func updateLogicNodesArray() {
        switch logicTreeClimber.count {
        case 0:
            logicNodesArray = LogicNodeService.logicNodes.events
        case 1:
            logicNodesArray = LogicNodeService.logicNodes.conditions
        case 2:
            logicNodesArray = LogicNodeService.logicNodes.flows
        case 3:
            logicNodesArray = LogicNodeService.logicNodes.actions
        case 4:
            logicNodesArray = LogicNodeService.logicNodes.values
        default:
            logicNodesArray = [LogicNode]()
        }
        logicNodesCollectionView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case blocksTableView:
            return caocapBlocks.count + 1
        case logicTableView:
            updateLogicNodesArray()
            return getNumberOfLogicNodes() + 1
        case structureTableView:
            return caocapBlocks.count
        case stylesTableView:
            guard let editingBlock = editingBlock else { return 0 }
            return editingBlock.styles.count
            
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
                guard let cell = blocksTableView.dequeueReusableCell(withIdentifier: "blockCell", for: indexPath) as? BlockCell else { return UITableViewCell() }
                
                cell.configure(block: caocapBlocks[indexPath.row])
                return cell
            }
        case logicTableView:
            
            if indexPath.row == getNumberOfLogicNodes() {
                guard let cell = logicTableView.dequeueReusableCell(withIdentifier: "addLogicCell", for: indexPath) as? AddLogicCell else { return UITableViewCell() }
                cell.delegate = self
                cell.configure(nodeTreeDepth: logicTreeClimber.count)
                return cell
            } else {
                guard let cell = logicTableView.dequeueReusableCell(withIdentifier: "logicNodeCell", for: indexPath) as? LogicNodeCell else { return UITableViewCell() }
                if let logicNode = getLogicNodeFor(index: indexPath.row) {
                    cell.configure(node: logicNode)
                }
                return cell
            }
        case structureTableView:
            let cell = structureTableView.dequeueReusableCell(withIdentifier: "structureCell", for: indexPath)
            cell.textLabel?.text = caocapBlocks[indexPath.row].type.rawValue
            return cell
        case stylesTableView:
            let cell = UITableViewCell() //TODO: - getStyleCell
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = editingBlock?.styles["backgroundColor"]?.title
            default:
                cell.textLabel?.text = "-***-"
            }
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == logicTableView && indexPath.row < getNumberOfLogicNodes() && logicTreeClimber.count < 4 {
            // enter the logic node ( E - C - F - A )
            logicTreeClimber.append(indexPath.row)
            logicTableView.reloadData()
        } else if tableView == logicTableView && indexPath.row < getNumberOfLogicNodes() {
            // Select a logic mode ( E - C - F - A - V )
            
        } else if tableView == blocksTableView && indexPath.row < caocapBlocks.count {
            //TODO: - blocksTableView didSelectRowAt
            editingBlock = caocapBlocks[indexPath.row]
            stylesTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView == logicTableView && indexPath.row < caocapLogicNodes.count {
            let delete = UIContextualAction(style: .destructive, title: "remove") { (_, _, _) in
                self.caocapLogicNodes.remove(at: indexPath.row)
                self.logicTableView.reloadData()
            }
            
            let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
            swipeActionConfig.performsFirstActionWithFullSwipe = false
            return swipeActionConfig
        } else if tableView == structureTableView || tableView == blocksTableView {
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
            let movedBlock = caocapBlocks[sourceIndexPath.row]
            caocapBlocks.remove(at: sourceIndexPath.row)
            caocapBlocks.insert(movedBlock, at: destinationIndexPath.row)
        }
    }
    
}


// MARK: - UICollectionViewDelegate UICollectionViewDataSource
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "templateTypeCell", for: indexPath) as? BlockTypeCell else { return UICollectionViewCell() }
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

extension BlockBuilderVC: AddBlockDelegate, AddLogicNodeDelegate {
    
    
    
    func didPressAddBlock() {
        let newBlock = BlockService.instance.blocks.first!
        caocapBlocks.append(newBlock)
        blocksTableView.reloadData()
        structureTableView.reloadData()
    }
    
    func addLogic(node: LogicNode) {
        switch logicTreeClimber.count {
        case 0:
            return caocapLogicNodes.append(node)
        case 1:
            return caocapLogicNodes[logicTreeClimber[0]].content.append(node)
        case 2:
            return caocapLogicNodes[logicTreeClimber[0]].content[logicTreeClimber[1]].content.append(node)
        case 3:
            return caocapLogicNodes[logicTreeClimber[0]].content[logicTreeClimber[1]].content[logicTreeClimber[2]].content.append(node)
        case 4:
            return caocapLogicNodes[logicTreeClimber[0]].content[logicTreeClimber[1]].content[logicTreeClimber[2]].content[logicTreeClimber[3]].content.append(node)
        default:
            return
        }
    }
    
    func didPressAddLogicNode() {
        let newNode: LogicNode
        switch logicTreeClimber.count {
        case 0:
            newNode = LogicNodeService.logicNodes.events.first!
        case 1:
            newNode = LogicNodeService.logicNodes.conditions.first!
        case 2:
            newNode = LogicNodeService.logicNodes.flows.first!
        case 3:
            newNode = LogicNodeService.logicNodes.actions.first!
        case 4:
            newNode = LogicNodeService.logicNodes.values.first!
        default:
            return
        }
        addLogic(node: newNode)
        logicTableView.reloadData()
    }
    
    func didPressBackButton() {
        logicTreeClimber.removeLast()
        logicTableView.reloadData()
    }
    
}

