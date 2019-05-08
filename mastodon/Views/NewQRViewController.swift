//
//  NewQRViewController.swift
//  mastodon
//
//  Created by Shihab Mehboob on 05/02/2019.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import StatusAlert

class NewQRViewController: UIViewController {
    
    var closeButton = MNGExpandedTouchAreaButton()
    var tootLabel = UIButton()
    var keyHeight = 0
    var bgView = UIView()
    var titleV = UILabel()
    var editListName = ""
    var listID = ""
    var fromWhich = 0
    var hex = ""
    var ur = "https://www.thebluebird.app"
    var tempIm = UIImage()
    let pulsator = Pulsator()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colours.white
        
        var tabHeight = Int(UITabBarController().tabBar.frame.size.height) + Int(34)
        var offset = 88
        var closeB = 47
        var botbot = 20
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2688:
                offset = 88
                closeB = 47
                botbot = 40
            case 2436, 1792:
                offset = 88
                closeB = 47
                botbot = 40
            default:
                offset = 64
                closeB = 24
                botbot = 20
                tabHeight = Int(UITabBarController().tabBar.frame.size.height)
            }
        }
        
        bgView.frame = CGRect(x:0, y:Int(self.view.bounds.height) - 40 - Int(self.keyHeight), width:Int(self.view.bounds.width), height:Int(self.keyHeight) + 40)
        bgView.backgroundColor = Colours.tabSelected
        bgView.alpha = 0
        self.view.addSubview(bgView)
        
        self.closeButton = MNGExpandedTouchAreaButton(frame:(CGRect(x: 20, y: closeB, width: 32, height: 32)))
        self.closeButton.setImage(UIImage(named: "block")?.maskWithColor(color: Colours.grayLight2), for: .normal)
        self.closeButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        self.closeButton.adjustsImageWhenHighlighted = false
        self.closeButton.addTarget(self, action: #selector(didTouchUpInsideCloseButton), for: .touchUpInside)
        self.view.addSubview(self.closeButton)
        
        titleV.frame = CGRect(x: 24, y: offset + 6, width: Int(self.view.bounds.width), height: 30)
        titleV.text = "Share Me".localized
        titleV.textColor = Colours.grayDark2
        titleV.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        self.view.addSubview(titleV)
        
        tootLabel.frame = CGRect(x: CGFloat(self.view.bounds.width - 175), y: CGFloat(closeB), width: CGFloat(150), height: CGFloat(36))
        tootLabel.setTitle("Share", for: .normal)
        tootLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        tootLabel.setTitleColor(Colours.tabSelected, for: .normal)
        tootLabel.contentHorizontalAlignment = .right
        tootLabel.addTarget(self, action: #selector(didTouchUpInsideTootButton), for: .touchUpInside)
//        self.view.addSubview(tootLabel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let bgCirc = UIView()
        bgCirc.frame = CGRect(x: self.view.bounds.width/2 - 180, y: self.view.bounds.height/2 - 180, width: 360, height: 360)
        bgCirc.layer.cornerRadius = 180
        bgCirc.backgroundColor = Colours.tabSelected
        self.view.addSubview(bgCirc)
        
        self.pulsator.numPulse = 3
        self.pulsator.radius = 420
        self.pulsator.backgroundColor = Colours.tabSelected.cgColor
        self.pulsator.animationDuration = 4
        self.pulsator.pulseInterval = 0.2
        bgCirc.layer.superlayer?.insertSublayer(self.pulsator, below: bgCirc.layer)
        self.pulsator.position = bgCirc.layer.position
        self.pulsator.start()
        
        guard let qrURLImage = URL(string: self.ur)?.qrImage(using: Colours.white, logo: UIImage(named: "qrlog")?.maskWithColor(color: Colours.tabSelected)) else { return }
        let qrim = UIImageView(image: UIImage(ciImage: qrURLImage))
        qrim.frame = CGRect(x: self.view.bounds.width/2 - 70, y: self.view.bounds.height/2 - 70, width: 140, height: 140)
        qrim.contentMode = .center
        qrim.layer.backgroundColor = UIColor.clear.cgColor
        qrim.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        self.tempIm = qrim.image ?? UIImage()
        self.view.addSubview(qrim)
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        }
        if gesture.direction == UISwipeGestureRecognizer.Direction.down {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func didTouchUpInsideCloseButton(_ sender: AnyObject) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTouchUpInsideTootButton() {
        let imageToShare = [self.tempIm]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
}

extension CIImage {
    func combined(with image: CIImage) -> CIImage? {
        guard let combinedFilter = CIFilter(name: "CISourceOverCompositing") else { return nil }
        let centerTransform = CGAffineTransform(translationX: extent.midX - (image.extent.size.width / 2), y: extent.midY - (image.extent.size.height / 2))
        combinedFilter.setValue(image.transformed(by: centerTransform), forKey: "inputImage")
        combinedFilter.setValue(self, forKey: "inputBackgroundImage")
        return combinedFilter.outputImage!
    }
    
    var transparent: CIImage? {
        return inverted?.blackTransparent
    }
    
    var inverted: CIImage? {
        guard let invertedColorFilter = CIFilter(name: "CIColorInvert") else { return nil }
        
        invertedColorFilter.setValue(self, forKey: "inputImage")
        return invertedColorFilter.outputImage
    }
    
    var blackTransparent: CIImage? {
        guard let blackTransparentFilter = CIFilter(name: "CIMaskToAlpha") else { return nil }
        blackTransparentFilter.setValue(self, forKey: "inputImage")
        return blackTransparentFilter.outputImage
    }
    
    func tinted(using color: UIColor) -> CIImage? {
        guard
            let transparentQRImage = transparent,
            let filter = CIFilter(name: "CIMultiplyCompositing"),
            let colorFilter = CIFilter(name: "CIConstantColorGenerator") else { return nil }
        
        let ciColor = CIColor(color: color)
        colorFilter.setValue(ciColor, forKey: kCIInputColorKey)
        let colorImage = colorFilter.outputImage
        filter.setValue(colorImage, forKey: kCIInputImageKey)
        filter.setValue(transparentQRImage, forKey: kCIInputBackgroundImageKey)
        
        return filter.outputImage!
    }
}

extension URL {
    func qrImage(using color: UIColor, logo: UIImage? = nil) -> CIImage? {
        let tintedQRImage = qrImage?.tinted(using: color)
        let qrbg = UIImage(named: "qrbg")?.maskWithColor(color: Colours.white)
        
        guard let logobg = qrbg?.cgImage else {
            return tintedQRImage
        }
        guard let logo = logo?.cgImage else {
            return tintedQRImage
        }
        
        return tintedQRImage?.combined(with: CIImage(cgImage: logobg))?.combined(with: CIImage(cgImage: logo))
    }
    
    func qrImage(using color: UIColor) -> CIImage? {
        return qrImage?.tinted(using: color)
    }
    
    var qrImage: CIImage? {
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        let qrData = absoluteString.data(using: String.Encoding.ascii)
        qrFilter.setValue(qrData, forKey: "inputMessage")
        
        let qrTransform = CGAffineTransform(scaleX: 14, y: 14)
        return qrFilter.outputImage?.transformed(by: qrTransform)
    }
}
