//
//  TimerListTableViewController.swift
//  Coffee Timer
//
//  Created by Ash Furrow on 2015-01-10.
//  Copyright (c) 2015 Ash Furrow. All rights reserved.
//

import UIKit

    extension Array {
        mutating func moveFrom(source: Int, toDestination destination: Int) {
            let object = removeAtIndex(source)
            insert(object, atIndex: destination)
        }
    }

class TimerListTableViewController: UITableViewController {
    var coffeeTimers: [TimerModel]!
    var teaTimers: [TimerModel]!

    enum TableSection: Int {
        case Coffee = 0
        case Tea
        case NumberOfSections
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        coffeeTimers = [
            TimerModel(name: "Colombian", duration: 240, type: .Coffee),
            TimerModel(name: "Mexican", duration: 200, type: .Coffee)
        ]
        teaTimers = [
            TimerModel(name: "Green Tea", duration: 400, type: .Tea),
            TimerModel(name: "Oolong", duration: 400, type: .Tea),
            TimerModel(name: "Rooibos", duration: 480, type: .Tea)
        ]

        navigationItem.leftBarButtonItem = editButtonItem()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if presentedViewController != nil {
            tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return TableSection.NumberOfSections.rawValue
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == TableSection.Coffee.rawValue {
            return coffeeTimers.count
        } else { // Must be section TableSection.Tea
            return teaTimers.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let timerModel = timerModelForIndexPath(indexPath)
        cell.textLabel?.text = timerModel.name

        return cell
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == TableSection.Coffee.rawValue {
            return "Coffees"
        } else { // Must be TableSection.Tea
            return "Teas"
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.editing {
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            performSegueWithIdentifier("editDetail", sender: cell)
        }
    }

    override func tableView(tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, canPerformAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        if action == "copy:" {
            return true
        }

        return false
    }

    override func tableView(tableView: UITableView, performAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject!) {
        let timerModel = timerModelForIndexPath(indexPath)
        let pasteboard = UIPasteboard.generalPasteboard()
        pasteboard.string = timerModel.name
    }

    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        if sourceIndexPath.section == TableSection.Coffee.rawValue {
            coffeeTimers.moveFrom(sourceIndexPath.row, toDestination: destinationIndexPath.row)
        } else { // Must be TableSection.Tea
            teaTimers.moveFrom(sourceIndexPath.row, toDestination: destinationIndexPath.row)
        }
    }

    override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        // If the source and destination index paths are the same section,
        // then return the proposed index path
        if sourceIndexPath.section == proposedDestinationIndexPath.section {
            return proposedDestinationIndexPath
        }

        // The sections are different, which we want to disallow.
        if sourceIndexPath.section == TableSection.Coffee.rawValue {
            // This is coming from the coffee section, so return
            // the last index path in that section.

            return NSIndexPath(forItem: coffeeTimers.count - 1, inSection: 0)
        } else { // Must be TableSection.Tea
            // This is coming from the tea section, so return
            // the first index path in that section.

            return NSIndexPath(forItem: 0, inSection: 1)
        }
    }

    // MARK: - Utility methods

    func timerModelForIndexPath(indexPath: NSIndexPath) -> TimerModel {
        if indexPath.section == TableSection.Coffee.rawValue {
            return coffeeTimers[indexPath.row]
        } else { // Must be TableSection.Tea
            return teaTimers[indexPath.row]
        }
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let cell = sender as? UITableViewCell {
            let indexPath = tableView.indexPathForCell(cell)!

            let timerModel = timerModelForIndexPath(indexPath)

            if segue.identifier == "pushDetail" {
                let detailViewController = segue.destinationViewController as! TimerDetailViewController
                detailViewController.timerModel = timerModel
            } else if segue.identifier == "editDetail" {
                let navigationController = segue.destinationViewController as! UINavigationController
                let editViewController = navigationController.topViewController as! TimerEditViewController

                editViewController.timerModel = timerModel
                editViewController.delegate = self // Note the new line
            }
        } else if let _ = sender as? UIBarButtonItem {
            if segue.identifier == "newTimer" {
                let navigationController = segue.destinationViewController as! UINavigationController
                let editViewController = navigationController.topViewController as! TimerEditViewController

                editViewController.creatingNewTimer = true
                editViewController.timerModel = TimerModel(name: "", duration: 240, type: .Coffee)
                editViewController.delegate = self // Note the new line
            }
        }
    }

    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier == "pushDetail" {
            if tableView.editing {
                return false
            }
        }

        return true
    }
}

extension TimerListTableViewController: TimerEditViewControllerDelegate {
    func timerEditViewControllerDidCancel(viewController: TimerEditViewController) {
        // Nothing to do for now
    }

    func timerEditViewControllerDidSave(viewController: TimerEditViewController) {
        let model = viewController.timerModel
        let type = model.type

        if type == .Coffee {
            if !coffeeTimers.contains(model) {
                coffeeTimers.append(model)
            }

            teaTimers = teaTimers.filter({ (item) -> Bool in
                return item != model
            })
        } else { // Type must be .Tea
            if !teaTimers.contains(model) {
                teaTimers.append(model)
            }

            coffeeTimers = coffeeTimers.filter({ (item) -> Bool in
                return item != model
            })
        }
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the data from the array.

            if indexPath.section == TableSection.Coffee.rawValue {
                coffeeTimers.removeAtIndex(indexPath.row)
            } else { // Must be TableSection.Tea
                teaTimers.removeAtIndex(indexPath.row)
            }

            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
}
