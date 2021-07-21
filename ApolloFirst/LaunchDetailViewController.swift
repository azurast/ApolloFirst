//
//  LaunchesDetailViewController.swift
//  ApolloFirst
//
//  Created by Azura Sakan Taufik on 20/07/21.
//

import UIKit
import Apollo

class LaunchDetailViewController: UIViewController {

    @IBOutlet weak var launchLabel: UILabel!
    var selectedRow: Int!
    var launchID: GraphQLID? {
        didSet {
            self.configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }
    
    func configureView() {
        print("this line is executed")
        guard
            let label = self.launchLabel,
            let id = self.launchID else {
            return
        }
        
        label.text = "Launch \(id)"
    }

}
