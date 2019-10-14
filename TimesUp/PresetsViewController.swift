//
//  PresetsViewController.swift
//  TimesUp
//
//  Created by Christopher San Diego on 10/13/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

import UIKit
import CoreData

class PresetsViewController: UITableViewController {
    
    var persistentContainer: NSPersistentContainer!
    var fetchedResultsController: NSFetchedResultsController<Preset>!

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
        try! fetchedResultsController.performFetch()
        navigationItem.title = "Presets"
        navigationItem.largeTitleDisplayMode = .always
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
}

