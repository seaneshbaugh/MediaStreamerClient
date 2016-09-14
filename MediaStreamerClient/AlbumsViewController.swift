import UIKit

class AlbumsViewController: UITableViewController {
    var artist: Artist?
    
    var albums: [Album] = [Album]()
    
    var selectedAlbum: Album?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
        self.navigationController?.navigationBar.topItem!.title = artist!.name
        
        self.refresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath)
        
        let album = albums[(indexPath as NSIndexPath).row] as Album
        
        cell.textLabel?.text = album.name
        
        cell.detailTextLabel?.text = ""
        
        //cell.detailTextLabel?.text = album.songs![0].year
        
        return cell
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        
        self.selectedAlbum = albums[(indexPath as NSIndexPath).row] as Album
        
        performSegue(withIdentifier: "albumsToSongsSegue", sender: self)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "albumsToSongsSegue" {
            let navigationController = segue.destination as! UINavigationController
            
            let songsViewController = navigationController.topViewController as! SongsViewController
            
            songsViewController.artist = self.artist
            
            songsViewController.album = self.selectedAlbum
            
            // TODO: Set songs here.
        }
    }

    func refresh() -> Void {
        DataManager.getAlbums((self.artist?.apiURL!)!, success: { (albumsData) -> Void in
            let json = JSON(data: albumsData!)
            
            if let albumsJSON = json["artist"]["albums"].array {
                self.albums = [Album]()
                
                for albumJSON in albumsJSON {
                    let name: String? = albumJSON["name"].string
                    
                    let url: String? = albumJSON["url"].string
                    
                    let apiURL: String? = albumJSON["api_url"].string
                    
                    var album: Album = Album(name: name, url: url, apiURL: apiURL)

                    if let songsJSON = albumJSON["songs"].array {
                        album.songs = [Song]()
                        
                        for songJSON in songsJSON {
                            let title: String? = songJSON["title"].string
                        
                            let track: String? = songJSON["track"].string
                            
                            let disc: String? = songJSON["disc"].string
                            
                            let year: String? = songJSON["year"].string
                            
                            let length: Int? = songJSON["audio_properties"]["length"].int
                            
                            let url: String? = songJSON["url"].string
                            
                            let apiURL: String? = songJSON["api_url"].string
                            
                            let song: Song = Song(title: title, track: track, disc: disc, year: year, length: length, url: url, apiURL: apiURL)
                            
                            album.songs!.append(song)
                        }
                    }
                    
                    self.albums.append(album)
                }
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData();
            }
        })
    }
    
    @IBAction func cancelToAlbumsViewController(_ segue: UIStoryboardSegue) {
    }
}
