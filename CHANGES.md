# Wikipedia iOS (Fork)

This is a fork of the [official Wikipedia iOS app](https://github.com/wikimedia/wikipedia-ios) with one change: I added deep link support so an external app can open Wikipedia directly to the Places tab at specific coordinates.

## What I added

The Wikipedia app already had a custom URL scheme (`wikipedia://`) and it already handled `wikipedia://places` for opening the Places tab. But it only supported opening an article URL there, not raw coordinates.

I extended it so you can now pass latitude and longitude directly:

```
wikipedia://places?lat=52.3676&lon=4.9041
```

When the app recieves this URL it switches to the Places tab, flips to map view, and zooms to those coordinates.

## Why

I built this to support [WikiBridge](https://github.com/ugur112358/WikiBridge), which fetches a list of locations from an API and opens them in Wikipedia via deep linking. Without this change there was no way to tell the Wikipedia app "go to this coordinate on the map".

## What I changed

The existing `NSUserActivity+WMFExtensions.m` already parsed the `wikipedia://places` URL and created an NSUserActivity. I modified it to also look for `lat` and `lon` query parameters and store them in the activity's userInfo dictionary.

Then on the receiving side, instead of the app controller directly checking for an article URL and calling `showArticleURL`, I added a small handler that checks wheter the activity contains coordinates or an article URL and routes accordingly.

### New files

- `Wikipedia/Code/DeepLink/PlacesDeepLinkDestination.swift` — enum with the possible destinations (coordinates, article, or default)
- `Wikipedia/Code/DeepLink/PlacesDeepLinkHandler.swift` — reads the NSUserActivity and returns the right destination. Also validates that lat is between -90 and 90 and lon between -180 and 180.
- `Wikipedia/Code/DeepLink/PlacesDeepLinkNavigating.swift` — protocol so PlacesViewController conforms to it

### Modified files

- `Wikipedia/Code/NSUserActivity+WMFExtensions.m` — the `wmf_placesActivityWithURL:` method now parses lat/lon params and puts them in userInfo
- `Wikipedia/Code/PlacesViewController.swift` — added an extension that conforms to `PlacesDeepLinkNavigating` and handles navigating to coordinates or an article
- `Wikipedia/Code/WMFAppViewController.swift` — replaced the old direct article URL handling with the new `PlacesDeepLinkHandler`

## How to test

1. Install this fork on a simulator or device
2. Install WikiBridge on the same simulator or device
3. Tap a location in WikiBridge, it should open Wikipedia and zoom to that spot on the map

