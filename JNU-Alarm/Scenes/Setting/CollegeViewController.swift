//
//  CollegeViewController.swift
//  JNU-Alarm
//
//  Created by 우진 on 2/20/24.
//

import UIKit
import FirebaseMessaging

class CollegeViewController: UIViewController {

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
        navigationItem.title = "단과대 설정"
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
        models.append(Section(title: "각 단과대 홈페이지에 새 공지사항이 올라오면 알려드립니다.", options: [
            .switchCell(model: SettingsSwitchOption(title: "경영대학", icon: UIImage(systemName: "building.columns"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: ConfigData.get(topic: "cba"), topic: "cba")),
            .switchCell(model: SettingsSwitchOption(title: "공과대학", icon: UIImage(systemName: "building.columns"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: ConfigData.get(topic: "eng"), topic: "eng")),
            .switchCell(model: SettingsSwitchOption(title: "농업생명과학대학", icon: UIImage(systemName: "building.columns"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: ConfigData.get(topic: "agric"), topic: "agric")),
            // 여기부터 이어서 작성
            .switchCell(model: SettingsSwitchOption(title: "사범대학", icon: UIImage(systemName: "building.columns"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: ConfigData.get(topic: "education"), topic: "education")),
            .switchCell(model: SettingsSwitchOption(title: "사회과학대학", icon: UIImage(systemName: "building.columns"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: ConfigData.get(topic: "socsci"), topic: "socsci")),
            .switchCell(model: SettingsSwitchOption(title: "생활과학대학", icon: UIImage(systemName: "building.columns"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: ConfigData.get(topic: "humanecology"), topic: "humanecology")),
            .switchCell(model: SettingsSwitchOption(title: "수의과대학", icon: UIImage(systemName: "building.columns"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: ConfigData.get(topic: "vetmed"), topic: "vetmed")),
            .switchCell(model: SettingsSwitchOption(title: "약학대학", icon: UIImage(systemName: "building.columns"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: ConfigData.get(topic: "pharmacy"), topic: "pharmacy")),
            .switchCell(model: SettingsSwitchOption(title: "예술대학", icon: UIImage(systemName: "building.columns"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: ConfigData.get(topic: "arts"), topic: "arts")),
            .switchCell(model: SettingsSwitchOption(title: "의과대학", icon: UIImage(systemName: "building.columns"), iconBackgroundColor: .systemGreen, handler: {
                Alert.showAlert(title: "안내", message: "서비스 준비중입니다.")
            }, isOn: ConfigData.get(topic: "medicine"), topic: "medicine", isEnabled: false)),
            .switchCell(model: SettingsSwitchOption(title: "인문대학", icon: UIImage(systemName: "building.columns"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: ConfigData.get(topic: "human"), topic: "human")),
            .switchCell(model: SettingsSwitchOption(title: "자연과학대학", icon: UIImage(systemName: "building.columns"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: ConfigData.get(topic: "natural"), topic: "natural")),
            .switchCell(model: SettingsSwitchOption(title: "AI융합대학", icon: UIImage(systemName: "building.columns"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: ConfigData.get(topic: "cvg"), topic: "cvg")),
            .switchCell(model: SettingsSwitchOption(title: "공학대학", icon: UIImage(systemName: "building.columns"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: ConfigData.get(topic: "engc"), topic: "engc")),
            .switchCell(model: SettingsSwitchOption(title: "문화사회과학대학", icon: UIImage(systemName: "building.columns"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: ConfigData.get(topic: "yculture"), topic: "yculture")),
            .switchCell(model: SettingsSwitchOption(title: "수산해양대학", icon: UIImage(systemName: "building.columns"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: ConfigData.get(topic: "sea"), topic: "sea")),
        ]))
    }
}

extension CollegeViewController: UITableViewDelegate {
    
}

extension CollegeViewController: UITableViewDataSource {
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
