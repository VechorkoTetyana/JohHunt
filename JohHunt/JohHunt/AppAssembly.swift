import Foundation
import Swinject
import JobHuntAuthentication
import JobHuntLogin
import JobHuntSettings

class AppAssembly {
    
    let container: Container
    
    init(container: Container) {
        self.container = container
    }
    
    func assemble() {
        let authService = AuthServiceLive()
        let userRepository = UserProfileRepositoryLive(authService: authService)
            
        let profilePictureRepository = ProfilePictureRepositoryLive(
            authService: authService,
            userProfileRepository: userRepository
        )
        
        container.register(AuthService.self) { container in
            authService
        }
        
        container.register(UserProfileRepository.self) { container in
            userRepository
        }
        
        container.register(ProfilePictureRepository.self) { container in
            profilePictureRepository
        }
        
//        let authServiceFromContainer = container.resolve(authService.self)!
    }
}
