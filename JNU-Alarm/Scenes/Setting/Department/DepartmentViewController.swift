//
//  DepartmentViewController.swift
//  JNU-Alarm
//
//  Created by 우진 on 2/20/24.
//

import UIKit
import FirebaseMessaging


class DepartmentViewController: UIViewController {

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
        navigationItem.title = "학과 설정"
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
        models.append(Section(title: "간호대학", options: [
            .switchCell(model: SettingsSwitchOption(title: "간호학과", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "nursing"), topic: "nursing")),
        ]))
        
        models.append(Section(title: "경영대학", options: [
            .switchCell(model: SettingsSwitchOption(title: "경영학부", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "biz"), topic: "biz")),
            .switchCell(model: SettingsSwitchOption(title: "경제학부", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "eco"), topic: "eco")),
        ]))
        
        models.append(Section(title: "공과대학", options: [
            .switchCell(model: SettingsSwitchOption(title: "건축학부", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "archi"), topic: "archi")),
            .switchCell(model: SettingsSwitchOption(title: "고분자융합소재공학부", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "pf"), topic: "pf")),
            .switchCell(model: SettingsSwitchOption(title: "기계공학부", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "mech"), topic: "mech")),
            .switchCell(model: SettingsSwitchOption(title: "생물공학과", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "bte"), topic: "bte")),
            .switchCell(model: SettingsSwitchOption(title: "신소재공학부", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "mse"), topic: "mse")),
            .switchCell(model: SettingsSwitchOption(title: "에너지자원공학과", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "resources"), topic: "resources")),
            .switchCell(model: SettingsSwitchOption(title: "화학공학부", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "ace"), topic: "ace")),
            .switchCell(model: SettingsSwitchOption(title: "전기공학과", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "elec"), topic: "elec")),
            .switchCell(model: SettingsSwitchOption(title: "전자공학과", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "ee"), topic: "ee")),
            .switchCell(model: SettingsSwitchOption(title: "컴퓨터정보통신공학과", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "ce"), topic: "ce")),
            .switchCell(model: SettingsSwitchOption(title: "소프트웨어공학과", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "sw"), topic: "sw")),
            .switchCell(model: SettingsSwitchOption(title: "토목공학과", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "civil"), topic: "civil")),
            .switchCell(model: SettingsSwitchOption(title: "환경에너지공학과", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "eee"), topic: "eee")),
        ]))
        
        models.append(Section(title: "농업생명과학대학", options: [
            .switchCell(model: SettingsSwitchOption(title: "응용식물학과", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "agro"), topic: "agro")),
            .switchCell(model: SettingsSwitchOption(title: "원예생명공학과", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "hort"), topic: "hort")),
            .switchCell(model: SettingsSwitchOption(title: "응용생물학과", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "agribio"), topic: "agribio")),
            .switchCell(model: SettingsSwitchOption(title: "산림자원학과", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "forestry"), topic: "forestry")),
            .switchCell(model: SettingsSwitchOption(title: "임산공학과", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "wood"), topic: "wood")),
            .switchCell(model: SettingsSwitchOption(title: "농생명화학과", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "agrochem"), topic: "agrochem")),
            .switchCell(model: SettingsSwitchOption(title: "식품공학과", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "foodsci"), topic: "foodsci")),
            .switchCell(model: SettingsSwitchOption(title: "분자생명공학과", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "mimb"), topic: "mimb")),
            .switchCell(model: SettingsSwitchOption(title: "동물자원학부", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "animalscience"), topic: "animalscience")),
            .switchCell(model: SettingsSwitchOption(title: "지역·바이오시스템공학과", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "rbe"), topic: "rbe")),
            .switchCell(model: SettingsSwitchOption(title: "농업경제학과", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "ae"), topic: "ae")),
            .switchCell(model: SettingsSwitchOption(title: "조경학과", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "jnula"), topic: "jnula")),
            .switchCell(model: SettingsSwitchOption(title: "바이오에너지공학과", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "bioenergy"), topic: "bioenergy")),
            .switchCell(model: SettingsSwitchOption(title: "융합바이오시스템기계공학과", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "bse"), topic: "bse")),
        ]))

        models.append(Section(title: "사범대학", options: [
            .switchCell(model: SettingsSwitchOption(title: "국어교육과", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "koredu"), topic: "koredu")),
            .switchCell(model: SettingsSwitchOption(title: "영어교육과", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "engedu"), topic: "engedu")),
            .switchCell(model: SettingsSwitchOption(title: "교육학과", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "educate"), topic: "educate")),
            .switchCell(model: SettingsSwitchOption(title: "유아교육과", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "ecedu"), topic: "ecedu")),
            .switchCell(model: SettingsSwitchOption(title: "지리교육과", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "geoedu"), topic: "geoedu")),
            .switchCell(model: SettingsSwitchOption(title: "역사교육과", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "hisedu"), topic: "hisedu")),
            .switchCell(model: SettingsSwitchOption(title: "윤리교육과", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "ethicsedu"), topic: "ethicsedu")),
            .switchCell(model: SettingsSwitchOption(title: "수학교육과", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "mathedu"), topic: "mathedu")),
            .switchCell(model: SettingsSwitchOption(title: "물리교육과", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "physicsedu"), topic: "physicsedu")),
            .switchCell(model: SettingsSwitchOption(title: "화학교육과", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "chemedu"), topic: "chemedu")),
            .switchCell(model: SettingsSwitchOption(title: "생물교육과", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "bioedu"), topic: "bioedu")),
            .switchCell(model: SettingsSwitchOption(title: "지구과학교육과", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "earthedu"), topic: "earthedu")),
            .switchCell(model: SettingsSwitchOption(title: "가정교육과", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "homeedu"), topic: "homeedu")),
            .switchCell(model: SettingsSwitchOption(title: "음악교육과", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "musicedu"), topic: "musicedu")),
            .switchCell(model: SettingsSwitchOption(title: "체육교육과", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "physicaledu"), topic: "physicaledu")),
            .switchCell(model: SettingsSwitchOption(title: "특수교육학부", icon: UIImage(systemName: "books.vertical"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "spededu"), topic: "spededu")),
        ]))

        models.append(Section(title: "사회과학대학", options: [
            .switchCell(model: SettingsSwitchOption(title: "정치외교학과", icon: UIImage(systemName: "person.3"), iconBackgroundColor: .systemBlue, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "politics"), topic: "politics")),
            .switchCell(model: SettingsSwitchOption(title: "사회학과", icon: UIImage(systemName: "person.3"), iconBackgroundColor: .systemBlue, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "sociology"), topic: "sociology")),
            .switchCell(model: SettingsSwitchOption(title: "심리학과", icon: UIImage(systemName: "person.3"), iconBackgroundColor: .systemBlue, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "psyche"), topic: "psyche")),
            .switchCell(model: SettingsSwitchOption(title: "신문방송학과", icon: UIImage(systemName: "person.3"), iconBackgroundColor: .systemBlue, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "comm"), topic: "comm")),
            .switchCell(model: SettingsSwitchOption(title: "지리학과", icon: UIImage(systemName: "person.3"), iconBackgroundColor: .systemBlue, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "geo"), topic: "geo")),
            .switchCell(model: SettingsSwitchOption(title: "문화인류고고학과", icon: UIImage(systemName: "person.3"), iconBackgroundColor: .systemBlue, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "illyu"), topic: "illyu")),
            .switchCell(model: SettingsSwitchOption(title: "행정학과", icon: UIImage(systemName: "person.3"), iconBackgroundColor: .systemBlue, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "jnupa"), topic: "jnupa")),
        ]))


        models.append(Section(title: "생활과학대학", options: [
            .switchCell(model: SettingsSwitchOption(title: "생활복지학과", icon: UIImage(systemName: "house"), iconBackgroundColor: .systemOrange, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "welfare"), topic: "welfare")),
            .switchCell(model: SettingsSwitchOption(title: "식품영양과학부", icon: UIImage(systemName: "house"), iconBackgroundColor: .systemOrange, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "fn"), topic: "fn")),
            .switchCell(model: SettingsSwitchOption(title: "의류학과", icon: UIImage(systemName: "house"), iconBackgroundColor: .systemOrange, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "clothing"), topic: "clothing")),
        ]))


        models.append(Section(title: "예술대학", options: [
            .switchCell(model: SettingsSwitchOption(title: "미술학과", icon: UIImage(systemName: "paintpalette"), iconBackgroundColor: .systemPurple, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "fineart"), topic: "fineart")),
            .switchCell(model: SettingsSwitchOption(title: "음악학과", icon: UIImage(systemName: "music.note"), iconBackgroundColor: .systemPurple, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "music"), topic: "music")),
            .switchCell(model: SettingsSwitchOption(title: "국악학과", icon: UIImage(systemName: "music.note"), iconBackgroundColor: .systemPurple, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "koreanmusic"), topic: "koreanmusic")),
            .switchCell(model: SettingsSwitchOption(title: "디자인학과", icon: UIImage(systemName: "square.and.pencil"), iconBackgroundColor: .systemPurple, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "design"), topic: "design")),
        ]))

        models.append(Section(title: "인문대학", options: [
            .switchCell(model: SettingsSwitchOption(title: "국어국문학과", icon: UIImage(systemName: "book"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "korean"), topic: "korean")),
            .switchCell(model: SettingsSwitchOption(title: "영어영문학과", icon: UIImage(systemName: "book"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "ell"), topic: "ell")),
            .switchCell(model: SettingsSwitchOption(title: "독일언어문학과", icon: UIImage(systemName: "book"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "german"), topic: "german")),
            .switchCell(model: SettingsSwitchOption(title: "불어불문학과", icon: UIImage(systemName: "book"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "french"), topic: "french")),
            .switchCell(model: SettingsSwitchOption(title: "중어중문학과", icon: UIImage(systemName: "book"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "china"), topic: "china")),
            .switchCell(model: SettingsSwitchOption(title: "일어일문학과", icon: UIImage(systemName: "book"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "nihon"), topic: "nihon")),
            .switchCell(model: SettingsSwitchOption(title: "사학과", icon: UIImage(systemName: "book"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "history"), topic: "history")),
            .switchCell(model: SettingsSwitchOption(title: "철학과", icon: UIImage(systemName: "book"), iconBackgroundColor: .systemGreen, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "philos"), topic: "philos")),
        ]))


        models.append(Section(title: "자연과학대학", options: [
            .switchCell(model: SettingsSwitchOption(title: "수학과", icon: UIImage(systemName: "pencil.and.outline"), iconBackgroundColor: .systemRed, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "math"), topic: "math")),
            .switchCell(model: SettingsSwitchOption(title: "통계학과", icon: UIImage(systemName: "pencil.and.outline"), iconBackgroundColor: .systemRed, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "stat"), topic: "stat")),
            .switchCell(model: SettingsSwitchOption(title: "물리학과", icon: UIImage(systemName: "pencil.and.outline"), iconBackgroundColor: .systemRed, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "physics"), topic: "physics")),
            .switchCell(model: SettingsSwitchOption(title: "지질환경전공", icon: UIImage(systemName: "pencil.and.outline"), iconBackgroundColor: .systemRed, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "geology"), topic: "geology")),
            .switchCell(model: SettingsSwitchOption(title: "해양환경전공", icon: UIImage(systemName: "pencil.and.outline"), iconBackgroundColor: .systemRed, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "oceanography"), topic: "oceanography")),
            .switchCell(model: SettingsSwitchOption(title: "화학과", icon: UIImage(systemName: "pencil.and.outline"), iconBackgroundColor: .systemRed, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "chem"), topic: "chem")),
            .switchCell(model: SettingsSwitchOption(title: "생물학과", icon: UIImage(systemName: "pencil.and.outline"), iconBackgroundColor: .systemRed, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "biology"), topic: "biology")),
            .switchCell(model: SettingsSwitchOption(title: "생명과학기술학부", icon: UIImage(systemName: "pencil.and.outline"), iconBackgroundColor: .systemRed, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "sbst"), topic: "sbst")),
        ]))

        models.append(Section(title: "AI융합대학", options: [
            .switchCell(model: SettingsSwitchOption(title: "인공지능학부", icon: UIImage(systemName: "gear"), iconBackgroundColor: .systemOrange, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "aisw"), topic: "aisw")),
            .switchCell(model: SettingsSwitchOption(title: "빅데이터융합학과", icon: UIImage(systemName: "gear"), iconBackgroundColor: .systemOrange, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "bigdata"), topic: "bigdata")),
            .switchCell(model: SettingsSwitchOption(title: "지능형모빌리티융합학과", icon: UIImage(systemName: "gear"), iconBackgroundColor: .systemOrange, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "imob"), topic: "imob")),
            .switchCell(model: SettingsSwitchOption(title: "자율전공학부", icon: UIImage(systemName: "gear"), iconBackgroundColor: .systemOrange, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "sdis"), topic: "sdis")),
        ]))

        models.append(Section(title: "공학대학(여수)", options: [
            .switchCell(model: SettingsSwitchOption(title: "전자통신공학과", icon: UIImage(systemName: "hammer"), iconBackgroundColor: .systemBlue, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "ece"), topic: "ece")),
            .switchCell(model: SettingsSwitchOption(title: "전기컴퓨터공학부", icon: UIImage(systemName: "hammer"), iconBackgroundColor: .systemBlue, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "eec"), topic: "eec")),
            .switchCell(model: SettingsSwitchOption(title: "기계시스템공학과", icon: UIImage(systemName: "hammer"), iconBackgroundColor: .systemBlue, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "mechse"), topic: "mechse")),
            .switchCell(model: SettingsSwitchOption(title: "기계설계공학과", icon: UIImage(systemName: "hammer"), iconBackgroundColor: .systemBlue, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "mechauto"), topic: "mechauto")),
            .switchCell(model: SettingsSwitchOption(title: "메카트로닉스공학과", icon: UIImage(systemName: "hammer"), iconBackgroundColor: .systemBlue, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "mechatronics"), topic: "mechatronics")),
            .switchCell(model: SettingsSwitchOption(title: "냉동공조공학과", icon: UIImage(systemName: "hammer"), iconBackgroundColor: .systemBlue, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "refri06"), topic: "refri06")),
            .switchCell(model: SettingsSwitchOption(title: "환경시스템공학과", icon: UIImage(systemName: "hammer"), iconBackgroundColor: .systemBlue, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "environ"), topic: "environ")),
            .switchCell(model: SettingsSwitchOption(title: "융합생명공학과", icon: UIImage(systemName: "hammer"), iconBackgroundColor: .systemBlue, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "biotech"), topic: "biotech")),
            .switchCell(model: SettingsSwitchOption(title: "화공생명공학과", icon: UIImage(systemName: "hammer"), iconBackgroundColor: .systemBlue, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "chemeng"), topic: "chemeng")),
            .switchCell(model: SettingsSwitchOption(title: "산업기술융합공학과(야간)", icon: UIImage(systemName: "hammer"), iconBackgroundColor: .systemBlue, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "itce"), topic: "itce")),
            .switchCell(model: SettingsSwitchOption(title: "석유화학소재공학과", icon: UIImage(systemName: "hammer"), iconBackgroundColor: .systemBlue, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "pcme"), topic: "pcme")),
            .switchCell(model: SettingsSwitchOption(title: "조기취업형 계약학과", icon: UIImage(systemName: "hammer"), iconBackgroundColor: .systemBlue, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "smartplant"), topic: "smartplant")),
        ]))

        models.append(Section(title: "문화사회과학대학(여수)", options: [
            .switchCell(model: SettingsSwitchOption(title: "국제학부", icon: UIImage(systemName: "globe"), iconBackgroundColor: .systemPurple, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "inter"), topic: "inter")),
            .switchCell(model: SettingsSwitchOption(title: "물류교통학과", icon: UIImage(systemName: "globe"), iconBackgroundColor: .systemPurple, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "logistics"), topic: "logistics")),
            .switchCell(model: SettingsSwitchOption(title: "국제통상학전공", icon: UIImage(systemName: "globe"), iconBackgroundColor: .systemPurple, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "trade"), topic: "trade")),
            .switchCell(model: SettingsSwitchOption(title: "글로벌비즈니스학전공", icon: UIImage(systemName: "globe"), iconBackgroundColor: .systemPurple, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "dogt"), topic: "dogt")),
            .switchCell(model: SettingsSwitchOption(title: "문화콘텐츠학부", icon: UIImage(systemName: "globe"), iconBackgroundColor: .systemPurple, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "ccd"), topic: "ccd")),
            .switchCell(model: SettingsSwitchOption(title: "문화관광경영학과", icon: UIImage(systemName: "globe"), iconBackgroundColor: .systemPurple, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "ctm"), topic: "ctm")),
        ]))

        models.append(Section(title: "수산해양대학(여수)", options: [
            .switchCell(model: SettingsSwitchOption(title: "기관시스템공학과", icon: UIImage(systemName: "ship"), iconBackgroundColor: .systemTeal, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "engineer"), topic: "engineer")),
            .switchCell(model: SettingsSwitchOption(title: "수산생명의학과", icon: UIImage(systemName: "ship"), iconBackgroundColor: .systemTeal, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "fishpath"), topic: "fishpath")),
            .switchCell(model: SettingsSwitchOption(title: "스마트수산자원관리학과", icon: UIImage(systemName: "ship"), iconBackgroundColor: .systemTeal, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "smartfish"), topic: "smartfish")),
            .switchCell(model: SettingsSwitchOption(title: "양식생물학과", icon: UIImage(systemName: "ship"), iconBackgroundColor: .systemTeal, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "aqua"), topic: "aqua")),
            .switchCell(model: SettingsSwitchOption(title: "조선해양공학과", icon: UIImage(systemName: "ship"), iconBackgroundColor: .systemTeal, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "oceaneng"), topic: "oceaneng")),
            .switchCell(model: SettingsSwitchOption(title: "해양경찰학과", icon: UIImage(systemName: "ship"), iconBackgroundColor: .systemTeal, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "police"), topic: "police")),
            .switchCell(model: SettingsSwitchOption(title: "해양바이오식품학과", icon: UIImage(systemName: "ship"), iconBackgroundColor: .systemTeal, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "marinefs"), topic: "marinefs")),
            .switchCell(model: SettingsSwitchOption(title: "해양생산관리학과", icon: UIImage(systemName: "ship"), iconBackgroundColor: .systemTeal, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "marine"), topic: "marine")),
            .switchCell(model: SettingsSwitchOption(title: "해양융합과학과", icon: UIImage(systemName: "ship"), iconBackgroundColor: .systemTeal, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "ocean89"), topic: "ocean89")),
            .switchCell(model: SettingsSwitchOption(title: "수산해양산업관광레저융합학과(계약학과)", icon: UIImage(systemName: "ship"), iconBackgroundColor: .systemTeal, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "dfmitl"), topic: "dfmitl")),
        ]))

        models.append(Section(title: "창의융합학부(여수)", options: [
            .switchCell(model: SettingsSwitchOption(title: "창의융합학부", icon: UIImage(systemName: "wand.and.rays"), iconBackgroundColor: .systemYellow, handler: {
                // 핸들러 구현
            }, isOn: getConfigData(topic: "fcc"), topic: "fcc")),
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

extension DepartmentViewController: UITableViewDelegate {
    
}

extension DepartmentViewController: UITableViewDataSource {
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
