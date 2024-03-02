//
//  BusinessViewController.swift
//  JNU-Alarm
//
//  Created by 우진 on 2/21/24.
//

import UIKit
import FirebaseMessaging

class BusinessViewController: UIViewController {

    private let tableView: UITableView = {
        let tabelView = UITableView(frame: .zero, style: .grouped)
        tabelView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.indentifier)
        tabelView.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.indentifier)
        return tabelView
    }()
    
    var models = [Section]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupNavigationController()
        setupSubViews()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupNavigationController() {
        navigationItem.title = "사업단 설정"
//        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupSubViews() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func configure() {
        models.append(Section(title: "각 사업단 홈페이지에 새 공지사항이 올라오면 알려드립니다.", options: [
            .switchCell(model: SettingsSwitchOption(title: "소프트웨어중심대학사업단", icon: UIImage(systemName: "building.2"), iconBackgroundColor: .systemOrange, handler: {
                // 핸들러 구현
            }, isOn: ConfigData.get(topic: "sojoong"), topic: "sojoong")),
            .switchCell(model: SettingsSwitchOption(title: "인공지능혁신융합대학사업단", icon: UIImage(systemName: "building.2"), iconBackgroundColor: .systemOrange, handler: {
                // 핸들러 구현
            }, isOn: ConfigData.get(topic: "aicoss"), topic: "aicoss")),
        ]))
    }
}

extension BusinessViewController: UITableViewDelegate {
    
}

extension BusinessViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section].options[indexPath.row]
        
        switch model.self {
        case .staticCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingTableViewCell.indentifier,
                for: indexPath
            ) as? SettingTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
        case .switchCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SwitchTableViewCell.indentifier,
                for: indexPath
            ) as? SwitchTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            cell.switchValueChanged = { sender in
                SwitchButton.switchButtonTapped(sender: sender, topic: model.topic) {
                    self.models.removeAll()
                    self.configure()
                }
            }
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].options.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let type = models[indexPath.section].options[indexPath.row]
        switch type.self {
        case .staticCell(let model):
            model.handler()
        case .switchCell(let model):
            model.handler()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = models[section]
        return section.title
    }
    
}
