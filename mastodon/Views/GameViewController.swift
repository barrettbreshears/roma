//
//  GameViewController.swift
//  mastodon
//
//  Created by Shihab Mehboob on 07/04/2019.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit

class GameViewController: UIViewController {
    
    // MARK: - enum
    fileprivate enum ScreenEdge: Int {
        case top = 0
        case right = 1
        case bottom = 2
        case left = 3
    }
    
    fileprivate enum GameState {
        case ready
        case playing
        case gameOver
    }
    
    // MARK: - Constants
    fileprivate let radius: CGFloat = 26
    fileprivate let playerAnimationDuration = 5.0
    fileprivate let enemySpeed: CGFloat = 60 // points per second
    fileprivate let colors = StoreStruct.colArray
    
    // MARK: - fileprivate
    fileprivate var playerView = UIImageView(frame: .zero)
    fileprivate var playerAnimator: UIViewPropertyAnimator?
    
    fileprivate var enemyViews = [UIView]()
    fileprivate var enemyAnimators = [UIViewPropertyAnimator]()
    fileprivate var enemyTimer: Timer?
    
    fileprivate var displayLink: CADisplayLink?
    fileprivate var beginTimestamp: TimeInterval = 0
    fileprivate var elapsedTime: TimeInterval = 0
    
    fileprivate var gameState = GameState.ready
    
    var clockLabel = UILabel()
    var startLabel = UILabel()
    var bestTimeLabel = UILabel()
    var crossButton = UIButton()
    var tipLabel = UILabel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colours.white
        
        setupPlayerView()
        prepareGame()
        
        var tabHeight = Int(UITabBarController().tabBar.frame.size.height) + Int(34)
        var offset = 88
        var newoff = 45
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2688:
                offset = 88
                newoff = 45
            case 2436, 1792:
                offset = 88
                newoff = 45
            default:
                offset = 64
                newoff = 24
                tabHeight = Int(UITabBarController().tabBar.frame.size.height)
            }
        }
        
        clockLabel.frame = CGRect(x: 0, y: Int(newoff), width: Int(self.view.bounds.width), height: 40)
        clockLabel.font = UIFont.boldSystemFont(ofSize: 20)
        clockLabel.textColor = Colours.tabSelected
        clockLabel.textAlignment = .center
        self.view.addSubview(clockLabel)
        
        crossButton.frame = CGRect(x: 20, y: newoff, width: 40, height: 40)
        crossButton.backgroundColor = UIColor.clear
        crossButton.setImage(UIImage(named: "block"), for: .normal)
        crossButton.addTarget(self, action: #selector(self.didTouchClose), for: .touchUpInside)
        self.view.addSubview(crossButton)
        
        tipLabel.frame = CGRect(x: 20, y: Int(self.view.bounds.height) - 50 - Int(newoff), width: Int(self.view.bounds.width) - 40, height: 50)
        tipLabel.font = UIFont.boldSystemFont(ofSize: 16)
        tipLabel.textColor = Colours.grayDark.withAlphaComponent(0.25)
        tipLabel.textAlignment = .center
        tipLabel.numberOfLines = 0
        tipLabel.text = "Tap anywhere to move yourself there.\nAvoid the dots. Simple."
        self.view.addSubview(tipLabel)
    }
    
    @objc func didTouchClose() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // First touch to start the game
        if gameState == .ready {
            springWithDelay(duration: 0.5, delay: 0, animations: {
                self.tipLabel.alpha = 0
            })
            startGame()
        }
        
        if let touchLocation = event?.allTouches?.first?.location(in: view) {
            // Move the player to the new position
            movePlayer(to: touchLocation)
            
            // Move all enemies to the new position to trace the player
            moveEnemies(to: touchLocation)
        }
    }
    
    // MARK: - Selectors
    @objc func generateEnemy(timer: Timer) {
        // Generate an enemy with random position
        let screenEdge = ScreenEdge.init(rawValue: Int(arc4random_uniform(4)))
        let screenBounds = UIScreen.main.bounds
        var position: CGFloat = 0
        
        switch screenEdge! {
        case .left, .right:
            position = CGFloat(arc4random_uniform(UInt32(screenBounds.height)))
        case .top, .bottom:
            position = CGFloat(arc4random_uniform(UInt32(screenBounds.width)))
        }
        
        // Add the new enemy to the view
        let enemyView = UIView(frame: .zero)
        enemyView.bounds.size = CGSize(width: radius - 10, height: radius - 10)
        enemyView.layer.cornerRadius = (radius - 10)/2
        enemyView.layer.masksToBounds = true
        enemyView.backgroundColor = getRandomColor()
        
        switch screenEdge! {
        case .left:
            enemyView.center = CGPoint(x: 0, y: position)
        case .right:
            enemyView.center = CGPoint(x: screenBounds.width, y: position)
        case .top:
            enemyView.center = CGPoint(x: position, y: screenBounds.height)
        case .bottom:
            enemyView.center = CGPoint(x: position, y: 0)
        }
        
        view.addSubview(enemyView)
        
        // Start animation
        let duration = getEnemyDuration(enemyView: enemyView)
        let enemyAnimator = UIViewPropertyAnimator(duration: duration,
                                                   curve: .linear,
                                                   animations: { [weak self] in
                                                    if let strongSelf = self {
                                                        enemyView.center = strongSelf.playerView.center
                                                    }
            }
        )
        enemyAnimator.startAnimation()
        enemyAnimators.append(enemyAnimator)
        enemyViews.append(enemyView)
    }
    
    @objc func tick(sender: CADisplayLink) {
        updateCountUpTimer(timestamp: sender.timestamp)
        checkCollision()
    }
}

fileprivate extension GameViewController {
    func setupPlayerView() {
        playerView.bounds.size = CGSize(width: radius * 2, height: radius * 2)
        playerView.layer.cornerRadius = radius
        playerView.backgroundColor = Colours.tabSelected
        playerView.pin_setImage(from: URL(string: "\(StoreStruct.currentUser.avatarStatic)"))
        playerView.layer.masksToBounds = true
        
        view.addSubview(playerView)
    }
    
    func startEnemyTimer() {
        enemyTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(generateEnemy(timer:)), userInfo: nil, repeats: true)
    }
    
    func stopEnemyTimer() {
        guard let enemyTimer = enemyTimer,
            enemyTimer.isValid else {
                return
        }
        enemyTimer.invalidate()
    }
    
    func startDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(tick(sender:)))
        displayLink?.add(to: RunLoop.main, forMode: RunLoop.Mode.default)
    }
    
    func stopDisplayLink() {
        displayLink?.isPaused = true
        displayLink?.remove(from: RunLoop.main, forMode: RunLoop.Mode.default)
        displayLink = nil
    }
    
    func getRandomColor() -> UIColor {
        let index = arc4random_uniform(UInt32(colors.count))
        return colors[Int(index)]
    }
    
    func getEnemyDuration(enemyView: UIView) -> TimeInterval {
        let dx = playerView.center.x - enemyView.center.x
        let dy = playerView.center.y - enemyView.center.y
        return TimeInterval(sqrt(dx * dx + dy * dy) / enemySpeed)
    }
    
    func gameOver() {
        stopGame()
        displayGameOverAlert()
    }
    
    func stopGame() {
        stopEnemyTimer()
        stopDisplayLink()
        stopAnimators()
        gameState = .gameOver
    }
    
    func prepareGame() {
        getBestTime()
        removeEnemies()
        centerPlayerView()
        popPlayerView()
        startLabel.isHidden = false
        clockLabel.text = "00:00.000"
        gameState = .ready
    }
    
    func startGame() {
        startEnemyTimer()
        startDisplayLink()
        startLabel.isHidden = true
        beginTimestamp = 0
        gameState = .playing
    }
    
    func removeEnemies() {
        enemyViews.forEach {
            $0.removeFromSuperview()
        }
        enemyViews = []
    }
    
    func stopAnimators() {
        playerAnimator?.stopAnimation(true)
        playerAnimator = nil
        enemyAnimators.forEach {
            $0.stopAnimation(true)
        }
        enemyAnimators = []
    }
    
    func updateCountUpTimer(timestamp: TimeInterval) {
        if beginTimestamp == 0 {
            beginTimestamp = timestamp
        }
        elapsedTime = timestamp - beginTimestamp
        clockLabel.text = format(timeInterval: elapsedTime)
    }
    
    func format(timeInterval: TimeInterval) -> String {
        let interval = Int(timeInterval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let milliseconds = Int(timeInterval * 1000) % 1000
        return String(format: "%02d:%02d.%03d", minutes, seconds, milliseconds)
    }
    
    func checkCollision() {
        enemyViews.forEach {
            guard let playerFrame = playerView.layer.presentation()?.frame,
                let enemyFrame = $0.layer.presentation()?.frame,
                playerFrame.intersects(enemyFrame) else {
                    return
            }
            gameOver()
        }
    }
    
    func movePlayer(to touchLocation: CGPoint) {
        playerAnimator = UIViewPropertyAnimator(duration: playerAnimationDuration,
                                                dampingRatio: 0.5,
                                                animations: { [weak self] in
                                                    self?.playerView.center = touchLocation
        })
        playerAnimator?.startAnimation()
    }
    
    func moveEnemies(to touchLocation: CGPoint) {
        for (index, enemyView) in enemyViews.enumerated() {
            let duration = getEnemyDuration(enemyView: enemyView)
            enemyAnimators[index] = UIViewPropertyAnimator(duration: duration,
                                                           curve: .linear,
                                                           animations: {
                                                            enemyView.center = touchLocation
            })
            enemyAnimators[index].startAnimation()
        }
    }
    
    func displayGameOverAlert() {
        Alertift.actionSheet(title: "Game Over", message: "You lasted for \(self.clockLabel.text ?? "0") minutes.")
            .backgroundColor(Colours.white)
            .titleTextColor(Colours.grayDark)
            .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
            .messageTextAlignment(.left)
            .titleTextAlignment(.left)
            .action(.default("Share".localized), image: UIImage(named: "share")) { (action, ind) in
                let bodyText = "I lasted for \(self.clockLabel.text ?? "0") minutes in the #Mast mini-game #SaveYourself!\n\nDo you think you can do better?\nhttps://itunes.apple.com/us/app/mast/id1437429129?mt=8"
                let vc = VisualActivityViewController(text: bodyText)
                vc.popoverPresentationController?.sourceView = self.view
                vc.previewNumberOfLines = 5
                vc.previewFont = UIFont.systemFont(ofSize: 14)
                self.present(vc, animated: true, completion: nil)
            }
            .action(.cancel("Dismiss"))
            .finally { action, index in
                if action.style == .cancel {
                    self.dismiss(animated: true, completion: nil)
                    return
                }
            }
            .popover(anchorView: self.view)
            .show(on: self)
    }
    
    func centerPlayerView() {
        // Place the player in the center of the screen.
        playerView.center = view.center
    }
    
    // Copy from IBAnimatable
    func popPlayerView() {
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values = [0, 0.2, -0.2, 0.2, 0]
        animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.duration = CFTimeInterval(0.7)
        animation.isAdditive = true
        animation.repeatCount = 1
        animation.beginTime = CACurrentMediaTime()
        playerView.layer.add(animation, forKey: "pop")
    }
    
    func setBestTime(with time:String){
        let defaults = UserDefaults.standard
        defaults.set(time, forKey: "bestTime")
        
    }
    
    func getBestTime(){
        let defaults = UserDefaults.standard
        
        if let time = defaults.value(forKey: "bestTime") as? String {
            self.bestTimeLabel.text = "Best Time: \(time)"
        }
    }
    
}
