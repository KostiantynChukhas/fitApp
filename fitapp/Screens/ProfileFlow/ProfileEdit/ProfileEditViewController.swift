//
//  ProfileEditViewController.swift
//  fitapp
//
//  Created by on 22.05.2023.
//


import UIKit
import Firebase
import RxSwift
import RxCocoa
import Kingfisher

class ProfileEditViewController: ViewController<ProfileEditViewModel> {
    
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var shortStoryTextField: ProfileEditInputView!
    @IBOutlet weak var goalTextField: ProfileEditInputView!
    @IBOutlet weak var trainingExperienceTextField: ProfileEditInputView!
    @IBOutlet weak var gymTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileImageActionButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    private let avatarImageSubject = PublishSubject<Data>()
    
    private let activityIndicator = CustomActivityIndicator()
    
    override func setupView() {
        super.setupView()
        addCenterActivityView(activityIndicator)
        setupTextfields()
        
        profileView.roundCorners(radius: 12)
        profileView.addBorder(color: Style.Color.starship.uiColor, width: 1)
        
        let tapGesture = UITapGestureRecognizer()
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
        
        let tapGestureObservable = tapGesture.rx.event.asObservable()
        
        tapGestureObservable.subscribe(onNext: { _ in
            ImagePickerManager().pickImage(self) { [weak self] image in
                self?.profileImage.image = image
                self?.avatarImageSubject.onNext(image.compressToData(sizeInKb: 250) ?? Data())
                self?.profileImage.contentMode = .scaleAspectFill
            }
        })
        .disposed(by: disposeBag)
    }
    
    override func setupLocalization() {
        
    }
    
    override func setupOutput() {
        let input = ProfileEditViewModel.Input(
            disposeBag: disposeBag,
            selectedManSignal: maleButton.rx.tap.asObservable(),
            selectedWomanSignal: femaleButton.rx.tap.asObservable(),
            doneSignal: doneButton.rx.tap.asObservable(),
            backSignal: backButton.rx.tap.asObservable(),
            name: nameTextField.rx.text.ignoreNil(),
            birthday: birthdayTextField.rx.text.ignoreNil(),
            country: countryTextField.rx.text.ignoreNil(),
            city: cityTextField.rx.text.ignoreNil(),
            gym: gymTextField.rx.text.ignoreNil(),
            training: trainingExperienceTextField.textView.rx.text.ignoreNil(),
            goal: goalTextField.textView.rx.text.ignoreNil(),
            story: shortStoryTextField.textView.rx.text.ignoreNil(),
            uploadImageSignal: avatarImageSubject.asObserver()
        )
        
        viewModel.transform(input, outputHandler: self.setupInput(input:))
    }
    
    override func setupInput(input: ProfileEditViewModel.Output) {
        disposeBag.insert([
            setupSelectionManButton(with: input.isSelectedMan),
            setupData(with: input.isUserData)
        ])
    }
    
    private func setupSelectionManButton(with signal: Driver<Bool>) -> Disposable {
        signal.drive(onNext: { [weak self] isSelectedMan in
            self?.maleButton.isSelected = isSelectedMan
            self?.femaleButton.isSelected = !isSelectedMan
        })
    }
    
    private func setupData(with signal: Driver<UserData?>)  -> Disposable {
        signal.drive { [weak self] user in
            self?.nameTextField.text = user?.name ?? ""
            if let birth = user?.dateBirth {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dateFormatter.dateFormat = "dd/MM/yyyy"
                let date = Date(timeIntervalSince1970: Double(birth) ?? .zero)
                let string = dateFormatter.string(from: date)
                self?.birthdayTextField.text = string
            }
            self?.countryTextField.text = user?.country ?? ""
            self?.cityTextField.text = user?.city ?? ""
            self?.gymTextField.text = user?.gym ?? ""
            
            if let gender = user?.gender?.lowercased() {
                self?.maleButton.isSelected = Gender(rawValue: gender) == .male
                self?.femaleButton.isSelected = Gender(rawValue: gender) == .female
            }
            
            if let myGoal = user?.myGoal {
                self?.goalTextField.textView.text = myGoal
                self?.goalTextField.updateSize()
            }
            self?.goalTextField.addPlaceholder(with: (user?.myGoal?.isEmpty ?? true) ? "My goal" : .empty)

            if let shortStory = user?.shortStory {
                self?.shortStoryTextField.textView.text = shortStory
                self?.shortStoryTextField.updateSize()
            }             
            self?.shortStoryTextField.addPlaceholder(with: (user?.shortStory?.isEmpty ?? true) ? "Shoty story" : .empty)

            if let experience = user?.experience {
                self?.trainingExperienceTextField.textView.text = experience
                self?.trainingExperienceTextField.updateSize()
            }
            self?.trainingExperienceTextField.addPlaceholder(with: (user?.experience?.isEmpty ?? true) ? "Training experience" : .empty)
            
            if let imageUrl = URL(string: user?.avatar ?? "") {
                self?.profileImage.kf.setImage(with: imageUrl, options: [.forceRefresh])
            }
            
            if let avatar = user?.avatar, !avatar.isEmpty {
                self?.profileImageView.kf
                    .setImage(with: URL(string: avatar), options: [.forceRefresh], completionHandler: { [weak self] _ in
                        self?.profileImageView.contentMode = .scaleAspectFill
                        self?.profileImageActionButton.setImage(UIImage(named: "ic_edit_photo"), for: .normal)
                    })
            } else {
                self?.profileImageView.image = UIImage(named: "no_profile_image")
                self?.profileImageView.contentMode = .center
                self?.profileImageActionButton.setImage(UIImage(named: "ic_profile_add_picture"), for: .normal)
            }
        }
        
    }
    
    private func setupTextfields() {
        [gymTextField, cityTextField, countryTextField, birthdayTextField, nameTextField].forEach {
            $0?.addBorder(color: Style.Color.borderColor.uiColor, width: 1)
            $0?.roundCorners(radius: 12)
            $0?.delegate = self
        }
        
        [shortStoryTextField, goalTextField, trainingExperienceTextField] .forEach {
            $0?.addBorder(color: Style.Color.borderColor.uiColor, width: 1)
            $0?.roundCorners(radius: 12)
        }
        
        birthdayTextField.withImage(
            direction: .right,
            image: UIImage(named: "CalendarBlank"),
            colorSeparator: .clear,
            colorBorder: .clear
        )
        
        setupDatePicker()
    }
    
    private func setupDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.tintColor = .black
        datePicker.preferredDatePickerStyle = traitCollection.verticalSizeClass == .compact ? .compact : .inline
        
        let rect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 30, height: 300)
        let pickerWrapperView = UIView(frame: rect)
        pickerWrapperView.addSubview(datePicker)
        
        // Adding constraints
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.leadingAnchor.constraint(equalTo: pickerWrapperView.leadingAnchor).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: pickerWrapperView.trailingAnchor).isActive = true
        datePicker.topAnchor.constraint(equalTo: pickerWrapperView.topAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: pickerWrapperView.bottomAnchor).isActive = true
        
        // Using wrapper view instead of picker
        birthdayTextField.inputView = pickerWrapperView
        datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        
        // Show the picker when the text field is tapped
        birthdayTextField.addTarget(self, action: #selector(showDatePicker), for: .editingDidBegin)
    }
    
    @objc
    func showDatePicker() {
        birthdayTextField.becomeFirstResponder()
    }
    
    @objc
    func handleDatePicker(sender: UIDatePicker) {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        birthdayTextField.text = df.string(from: sender.date)
    }
    
}

extension ProfileEditViewController: UITextFieldDelegate {
    
}
