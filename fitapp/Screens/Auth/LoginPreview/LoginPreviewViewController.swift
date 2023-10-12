//
//  LoginPreviewViewController.swift
//  StartProjectsMVVM + C
//

import UIKit
import SocketIO

class LoginPreviewViewController: UIViewController {
    
    var viewModel: LoginPreviewViewModelType!
    
    @IBOutlet weak var btnRegister: RoundedButton!
    @IBOutlet weak var btnLogin: RoundedButton!
    
    private let activityIndicator = CustomActivityIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
    }
    
    private func setupButtons() {
        btnRegister.configure(style: .white)
    }
    
    @IBAction func btnRegisterAction(_ sender: Any) {
        viewModel.route(to: .registration)
    }
    
    @IBAction func btnLoginAction(_ sender: Any) {
        viewModel.route(to: .login)
    }
    
    deinit {
        print("LoginPreviewViewController - deinit")
    }
}
