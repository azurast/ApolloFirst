//
//  ViewController.swift
//  ApolloFirst
//
//  Created by Azura Sakan Taufik on 20/07/21.
//

import UIKit

class LaunchesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var launchDetailVC: LaunchDetailViewController? = nil
    var launches = [LaunchListQuery.Data.Launch.Launch]()
    enum ListSection: Int, CaseIterable {
      case launches
    }
    
    // Components
    @IBOutlet weak var launchesTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Launches"
        launchesTable.delegate = self
        launchesTable.dataSource = self
        self.loadLaunches()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ListSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let listSection = ListSection(rawValue: section) else {
            assertionFailure("Invalid Section")
            return 0
        }
        
        switch listSection {
        case .launches:
            return self.launches.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LaunchesTableViewCell
        
        guard let listSection = ListSection(rawValue: indexPath.section) else {
            assertionFailure("Invalid Section")
            return cell
        }
        
        switch listSection {
          case .launches:
            let launch = self.launches[indexPath.row]
            cell.launchLable?.text = launch.site
          }
          return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let launch = self.launches[indexPath.row]
        let launchDetailVC = LaunchDetailViewController()
        launchDetailVC.title = launch.site
        launchDetailVC.launchID = launch.id
        navigationController?.pushViewController(launchDetailVC, animated: true)
    }
    
    private func loadLaunches() {
        Network.shared.apollo.fetch(query: LaunchListQuery()) {
            [weak self] result in
            guard let self = self else {
                return
            }
            
            defer {
                self.launchesTable.reloadData()
            }
            
            switch result {
            case .success(let graphQLResult):
                if let launchConnection = graphQLResult.data?.launches {
                  self.launches.append(contentsOf: launchConnection.launches.compactMap { $0 })
                }
                        
                if let errors = graphQLResult.errors {
                  let message = errors
                        .map { $0.localizedDescription }
                        .joined(separator: "\n")
                  self.showErrorAlert(title: "GraphQL Error(s)",
                                      message: message)
                }
            case .failure(let error):
                self.showErrorAlert(title: "Network Error", message: error.localizedDescription)
            }
        }
    }

    private func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        alert.present(alert, animated: true)
    }
}
