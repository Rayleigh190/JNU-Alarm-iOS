//
//  AgreeViewController.swift
//  JNU-Alarm
//
//  Created by 우진 on 3/4/24.
//

import UIKit
import SafariServices

class AgreeViewController: UIViewController {
    
    private lazy var titleLabael: UILabel = {
        let label = UILabel()
        label.text = "서비스 등록"
        label.font = .systemFont(ofSize: 23, weight: .bold)
        return label
    }()
    
    private lazy var serviceTermsLabel: UILabel = {
        let label = UILabel()
        label.text = "(필수) 서비스 이용약관 동의 >"
        return label
    }()
    
    private lazy var privacyTermsLabel: UILabel = {
        let label = UILabel()
        label.text = "(필수) 개인정보 수집 및 이용 동의 >"
        return label
    }()
    
    private lazy var termsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.addArrangedSubview(serviceTermsLabel)
        stackView.addArrangedSubview(privacyTermsLabel)
        return stackView
    }()
    
    private lazy var disagreeButton: UIButton = {
        let button = UIButton()
        button.setTitle("비동의", for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 10
        return button
    }()
    
    private lazy var agreeButton: UIButton = {
        let button = UIButton()
        button.setTitle("동의", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.addArrangedSubview(disagreeButton)
        stackView.addArrangedSubview(agreeButton)
        return stackView
    }()
    
    private lazy var alertStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.backgroundColor = .systemBackground
        stackView.layer.cornerRadius = 10
        stackView.addArrangedSubview(titleLabael)
        stackView.addArrangedSubview(termsStackView)
        stackView.addArrangedSubview(buttonStackView)
        
        // 그림자 설정
        stackView.layer.shadowColor = UIColor.black.cgColor // 그림자 색상
        stackView.layer.shadowOpacity = 0.5 // 그림자 투명도
        stackView.layer.shadowOffset = CGSize(width: 0, height: 2) // 그림자의 offset
        stackView.layer.shadowRadius = 4 // 그림자의 블러 효과 반경
        stackView.layer.masksToBounds = false // 뷰 경계를 벗어나는 그림자를 보이도록 설정

        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        if !UserDefaults.standard.bool(forKey: "terms") {
            setupSubViews()
            setupListener()
        } else {
            showContainer()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !NetworkMonitor.shared.isConnected {
            Alert.showAlertAndExit(title: "네트워크 연결 오류", message: "인터넷에 연결되어 있지 않습니다. 앱을 종료합니다.")
        }
    }
}

extension AgreeViewController {
    func setupSubViews() {
        view.addSubview(alertStackView)
        
        alertStackView.isLayoutMarginsRelativeArrangement = true
        alertStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        alertStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            alertStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            alertStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
        ])
    }
    
    func setupListener() {
        let serviceTermsTapGesture = UITapGestureRecognizer(target: self, action: #selector(serviceTermsLabelTapped))
        serviceTermsLabel.isUserInteractionEnabled = true
        serviceTermsLabel.addGestureRecognizer(serviceTermsTapGesture)
        
        let privacyTermsTapGesture = UITapGestureRecognizer(target: self, action: #selector(privacyTermsLabelTapped))
        privacyTermsLabel.isUserInteractionEnabled = true
        privacyTermsLabel.addGestureRecognizer(privacyTermsTapGesture)
        
        disagreeButton.addTarget(self, action: #selector(disagreeButtonTapped), for: .touchUpInside)
        agreeButton.addTarget(self, action: #selector(agreeButtonTapped), for: .touchUpInside)
    }
    
    @objc func serviceTermsLabelTapped() {
        print("serviceTermsLabelTapped")
        showWebView(link: "https://wackitlab.notion.site/81bc7df4763144beaec4610b39811529")
    }
    
    @objc func privacyTermsLabelTapped() {
        print("privacyTermsLabelTapped")
        showWebView(link: "https://wackitlab.notion.site/d6483585330d47cf8c3927c018d9075e")
    }
    
    @objc func disagreeButtonTapped() {
        print("disagreeButtonTapped")
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exit(0)
        }
    }
    
    @objc func agreeButtonTapped() {
        print("agreeButtonTapped")
        UserDefaults.standard.setValue(true, forKey: "terms")
        self.showContainer()
    }
    
    func showWebView(link: String) {
        guard let url = URL(string: link) else { return }
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .automatic
        present(safariVC, animated: true)
    }
    
    func showContainer() {
        DispatchQueue.main.async {
            let vc = ContainerViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false)
        }
    }
}
