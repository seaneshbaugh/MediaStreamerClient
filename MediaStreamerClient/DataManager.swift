import Foundation

class DataManager {
    static let baseURL = "http://70.121.54.117:4567/api/v1"
    
    class func loadDataFromURL(url: NSURL, completion:(data: NSData?, error: NSError?) -> Void) {
        let session = NSURLSession.sharedSession()
        
        let loadDataTask = session.dataTaskWithURL(url, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let responseError = error {
                completion(data: nil, error: responseError)
            } else {
                if let httpResponse = response as? NSHTTPURLResponse {
                    if httpResponse.statusCode != 200 {
                        let statusError = NSError(domain: "com.seaneshbaugh", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey : "Non-200 response."])
                        
                        completion(data: nil, error: statusError)
                    } else {
                        completion(data: data, error: nil)
                    }
                }
            }
        })
        
        loadDataTask.resume()
    }
    
    class func getArtists(success: ((artistsData: NSData?) -> Void)) {
        loadDataFromURL(NSURL(string: baseURL)!, completion: {(data, error) -> Void in
            if let urlData = data {
                success(artistsData: urlData)
            }
        })
    }
    
    class func getAlbums(apiURL: String, success: ((albumsData: NSData?) -> Void)) {
        let escapedURL = apiURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        loadDataFromURL(NSURL(string: escapedURL)!, completion: {(data, error) -> Void in
            if let urlData = data {
                success(albumsData: urlData)
            }
        })
    }
    
    class func getSongs(apiURL: String, success: ((songsData: NSData?) -> Void)) {
        let escapedURL = apiURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        loadDataFromURL(NSURL(string: escapedURL)!, completion: {(data, error) -> Void in
            if let urlData = data {
                success(songsData: urlData)
            }
        })
    }
    
    class func downloadImage(url: String, success: ((imageData: NSData?) -> Void)) {
        let escapedURL = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        loadDataFromURL(NSURL(string: escapedURL)!, completion: {(data, error) -> Void in
            if let urlData = data {
                success(imageData: urlData)
            }
        })
    }
}