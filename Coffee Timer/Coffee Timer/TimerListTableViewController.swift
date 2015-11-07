//
//  TimerListTableViewController.swift
//  Coffee Timer
//
//  Created by Ash Furrow on 2015-01-10.
//  Copyright (c) 2015 Ash Furrow. All rights reserved.
//

import UIKit
import CoreData

extension Array {
    mutating func moveFrom(source: Int, toDestination destination: Int) {
        let object = removeAtIndex(source)
        insert(object, atIndex: destination)
    }
}

class TimerListTableViewController: UITableViewController {

    var userReorderingCells = false
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "TimerModel")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "type", ascending: true),
            NSSortDescriptor(key: "displayOrder", ascending: true)
        ]

        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate().coreDataStack.managedObjectContext, sectionNameKeyPath: "type", cacheName: nil)
        controller.delegate = self
        return controller
    }()

    enum TableSection: Int {
        case Coffee = 0
        case Tea
        case NumberOfSections
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error fetching: \(error)")
        }

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
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections?[section]

        return sectionInfo?.numberOfObjects ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let timerModel = timerModelForIndexPath(indexPath)
        cell.textLabel?.text = timerModel.name

        return cell
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == TableSection.Coffee.rawValue {
            return NSLocalizedString("Coffees", comment: "Coffee section title")
        } else { // Must be TableSection.Tea
            return NSLocalizedString("Teas", comment: "Tea section title")
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard tableView.editing else { return }

        let cell = tableView.cellForRowAtIndexPath(indexPath)
        performSegueWithIdentifier("editDetail", sender: cell)
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
        userReorderingCells = true

        // Grab the section and the TimerModels in the section
        let sectionInfo = fetchedResultsController.sections?[sourceIndexPath.section]
        var objectsInSection = sectionInfo?.objects ?? []

        // Rearrange the order to match the user's actions
        // Note: this doesn't move anything in Core Data, just our objectsInSection array
        objectsInSection.moveFrom(sourceIndexPath.row, toDestination: destinationIndexPath.row)

        // The models are now in the correct order.
        // Update their displayOrder to match the new order.
        for i in 0..<objectsInSection.count {
            let model = objectsInSection[i] as? TimerModel
            model?.displayOrder = Int32(i)
        }

        userReorderingCells = false
        appDelegate().coreDataStack.save()
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

            let sectionInfo = fetchedResultsController.sections?[TableSection.Coffee.rawValue]

            let numberOfCoffeTimers = sectionInfo?.numberOfObjects ?? 0

            return NSIndexPath(forItem: numberOfCoffeTimers - 1, inSection: 0)
        } else { // Must be TableSection.Tea
            // This is coming from the tea section, so return
            // the first index path in that section.

            return NSIndexPath(forItem: 0, inSection: 1)
        }
    }

    // MARK: - Utility methods

    func timerModelForIndexPath(indexPath: NSIndexPath) -> TimerModel {
        return fetchedResultsController.objectAtIndexPath(indexPath) as! TimerModel
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
                editViewController.delegate = self
            }
        } else if let _ = sender as? UIBarButtonItem {
            if segue.identifier == "newTimer" {
                let navigationController = segue.destinationViewController as! UINavigationController
                let editViewController = navigationController.topViewController as! TimerEditViewController

                editViewController.creatingNewTimer = true

                editViewController.timerModel = NSEntityDescription.insertNewObjectForEntityForName("TimerModel", inManagedObjectContext: appDelegate().coreDataStack.managedObjectContext) as! TimerModel
                editViewController.delegate = self
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

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let timer = timerModelForIndexPath(indexPath)
            timer.managedObjectContext?.deleteObject(timer)
        }
    }
}

extension TimerListTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }

    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {

        guard userReorderingCells == false else { return }

        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        case .Move:
            tableView.moveRowAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
        case .Update:
            tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        }
    }

    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {

        guard userReorderingCells == false else { return }

        switch type {
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        default: break
        }
    }
}

extension TimerListTableViewController: TimerEditViewControllerDelegate {
    func timerEditViewControllerDidCancel(viewController: TimerEditViewController) {
        if viewController.creatingNewTimer {
            appDelegate().coreDataStack.managedObjectContext.deleteObject(viewController.timerModel)
        }
    }

    func timerEditViewControllerDidSave(viewController: TimerEditViewController) {
        appDelegate().coreDataStack.save()
    }
}
