import Foundation

struct Song {
    var title: String?
    
    var track: String?
    
    var disc: String?
    
    var year: String?
    
    var length: Int?
    
    var url: String?
    
    var apiURL: String?
    
    init(title: String?, track: String?, disc: String?, year: String?, length: Int?, url: String?, apiURL: String?) {
        self.title = title
        
        self.track = track
        
        self.disc = disc
        
        self.year = year

        self.length = length

        self.url = url

        self.apiURL = apiURL
    }
}
