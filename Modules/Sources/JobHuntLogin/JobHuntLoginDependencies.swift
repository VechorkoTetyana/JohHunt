import Foundation
import JobHuntAuthentication

public protocol JobHuntLoginDependencies {
    var authService: AuthService { get }
}
