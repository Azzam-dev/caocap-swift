//
//  WorkStationVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 25/08/2021.
//  Copyright © 2021 Ficruty. All rights reserved.
//

import UIKit
import ReSwift

class WorkStationVC: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var artView: UIView!
    @IBOutlet weak var logicView: UIView!
    
    @IBOutlet weak var blocksCollectionView: UICollectionView!
    @IBOutlet weak var logicNodesCollectionView: UICollectionView!
    
    @IBOutlet weak var toolsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var gestureRecognizerView: UIView!
    
    @IBOutlet weak var stylesTableView: UITableView!
    @IBOutlet weak var structureTableView: UITableView!
    
    var toolsSelectedIndex = 0
    var openedCaocap: Caocap?
    
    var logicMindMapVC: LogicMindMapVC?
    var artCanvasVC: ArtCanvasVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gestureRecognizerSetup()
        getCaocapData()
        registerdUINib()
        addSubViews()
        
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
        addChild(logicMindMapVC!)
        addChild(artCanvasVC!)
        
        logicMindMapVC!.view.frame = logicView.frame
        artCanvasVC!.view.frame = artView.frame
        
        logicView.addSubview(logicMindMapVC!.view)
        artView.addSubview(artCanvasVC!.view)
        
        logicMindMapVC!.didMove(toParent: self)
        artCanvasVC!.didMove(toParent: self)
        
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
                
                self.artView.isHidden = false
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
                
                self.artView.isHidden = true
                self.blocksCollectionView.isHidden = true
            }
        }
    }
    
}


// MARK: - UITableViewDelegate UITableViewDataSource
extension WorkStationVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case structureTableView:
            return (artCanvasVC?.caocapBlocks.count)!
        case stylesTableView:
            guard let editingBlock = artCanvasVC?.editingBlock else { return 0 }
            return editingBlock.styles.count
            
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case structureTableView:
            let cell = structureTableView.dequeueReusableCell(withIdentifier: "structureCell", for: indexPath)
            cell.textLabel?.text = artCanvasVC?.caocapBlocks[indexPath.row].type.rawValue
            return cell
        case stylesTableView:
            let cell = UITableViewCell() //TODO: - getStyleCell
            
            cell.textLabel?.text = artCanvasVC?.editingBlock?.styles[indexPath.row].title
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    fileprivate func reloadBlockTableViews() {
        artCanvasVC?.editingBlock = nil
        self.structureTableView.reloadData()
        self.stylesTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView == structureTableView {
            let delete = UIContextualAction(style: .destructive, title: "remove") { (_, _, _) in
                self.artCanvasVC?.caocapBlocks.remove(at: indexPath.row)
                self.reloadBlockTableViews()
            }
            
            let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
            swipeActionConfig.performsFirstActionWithFullSwipe = false
            return swipeActionConfig
        }
        
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if tableView == structureTableView {
            guard let movedBlock = artCanvasVC?.caocapBlocks[sourceIndexPath.row] else { return }
            artCanvasVC?.caocapBlocks.remove(at: sourceIndexPath.row)
            artCanvasVC?.caocapBlocks.insert(movedBlock, at: destinationIndexPath.row)
            reloadBlockTableViews()
        }
    }
    
}


// MARK: - UICollectionViewDelegate UICollectionViewDataSource
extension WorkStationVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case blocksCollectionView:
            return (artCanvasVC?.blocksArray.count)!
        case logicNodesCollectionView:
            guard let logicMindMapVC = logicMindMapVC else { return 0 }
            return logicMindMapVC.logicNodesArray.count
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case blocksCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "templateTypeCell", for: indexPath) as? BlockTypeCell else { return UICollectionViewCell() }
            cell.configure(template: (artCanvasVC?.blocksArray[indexPath.row])!)
            return cell
        case logicNodesCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "logicNodeTypeCell", for: indexPath) as? LogicNodeTypeCell else { return UICollectionViewCell() }
            guard let logicMindMapVC = logicMindMapVC else { return UICollectionViewCell() }
            cell.configure(logicNode: logicMindMapVC.logicNodesArray[indexPath.row])
            return cell
        default:
            return UICollectionViewCell()
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case blocksCollectionView:
            artCanvasVC?.caocapBlocks.append((artCanvasVC?.blocksArray[indexPath.row])!)
            reloadBlockTableViews()
        case logicNodesCollectionView:
            guard let logicMindMapVC = logicMindMapVC else { return }
            logicMindMapVC.addLogic(node: logicMindMapVC.logicNodesArray[indexPath.row])
        default:
            return
        }
    }
    
    
}

extension WorkStationVC: StoreSubscriber {
    
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

extension WorkStationVC: AddBlockDelegate {
    
    
    
    func didPressAddBlock() {
        let newBlock = BlockService.instance.blocks.first!
        artCanvasVC?.caocapBlocks.append(newBlock)
        reloadBlockTableViews()
    }
    
}

