//
//  ViewController.swift
//  Project7-Whitehouse Petitions
//
//  Created by Zeeshan Waheed on 09/02/2024.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//      using the url to get json data and the parsing it using function
        let urlString: String

//      creating a right bar button item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(credits))
        
//      creating a filter search field and a reset button
        navigationItem.leftBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filter)), UIBarButtonItem(title: "Reset", style: .done, target: self, action: #selector(reset))]
          
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                filteredPetitions = petitions
                return
            }
        }
        
        showError()
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
//  function to parse JSON
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()

            
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        print(petition.title)
        return cell
    }
    
//  connecting the DetailViewController using didselectrowat method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()

        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
//  creating credits bar button function
    @objc func credits() {
        let ac = UIAlertController(title: "Data Source", message: "This data comes from 'We The People API of the Whitehouse'", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "ok", style: .cancel))
        present(ac, animated: true)
    }
    
    
//  creating a search filter funciton
    @objc func filter() {
        let ac = UIAlertController(title: "Search for a string", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let searchString = UIAlertAction(title: "filter", style: .default) {
//          selecting the string entered in text field
            [weak self, weak ac] _ in
            guard let answer  = ac?.textFields?[0].text else { return }
            self?.submit(answer)
//          using a function submit and entering the word entered by the user
        }
        ac.addAction(searchString)
        ac.addAction(UIAlertAction(title: "cancel", style: .cancel))
        present(ac, animated: true)
    }
    
//  a function where it clears the petitions array and then checks whether the input entered is contained in the petitions title row and appends that to the filtered petitions array
    func submit(_ answer: String) {
        filteredPetitions.removeAll(keepingCapacity: true)
        for row in petitions {
            if row.title.contains(answer){
                filteredPetitions.append(row)
                tableView.reloadData()
            }
        }
    }
    
//  to reset the petitions list
    @objc func reset() {
        filteredPetitions = petitions
        tableView.reloadData()
    }
}


