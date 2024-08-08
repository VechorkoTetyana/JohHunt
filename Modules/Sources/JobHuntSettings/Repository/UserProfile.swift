import Foundation

public struct UserProfile: Codable {
    public let companyName: String
    public let location: String
    public let profilePictureUrl: URL?
    
    public init(
        companyName: String,
        location: String,
        profilePictureUrl: URL? = nil
    ) {
        self.companyName = companyName
        self.location = location
        self.profilePictureUrl = profilePictureUrl
    }
}
