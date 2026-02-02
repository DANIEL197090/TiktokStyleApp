//
//  VideoPlayerView.swift
//  TikTokApp
//
//  Created by Ifeanyi Mbata on 02/02/2026.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    // MARK: - Properties
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var playerItem: AVPlayerItem?
    private var statusObserver: NSKeyValueObservation?
    
    var isPlaying: Bool {
        return player?.rate != 0
    }
    
    // Callback when video is ready to play
    var onReadyToPlay: (() -> Void)?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPlayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPlayer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }
    
    // MARK: - Setup
    private func setupPlayer() {
        backgroundColor = .black
    }
    
    // MARK: - Public Methods
    func configure(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        // Clean up previous player
        cleanupPlayer()
        
        // Always create a new AVPlayerItem - cannot reuse between players
        playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        
        // Setup player layer
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill
        playerLayer?.frame = bounds
        
        if let playerLayer = playerLayer {
            layer.addSublayer(playerLayer)
        }
        
        // Loop video
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )
        
        // Observe player item status to know when video is ready
        statusObserver = playerItem?.observe(\.status, options: [.new]) { [weak self] item, _ in
            DispatchQueue.main.async {
                if item.status == .readyToPlay {
                    self?.onReadyToPlay?()
                }
            }
        }
    }
    
    func play() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    func stop() {
        player?.pause()
        player?.seek(to: .zero)
    }
    
    func cleanupPlayer() {
        statusObserver?.invalidate()
        statusObserver = nil
        NotificationCenter.default.removeObserver(self)
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        player = nil
        playerLayer = nil
        playerItem = nil
    }
    
    @objc private func playerDidFinishPlaying() {
        player?.seek(to: .zero)
        player?.play()
    }
    
    deinit {
        cleanupPlayer()
    }
}
