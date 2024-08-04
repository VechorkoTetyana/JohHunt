import UIKit
import Swinject
import JobHuntAuthentication

public final class SettingsViewModel {
    
    struct Header {
        let imageUrl: URL?
        let name: String
        let description: String
    }
    var header: Header
    
    var didUpdateHeader: (() -> ())?
    
    let container: Container
        
    var userRepository: UserProfileRepository {
        container.resolve(UserProfileRepository.self)!
    }
    
    public init(container: Container)
    {
        self.container = container

        header = Header(
            imageUrl: nil,
            name: "Company",
            description: "No description"
        )
    }
    
    func fetchUserProfile() {
        Task { [weak self] in
            do {
                guard let profile = try await self?.userRepository.fetchUserProfile() else { return }
                                
                await MainActor.run { [weak self] in
                    self?.updateHeader(with: profile)
                }
            } catch {
                print(error)
            }
        }
    }
    
    private func updateHeader(with userProfile: UserProfile) {
        header = Header(
            imageUrl: userProfile.profilePictureUrl,
            name: userProfile.fullName,
            description: userProfile.description
        )
        
        didUpdateHeader?()
    }
}
