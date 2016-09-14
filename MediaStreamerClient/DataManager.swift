import Foundation

class DataManager {
    static let baseURL = "http://70.121.54.117:4567/api/v1"
    
    class func loadDataFromURL(_ url: URL, completion:@escaping (_ data: Data?, _ error: NSError?) -> Void) {
        let session = URLSession.shared
        
        let loadDataTask = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if let responseError = error {
                completion(nil, responseError as NSError?)
            } else {
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode != 200 {
                        let statusError = NSError(domain: "com.seaneshbaugh", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey : "Non-200 response."])
                        
                        completion(nil, statusError)
                    } else {
                        completion(data, nil)
                    }
                }
            }
        })
        
        loadDataTask.resume()
    }
    
    class func getArtists(_ success: @escaping ((_ artistsData: Data?) -> Void)) {
        loadDataFromURL(URL(string: baseURL)!, completion: {(data, error) -> Void in
            if let urlData = data {
                success(urlData)
            }
        })
    }
    
    class func getAlbums(_ apiURL: String, success: @escaping ((_ albumsData: Data?) -> Void)) {
        let escapedURL = apiURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        loadDataFromURL(URL(string: escapedURL)!, completion: {(data, error) -> Void in
            if let urlData = data {
                success(urlData)
            }
        })
    }
    
    class func getSongs(_ apiURL: String, success: @escaping ((_ songsData: Data?) -> Void)) {
        let escapedURL = apiURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        loadDataFromURL(URL(string: escapedURL)!, completion: {(data, error) -> Void in
            if let urlData = data {
                success(urlData)
            }
        })
    }
    
    class func downloadImage(_ url: String, success: @escaping ((_ imageData: Data?) -> Void)) {
        let escapedURL = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        loadDataFromURL(URL(string: escapedURL)!, completion: {(data, error) -> Void in
            if let urlData = data {
                success(urlData)
            }
        })
    }
}
