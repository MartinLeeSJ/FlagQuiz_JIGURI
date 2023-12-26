//
//  Services.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/12/23.
//

import Foundation

protocol ServiceType {
    var authService: AuthServiceType { get set }
    var userService: UserServiceType { get set }
    var quizRecordService: QuizRecordServiceType { get set }
    var quizStatService: QuizStatServiceType { get set }
    var countryService: CountryServiceType { get set }
    var countryQuizStatService: CountryQuizStatServiceType { get set }
    var imageCacheService: ImageCacheServiceType { get set }
}

class Services: ServiceType {
    
    var authService: AuthServiceType
    var userService: UserServiceType
    var quizRecordService: QuizRecordServiceType
    var quizStatService: QuizStatServiceType
    var countryService: CountryServiceType
    var countryQuizStatService: CountryQuizStatServiceType
    var imageCacheService: ImageCacheServiceType

    init() {
        self.authService = AuthService()
        self.userService = UserService(repository: .init())
        
        self.quizRecordService = QuizRecordService(
            repository: FQQuizRecordRepository()
        )
        
        self.quizStatService = QuizStatService(
            repository: FQUserQuizStatRepository()
        )
        
        self.countryService = CountryService(
            apiClient: .init(
                cacheService: CountryCacheService(
                    countryMemoryStorage: CountryMemoryStorage(),
                    countryDiskStorage: CountryDiskStorage()
                )
            )
        )
        
        self.countryQuizStatService = CountryQuizStatService(repository: FQCountryQuizStatRepository())
        
        self.imageCacheService = ImageCacheService(
            imageMemoryStorage: ImageMemoryStorage(),
            imageDiskStorage: ImageDiskStorage()
        )
  
    }
}

class StubService: ServiceType {
    var authService: AuthServiceType
    var userService: UserServiceType
    var quizRecordService: QuizRecordServiceType
    var quizStatService: QuizStatServiceType
    var countryService: CountryServiceType
    var countryQuizStatService: CountryQuizStatServiceType
    var imageCacheService: ImageCacheServiceType
  
    
    init() {
        self.authService = StubAuthService()
        self.userService = StubUserService()
        self.quizRecordService = StubQuizRecordService()
        self.quizStatService = StubQuizStatService()
        self.countryService = StubCountryService()
        self.countryQuizStatService = StubCountryQuizStatService()
        self.imageCacheService = StubImageCacheService()
    }
}
