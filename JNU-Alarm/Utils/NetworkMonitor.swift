//
//  NetworkCheck.swift
//  JNU-Alarm
//
//  Created by 우진 on 4/17/24.
//

import Foundation
import Network

final class NetworkMonitor{
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    public private(set) var isConnected: Bool = false
    public private(set) var connectionType: ConnectionType = .unknown
    
    // 연결 타입
    enum ConnectionType{
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    // monotior 초기화
    private init(){
        print("NetworkMonitor - init(): 모니터 초기화")
        monitor = NWPathMonitor()
    }
    
    // Network Monitoring 시작
    public func startMonitoring(){
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            print("NetworkMonitor - path : \(path)")
            self?.isConnected = path.status == .satisfied
            self?.getConnectionType(path)
            
            if self?.isConnected == true{
                print("NetworkMonitor - startMonitoring(): 네트워크 연결 됨")
            } else {
                print("NetworkMonitor - startMonitoring(): 네트워크 연결 오류")
            }
            
        }
    }
    
    // Network Monitoring 종료
    public func stopMonitoring(){
        print("NetworkMonitor - stopMonitoring(): 모니터 종료")
        monitor.cancel()
    }
    
    // Network 연결 타입가져오기.
    private func getConnectionType(_ path: NWPath){
        if path.usesInterfaceType(.wifi){
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular){
            connectionType = .cellular
        } else if path.usesInterfaceType(.wiredEthernet){
            connectionType = .ethernet
        } else {
            connectionType = .unknown
        }
    }
}
