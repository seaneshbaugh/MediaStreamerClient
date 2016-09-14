import UIKit

class ArtistsViewController: UITableViewController {
    var artists: [Artist] = [Artist]()
    
    var selectedArtist: Artist?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
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
        return artists.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistCell", for: indexPath)
        
        let artist = artists[(indexPath as NSIndexPath).row] as Artist
        
        cell.textLabel?.text = artist.name
        
        cell.detailTextLabel?.text = artist.genre
        
        return cell
    }

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
        
        self.selectedArtist = artists[(indexPath as NSIndexPath).row] as Artist

        performSegue(withIdentifier: "artistsToAlbumsSegue", sender: self)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "artistsToAlbumsSegue" {
            let navigationController = segue.destination as! UINavigationController
            
            let albumsViewController = navigationController.topViewController as! AlbumsViewController
            
            //let albumsViewController = segue.destinationViewController.topViewController as! AlbumsViewController
        
            albumsViewController.artist = self.selectedArtist
        }
    }
    
//    - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([[segue identifier] isEqualToString:@"showItems"]) {
//    UINavigationController *navigationController = segue.destinationViewController;
//    ShowItemsTableViewController *showItemsTVC = (ShowItemsTableViewController * )navigationController.topViewController;
//    showItemsTVC.items = [self itemsFromCoreData];
//    }
    
    func refresh() -> Void {
        DataManager.getArtists { (artistsData) -> Void in
            let json = JSON(data: artistsData!)
            
            if let artists = json["artists"].array {
                self.artists = [Artist]()
                
                for artist in artists {
                    let name: String? = artist["name"].string
                    
                    let genre: String? = artist["genre"].string
                    
                    let url: String? = artist["url"].string
                    
                    let apiURL: String? = artist["api_url"].string
                    
                    self.artists.append(Artist(name: name, genre: genre, url: url, apiURL: apiURL))
                }
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData();
            }
        }
    }
    
    @IBAction func cancelToArtistsViewController(_ segue: UIStoryboardSegue) {
    }
}
