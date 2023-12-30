//
//  NetworkMonitorManager.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/29/23.
//

import Foundation
import Network

final class NetworkMonitorManager: ObservableObject {
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")
    @Published private(set) var isConnected = false
    
    init() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        
        networkMonitor.start(queue: workerQueue)
    }

}
