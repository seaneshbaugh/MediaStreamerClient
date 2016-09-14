import UIKit
import MediaPlayer

class SongsViewController: UIViewController {
    @IBOutlet weak var songsTableView: UIView!
    
    @IBOutlet weak var currentSongTitle: UILabel!

    @IBOutlet weak var currentSongTime: UILabel!
    
    @IBOutlet weak var previousButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var playPauseButton: UIButton!
    
    @IBOutlet weak var currentSongProgress: UISlider!
    
    var songsTableViewController: SongsTableViewController!

    var artist: Artist?
    
    var album: Album?

    var selectedSong: Song?
    
    var draggingProgress = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.songsTableViewController = SongsTableViewController()
        
        self.songsTableViewController.willMove(toParentViewController: self)
        
        self.addChildViewController(self.songsTableViewController)
        
        self.songsTableViewController.view.frame = self.songsTableView.bounds
        
        self.songsTableView.addSubview(self.songsTableViewController.view)
        
        self.songsTableViewController.didMove(toParentViewController: self)
        
        self.refresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func refresh() -> Void {
        self.navigationController?.navigationBar.topItem!.title = album!.name
        
        DataManager.getAlbums(self.album!.url! + "/albumart", success: { (imageData) -> Void in
            // TODO: Figure out a way to reference the subview that doesn't involve magically knowing its index.
            
            DispatchQueue.main.async {
                let imageView = self.view.subviews[0] as! UIImageView
            
                let image = UIImage(data: imageData!)
            
                imageView.image = image
            }
        })
        
        DataManager.getSongs(self.album!.apiURL!, success: { (albumData) -> Void in
            let json = JSON(data: albumData!)
            
            if let songsJSON = json["album"]["songs"].array {
                self.album!.songs = [Song]()
                
                for songJSON in songsJSON {
                    let title: String? = songJSON["title"].string
                    
                    let track: String? = songJSON["track"].string
                    
                    let disc: String? = songJSON["disc"].string
                    
                    let year: String? = songJSON["year"].string
                    
                    let length: Int? = songJSON["audio_properties"]["length"].int
                    
                    let url: String? = songJSON["url"].string
                    
                    let apiURL: String? = songJSON["api_url"].string
                    
                    let song: Song = Song(title: title, track: track, disc: disc, year: year, length: length, url: url, apiURL: apiURL)
                    
                    self.album!.songs!.append(song)
                }
            }
            
            self.songsTableViewController.songs = self.album!.songs!
            
            self.songsTableViewController.refresh()
        })
    }
    
    func playSong(_ song: Song) -> Void {
        let escapedURL = song.url!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        appDelegate.avPlayer = AVPlayer(url: URL(string: escapedURL)!)

        appDelegate.avPlayer!.play()
        
        self.currentSongTitle.text = self.selectedSong!.title
        
        self.currentSongTime.text = "0:00"
        
        self.currentSongProgress.isEnabled = true
        
        self.currentSongProgress.value = 0.0
        
        self.currentSongProgress.maximumValue = Float((self.selectedSong?.length!)!)
        
        self.playPauseButton.setImage(UIImage(named: "pause.png"), for: UIControlState())
        
        appDelegate.avPlayer!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(0.016, 1000), queue: DispatchQueue.main) { (CMTime) -> Void in

            let currentTime = Int(appDelegate.avPlayer!.currentTime().value) / Int(appDelegate.avPlayer!.currentTime().timescale)
            
            self.currentSongTime.text = String(format: "%d:%02d", currentTime / 60, currentTime % 60)
            
            if !self.draggingProgress {
                self.currentSongProgress.value = Float(appDelegate.avPlayer!.currentTime().value) / Float(appDelegate.avPlayer!.currentTime().timescale)
            }
        }

        NotificationCenter.default.addObserver(self, selector: #selector(SongsViewController.songFinishedPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: appDelegate.avPlayer!.currentItem)
    }
    
    @IBAction func previousSong(_ sender: AnyObject) {
        let currentIndexPath = self.songsTableViewController.tableView.indexPathForSelectedRow

        var nextRow = (currentIndexPath! as NSIndexPath).row - 1
        
        if nextRow < 0 {
            nextRow = self.album!.songs!.count - 1
        }
        
        let nextIndexPath = IndexPath(row: nextRow, section: 0)
        
        self.songsTableViewController.tableView.selectRow(at: nextIndexPath, animated: true, scrollPosition: UITableViewScrollPosition.middle)
        
        self.songsTableViewController.selectedSong = self.songsTableViewController.songs[nextRow]
        
        self.selectedSong = self.songsTableViewController.selectedSong
        
        self.playSong(self.songsTableViewController.selectedSong!)
    }
    
    @IBAction func nextSong(_ sender: AnyObject) {
        let currentIndexPath = self.songsTableViewController.tableView.indexPathForSelectedRow
        
        var nextRow = (currentIndexPath! as NSIndexPath).row + 1
        
        if nextRow >= self.album!.songs!.count {
            nextRow = 0
        }

        let nextIndexPath = IndexPath(row: nextRow, section: 0)
    
        self.songsTableViewController.tableView.selectRow(at: nextIndexPath, animated: true, scrollPosition: UITableViewScrollPosition.middle)
        
        self.songsTableViewController.selectedSong = self.songsTableViewController.songs[nextRow]
        
        self.selectedSong = self.songsTableViewController.selectedSong
        
        self.playSong(self.songsTableViewController.selectedSong!)
    }
    
    @IBAction func playPauseSong(_ sender: AnyObject) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        if self.selectedSong != nil{
            if appDelegate.avPlayer!.rate != 0 && appDelegate.avPlayer!.error == nil {
                appDelegate.avPlayer!.pause()
                
                self.playPauseButton.setImage(UIImage(named: "play.png"), for: UIControlState())
            } else {
                appDelegate.avPlayer!.play()
                
                self.playPauseButton.setImage(UIImage(named: "pause.png"), for: UIControlState())
            }
        }
    }

    @IBAction func currentSongProgressDragStart(_ sender: AnyObject) {
        self.draggingProgress = true
    }
    
    @IBAction func currentSongProgressDragEnd(_ sender: AnyObject) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        self.draggingProgress = false
        
        let slider = sender as! UISlider
        
        appDelegate.avPlayer!.seek(to: CMTimeMake(Int64(slider.value), 1))
    }
    
    func songFinishedPlaying(_ note: Notification) {
        self.nextSong(self.nextButton)
    }
}
