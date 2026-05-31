import Foundation

struct PlacesDeepLinkHandler {
    func destination(from activity: NSUserActivity) -> PlacesDeepLinkDestination {
        guard let userInfo = activity.userInfo,
              let latValue = userInfo["WMFPlacesLatitude"] as? Double,
              let lonValue = userInfo["WMFPlacesLongitude"] as? Double else {
            if let url = activity.webpageURL {
                return .article(url)
            }
            return .default
        }

        guard (-90...90).contains(latValue), (-180...180).contains(lonValue) else {
            return .default
        }

        return .coordinates(latitude: latValue, longitude: lonValue)
    }
}
