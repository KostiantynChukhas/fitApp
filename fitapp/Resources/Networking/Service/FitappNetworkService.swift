//
//  FitappNetworkService.swift
//  fitapp
//
//   on 05.05.2023.
//

import RxSwift

protocol FitappNetworkServiceProtocol {
    func updateOnboardingInfo(requestData: OnboardingInfoRequestModel) -> Single<UserResponseModel>
    func login(requestData: LoginRequestModel) -> Single<UserResponseModel>
    func registration(requestData: RegistrationRequestModel) -> Single<UserResponseModel>
    func onboarding(requestData: EmptyRequestData) -> Single<OnboardingResponseModel>
    func updateProfileImage(requestData: UploadProfileImageRequestModel) -> Single<UserResponseModel>
    func getProfileInfo(requestData: EmptyRequestData) -> Single<UserResponseModel>
    func getProfileInfo(requestData: EmptyRequestData, id: String) -> Single<UserResponseModel>
    func viewAndCreateDraftCommunity(requestData: EmptyRequestData) -> Single<DraftCommunityResponseModel>
    func uploadDataDraftCommunity(requestData: UploadDataDraftCommunityRequestModel) -> Single<DraftCommunityResponseModel>
    func releaseDraftCommunity(requestData: ViewCreateDraftCommunityRequestModel) -> Single<DraftCommunityResponseModel>
    func communityView(requestData: CommunityViewRequestModel) -> Single<CommunityViewResponseModel> 

    func getPublications(requestData: PageRequestData, userId: String) -> Single<PublicationsResponseDTO>
    func getFeed(requestData: CreatedAtRequestData, userId: String) -> Single<CommunityViewResponseModel>
    func getArticles(requestData: PageRequestData) -> Single<LibraryResponseModel>
    
    func getTrainers(requestData: EmptyRequestData) -> Single<TrainersResponseModel>
    func getTrainerReviews(requestData: EmptyRequestData, id: String) -> Single<TrainerReviewResponse>
    func createTrainerReview(requestData: CreateTrainerReviewRequestData) -> Single<EmptyResponseModel>
    func createPublication(requestData: CreatePublicationRequestData) -> Single<EmptyResponseModel>
}

final class FitappNetworkService: NetworkMoyaBaseService<FitappNetworkEndpoints> {
    // MARK: - Properties
    
    private let jsonDecoder = JSONDecoder()
    
    // MARK: - Private Functions
    private func dataBaseRequest<T>(endpoint: FitappNetworkEndpoints) -> Single<T> where T: Decodable, T: Equatable {
        return networkProvider.rx.request(endpoint)
            .flatMap { response in
                return Single.just(response)
                    .map(DataResponseBaseModel<T>.self, using: JSONDecoder())
                    .checkServerError()
            }
            .extractDataOrSendError()
            .map { $0.data }
            .printNetworkError()
    }
    
    
    private func dataRequest<T: Decodable>(
        endpoint: FitappNetworkEndpoints
    ) -> Single<T> where T: Equatable { networkProvider.rx
            .request(endpoint)
            .flatMap { response in
                if let errorResponse = try? response.map(FitAppError.self) {
                    return .error(errorResponse)
                }
                return .just(response)
            }
            .map(T.self, using: self.jsonDecoder, failsOnEmptyData: false)
            .printNetworkError()
    }
    
    private func dataRequest<T: Decodable, E: Error>(
        endpoint: FitappNetworkEndpoints,
        parsingErrorType: E.Type
    ) -> Single<T> where T: Equatable {
        networkProvider.rx
            .request(endpoint)
            .flatMap { response in
                if let errorResponse = try? response.map(FitAppCustomError.self) {
                    return .error(errorResponse)
                }
                return .just(response)
            }
            .map(T.self, using: self.jsonDecoder, failsOnEmptyData: false)
            .catch { error in
                if let parsingError = error as? Swift.DecodingError {
                    return .error(parsingError as! E)
                }
                return .error(error)
            }
            .printNetworkError()
    }
}

extension FitappNetworkService: FitappNetworkServiceProtocol {
  
    func updateOnboardingInfo(requestData: OnboardingInfoRequestModel) -> Single<UserResponseModel> {
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken(),
            uuid: uuidProvider?.uuidValue()
        )
        return dataRequest(
            endpoint: .updateOnboardingInfo(requestData: data),
            parsingErrorType: FitAppCustomError.self
        )
    }
    
    func login(requestData: LoginRequestModel) -> Single<UserResponseModel> {
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken(),
            uuid: uuidProvider?.uuidValue()
        )
        return dataRequest(endpoint: .login(requestData: data))
    }
    
    func registration(requestData: RegistrationRequestModel) -> Single<UserResponseModel> {
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken(),
            uuid: uuidProvider?.uuidValue()
        )
        
        return dataRequest(endpoint: .register(requestData: data), parsingErrorType: FitAppCustomError.self)
    }
    
    func loginFromSocial(requestData: RegistrationSocialRequestModel) -> Single<UserResponseModel> {
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken(),
            uuid: uuidProvider?.uuidValue()
        )
        
        return dataRequest(endpoint: .loginSocial(requestData: data))
    }
    
    func onboarding(requestData: EmptyRequestData) -> Single<OnboardingResponseModel> {
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken(),
            uuid: uuidProvider?.uuidValue()
        )
        
        return dataRequest(endpoint: .onboarding(requestData: data))
    }
    
    func getLibrary(requestData: LibraryRequestModel) -> Single<LibraryResponseModel> {
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken(),
            uuid: uuidProvider?.uuidValue()
        )
        return dataRequest(endpoint: .getLibrary(requestData: data))
    }
    
    func createCommunityPost(requestData: CommunityRequestModel) -> Single<CommunityResponseModel> {
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken(),
            uuid: uuidProvider?.uuidValue()
        )
        
        return dataRequest(endpoint: .communityPost(requestData: data))
    }

    
    func getLibraryComments(requestData: LibraryCommentsRequestModel) -> Single<LibraryCommentsResponseModel> {
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken(),
            uuid: uuidProvider?.uuidValue()
        )
        return dataRequest(endpoint: .getCommentsLibrary(requestData: data))
    }
    
    func getCommunityComments(requestData: CommunityCommentsRequestModel) -> Single<CommunityCommentsResponseModel> {
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken(),
            uuid: uuidProvider?.uuidValue()
        )
        return dataRequest(endpoint: .getCommunityComments(requestData: data))
    }
    
    func getProfileInfo(requestData: EmptyRequestData) -> Single<UserResponseModel> {
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken(),
            uuid: uuidProvider?.uuidValue()
        )
        return dataRequest(endpoint: .getProfileInfo(requestData: data))
    }
    
    func getProfileInfo(requestData: EmptyRequestData, id: String) -> RxSwift.Single<UserResponseModel> {
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken(),
            uuid: uuidProvider?.uuidValue(),
            pathEnding: id
        )
        return dataRequest(endpoint: .getProfileInfo(requestData: data))
    }
    
    func updateProfileInfo(requestData: ProfileInfoRequestModel) -> Single<UserResponseModel> {
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken(),
            uuid: uuidProvider?.uuidValue()
        )
        return dataRequest(endpoint: .profileEdit(requestData: data))
    }
    
    func updateProfileImage(requestData: UploadProfileImageRequestModel) -> Single<UserResponseModel> {
        
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken() ?? "",
            uuid: uuidProvider?.uuidValue()
        )
        return dataRequest(endpoint: .uploadProfileImage(requestData: data, model: requestData))
    }
    
    func viewAndCreateDraftCommunity(requestData: EmptyRequestData) -> Single<DraftCommunityResponseModel> {
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken() ?? "",
            uuid: uuidProvider?.uuidValue()
        )
        return dataRequest(endpoint: .viewAndCreateDraftCommunity(requestData: data))
    }
    
    func uploadDataDraftCommunity(requestData: UploadDataDraftCommunityRequestModel) -> Single<DraftCommunityResponseModel>{
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken() ?? "",
            uuid: uuidProvider?.uuidValue()
        )
        return dataRequest(endpoint: .uploadDataDraftCommunity(requestData: data, model: requestData))
    }
    
    func removeDraftFile(requestData: RemoveDraftFileRequestData) -> Single<EmptyResponseModel>{
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken() ?? "",
            uuid: uuidProvider?.uuidValue()
        )
        return dataRequest(endpoint: .removeDraftFile(requestData: data))
    }
    
    func releaseDraftCommunity(requestData: ViewCreateDraftCommunityRequestModel) -> Single<DraftCommunityResponseModel> {
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken() ?? "",
            uuid: uuidProvider?.uuidValue()
        )
        return dataRequest(endpoint: .releaseDraftCommunity(requestData: data))
    }
    
    func communityView(requestData: CommunityViewRequestModel) -> Single<CommunityViewResponseModel> {
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken() ?? "",
            uuid: uuidProvider?.uuidValue()
        )
        return dataRequest(endpoint: .communityView(requestData: data))
    }
    
    func addCommentCommunity(requestData: AddCommentCommunityRequestModel) -> Single<AddCommentCommunityResponseModel> {
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken() ?? "",
            uuid: uuidProvider?.uuidValue()
        )
        return dataRequest(endpoint: .addCommentCommunity(requestData: data))
    }
    
    func addCommentLibrary(requestData: AddCommentLibraryRequestModel) -> Single<AddCommentLabraryResponseModel> {
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken() ?? "",
            uuid: uuidProvider?.uuidValue()
        )
        return dataRequest(endpoint: .addCommentLibrary(requestData: data))
    }
    
    func getPublications(requestData: PageRequestData, userId: String) -> Single<PublicationsResponseDTO> {
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken() ?? "",
            uuid: uuidProvider?.uuidValue(),
            pathEnding: userId
        )
        return dataRequest(endpoint: .getMyPublications(requestData: data))
    }
    
    func getFeed(requestData: CreatedAtRequestData, userId: String) -> Single<CommunityViewResponseModel> {
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken() ?? "",
            uuid: uuidProvider?.uuidValue(),
            pathEnding: userId
        )
        return dataRequest(endpoint: .getMyFeed(requestData: data))
    }
    
    func getArticles(requestData: PageRequestData) -> Single<LibraryResponseModel> {
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken() ?? "",
            uuid: uuidProvider?.uuidValue()
        )
        return dataRequest(endpoint: .getMyArticles(requestData: data))
    }
    
    func createLikeCommunity(requestData: CreateLikeCommunityRequestModel) -> Single<CreateLikeCommunityResponseModel> {
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken() ?? "",
            uuid: uuidProvider?.uuidValue()
        )
        return dataRequest(endpoint: .createLikeCommunity(requestData: data))
    }
    
    func createDislikeCommunity(requestData: CreateDislikeCommunityRequestModel) -> Single<CreateLikeCommunityResponseModel> {
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken() ?? "",
            uuid: uuidProvider?.uuidValue()
        )
        return dataRequest(endpoint: .createDislikeCommunity(requestData: data))
    }
    
    func createLikeCommunityComment(requestData: CreateLikeCommentRequestModel) -> Single<CreateLikeCommunityResponseModel> {
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken() ?? "",
            uuid: uuidProvider?.uuidValue()
        )
        return dataRequest(endpoint: .createLikeCommunityComment(requestData: data))
    }
    
    func createDislikeCommunityComment(requestData: CreateDislikeCommentRequestModel) -> Single<CreateLikeCommunityResponseModel> {
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken() ?? "",
            uuid: uuidProvider?.uuidValue()
        )
        return dataRequest(endpoint: .createDislikeCommunityComment(requestData: data))
    }
    
    func createLikeLibraryComment(requestData: CreateLikeCommentRequestModel) -> Single<CreateLikeCommunityResponseModel> {
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken() ?? "",
            uuid: uuidProvider?.uuidValue()
        )
        return dataRequest(endpoint: .createLikeLibraryComment(requestData: data))
    }
    
    func createDislikeLibraryComment(requestData: CreateDislikeCommentRequestModel) -> Single<CreateLikeCommunityResponseModel> {
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken() ?? "",
            uuid: uuidProvider?.uuidValue()
        )
        return dataRequest(endpoint: .createDislikeLibraryComment(requestData: data))
    }
    
    func viewCategoriesWorkout(requestData: EmptyRequestData) -> Single<CreateLikeCommunityResponseModel> {
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken() ?? "",
            uuid: uuidProvider?.uuidValue()
        )
        return dataRequest(endpoint: .viewCategoriesWorkout(requestData: data))
    }
    
    func createCategoriesWorkout(requestData: CreateCategoriesWorkoutRequestModel) -> Single<CategoriesWorkoutResponseModel> {
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken() ?? "",
            uuid: uuidProvider?.uuidValue()
        )
        return dataRequest(endpoint: .createCategoriesWorkout(requestData: data, model: requestData))
    }
    
    func editCategoriesWorkout(requestData: EditCategoriesWorkoutRequestModel) -> Single<CategoriesWorkoutResponseModel> {
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken() ?? "",
            uuid: uuidProvider?.uuidValue()
        )
        return dataRequest(endpoint: .editCategoriesWorkout(requestData: data))
    }
    
    func deleteCategoriesWorkout(requestData: DeleteCategoriesWorkoutRequestModel) -> Single<CategoriesWorkoutResponseModel> {
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken() ?? "",
            uuid: uuidProvider?.uuidValue()
        )
        return dataRequest(endpoint: .deleteCategoriesWorkout(requestData: data))
    }
    
    func viewWorkout(requestData: ViewWorkoutRequestModel) -> Single<ViewWorkoutResponseModel> {
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken() ?? "",
            uuid: uuidProvider?.uuidValue()
        )
        return dataRequest(endpoint: .viewWorkout(requestData: data))
    }
    
    func getTrainers(requestData: EmptyRequestData) -> Single<TrainersResponseModel> {
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken() ?? "",
            uuid: uuidProvider?.uuidValue()
        )
        return dataRequest(endpoint: .getTrainers(requestData: data))
    }
    
    
    func getTrainerReviews(requestData: EmptyRequestData, id: String) -> Single<TrainerReviewResponse> {
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken() ?? "",
            uuid: uuidProvider?.uuidValue(),
            pathEnding: id
        )
        return dataRequest(endpoint: .getTrainerReviews(requestData: data))
    }
    
    func createTrainerReview(requestData: CreateTrainerReviewRequestData) -> Single<EmptyResponseModel> {
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken() ?? "",
            uuid: uuidProvider?.uuidValue()
        )
        return dataRequest(endpoint: .createTrainerReview(requestData: data, model: requestData))
    }
    
    func createPublication(requestData: CreatePublicationRequestData) -> Single<EmptyResponseModel> {
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken() ?? "",
            uuid: uuidProvider?.uuidValue()
        )
        return dataRequest(endpoint: .createPublication(requestData: data, model: requestData))
    }
    
    func createTrainerLike(requestData: TrainerReviewRequestData) -> Single<EmptyResponseModel> {
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken() ?? "",
            uuid: uuidProvider?.uuidValue()
        )
        return dataRequest(endpoint: .trainerLike(requestData: data))
    }
    
    func createTrainerDislike(requestData: TrainerReviewRequestData) -> Single<EmptyResponseModel> {
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken() ?? "",
            uuid: uuidProvider?.uuidValue(),
            pathEnding: requestData.trainerId
        )
        return dataRequest(endpoint: .trainerDislike(requestData: data))
    }
    
    func addToSaved(requestData: LibraryActionRequesData) -> Single<EmptyResponseModel> {
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken() ?? "",
            uuid: uuidProvider?.uuidValue()
        )
        return dataRequest(endpoint: .addToSaved(requestData: data))
    }
    
    func removeFromSaved(requestData: LibraryActionRequesData) -> Single<EmptyResponseModel> {
        let data = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken() ?? "",
            uuid: uuidProvider?.uuidValue()
        )
        return dataRequest(endpoint: .removeFromSaved(requestData: data))
    }
}
