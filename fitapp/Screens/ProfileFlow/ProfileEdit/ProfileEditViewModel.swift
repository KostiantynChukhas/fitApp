//
//  ProfileEditViewModel.swift
//  fitapp
//
//  Created by on 22.05.2023.
//

import Foundation
import RxSwift
import RxCocoa

class ProfileEditViewModel: DeinitAnnouncerType {
    
    private var coordinator: ProfileEditCoordinator
    
    // MARK: - Observabled
    
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    private let isSelectedManRelay = BehaviorRelay<Bool>(value: Gender(rawValue: SessionManager.shared.user?.gender?.lowercased() ?? "") == .male)
    
    private let isSelectedWomanRelay = BehaviorRelay<Bool>(value: false)
    
    private let nameRelay = BehaviorRelay<String>(value: .empty)
    
    private let birthdayRelay = BehaviorRelay<String>(value: .empty)
    
    private let countryRelay = BehaviorRelay<String>(value: .empty)
    
    private let cityRelay = BehaviorRelay<String>(value: .empty)
    
    private let gymRelay = BehaviorRelay<String>(value: .empty)
    
    private let trainingExperianceRelay = BehaviorRelay<String>(value: .empty)
    
    private let goalRelay = BehaviorRelay<String>(value: .empty)
    
    private let storyRelay = BehaviorRelay<String>(value: .empty)
    
    private let userDataSubject = BehaviorRelay<UserData?>(value: nil)
    
    private let nerworkService = ServiceFactory.createNetworkService()
    
    init(_ coordinator: ProfileEditCoordinator, avatar: String) {
        self.coordinator = coordinator
        self.userDataSubject.accept(SessionManager.shared.user)
        setupDeinitAnnouncer()
    }
    
    func route(to route: ProfileEditCoordinator.Route) {
        coordinator.route(to: route)
    }
}

// MARK: - ViewModelProtocol

extension ProfileEditViewModel: ViewModelProtocol {
    
    struct Input {
        let disposeBag: DisposeBag
        let selectedManSignal: Observable<Void>
        let selectedWomanSignal: Observable<Void>
        let doneSignal: Observable<Void>
        let backSignal: Observable<Void>
        let name: Observable<String>
        let birthday: Observable<String>
        let country: Observable<String>
        let city: Observable<String>
        let gym: Observable<String>
        let training: Observable<String>
        let goal: Observable<String>
        let story: Observable<String>
        let uploadImageSignal: Observable<Data>
    }
    
    struct Output {
        let isSelectedMan: Driver<Bool>
        let isUserData: Driver<UserData?>
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([
            setupSelectedManObserving(with: input.selectedManSignal),
            setupSelectedWomanObserving(with: input.selectedWomanSignal),
            setupNameObserving(with: input.name),
            setupBirthdayObserving(with: input.birthday),
            setupCityObserving(with: input.city),
            setupCountryObserving(with: input.country),
            setupGymObserving(with: input.gym),
            setupTrainingObserving(with: input.training),
            setupGoalObserving(with: input.goal),
            setupStoryObserving(with: input.story),
            setupDoneObserving(with: input.doneSignal),
            setupBackObserving(with: input.backSignal),
            setupProfileImageObserving(with: input.uploadImageSignal)
            
        ])
        let output = Output(
            isSelectedMan: isSelectedManRelay.asDriver(onErrorJustReturn: false),
            isUserData: userDataSubject.asDriver(onErrorJustReturn: nil)
        )
        
        outputHandler(output)
    }
    
    private func setupNameObserving(with signal: Observable<String>) -> Disposable {
        signal
            .withUnretained(self)
            .subscribe(onNext: { (`self`, name) in
                self.nameRelay.accept(name)
            })
    }
    
    private func setupBirthdayObserving(with signal: Observable<String>) -> Disposable {
        signal
            .withUnretained(self)
            .subscribe(onNext: { (`self`, birthday) in
                self.birthdayRelay.accept(birthday)
            })
    }
    
    private func setupCountryObserving(with signal: Observable<String>) -> Disposable {
        signal
            .withUnretained(self)
            .subscribe(onNext: { (`self`, city) in
                self.countryRelay.accept(city)
            })
    }
    
    private func setupCityObserving(with signal: Observable<String>) -> Disposable {
        signal
            .withUnretained(self)
            .subscribe(onNext: { (`self`, city) in
                self.cityRelay.accept(city)
            })
    }
    
    private func setupGymObserving(with signal: Observable<String>) -> Disposable {
        signal
            .withUnretained(self)
            .subscribe(onNext: { (`self`, gym) in
                self.gymRelay.accept(gym)
            })
    }
    
    private func setupTrainingObserving(with signal: Observable<String>) -> Disposable {
        signal
            .withUnretained(self)
            .subscribe(onNext: { (`self`, training) in
                self.trainingExperianceRelay.accept(training)
            })
    }
    
    private func setupGoalObserving(with signal: Observable<String>) -> Disposable {
        signal
            .withUnretained(self)
            .subscribe(onNext: { (`self`, goal) in
                self.goalRelay.accept(goal)
            })
    }
    
    private func setupStoryObserving(with signal: Observable<String>) -> Disposable {
        signal
            .withUnretained(self)
            .subscribe(onNext: { (`self`, story) in
                self.storyRelay.accept(story)
            })
    }
    
    private func setupSelectedManObserving(with signal: Observable<Void>) -> Disposable {
        signal
            .withUnretained(self)
            .subscribe(onNext: { (`self`, _) in
                self.isSelectedManRelay.accept(true)
                self.isSelectedWomanRelay.accept(false)
            })
    }
    
    private func setupSelectedWomanObserving(with signal: Observable<Void>) -> Disposable {
        signal
            .withUnretained(self)
            .subscribe(onNext: { (`self`, _) in
                self.isSelectedWomanRelay.accept(true)
                self.isSelectedManRelay.accept(false)
            })
    }
    
    private func setupDoneObserving(with signal: Observable<Void>) -> Disposable {
        signal
            .withUnretained(self)
            .flatMap { (`self`, _) in
                let gender = self.isSelectedManRelay.value ? "MALE" : "FEMALE"
                var timeInterval: String = ""
                if let date = DateFormatter.dateFromString(self.birthdayRelay.value, format: "dd/MM/yyyy") {
                    timeInterval = "\(date.timeIntervalSince1970)"
                }
                let name = self.nameRelay.value.isEmpty ? SessionManager.shared.user?.name : self.nameRelay.value
                let country = self.countryRelay.value.isEmpty ? SessionManager.shared.user?.country : self.countryRelay.value
                let city = self.cityRelay.value.isEmpty ? SessionManager.shared.user?.city : self.cityRelay.value
                let gym = self.gymRelay.value.isEmpty ? SessionManager.shared.user?.gym : self.gymRelay.value
                let shortStory = self.storyRelay.value.isEmpty ? SessionManager.shared.user?.shortStory : self.storyRelay.value
                let goal = self.goalRelay.value.isEmpty ? SessionManager.shared.user?.myGoal : self.goalRelay.value
                let experience = self.trainingExperianceRelay.value.isEmpty ? SessionManager.shared.user?.experience : self.trainingExperianceRelay.value

                
                let onboardingInfoRequestModel = ProfileInfoRequestModel(
                    country: country,
                    city: city,
                    gym: gym,
                    experience: experience,
                    my_goal: goal,
                    short_story: shortStory,
                    about_me: "",
                    achievements: "",
                    education: "",
                    other: "",
                    gender: gender,
                    date_birth: timeInterval,
                    name: name,
                    notification_workout: nil,
                    notification_comments: nil,
                    type_account: nil
                )

                return self.nerworkService.updateProfileInfo(requestData: onboardingInfoRequestModel).asObservable()
            }
            .withUnretained(self)
            .do(onNext: { [weak self] _ in self?.isLoadingRelay.accept(false) })
                .subscribe { (`self`, response) in
                    guard let user = response.data else { return }
                    SessionManager.shared.setUser(user: user)
                    self.route(to: .backWithModel(model: user))
                }
    }
    
    private func setupBackObserving(with signal: Observable<Void>) -> Disposable {
        signal
            .withUnretained(self)
            .subscribe(onNext: { (`self`, _) in
                self.route(to: .back)
            })
    }
    
    private func setupProfileImageObserving(with signal: Observable<Data>) -> Disposable {
        signal
            .withUnretained(self)
            .flatMap { (`self`, dataImage) in
                let profileImageModel = UploadProfileImageRequestModel(picture: dataImage)
                return self.nerworkService.updateProfileImage(requestData: profileImageModel).asObservable()
            }
            .withUnretained(self)
            .subscribe(onNext: { (`self`, response) in
                guard let data = response.data else { return }
                SessionManager.shared.setUser(user: data)
            })
    }
}
