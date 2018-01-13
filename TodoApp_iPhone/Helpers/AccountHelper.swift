
import Foundation


class AccountHelper {
    //  This is the singleton pattern -> only one instance allowed per application
    public static var sharedInstance = AccountHelper()

    var userId: Int?
    var token: String?
    var userName: String?

    fileprivate init() {

    }
}

