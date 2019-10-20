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
    var fetchedResultsController: NSFetchedResultsController<Preset>!

    override func viewDidLoad() {
        super.viewDidLoad()
        let request: NSFetchRequest<Preset> = Preset.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultsController.delegate = self
        try! fetchedResultsController.performFetch()
        tableView.allowsSelectionDuringEditing = true
        navigationItem.setRightBarButton(editButtonItem, animated: false)
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
        cell.detailTextLabel!.text = String(
            format: "%02d:%02d:%02d",
            preset.hours,
            preset.minutes,
            preset.seconds
        )
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
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
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

