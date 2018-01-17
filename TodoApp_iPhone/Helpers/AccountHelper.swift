
import Foundation


class AccountHelper {
    //  This is the singleton pattern -> only one instance allowed per application
    public static var sharedInstance = AccountHelper()

    var userId: Int?
    var token: String?
    var username: String?

    fileprivate init() {

    }
    
    func getUsername() -> String {
        return username!
    }
    
    func getToken() -> String {
        return token!
    }
}

