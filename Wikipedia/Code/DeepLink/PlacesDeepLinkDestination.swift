import CoreLocation

enum PlacesDeepLinkDestination {
    case coordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    case article(URL)
    case `default`
}
