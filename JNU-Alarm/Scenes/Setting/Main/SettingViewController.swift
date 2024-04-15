//
//  SettingViewController.swift
//  JNU-Alarm
//
//  Created by 우진 on 2/14/24.
//

import UIKit
import FirebaseMessaging

struct SettingsOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let handler: (() -> Void)
}

struct SettingsSwitchOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let handler: (() -> Void)
    var isOn: Bool
    let topic: String
    var isEnabled = true
}

struct SettingStringOption {
    let title: String
    let handler: (() -> Void)
}

enum SettingsOptionType {
    case staticCell(model: SettingsOption)
    case switchCell(model: SettingsSwitchOption)
    case stringCell(model: SettingStringOption)
}

struct Section {
    let title: String
    let options: [SettingsOptionType]
}


class SettingViewController: UIViewController {
    
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
        navigationItem.title = "설정"
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
        models.append(Section(title: "일반", options: [
            .switchCell(model: SettingsSwitchOption(title: "기본 알림", icon: UIImage(systemName: "info.bubble"), iconBackgroundColor: .systemTeal, handler: {
                Alert.showAlert(title: "안내", message: "기본으로 제공되는 알림입니다.(서비스 공지)")
            }, isOn: true, topic: "basic", isEnabled: false)),
            .switchCell(model: SettingsSwitchOption(title: "홍보/광고", icon: UIImage(systemName: "giftcard"), iconBackgroundColor: .purple, handler: {
                Alert.showAlert(title: "안내", message: "홍보, 광고 알림입니다.")
            }, isOn: ConfigData.get(topic: "ad"), topic: "ad")),
        ]))
        
        models.append(Section(title: "대학", options: [
            .switchCell(model: SettingsSwitchOption(title: "학사 알림", icon: UIImage(systemName: "graduationcap"), iconBackgroundColor: .systemGreen, handler: {
                Alert.showAlert(title: "안내", message: "홈페이지 학사 게시판의 새 게시물을 알려드립니다.")
            }, isOn: ConfigData.get(topic: "academic"), topic: "academic")),
            .switchCell(model: SettingsSwitchOption(title: "장학 알림", icon: UIImage(systemName: "newspaper"), iconBackgroundColor: .systemGreen, handler: {
                Alert.showAlert(title: "안내", message: "홈페이지 장학 게시판의 새 게시물을 알려드립니다.")
            }, isOn: ConfigData.get(topic: "scholarship"), topic: "scholarship")),
            .staticCell(model: SettingsOption(title: "단과대 알림", icon: UIImage(systemName: "building.columns"), iconBackgroundColor: .systemGreen) {
                let vc = CollegeViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }),
            .staticCell(model: SettingsOption(title: "학과 알림", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen) {
                let vc = DepartmentViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }),
        ]))
        
        models.append(Section(title: "기타", options: [
            .staticCell(model: SettingsOption(title: "사업단 알림", icon: UIImage(systemName: "building.2"), iconBackgroundColor: .systemOrange) {
                let vc = BusinessViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }),
            .staticCell(model: SettingsOption(title: "문의 및 제안", icon: UIImage(systemName: "person.wave.2"), iconBackgroundColor: .systemPink) {
                let vc = ContactViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }),
            .staticCell(model: SettingsOption(title: "정보", icon: UIImage(systemName: "info.circle"), iconBackgroundColor: .systemBlue) {
                let vc = InfoViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }),
        ]))
        
        #if DEBUG
            models.append(Section(title: "개발자 모드", options: [
                .switchCell(model: SettingsSwitchOption(title: "테스트 알림", icon: UIImage(systemName: "testtube.2"), iconBackgroundColor: .cyan, handler: {
                }, isOn: ConfigData.get(topic: "test"), topic: "test")),
            ]))
        #else
            print("release mode..")
        #endif
    }
}

extension SettingViewController: UITableViewDelegate {
    
}

extension SettingViewController: UITableViewDataSource {
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
        case .stringCell(let model):
            model.handler()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = models[section]
        return section.title
    }
    
}
