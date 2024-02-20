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
}

enum SettingsOptionType {
    case staticCell(model: SettingsOption)
    case switchCell(model: SettingsSwitchOption)
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
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
    }
    
    func setupNavigationController() {
        navigationItem.title = "설정"
//        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func getConfigData(topic: String) -> Bool {
        return UserDefaults.standard.bool(forKey: topic)
    }
    
    func setConfigData(isOn: Bool, topic: String) {
        UserDefaults.standard.set(isOn, forKey: topic)
        print("\(topic)이 \(isOn)으로 설정됨.")
        
        guard var notiData: [String] = UserDefaults.standard.array(forKey: "notifications") as? [String] else {return}
        
        if isOn {
            notiData.append(topic)
        } else {
            guard let idx = notiData.firstIndex(of: topic) else {return}
            notiData.remove(at: idx)
        }
        UserDefaults.standard.set(notiData, forKey: "notifications")
//        print("알림 내역 설정 상태 : \(UserDefaults.standard.array(forKey: "notifications"))")
    }
    
    func configure() {
        models.append(Section(title: "일반", options: [
            .staticCell(model: SettingsOption(title: "설명", icon: UIImage(systemName: "text.quote"), iconBackgroundColor: .systemTeal) {
                
            }),
            .switchCell(model: SettingsSwitchOption(title: "학교 날씨", icon: UIImage(systemName: "cloud.sun"), iconBackgroundColor: .link, handler: {
                
            }, isOn: getConfigData(topic: "weather"), topic: "weather")),
            .switchCell(model: SettingsSwitchOption(title: "긴급 알림", icon: UIImage(systemName: "light.beacon.max"), iconBackgroundColor: .systemRed, handler: {
                
            }, isOn: getConfigData(topic: "emergency"), topic: "emergency")),
        ]))
        
        models.append(Section(title: "대학", options: [
            .switchCell(model: SettingsSwitchOption(title: "학사 알림", icon: UIImage(systemName: "graduationcap"), iconBackgroundColor: .systemGreen, handler: {
                
            }, isOn: getConfigData(topic: "academic"), topic: "academic")),
            .switchCell(model: SettingsSwitchOption(title: "장학 알림", icon: UIImage(systemName: "newspaper"), iconBackgroundColor: .systemGreen, handler: {
                
            }, isOn: getConfigData(topic: "scholarship"), topic: "scholarship")),
            .staticCell(model: SettingsOption(title: "단과대 알림", icon: UIImage(systemName: "building.columns"), iconBackgroundColor: .systemGreen) {
                
            }),
            .staticCell(model: SettingsOption(title: "학과 알림", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen) {
                
            }),
        ]))
        
        models.append(Section(title: "기타", options: [
            .staticCell(model: SettingsOption(title: "사업단 알림", icon: UIImage(systemName: "building.2"), iconBackgroundColor: .systemOrange) {
                
            }),
            .staticCell(model: SettingsOption(title: "문의 및 제안", icon: UIImage(systemName: "person.wave.2"), iconBackgroundColor: .systemPink) {
                
            }),
        ]))
    }
    
    func subscribeFcmTopic(topic: String) {
        Messaging.messaging().subscribe(toTopic: topic) { error in
            if let error = error {
                print("Error subscribe: \(error)")
              } else {
                  print("Subscribed to \(topic) topic")
              }
        }
    }
    
    func unSubscribeFcmTopic(topic: String) {
        Messaging.messaging().unsubscribe(fromTopic: topic) { error in
            if let error = error {
                print("Error unsubscribe: \(error)")
              } else {
                  print("Unsubscribed to \(topic) topic")
              }
        }
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
            cell.switchValueChanged = { isOn in
                if isOn {
                    print("\(model.topic) 구독 시작")
                    self.subscribeFcmTopic(topic: model.topic) // 또는 전달하고자 하는 다른 주제
                } else {
                    print("\(model.topic) 구독 취소 시작")
                    self.unSubscribeFcmTopic(topic: model.topic)
                }
                self.setConfigData(isOn: isOn, topic: model.topic)
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