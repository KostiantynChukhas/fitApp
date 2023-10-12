//
//  CommunityAddPostViewController.swift
//  fitapp
//
//  Created by on 15.05.2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import IQKeyboardManagerSwift

class CommunityAddPostViewController: ViewController<CommunityAddPostViewModel> {
    
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var heightTextView: NSLayoutConstraint!
    @IBOutlet weak var stackView: UIStackView!
    
    private var placeholderLabel: UILabel!
    private let activityIndicator = CustomActivityIndicator()
    
    private let descriptionText = PublishSubject<String>()
    private let imageData = PublishSubject<[Data]>()
    private let videoData = PublishSubject<Data>()
    
    private var removeImageSubject = PublishSubject<DraftModel>()
    
    override func setupView() {
        setupTextView()
        setupButtons()
        addCenterActivityView(activityIndicator)
    }
    
    override func setupOutput() {
        let input = CommunityAddPostViewModel.Input(
            disposeBag: disposeBag,
            postText: descriptionText.asObserver(),
            backSignal: backButton.rx.tap.asObservable(),
            postSignal: postButton.rx.tap.asObservable(),
            imageDataSignal: imageData.asObservable(),
            videoDataSignal: videoData.asObservable(),
            removeImageSignal: removeImageSubject.asObservable()
        )
        
        viewModel.transform(input, outputHandler: self.setupInput(input:))
    }
    
    override func setupInput(input: CommunityAddPostViewModel.Output) {
        disposeBag.insert([
            setupDriveDataObserving(with: input.draftData),
            setupImagesObserving(with: input.images),
            setupActivityIndicatorObserving(with: input.isLoading)
        ])
    }
    
    private func setupDriveDataObserving(with signal: Driver<DraftData?>) -> Disposable {
        signal.drive { [weak self] model in
            let description = model?.description ?? ""
            self?.postTextView.text = description.isEmpty ? nil: description
            self?.heightTextView.constant = self?.postTextView.contentSize.height ?? 100
            self?.placeholderLabel.isHidden = !description.isEmpty
            self?.setupPostButton(with: !description.isEmpty)
            
            self?.view.layoutIfNeeded()
        }
    }
    
    private func setupImagesObserving(with signal: Driver<[DraftModel]>) -> Disposable {
        signal.drive { [weak self] models in
            self?.stackView.removeFullyAllArrangedSubviews()
            models.forEach { self?.addImageViewToStackView(imageURLString: $0.url) }
            self?.view.layoutIfNeeded()
        }
    }
    
    private func setupActivityIndicatorObserving(with signal: Driver<Bool>) -> Disposable {
        signal.drive { [weak self] value in
            _ = value ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
        }
    }
    
    private func setupPostButton(with enabled: Bool) {
        postButton.isEnabled = enabled
        postButton.backgroundColor = enabled ?  Style.Color.starship.uiColor : Style.Color.inactiveBorder.uiColor
        postButton.titleLabel?.textColor = enabled ? Style.Color.textColor.uiColor : Style.Color.lightTextColor.uiColor
    }
    
    private func setupButtons() {
        postButton.roundCorners(radius: 12)
    }
    
    private func setupTextView() {
        let button1 = UIButton(type: .custom)
        button1.setImage(UIImage(named: "FilmButton"), for: .normal)
        button1.addTarget(self, action: #selector(buttonVideoTapped), for: .touchUpInside)
        
        let button2 = UIButton(type: .custom)
        button2.setImage(UIImage(named: "ImageButton"), for: .normal)
        button2.addTarget(self, action: #selector(buttonImageTapped), for: .touchUpInside)
        
        let button3 = UIButton(type: .custom)
        button3.setTitle("Done", for: .normal)
        button3.addTarget(self, action: #selector(buttonDoneTapped), for: .touchUpInside)
        
        // Create a custom toolbar
        let toolbar = IQToolbar()
        toolbar.tintColor = .black
        toolbar.barTintColor = .black
        
        // Add the custom buttons to the toolbar
        let button1Item = UIBarButtonItem(customView: button1)
        let button2Item = UIBarButtonItem(customView: button2)
        let buttonDoneItem = UIBarButtonItem(customView: button3)
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spaceItem.width = 10
        
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = 16 // Adjust the width as needed
        
        toolbar.items = [button1Item, fixedSpace, button2Item, flexibleSpace, buttonDoneItem]
        
        // Set the custom toolbar as the inputAccessoryView for the desired text field or text view
        postTextView.inputAccessoryView = toolbar
        postTextView.keyboardAppearance = .dark
        postTextView.delegate = self
        postTextView.autocorrectionType = .no
        postTextView.autocapitalizationType = .none
        postTextView.spellCheckingType = .no
        
        placeholderLabel = UILabel()
        placeholderLabel.text = "Type your message here"
        placeholderLabel.font = Style.Font.latoBold.uiFont.withSize(20)
        placeholderLabel.sizeToFit()
        postTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (postTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = .tertiaryLabel
        placeholderLabel.isHidden = !postTextView.text.isEmpty
    }
    
    @objc private func buttonVideoTapped() {
        var pickerConfig = FYPhotoPickerConfiguration()
        pickerConfig.selectionLimit = 1
        pickerConfig.supportCamera = false
        pickerConfig.mediaFilter = [.video]
        let videoPickerVC = PhotoPickerViewController(configuration: pickerConfig)
        videoPickerVC.selectedVideo = { [weak self] result in
            switch result {
            case .success(let video):
                guard let videoData = try? Data(contentsOf: video.url) else { return }
                self?.videoData.onNext(videoData)
            case .failure: break
            }
        }
        
        videoPickerVC.modalPresentationStyle = .fullScreen
        self.present(videoPickerVC, animated: true, completion: nil)
    }
    
    @objc private func buttonImageTapped() {
        var pickerConfig = FYPhotoPickerConfiguration()
        pickerConfig.selectionLimit = 5
        pickerConfig.supportCamera = false
        pickerConfig.mediaFilter =  [.image]
        let photoPickerVC = PhotoPickerViewController(configuration: pickerConfig)
        photoPickerVC.selectedPhotos = { [weak self] images in
            let images = images.compactMap { $0.image.compressToData(sizeInKb: 500) }
            self?.imageData.onNext(images)
        }
        
        photoPickerVC.modalPresentationStyle = .fullScreen
        self.present(photoPickerVC, animated: true, completion: nil)
    }
    
    @objc private func buttonDoneTapped() {
        self.view.endEditing(true)
    }
    
    func addImageViewToStackView(imageURLString: String?) {
        if let imageURLString = imageURLString, !imageURLString.isEmpty {
            let model = DraftModel(id: UUID().uuidString, url: imageURLString)
            let container = DraftImageView()
            container.render(model: model)
            
            container.removeImageSubject
                .bind(to: removeImageSubject)
                .disposed(by: disposeBag)
            
            self.stackView.addArrangedSubview(container)
        }
    }
    
}

extension CommunityAddPostViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let textCount = textView.text.count
        setupPostButton(with: textCount > 0)
        placeholderLabel?.isHidden = !textView.text.isEmpty
        descriptionText.onNext(textView.text ?? "")
        
        if (textView.contentSize.height < 1000) {
            self.heightTextView.constant = textView.contentSize.height
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel?.isHidden = !textView.text.isEmpty
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel?.isHidden = true
    }
}
