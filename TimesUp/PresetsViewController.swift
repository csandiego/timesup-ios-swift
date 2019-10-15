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
    var selectedPreset: Preset?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        navigationItem.title = "Presets"
        navigationItem.largeTitleDisplayMode = .always
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newPreset))
        navigationItem.setRightBarButton(addButton, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell")!
        let preset = fetchedResultsController.object(at: indexPath)
        cell.textLabel!.text = preset.name
        cell.detailTextLabel!.text = String(
            format: "%02d:%02d:%02d",
            preset.hours,
            preset.minutes,
            preset.seconds
        )
        return cell
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return swipeActionConfigurationForRowAt(tableView, indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return swipeActionConfigurationForRowAt(tableView, indexPath: indexPath)
    }
    
    func swipeActionConfigurationForRowAt(_ tableView: UITableView, indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") {
            action, sourceView, completionHandler in
            let preset = self.fetchedResultsController.object(at: indexPath)
            let context = self.persistentContainer.viewContext
            context.delete(preset)
            try! context.save()
            completionHandler(true)
        }
        let config = UISwipeActionsConfiguration(actions: [action])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPreset = fetchedResultsController.object(at: indexPath)
        performSegue(withIdentifier: "showTimer", sender: self)
    }
    
    @objc func newPreset() {
        performSegue(withIdentifier: "newPreset", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "newPreset":
            let viewController = segue.destination as! NewPresetViewController
            viewController.persistentContainer = persistentContainer
        case "showTimer":
            let viewController = segue.destination as! TimerViewController
            viewController.persistentContainer = persistentContainer
            viewController.preset = selectedPreset!
        default:
            break
        }
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
            let cell = tableView.cellForRow(at: indexPath!)!
            let preset = fetchedResultsController.object(at: indexPath!)
            cell.textLabel!.text = preset.name
            cell.detailTextLabel!.text = String(
                format: "%02d:%02d:%02d",
                preset.hours,
                preset.minutes,
                preset.seconds
            )
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        @unknown default:
            break
        }
    }
}

