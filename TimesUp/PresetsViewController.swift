//
//  PresetsViewController.swift
//  TimesUp
//
//  Created by Christopher San Diego on 10/13/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

import UIKit
import CoreData

class PresetsViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var persistentContainer: NSPersistentContainer!
    lazy var fetchedResultsController: NSFetchedResultsController<Preset> = {
        let request: NSFetchRequest<Preset> = Preset.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        try! controller.performFetch()
        return controller
    }()
    lazy var formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    lazy var emptyView: UIView = Bundle.main.loadNibNamed("EmptyView", owner: self, options: nil)!.first as! UIView

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelectionDuringEditing = true
        if fetchedResultsController.fetchedObjects!.count == 0 {
            tableView.backgroundView = emptyView
            tableView.separatorStyle = .none
        } else {
            navigationItem.setRightBarButton(editButtonItem, animated: false)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "newPreset":
            let viewController = segue.destination as! NewPresetViewController
            viewController.persistentContainer = persistentContainer
        case "showTimer":
            let viewController = segue.destination as! TimerViewController
            viewController.preset = fetchedResultsController.object(at: tableView.indexPathForSelectedRow!)
        case "editPreset":
            let viewController = segue.destination as! EditPresetViewController
            viewController.persistentContainer = persistentContainer
            viewController.preset = fetchedResultsController.object(at: tableView.indexPathForSelectedRow!)
        default:
            break
        }
    }
    
    func bindCell(_ cell: UITableViewCell, _ indexPath: IndexPath) {
        let preset = fetchedResultsController.object(at: indexPath)
        cell.textLabel!.text = preset.name
        cell.detailTextLabel!.text = formatter.string(from: preset.duration)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell")!
        bindCell(cell, indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: NSLocalizedString("Delete", comment: "Delete")) { _, _, completionHandler in
            let context = self.persistentContainer.viewContext
            context.delete(self.fetchedResultsController.object(at: indexPath))
            try! context.save()
            completionHandler(true)
        }
        let config = UISwipeActionsConfiguration(actions: [action])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: isEditing ? "editPreset" : "showTimer", sender: self)
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if tableView.backgroundView != nil {
                tableView.backgroundView = nil
                tableView.separatorStyle = .singleLine
                navigationItem.setRightBarButton(editButtonItem, animated: true)
            }
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            if controller.fetchedObjects!.count == 0 {
                tableView.backgroundView = emptyView
                tableView.separatorStyle = .none
                navigationItem.setRightBarButton(nil, animated: true)
            }
        case .update:
            bindCell(tableView.cellForRow(at: indexPath!)!, indexPath!)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        default:
            break
        }
    }
}

