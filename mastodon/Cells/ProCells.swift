//
//  ProCells.swift
//  mastodon
//
//  Created by Shihab Mehboob on 20/12/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import PINRemoteImage

class ProCells: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SKPhotoBrowserDelegate {

    var collectionView: UICollectionView!
    var profileStatuses: [Status] = []
    var profileStatusesHasImage: [Status] = []

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let layout = ColumnFlowLayout(
            cellsPerRow: 10,
            minimumInteritemSpacing: 14,
            minimumLineSpacing: 14,
            sectionInset: UIEdgeInsets(top: -10, left: 20, bottom: 0, right: 20)
        )
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 55, height: 80)
        if UIDevice.current.userInterfaceIdiom == .pad {
            collectionView = UICollectionView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(540), height: CGFloat(105)), collectionViewLayout: layout)
        } else {
            collectionView = UICollectionView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(UIScreen.main.bounds.width), height: CGFloat(105)), collectionViewLayout: layout)
        }
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .pad:
            collectionView.backgroundColor = Colours.white
        default:
            collectionView.backgroundColor = Colours.grayDark3
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CollectionProCells.self, forCellWithReuseIdentifier: "CollectionColourCell")

        contentView.addSubview(collectionView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



    func configure() {
        self.collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 55, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let z1 = Account.getAccounts().count
        let z2 = InstanceData.getAllInstances().count
        
        
        if z1 != z2 {
            showAccountError()
            return 0
        }
        return InstanceData.getAllInstances().count + 1
    }
    
    func showAccountError(){
        
        let alert = UIAlertController(title: "Looks like we encountered an error please log in again", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (_) in
            let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
            switch (deviceIdiom) {
            case .phone:
                NotificationCenter.default.post(name: Notification.Name(rawValue: "signOut"), object: nil)
            case .pad:
                NotificationCenter.default.post(name: Notification.Name(rawValue: "logBackOut"), object: nil)
            default:
                NotificationCenter.default.post(name: Notification.Name(rawValue: "signOut"), object: nil)
            }
        }
        alert.addAction(action)
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionColourCell", for: indexPath) as! CollectionProCells
        if indexPath.row >= InstanceData.getAllInstances().count {
            cell.image.image = UIImage(named: "newac2")
        } else {
            let account = Account.getAccounts()[indexPath.row]
            print("index \(indexPath.row) \(account.avatarStatic)")
            if account.avatarStatic != nil {
                cell.setImageFromAccount(account: account)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionColourCell", for: indexPath) as! CollectionProCells
        
        if indexPath.item >= InstanceData.getAllInstances().count {
            DispatchQueue.main.async {
                cell.image.image = UIImage(named: "newac2")?.maskWithColor(color: Colours.tabSelected)
                cell.image.layer.borderColor = Colours.clear.cgColor
                cell.image.layer.borderWidth = 0
            }

        } else {

            cell.image.image = nil
            let instances = InstanceData.getAllInstances()
            if instances.isEmpty || Account.getAccounts().isEmpty {} else {
                let curr = InstanceData.getCurrentInstance()
                if curr?.clientID == instances[indexPath.item].clientID {
                    cell.image.layer.borderWidth = 3.6
                } else {
                    cell.image.layer.borderWidth = 0
                }
                cell.image.layer.borderColor = Colours.tabSelected.cgColor
                DispatchQueue.main.async {
                    let account = Account.getAccounts()[indexPath.item]
                    cell.image.pin_setImage(from: URL(string: account.avatar))
                    cell.name.text = account.username
                }
                
                cell.image.backgroundColor = Colours.clear
            }
        }

        cell.image.layer.cornerRadius = 27.5
        cell.image.layer.masksToBounds = true

        cell.image.frame = CGRect(x: 0, y: 5, width: 55, height: 55)
        cell.bgImage.frame = CGRect(x: 0, y: 5, width: 55, height: 55)


        cell.bgImage.layer.masksToBounds = false
        cell.bgImage.layer.shadowColor = UIColor.black.cgColor
        cell.bgImage.layer.shadowOffset = CGSize(width:0, height:6)
        cell.bgImage.layer.shadowRadius = 12
        cell.bgImage.layer.shadowOpacity = 0.12
        
        cell.frame.size.width = 55
        cell.frame.size.height = 55
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .pad:
            cell.backgroundColor = Colours.white
        default:
            cell.backgroundColor = Colours.grayDark3
        }
        
        cell.configure()
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        NotificationCenter.default.post(name: Notification.Name(rawValue: "dismissThings"), object: self)

        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
        }

        if indexPath.item == InstanceData.getAllInstances().count {

            NotificationCenter.default.post(name: Notification.Name(rawValue: "signOut2"), object: nil)

        } else {

            let instances = InstanceData.getAllInstances()
            let curr = InstanceData.getCurrentInstance()

            if curr?.clientID == instances[indexPath.item].clientID {
                
                Alertift.actionSheet(title: "Already selected", message: "Pick another account, or add a new one.")
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .show(on: self.window?.rootViewController)
                
            } else {



                if indexPath.item >= InstanceData.getAllInstances().count {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "signOut2"), object: nil)
                } else {


                    DispatchQueue.main.async {
                        
                        StoreStruct.switchedNow = true
                        InstanceData.setCurrentInstance(instance: instances[indexPath.item])
                        StoreStruct.client = Client(
                            baseURL: "https://\(instances[indexPath.item].returnedText)",
                            accessToken: instances[indexPath.item].accessToken
                        )
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.reloadApplication()
                        
                        
                    }
                }

            }

        }

    }

}
