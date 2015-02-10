class Settings: NSObject {

    var defaults: NSUserDefaults

    let CookieStorageKey = "CookieStorageKey"

    override init() {
        defaults = NSUserDefaults()

        super.init()

        registerDefaults()
    }

    func registerDefaults() {
        defaults.registerDefaults([
            CookieStorageKey : NSKeyedArchiver.archivedDataWithRootObject(BSHTTPCookieStorage())
        ]);
    }

    func saveCookieStorage(cookieStorage: BSHTTPCookieStorage) {
        defaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(cookieStorage), forKey: CookieStorageKey )
        defaults.synchronize()
    }

    func retrieveCookieStorage() -> BSHTTPCookieStorage {
        var cookieStorage  = defaults.objectForKey(CookieStorageKey ) as NSData
        return NSKeyedUnarchiver.unarchiveObjectWithData(cookieStorage) as BSHTTPCookieStorage
    }
}
