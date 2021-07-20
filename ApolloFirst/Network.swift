//
//  Network.swift
//  ApolloFirst
//
//  Created by Azura Sakan Taufik on 20/07/21.
//

import Foundation
import Apollo

class Network {
  static let shared = Network()
    
  private(set) lazy var apollo = ApolloClient(url: URL(string: "https://apollo-fullstack-tutorial.herokuapp.com")!)
}
