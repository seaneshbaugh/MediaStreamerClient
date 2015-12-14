import Foundation

struct Artist {
    var name: String?

    var genre: String?
    
    var url: String?

    var apiURL: String?
    
    init(name: String?, genre: String?, url: String?, apiURL: String?) {
        self.name = name
        
        self.genre = genre
        
        self.url = url
        
        self.apiURL = apiURL
    }
}