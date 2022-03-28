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
    
    @IBOutlet weak var artView: DesignableView!
    @IBOutlet weak var artsObjectsCollectionView: UICollectionView!
    
    @IBOutlet weak var logicView: DesignableView!
    @IBOutlet weak var logicTableView: UITableView!
    @IBOutlet weak var logicNodesCollectionView: UICollectionView!
    
    @IBOutlet weak var toolsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var gestureRecognizerView: UIView!
    
    @IBOutlet weak var stylesTableView: UITableView!
    @IBOutlet weak var structureTableView: UITableView!
    
    var toolsSelectedIndex = 0
    var openedCaocap: Caocap?
    
    var logicNodesArray = [LogicNode]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gestureRecognizerSetup()
        getCaocapData()
        registerdUINib()
        addSubViews()
        
    }
    
    
    func getCaocapData() {
        guard let openedCaocapKey = openedCaocap?.key else { return }
        DataService.instance.getCaocap(withKey: openedCaocapKey) { caocap in
            // TODO: - getCaocapData
        }
    }
    
    
    func presentSelectedView(_ selectedView: UIView) {
        structureTableView.isHidden = true
        artsObjectsCollectionView.isHidden = true
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
                
                self.artView.isHidden = false
                self.artsObjectsCollectionView.isHidden = false
                
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
                self.artsObjectsCollectionView.isHidden = true
            }
        }
    }
    
}


extension ArtBuilderVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case structureTableView:
            return 0 //TODO: - fix structureTableView count
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
        case structureTableView:
            let cell = UITableViewCell()
            cell.textLabel?.text = "artObject" //TODO: - setup art Object names
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
    
}


extension ArtBuilderVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case artsObjectsCollectionView:
            return 0 //TODO: - artsObjectsCells count
        case logicNodesCollectionView:
            return logicNodesArray.count
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case artsObjectsCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "templateTypeCell", for: indexPath) as? BlockTypeCell else { return UICollectionViewCell() }
            // TODO: - setup cell.configure
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
        //TODO: - didSelectItemAt
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

