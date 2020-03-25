

import Foundation



public class User : JsonSerilizable{
	public var user_id : Int64?
	public var authtoken : String?
	public var login_date : Date?
	public var device_type : String?
	public var last_time_used : Date?
	public var id : Int64?


    public class func modelsFromDictionaryArray(array:NSArray) -> [User]
    {
        var models:[User] = []
        for item in array
        {
            models.append(User(dictionary: item as! NSDictionary)!)
        }
        return models
    }


	required public init?(dictionary: NSDictionary) {
        
        let dateFor = DateFormatter()//ISO8601DateFormatter()
        dateFor.calendar = Calendar(identifier: .iso8601)
        dateFor.locale = Locale(identifier: "en_US_POSIX")
     //   dateFor.timeZone = TimeZone.init(identifier: "UTC")
        dateFor.setLocalizedDateFormatFromTemplate("yyyy-MM-dd HH:mm:ss")
      //  dateFor.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        
    //    dateFor.locale = Locale(identifier: "en_US_POSIX")

		user_id = dictionary["user_id"] as? Int64
		authtoken = dictionary["authtoken"] as? String
        
		device_type = dictionary["device_type"] as? String
        
		id = dictionary["id"] as? Int64
	}

		

	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.user_id, forKey: "user_id")
		dictionary.setValue(self.authtoken, forKey: "authtoken")
		dictionary.setValue(self.login_date, forKey: "login_date")
		dictionary.setValue(self.device_type, forKey: "device_type")
		dictionary.setValue(self.last_time_used, forKey: "last_time_used")
		dictionary.setValue(self.id, forKey: "id")

		return dictionary
	}

}
