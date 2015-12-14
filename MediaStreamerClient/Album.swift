import Foundation

struct Album {
    var name: String?
    
    var url: String?

    var apiURL: String?
    
    var songs: [Song]?
    
    init(name: String?, url: String?, apiURL: String?) {
        self.name = name
        
        self.url = url

        self.apiURL = apiURL
    }
}