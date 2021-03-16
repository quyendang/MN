//
//  ViewController.swift
//  musicnow
//
//  Created by Quyen on 10/4/20.
//

import UIKit
import SDWebImage
import XCDYouTubeKit
import PromiseKit
typealias CellActivityItem = (index: Int, activity: CGFloat)
class ViewController: UIViewController {
    let cellHeight = (4 / 5) * UIScreen.main.bounds.height
    let sectionSpacing = (1 / 10) * UIScreen.main.bounds.height
    let cellSpacing = CGFloat(5)
    fileprivate let animatableViewHeight = 50
    fileprivate let animatableViewWidth = 50
    fileprivate let animatableViewAlpha: CGFloat = 0.7
    fileprivate let animatableViewScale: CGFloat = 1.7
    fileprivate let defaultStartProgress: Float = 0.0
    
    fileprivate let asyncOffset: Float = 0.2
    fileprivate var isLoading = false
    fileprivate var loadingView: LoadMoreReusableView?
    @IBOutlet weak var searchButton: UIButton!
    lazy var collectionView: UICollectionView = {
        let layout = CenterCellCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let top = UIApplication.shared.windows[0].safeAreaInsets.top
        layout.headerReferenceSize = CGSize.zero
        layout.footerReferenceSize = CGSize.zero
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: 0, bottom: sectionSpacing, right: 0)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: cellHeight)
        layout.minimumLineSpacing = cellSpacing
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .systemBackground
        collectionView.decelerationRate = .fast
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(UINib(nibName: "PlayerCell", bundle: nil), forCellWithReuseIdentifier: "playercell")
        collectionView.register(UINib(nibName: "LoadMoreReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "loadingcell")
        return collectionView
    }()
    
    lazy var customTitleView: CustomTitleView = {
        let customTitleView = CustomTitleView.instantiateFromNib()
        customTitleView.titleViewStack.translatesAutoresizingMaskIntoConstraints = false
        customTitleView.titleViewStack.layer.cornerRadius = 6.0
        customTitleView.delegate = self
        return customTitleView
    }()
    
    
    
    var currentCell: PlayerCell?
    
    var videos: [Video] = []
    var channels: [Channel] = [] {
        didSet{
            if channels.count > 0 {
                guard let title = channels.first?.snippet?.title else {
                    return
                }
                DispatchQueue.main.async {
                    self.customTitleView.titleLabel.text = title
                }
            }
            
        }
    }
    private let minimumLineSpacing: CGFloat = 0
    private let expansionValue: CGFloat = 0
    private let transformValueCoefficient: CGFloat = 1
    private let numberOfTapsRequired = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = customTitleView
        PlayerManager.player.delegate = self
        setupUI()
        applyConstraints()
        loadData()
        searchButton.addTarget(self, action: #selector(searchTaped), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    fileprivate func customizeViewController() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: nil)
        alertController.addAction(deleteAction)
        // Create custom content viewController
        let contentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "channelViewController") as! ChannelViewController
        contentViewController.preferredContentSize = CGSize(width: 270, height: 320)
        alertController.setValue(contentViewController, forKey: "contentViewController")
        //        contentViewController.updateUI(image: "heart", message: "Tiêu chuẩn chọn người yêu của bạn là gì?",
        //                                       items: [
        //                                        ("Xinh đẹp", false),
        //                                        ("Sexy", false),
        //                                        ("Giỏi giang", false),
        //                                        ("Dịu dàng", false),
        //                                        ("Biết nấu ăn", true),
        //                                        ("Là con gái", true),
        //                                       ])
        present(alertController, animated: true, completion: nil)
    }
    
    
    @objc func searchTaped() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "searchViewController") as! SearchViewController
        self.present(vc, animated: true, completion: nil)
    }
    private func setupUI(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap)
    }
    @objc private func doubleTapped(g: UIGestureRecognizer) {
        togglePlay()
    }
    private func applyConstraints() {
        view.insertSubview(collectionView, belowSubview: searchButton)
        
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    func loadData() {
        firstly {
            when(fulfilled: getFeatureChannel(), getTrendingVideo())
        }.done { (arg) in
            let (channels, videoss) = arg
            self.channels = channels
            self.videos.append(contentsOf: videoss)
            self.collectionView.reloadData()
            let listAudioItem = self.videos.map({ (video: Video) -> AudioItem in
                AudioItem(videoId: video.id, title: video.snippet?.title, artist: video.snippet?.channelTitle, imageUrl: video.snippet?.thumbnails.high.url)!
            })
            PlayerManager.player.play(items: listAudioItem)
            
        }.catch { error in
        }
    }
    
    func getFeatureChannel() -> Promise<[Channel]> {
        return Promise { seal in
            let request = ChannelListRequest(part: [.snippet], filter: .id("UCEickjZj99-JJIU8_IJ7J-Q,UC_aEa8K-EOJ3D6gOs7HcyNg,UC0e9cA2FBgEhhFuf1Kifujw,UCCeNgETxEJf__ZAAOvU5ZaQ,UCXvSeBDvzmPO05k-0RyB34w,UCfLFTP1uTuIizynWsZq2nkQ,UCJrOtniJ0-NWz37R30urifQ,UCAA6pKrh72sARBb7JCfp8AA,UCmDM6zuSTROOnZnjlt2RJGQ,UCBNkoUc0kf7a-x1RteoNHng,UCtrJkOsiFLIUg6Dku7UVn_A,UCM9KEEuzacwVlkt9JfJad7g,UCAHlZTSgcwNNpf8LV3E6kDQ"))
            ApiSession.shared.send(request) { result in
                switch result {
                case .success(let response):
                    for item in response.items {
                        print("\(item.id),\(item.snippet!.title)")
                    }
                    seal.fulfill(response.items)
                case .failed( _):
                    seal.fulfill([])
                }
            }
        }
    }
    
    func getTrendingVideo()  -> Promise<[Video]>{
        return Promise { seal in
            guard let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String else {
                return
            }
            
            let request = VideoListRequest(part: [.snippet, .statistics], filter: .chart, maxResults: 20, onBehalfOfContentOwner: nil, pageToken: nil, regionCode: "VN", videoCategoryID: nil)
            
            ApiSession.shared.send(request) { result in
                switch result {
                case .success(let response):
                    let list =  response.items.filter({ (video) -> Bool in
                        video.snippet?.categoryID == "10"
                    })
                    seal.fulfill(list)
                case .failed( _):
                    seal.fulfill([])
                }
            }
        }
    }
    
    func getChannelVideoIds(_ channelId: String) -> Promise<[String]> {
        return Promise { seal in
            let request = VideoListChannelRequest(part: [.id, .snippet], channelID: channelId, maxResults: 10, pageToken: nil, order: .viewCount)
            ApiSession.shared.send(request) { result in
                switch result {
                case .success(let response):
                    let videoIds = response.items.map { (item) -> String in
                        item.id.videoID!
                    }
                    seal.fulfill(videoIds)
                case .failed( _):
                    seal.fulfill([])
                }
            }
        }
    }
    
    func getVideoInfos(_ videoIds: [String]) -> Promise<[Video]>{
        return Promise { seal in
            let videoIdString = videoIds.joined(separator: ",")
            let request = VideoListRequest(part: [.id, .snippet, .statistics], filter: .id(videoIdString))
            ApiSession.shared.send(request) { result in
                switch result {
                case .success(let response):
                    seal.fulfill(response.items)
                case .failed( _):
                    seal.fulfill([])
                }
            }
        }
    }
    
    func setCurrentIndex(index: Int, animated: Bool) {
        guard let songs = PlayerManager.player.items, index < songs.count, index >= 0 else {
            return
        }
        self.currentCell?.isHide = true
        //currentSongIndex = index
        let ix = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: ix, at: .centeredVertically, animated: animated)
    }
    
    fileprivate func togglePlay() {
        let isPlaying = PlayerManager.player.state.isPlaying
        
        if isPlaying {
            PlayerManager.player.pause()
        } else {
            PlayerManager.player.resume()
        }
        animatePlayToggling()
    }
    
    fileprivate func animatePlayToggling(duration: TimeInterval = 0.2) {
        let viewToAnimate = UIImageView(frame: CGRect(x: 0, y: 0, width: animatableViewWidth, height: animatableViewHeight))
        let imageStr = PlayerManager.player.state.isPlaying ? "pause.fill": "play.fill"
        let image = UIImage(systemName: imageStr)
        viewToAnimate.image = image
        viewToAnimate.alpha = 0
        viewToAnimate.center = view.center
        viewToAnimate.tintColor = .white
        viewToAnimate.tag = 11111
        view.addSubview(viewToAnimate)
        view.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: duration/2, delay: 0, options: .autoreverse, animations: { [self] in
            viewToAnimate.alpha = animatableViewAlpha
        })
        
        UIView.animate(withDuration: duration, animations: { [self] in
            viewToAnimate.transform = viewToAnimate.transform.scaledBy(x: animatableViewScale, y: animatableViewScale)
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration - (duration * Double(asyncOffset))) {
            viewToAnimate.removeFromSuperview()
            self.view.isUserInteractionEnabled = true
        }
    }
}

extension ViewController: CustomTitleViewDelegate {
    func isExpandMenu(_ isExpand: Bool) {
//        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
//        let topChartAction = UIAlertAction(title: "TOP CHART", style: .destructive) { (atc) in
//
//        }
//        let recentAction = UIAlertAction(title: "Recent", style: .destructive) { (atc) in
//
//        }
//        optionMenu.addAction(topChartAction)
//        optionMenu.addAction(recentAction)
//
//        for item in self.channels {
//            let action = UIAlertAction(title: item.snippet?.title, style: .default) { (atc) in
//                self.customTitleView.titleLabel.text = item.snippet?.title
//                self.customTitleView.isExpand = false
//                firstly {
//                    self.getChannelVideoIds(item.id)
//                    }.then { videoIds in
//                        self.getVideoInfos(videoIds)
//                    }.done { vids in
//                        self.videos.removeAll()
//                        self.videos.append(contentsOf: vids)
//                        self.collectionView.reloadData()
//                        let listAudioItem = self.videos.map({ (video: Video) -> AudioItem in
//                            AudioItem(videoId: video.id, title: video.snippet?.title, artist: video.snippet?.channelTitle, imageUrl: video.snippet?.thumbnails.high.url)!
//                        })
//                        PlayerManager.player.play(items: listAudioItem)
//                    }.catch { _ in
//                        print("Error!")
//                }
//            }
//            optionMenu.addAction(action)
//        }
//        let cancelAction = UIAlertAction(title: "Cancle", style: .cancel) { (atc) in
//            self.customTitleView.isExpand = false
//        }
//        optionMenu.addAction(cancelAction)
//        self.present(optionMenu, animated: true, completion: nil)
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "channelSettingViewController") as! ChannelSettingViewController
        self.present(vc, animated: true, completion: nil)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //
    //        if indexPath.item == 0 {
    //            return CGSize(width: UIScreen.main.bounds.width, height: cellHeight + sectionSpacing)
    //        }else{
    //            return CGSize(width: UIScreen.main.bounds.width, height: cellHeight)
    //        }
    //    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    //        return UIEdgeInsets(top: 0, left: 0, bottom: sectionSpacing, right: 0)
    //
    //    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.isLoading {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.bounds.size.width, height: 30)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "loadingcell", for: indexPath) as! LoadMoreReusableView
            loadingView = aFooterView
            loadingView?.backgroundColor = UIColor.clear
            return aFooterView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.startAnimating()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.stopAnimating()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == videos.count - 1 && !self.isLoading {
            loadMoreData()
        }
    }
    
    func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            DispatchQueue.global().async {
                // Fake background loading task for 2 seconds
                sleep(2)
                //self.videos.append(contentsOf: self.videos)
                // Download more data here
                DispatchQueue.main.async {
                    //self.collectionView.reloadData()
                    self.isLoading = false
                }
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "playercell", for: indexPath) as! PlayerCell
        cell.transform = CGAffineTransform.identity
        cell.isHide = true
        let item = videos[indexPath.item]
        let ix = (indexPath.item+1) % 15
        cell.progressView.tintColor = UIColor(named: "1l-\(ix)")
        if let imageUrl = item.snippet?.thumbnails.medium.url {
            SDWebImageManager.shared.loadImage(with: URL(string: imageUrl.replacingOccurrences(of: "mqdefault", with: "maxresdefault")), options: .refreshCached, progress: nil) { (image, _, _, _, _, _) in
                if let img = image {
                    img.getColorsAddFillter(index: indexPath.item, quality: .high) { (imgOut) in
                        cell.scrollImage.imageView.image = imgOut
                        
                    }
                }
            }
        }
        cell.onPlayTapped = { [self] in
            togglePlay()
        }
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let y = self.collectionView.contentOffset.y + sectionSpacing
        let p = CGPoint(x: 0, y: y)
        guard let ix = collectionView.indexPathForItem(at: p), let currentIndex = PlayerManager.player.currentItemIndexInQueue else {
            return
        }
        
        if ix.item != currentIndex {
            self.currentCell?.isHide = true
            PlayerManager.player.queue?.nextPosition = ix.item
            PlayerManager.player.currentItem = PlayerManager.player.queue?.nextItem()
        }
        
    }
    
}


extension ViewController: AudioPlayerDelegate {
    
    func audioPlayer(_ audioPlayer: AudioPlayer, didFindDuration duration: TimeInterval, for item: AudioItem) {
        DispatchQueue.main.async { [self] in
            guard let currentIndex = audioPlayer.currentItemIndexInQueue, let cell = collectionView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? PlayerCell else{return}
            cell.totalTimeLabel.text = duration.intervalToString()
            cell.progressView.progress = 0.0
            cell.isHide = false
            self.currentCell = cell
        }
    }
    
    func audioPlayer(_ audioPlayer: AudioPlayer, didChangeStateFrom from: AudioPlayerState, to state: AudioPlayerState) {
        DispatchQueue.main.async { [self] in
            guard let currentIndex = audioPlayer.currentItemIndexInQueue, let cell = collectionView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? PlayerCell else{return}
            cell.isPlaying = state.isPlaying
        }
        
    }
    
    func audioPlayer(_ audioPlayer: AudioPlayer, didUpdateProgressionTo time: TimeInterval, percentageRead: Float) {
        DispatchQueue.main.async { [self] in
            guard let currentIndex = audioPlayer.currentItemIndexInQueue, let cell = collectionView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? PlayerCell else{return}
            guard let duration = audioPlayer.currentItemDuration else {return}
            
            cell.progressView.progress = Float(time / duration)
            cell.scrollImage.progress = Float(time / duration)
            cell.progressLabel.text = time.intervalToString()
            
        }
    }
    
    func audioPlayer(_ audioPlayer: AudioPlayer, updatePlaying item: AudioItem) {
        DispatchQueue.main.async { [self] in
            guard let currentIndex = audioPlayer.currentItemIndexInQueue, let cell = collectionView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? PlayerCell else{return}
            //            let stringTitle = NSMutableAttributedString(string: "‎‎‏‏‎ \(item.title!) ")
            //            let stringChannel = NSMutableAttributedString(string: "‎‎‏‏‎ \(item.artist!) ")
            //            stringTitle.setHighlightColorForText(" \(item.title!) ", with: cell.progressView.tintColor.withAlphaComponent(0.7))
            //            stringChannel.setHighlightColorForText(" \(item.artist!) ", with: cell.progressView.tintColor.withAlphaComponent(0.7))
            //            cell.titleLabel.attributedText = stringTitle
            //            cell.channelLabel.attributedText = stringChannel
            cell.channelLabel.text = " \(item.artist!) "
            cell.titleLabel.text = " \(item.title!) "
            self.setCurrentIndex(index: audioPlayer.currentItemIndexInQueue!, animated: true)
        }
    }
}

