//
//  FitappNetworkEndpoints.swift
//  fitapp
//
// on 05.05.2023.
//

import Foundation
import Moya

enum FitappNetworkEndpoints {
    case onboarding(requestData: RequestModelTypeProtocol)
    case login(requestData: RequestModelTypeProtocol)
    case loginSocial(requestData: RequestModelTypeProtocol)
    case register(requestData: RequestModelTypeProtocol)
    case updateOnboardingInfo(requestData: RequestModelTypeProtocol)
    case getLibrary(requestData: RequestModelTypeProtocol)
    case getCommentsLibrary(requestData: RequestModelTypeProtocol)
    case getCommunityComments(requestData: RequestModelTypeProtocol)
    case communityPost(requestData: RequestModelTypeProtocol)
    case communityView(requestData: RequestModelTypeProtocol)
    case profileEdit(requestData: RequestModelTypeProtocol)
    case uploadProfileImage(requestData: RequestModelTypeProtocol, model: UploadProfileImageRequestModel)
    case getProfileInfo(requestData: RequestModelTypeProtocol)
    case getProfileInfoForId(requestData: RequestModelTypeProtocol)
    case viewAndCreateDraftCommunity(requestData: RequestModelTypeProtocol)
    case uploadDataDraftCommunity(requestData: RequestModelTypeProtocol, model: UploadDataDraftCommunityRequestModel)
    case removeDraftFile(requestData: RequestModelTypeProtocol)
    case releaseDraftCommunity(requestData: RequestModelTypeProtocol)
    case addCommentCommunity(requestData: RequestModelTypeProtocol)
    case addCommentLibrary(requestData: RequestModelTypeProtocol)
    
    case getMyPublications(requestData: RequestModelTypeProtocol)
    case getMyFeed(requestData: RequestModelTypeProtocol)
    case getMyArticles(requestData: RequestModelTypeProtocol)
    case createLikeCommunity(requestData: RequestModelTypeProtocol)
    case createDislikeCommunity(requestData: RequestModelTypeProtocol)
    case createLikeCommunityComment(requestData: RequestModelTypeProtocol)
    case createDislikeCommunityComment(requestData: RequestModelTypeProtocol)
    case createLikeLibraryComment(requestData: RequestModelTypeProtocol)
    case createDislikeLibraryComment(requestData: RequestModelTypeProtocol)
    
    //workouts
    case viewCategoriesWorkout(requestData: RequestModelTypeProtocol)
    case createCategoriesWorkout(requestData: RequestModelTypeProtocol, model: CreateCategoriesWorkoutRequestModel)
    case editCategoriesWorkout(requestData: RequestModelTypeProtocol)
    case deleteCategoriesWorkout(requestData: RequestModelTypeProtocol)
    
    case createPublication(requestData: RequestModelTypeProtocol, model: CreatePublicationRequestData)
    
    case viewWorkout(requestData: RequestModelTypeProtocol)
    
    case getTrainers(requestData: RequestModelTypeProtocol)
    case getTrainerReviews(requestData: RequestModelTypeProtocol)
    case createTrainerReview(requestData: RequestModelTypeProtocol, model: CreateTrainerReviewRequestData)
    case trainerLike(requestData: RequestModelTypeProtocol)
    case trainerDislike(requestData: RequestModelTypeProtocol)
    
    case addToSaved(requestData: RequestModelTypeProtocol)
    case removeFromSaved(requestData: RequestModelTypeProtocol)
    
    // MARK: - Functions
    private var extractedRequestData: RequestModelTypeProtocol {
        switch self {
        case .updateOnboardingInfo(let requestData):
            return requestData
        case .onboarding(let requestData):
            return requestData
        case .login(let requestData):
            return requestData
        case .register(let requestData):
            return requestData
        case .loginSocial(let requestData):
            return requestData
        case .getLibrary(let requestData):
            return requestData
        case .communityPost(let requestData):
            return requestData
        case .getCommentsLibrary(let requestData):
            return requestData
        case .profileEdit(let requestData):
            return requestData
        case .uploadProfileImage(let requestData, _):
            return requestData
        case .getProfileInfo(let requestData):
            return requestData
        case .getProfileInfoForId(let requestData):
            return requestData
        case .viewAndCreateDraftCommunity(let requestData):
            return requestData
        case .uploadDataDraftCommunity(let requestData, _):
            return requestData
        case .removeDraftFile(let requestData):
            return requestData
        case .releaseDraftCommunity(let requestData):
            return requestData
        case .communityView(let requestData):
            return requestData
        case .getCommunityComments(let requestData):
            return requestData
        case .addCommentCommunity(let requestData):
            return requestData
        case .addCommentLibrary(let requestData):
            return requestData
        case .getMyPublications(let requestData):
            return requestData
        case .getMyArticles(let requestData):
            return requestData
        case .getMyFeed(let requestData):
            return requestData
        case .createLikeCommunity(let requestData):
            return requestData
        case .createDislikeCommunity(let requestData):
            return requestData
        case .createLikeCommunityComment(let requestData):
            return requestData
        case .createDislikeCommunityComment(let requestData):
            return requestData
        case .createLikeLibraryComment(let requestData):
            return requestData
        case .createDislikeLibraryComment(let requestData):
            return requestData
        case .viewCategoriesWorkout(let requestData):
            return requestData
        case .createCategoriesWorkout(let requestData, _):
            return requestData
        case .editCategoriesWorkout(let requestData):
            return requestData
        case .deleteCategoriesWorkout(let requestData):
            return requestData
        case .viewWorkout(let requestData):
            return requestData
        case .getTrainers(let requestData):
            return requestData
        case .getTrainerReviews(let requestData):
            return requestData
        case .createTrainerReview(let requestData, _):
            return requestData
        case .trainerLike(let requestData):
            return requestData
        case .trainerDislike(let requestData):
            return requestData
        case .createPublication(let requestData, _):
            return requestData
        case .addToSaved(let requestData):
            return requestData
        case .removeFromSaved(let requestData):
            return requestData
        }
    }
}

extension FitappNetworkEndpoints: TargetType {
    var baseURL: URL {
        switch self {
        case .updateOnboardingInfo, .onboarding, .login, .register, .loginSocial, .getLibrary, .getCommentsLibrary, .communityPost, .profileEdit, .uploadProfileImage, .getProfileInfo, .getProfileInfoForId, .viewAndCreateDraftCommunity, .uploadDataDraftCommunity, .removeDraftFile, .releaseDraftCommunity, .communityView, .getCommunityComments, .addCommentCommunity, .addCommentLibrary, .getMyPublications, .getMyArticles, .getMyFeed, .createLikeCommunity, .createDislikeCommunity, .createDislikeCommunityComment, .createLikeCommunityComment, .createLikeLibraryComment, .createDislikeLibraryComment, .viewCategoriesWorkout,.createCategoriesWorkout, .editCategoriesWorkout, .deleteCategoriesWorkout, .viewWorkout, .getTrainers, .getTrainerReviews, .createTrainerReview, .trainerLike, .trainerDislike, .createPublication, .addToSaved, .removeFromSaved:
            return self.extractedRequestData.baseUrl
        }
    }
    
    var path: String {
        switch self {
        case .updateOnboardingInfo:
            return "/api/account/info-onboard-edit"
        case .onboarding:
            return "/api/info/onboard"
        case .register:
            return "/api/auth/register"
        case .login:
            return "/api/auth/login"
        case .loginSocial:
            return "/api/auth/login-social"
        case .getLibrary:
            return "/api/library/view"
        case .communityPost:
            return "/api/community/draft/release"
        case .getCommentsLibrary:
            return "/api/library/view/comments"
        case .profileEdit:
            return "/api/account/info"
        case .uploadProfileImage:
            return "/api/account/info/avatar"
        case .getProfileInfo:
            return "/api/account/info"
        case .getProfileInfoForId(let requestData):
            let id = requestData.pathEnding ?? ""
            return "/api//account/info/user/\(id)"
        case .viewAndCreateDraftCommunity, .uploadDataDraftCommunity:
            return "/api/community/draft"
        case .removeDraftFile:
            return "/api/community/draft/file"
        case .releaseDraftCommunity:
            return "/api/community/draft/release"
        case .communityView:
            return "/api/community/view"
        case .getCommunityComments:
            return "/api/community/view/comments"
        case .addCommentCommunity:
            return "/api/community/comments"
        case .addCommentLibrary:
            return "/api/library/comments"
        case .getMyPublications(let requestData):
            let id = requestData.pathEnding ?? ""
            return "/api/publication/user/\(id)"
        case .getMyFeed:
            return "/api/community/my/view"
        case .getMyArticles:
            return "/api/library/view/saved"
        case .createLikeCommunity:
            return "/api/community/like"
        case .createDislikeCommunity:
            return "/api/community/dislike"
        case .createDislikeCommunityComment:
            return "/api/community/comments/dislike"
        case .createLikeCommunityComment:
            return "/api/community/comments/like"
        case .createLikeLibraryComment:
            return "/api/library/comments/like"
        case .createDislikeLibraryComment:
            return "/api/library/comments/dislike"
        case .viewCategoriesWorkout, .createCategoriesWorkout, .editCategoriesWorkout, .deleteCategoriesWorkout:
            return "/api/workout/categories"
        case .viewWorkout:
            return "/api/workout/view"
        case .getTrainers:
            return "/api/workout/trainer"
        case .getTrainerReviews(let requestData):
            let id = requestData.pathEnding ?? ""
            return "/api/workout/trainer/review/\(id)"
        case .createTrainerReview:
            return "/api/workout/trainer/review"
        case .trainerLike:
            return "/api/workout/trainer/like"
        case .trainerDislike(let data):
            return "/api/workout/trainer/like/\(data.pathEnding ?? "")"
        case .createPublication:
            return "/api/publication/content"
        case .addToSaved:
            return "/api/library/add/saved"
        case .removeFromSaved:
            return "/api/library/delete/saved"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .updateOnboardingInfo, .profileEdit, .uploadDataDraftCommunity:
            return .patch
        case .onboarding, .getProfileInfo, .getProfileInfoForId, .viewAndCreateDraftCommunity, .getMyPublications, .getMyArticles, .viewCategoriesWorkout, .getTrainers, .getTrainerReviews:
            return .get
        case .login, .register, .loginSocial, .getLibrary, .getCommentsLibrary, .communityPost, .releaseDraftCommunity, .communityView, .getCommunityComments, .addCommentCommunity, .addCommentLibrary, .getMyFeed, .createLikeCommunity, .createDislikeCommunity, .createDislikeCommunityComment, .createLikeCommunityComment, .createLikeLibraryComment, .createDislikeLibraryComment, .createCategoriesWorkout, .viewWorkout, .createTrainerReview, .trainerLike, .createPublication, .addToSaved:
            return .post
        case .uploadProfileImage, .editCategoriesWorkout:
            return .put
        case .deleteCategoriesWorkout, .trainerDislike, .removeFromSaved, .removeDraftFile:
            return .delete
        }
    }
    
    var sampleData: Data {
        return extractedRequestData.sampleData ?? Data()
    }
    
    var task: Task {
        guard let parameters = extractedRequestData.parameters else {
            return .requestPlain
        }
        
        switch self {
        case .updateOnboardingInfo, .login, .register, .loginSocial, .getLibrary, .getCommentsLibrary, .communityPost, .profileEdit, .releaseDraftCommunity, .communityView, .getCommunityComments, .addCommentCommunity, .addCommentLibrary, .getMyFeed, .createLikeCommunity, .createDislikeCommunity, .createDislikeCommunityComment, .createLikeCommunityComment, .createLikeLibraryComment, .createDislikeLibraryComment, .viewCategoriesWorkout, .editCategoriesWorkout, .deleteCategoriesWorkout, .viewWorkout, .trainerLike, .addToSaved, .removeFromSaved, .removeDraftFile:
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .getMyPublications, .getMyArticles:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .onboarding, .getProfileInfo, .getProfileInfoForId, .viewAndCreateDraftCommunity, .getTrainers, .getTrainerReviews, .trainerDislike:
            return .requestPlain
        case .uploadProfileImage(_, let model):
            var formData: [MultipartFormData] = []
            formData.append(MultipartFormData(provider: .data( model.picture), name: "picture", fileName: "\(UUID().uuidString).jpeg", mimeType: "image/jpeg"))
            
            return .uploadMultipart(formData)
        case .uploadDataDraftCommunity(_, let model):
            var formData: [MultipartFormData] = []
            
            if let id = model.id_community.data(using: .utf8) {
                formData.append(MultipartFormData(provider: .data(id), name: "id_community"))
            }
            
            if let description = model.description, let descriptionData = description.data(using: .utf8) {
                formData.append(MultipartFormData(provider: .data(descriptionData), name: "description"))
            }
            
            if let image: Data = model.image, !image.isEmpty {
                formData.append(MultipartFormData(provider: .data(image), name: "file", fileName: "\(UUID().uuidString).jpeg", mimeType: "image/jpeg"))
            }
            
            if let video: Data = model.video, !video.isEmpty {
                formData.append(MultipartFormData(provider: .data(video), name: "file", fileName: "\(UUID().uuidString).mp4", mimeType: "video/vp4"))
            }
            
            return .uploadMultipart(formData)
            
        case .createCategoriesWorkout(_, let model):
            var formData: [MultipartFormData] = []
            
            if let name = model.name.data(using: .utf8) {
                formData.append(MultipartFormData(provider: .data(name), name: "name"))
            }
            
            if let descriptionData = model.description.data(using: .utf8) {
                formData.append(MultipartFormData(provider: .data(descriptionData), name: "description"))
            }
            
            if let image: Data = model.picture, !image.isEmpty {
                formData.append(MultipartFormData(provider: .data(image), name: "picture", fileName: "\(UUID().uuidString).jpeg", mimeType: "image/jpeg"))
            }
            
            return .uploadMultipart(formData)
        case .createTrainerReview(_, let model):
            var formData: [MultipartFormData] = []
            
            for parameter in parameters {
                if parameter.key != "picture" {
                    if let data = String(describing: parameter.value).data(using: .utf8) {
                        formData.append(.init(provider: .data(data), name: parameter.key))
                    }
                }
            }
            
            for picture in model.picture {
                formData.append(MultipartFormData(
                    provider: .data(picture),
                    name: "picture",
                    fileName: "\(UUID().uuidString).jpeg",
                    mimeType: "image/jpeg")
                )
            }
            
            return .uploadMultipart(formData)
        case .createPublication(_, let model):
            var formData: [MultipartFormData] = []
            
            if let header = model.header.data(using: .utf8) {
                formData.append(.init(provider: .data(header), name: "header"))
            }
            
            formData.append(MultipartFormData(
                provider: .data(model.picture),
                name: "picture",
                fileName: "\(UUID().uuidString).jpeg",
                mimeType: "image/jpeg")
            )
            
            return .uploadMultipart(formData)
        }
    }
    
    var headers: [String : String]? {
        var dict: [String: String] = [:]
        
        if let accessToken = extractedRequestData.authorizationToken {
            dict["Authorization"] = "Bearer \(accessToken)"
        }
        
        dict["user-agent"] = extractedRequestData.uuid
        return dict
    }
}
