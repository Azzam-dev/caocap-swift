//
//  LogicMindMapVC.swift
//  caocap
//
//  Created by CAOCAP inc on 29/08/1443 AH.
//  Copyright © 1443 Ficruty. All rights reserved.
//

import UIKit

class LogicMindMapVC: UIViewController, AddLogicNodeDelegate {
    
    @IBOutlet weak var logicTableView: UITableView!
    
    var caocapLogicNodes = [LogicNode]()
    var logicTreeClimber = [Int]()
    
    var logicNodesArray = LogicNodeService.logicNodes.events
    
    var workStationVC: WorkStationVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        logicTableView.contentInset.bottom = 400
    }

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
        guard let workStationVC = workStationVC else { return }
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
        workStationVC.logicNodesCollectionView.reloadData()
    }
    
    func addLogic(node: LogicNode) {
        switch logicTreeClimber.count {
        case 0:
            caocapLogicNodes.append(node)
        case 1:
            caocapLogicNodes[logicTreeClimber[0]].content.append(node)
        case 2:
            caocapLogicNodes[logicTreeClimber[0]].content[logicTreeClimber[1]].content.append(node)
        case 3:
            caocapLogicNodes[logicTreeClimber[0]].content[logicTreeClimber[1]].content[logicTreeClimber[2]].content.append(node)
        case 4:
            caocapLogicNodes[logicTreeClimber[0]].content[logicTreeClimber[1]].content[logicTreeClimber[2]].content[logicTreeClimber[3]].content.append(node)
        default:
            return
        }
        
        logicTableView.reloadData()
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
    }
    
    func didPressBackButton() {
        logicTreeClimber.removeLast()
        logicTableView.reloadData()
    }
}

extension LogicMindMapVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        updateLogicNodesArray()
        return getNumberOfLogicNodes() + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < getNumberOfLogicNodes() && logicTreeClimber.count < 4 {
            // enter the logic node ( E - C - F - A )
            logicTreeClimber.append(indexPath.row)
            logicTableView.reloadData()
        } else if indexPath.row < getNumberOfLogicNodes() {
            // Select a logic mode ( E - C - F - A - V )
            
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.row < caocapLogicNodes.count {
            let delete = UIContextualAction(style: .destructive, title: "remove") { (_, _, _) in
                self.caocapLogicNodes.remove(at: indexPath.row)
                self.logicTableView.reloadData()
            }
            
            let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
            swipeActionConfig.performsFirstActionWithFullSwipe = false
            return swipeActionConfig
        }
        
        return nil
    }
    
}
