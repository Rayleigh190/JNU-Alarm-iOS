//
//  InfoViewController.swift
//  JNU-Alarm
//
//  Created by 우진 on 4/15/24.
//

import UIKit
import SafariServices

class InfoViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tabelView = UITableView(frame: .zero, style: .grouped)
        tabelView.register(StringTableViewCell.self, forCellReuseIdentifier: StringTableViewCell.indentifier)
        return tabelView
    }()
    
    var models = [Section]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configure()
        setupNavigationController()
        setupSubViews()
        tableView.delegate = self
        tableView.dataSource = self
    
    }
    
    func setupNavigationController() {
        navigationItem.title = "정보"
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
        models.append(Section(title: "가나다라마바사.", options: [
            .stringCell(model: SettingStringOption(title: "🚀 앱 버전", handler: {
                if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    Alert.showAlert(title: "현재 버전", message: "\(version)")
                }
            })),
            .stringCell(model: SettingStringOption(title: "🎯 업데이트 내역", handler: {
                self.showWebView(url: "https://wackitlab.notion.site/iOS-373883435fcb4dd5aada2723b0fef7e0")
            })),
            .stringCell(model: SettingStringOption(title: "🛡️ 개인정보 처리방침", handler: {
                self.showWebView(url: "https://wackitlab.notion.site/d6483585330d47cf8c3927c018d9075e")
            })),
            .stringCell(model: SettingStringOption(title: "🏠 공식페이지", handler: {
                self.showWebView(url: "https://wackitlab.notion.site/469d2c23433c48cca6965c3573058397")
            })),
        ]))
    }
    
    func showWebView(url: String) {
        guard let url = URL(string: url) else { return }
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .automatic
        self.present(safariVC, animated: true)
    }
 
}

extension InfoViewController: UITableViewDelegate {
    
}

extension InfoViewController: UITableViewDataSource {
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
        case .stringCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: StringTableViewCell.indentifier,
                for: indexPath
            ) as? StringTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
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
        case .stringCell(model: let model):
            model.handler()
        }
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let section = models[section]
//        return section.title
//    }
    
}
