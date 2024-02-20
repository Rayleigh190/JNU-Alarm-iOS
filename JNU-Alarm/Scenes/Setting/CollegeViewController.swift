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
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
    }
    
    func setupNavigationController() {
        navigationItem.title = "단과대 설정"
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
        print("알림 내역 설정 상태 : \(String(describing: UserDefaults.standard.array(forKey: "notifications")))")
    }
    
    func configure() {
        models.append(Section(title: "단과대", options: [
            .switchCell(model: SettingsSwitchOption(title: "경영대학", icon: UIImage(systemName: "graduationcap"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "cba"), topic: "cba")),
            .switchCell(model: SettingsSwitchOption(title: "공과대학", icon: UIImage(systemName: "graduationcap"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "eng"), topic: "eng")),
            .switchCell(model: SettingsSwitchOption(title: "농업생명과학대학", icon: UIImage(systemName: "graduationcap"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "agric"), topic: "agric")),
            // 여기부터 이어서 작성
            .switchCell(model: SettingsSwitchOption(title: "사범대학", icon: UIImage(systemName: "graduationcap"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "education"), topic: "education")),
            .switchCell(model: SettingsSwitchOption(title: "사회과학대학", icon: UIImage(systemName: "graduationcap"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "socsci"), topic: "socsci")),
            .switchCell(model: SettingsSwitchOption(title: "생활과학대학", icon: UIImage(systemName: "graduationcap"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "humanecology"), topic: "humanecology")),
            .switchCell(model: SettingsSwitchOption(title: "수의과대학", icon: UIImage(systemName: "graduationcap"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "vetmed"), topic: "vetmed")),
            .switchCell(model: SettingsSwitchOption(title: "약학대학", icon: UIImage(systemName: "graduationcap"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "pharmacy"), topic: "pharmacy")),
            .switchCell(model: SettingsSwitchOption(title: "예술대학", icon: UIImage(systemName: "graduationcap"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "arts"), topic: "arts")),
            .switchCell(model: SettingsSwitchOption(title: "인문대학", icon: UIImage(systemName: "graduationcap"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "human"), topic: "human")),
            .switchCell(model: SettingsSwitchOption(title: "자연과학대학", icon: UIImage(systemName: "graduationcap"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "natural"), topic: "natural")),
            .switchCell(model: SettingsSwitchOption(title: "AI융합대학", icon: UIImage(systemName: "graduationcap"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "cvg"), topic: "cvg")),
            .switchCell(model: SettingsSwitchOption(title: "공학대학", icon: UIImage(systemName: "graduationcap"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "engc"), topic: "engc")),
            .switchCell(model: SettingsSwitchOption(title: "문화사회과학대학", icon: UIImage(systemName: "graduationcap"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "yculture"), topic: "yculture")),
            .switchCell(model: SettingsSwitchOption(title: "수산해양대학", icon: UIImage(systemName: "graduationcap"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "sea"), topic: "sea")),
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
