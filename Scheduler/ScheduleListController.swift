//
//  ViewController.swift
//  Scheduler
//
//  Created by Alex Paul on 11/20/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class ScheduleListController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // data - an array of events
    var events = [Event]()
    
    var isEditingTableView = false {
        didSet { // property observer
            // toggle editing mode of table view
            tableView.isEditing = isEditingTableView
            
            // toggle bar button item's title between "Edit" and "Done"
            navigationItem.leftBarButtonItem?.title = isEditingTableView ? "Done" : "Edit"
        }
    }
    
    lazy var dateFormatter:  DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy, hh:mm a"
        formatter.timeZone = .current
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // events = Event.getTestData().sorted { $0.date < $1.date }
        tableView.dataSource = self
        loadEvents()
        // print path to documents directory
        print(FileManager.getDocumentsDirectory())
    }
    
    private func loadEvents() {
        do {
            events = try PersistenceHelper.loadEvents().sorted {$0.date < $1.date}
        } catch {
            print("no events: \(error)")
        }
    }
    
    private func deleteEvent(index: IndexPath) {
        do {
            try PersistenceHelper.deleteEvents(index: index.row)
        } catch {
            print("\(error)")
        }
    }
    
    @IBAction func addNewEvent(segue: UIStoryboardSegue) {
        // caveman debugging
        
        // get a reference to the CreateEventController instance
        guard let createEventController = segue.source as? CreateEventController,
            let createdEvent = createEventController.event else {
                fatalError("failed to access CreateEventController")
        }
        
        // persist (save) to document directory
        do {
            try PersistenceHelper.create(item: createdEvent)
        } catch {
            print("Did not save the event: \(error)")
        }
        
        // insert new event into our events array
        // 1. update the data model e.g update the events array
        
        // insert new event into our events array
        events.append(createdEvent)
        
        // create an indexPath to be inserted into the table view
        let indexPath = IndexPath(row: events.count - 1, section: 0) // will represent top of table view
        
        // 2. we need to update the table view
        // use indexPath to insert into table view
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        isEditingTableView.toggle() // changes a boolean value
    }
}

extension ScheduleListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
        let event = events[indexPath.row]
        cell.textLabel?.text = event.name
        cell.detailTextLabel?.text = dateFormatter.string(from: event.date)
        return cell
    }
    
    // MARK:- deleting rows in a table view
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .insert:
            // only gets called if "insertion control" exist and gets selected
            print("inserting....")
        case .delete:
            print("deleting..")
            // 1. remove item for the data model e.g events
            events.remove(at: indexPath.row) // remove event from events array
            deleteEvent(index: indexPath)
            // 2. update the table view
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            print("......")
        }
    }
    
    // MARK:- reordering rows in a table view
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let eventToMove = events[sourceIndexPath.row] // save the event being moved
        events.remove(at: sourceIndexPath.row)
        events.insert(eventToMove, at: destinationIndexPath.row)
        
        PersistenceHelper.reorderEvents(events: events)
        do {
            events = try PersistenceHelper.loadEvents()
            tableView.reloadData()
        } catch {
            print("error loading events: \(error)")
        }
    }
}

