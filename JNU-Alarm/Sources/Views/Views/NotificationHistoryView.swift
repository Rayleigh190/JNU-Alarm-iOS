//
//  NotificationHistoryView.swift
//  JNU-Alarm
//
//  Created by 우진 on 6/23/24.
//

import UIKit

class NotificationHistoryView: UIView {
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "원하는 알림을 설정하세요!"
        label.textColor = .gray
        return label
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()        
        return refreshControl
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(NotificationHistoryTableViewCell.self, forCellReuseIdentifier: NotificationHistoryTableViewCell.indentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViews() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // infoLabel을 수평 및 수직 중앙에 배치
            infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            infoLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}

