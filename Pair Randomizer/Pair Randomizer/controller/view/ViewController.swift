//
//  ViewController.swift
//  Pair Randomizer
//
//  Created by Gavin Craft on 5/21/21.
//

import UIKit

class ViewController: UIViewController, RandomDelegate {
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        GroupController.shared.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    
    //MARK: - actions
    @IBAction func randomizeButtonPressed(_ sender: Any) {
        GroupController.shared.randomize()
    }
    @IBAction func addButtonPressed(_ sender: Any) {
        presentAlertForTheyThemCreation()
    }
    
    //MARK: - funcs
    func wasRandomized(){
        tableView.reloadData()
    }
    func presentAlertForTheyThemCreation(){
        let alertCon = UIAlertController(title: "create man", message: nil, preferredStyle: .alert)
        alertCon.addTextField { textField in
            textField.placeholder = "man name"
        }
        let calcelAction = UIAlertAction(title: "calcel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "add", style: .default) { _ in
            guard let name = alertCon.textFields![0].text, !name.isEmpty else {return}
            GroupController.shared.createPerson(name: name)
            GroupController.shared.groupPeople()
        }
        alertCon.addAction(addAction)
        alertCon.addAction(calcelAction)
        present(alertCon, animated: true)
    }
}

extension ViewController:  UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GroupController.shared.pairs[section].people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath)
        var person:Man = GroupController.shared.pairs[indexPath.section].people[indexPath.row]
        cell.textLabel?.text = person.name
        print("made person \(person.name)", indexPath.section, indexPath.row)
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section==0 && !(GroupController.shared.ungroupedPeople.isEmpty){
            return "ungrouped"
        }
        else{return "group \(section+1)"}
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var t = GroupController.shared.ungroupedPeople.count==0 ? GroupController.shared.pairs.count : GroupController.shared.pairs.count
        print(t, GroupController.shared.ungroupedPeople.isEmpty)
        return t
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        GroupController.shared.deleteLoosePerson(GroupController.shared.pairs[indexPath.section].people[indexPath.row])
        tableView.reloadData()
        //tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
