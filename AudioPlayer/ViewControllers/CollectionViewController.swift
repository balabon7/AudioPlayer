//
//  CollectionViewController.swift
//  AudioPlayer
//
//  Created by Oleksandr Balabon on 19.06.2022.
//

import UIKit
import Combine

class CollectionViewController: UIViewController {
    
    let playerManager: PlayerManager = PlayerManager(player: AudioPlayer(), for: Playlist())
    
    var playlist: Playlist {
        return playerManager.playlist
    }
    
    private var collectionView: UICollectionView?
    
    private var audioBatchSubscriber: AnyCancellable?
    
    private let manager = CollectionViewManager()
    
//    var colors: [UIColor] = [.systemBrown, .green, .blue, .systemYellow, .systemBlue, .purple, .brown, .gray, .systemGreen, .yellow, .lightGray, .systemOrange, .systemPurple, .systemBrown, .green, .blue, .systemYellow, .systemBlue, .systemGreen, .yellow, .lightGray, .systemOrange]
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        setupNavigationBar()
        
        manager.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = .white
        
        view.addSubview(collectionView!)
    
        setUpBindings()
        
        updateAudioList()
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        collectionView?.addGestureRecognizer(gesture)
    }
    
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer){
        guard let collectionView = collectionView else {
            return
        }
        
        switch gesture.state {
        case .began:
            guard let targetIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                return
            }
            collectionView.beginInteractiveMovementForItem(at: targetIndexPath)
            
            guard manager.viewMode == .selection else { return }
            
            deselectAllItems(animated: true)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView?.frame = view.bounds
    }
}

extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlist.audioList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as! CustomCollectionViewCell
        cell.backgroundColor = .lightGray
        cell.label.text = playlist.audioList[indexPath.row].name
        return cell
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width / 3.4, height: view.frame.size.width / 3.4)
    }
}

extension CollectionViewController {
    
    // Re-order
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = playlist.audioList.remove(at: sourceIndexPath.row)
        playlist.audioList.insert(item, at: destinationIndexPath.row)
    }
}

extension CollectionViewController {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        select(index: indexPath.row)
        // let selectedCell = collectionView.cellForItem(at: indexPath) as! CustomCollectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        deselect(index: indexPath.row)
    }
    
    /// Позволяет  выбрать элемент по тапу
    func collectionView( _ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if manager.viewMode == .selection {
            return true
        } else {
            displayItemOnTapByIndexPath(indexPath: indexPath)
            return false
        }
    }
    
    func deselectAllItems(animated: Bool) {
        guard let selectedItems = collectionView?.indexPathsForSelectedItems else { return }
        selectedItems.forEach { collectionView?.deselectItem(at: $0, animated: false) }
    }
}

extension CollectionViewController {
    
    private func select(index: Int) {
        let selectedItemIndexPath: IndexPath = IndexPath(item: index, section: 0)
        
        if let indexPathsForSelectedItems = collectionView?.indexPathsForSelectedItems,
           // check already selected item
           // проверить уже выбранный элемент
            indexPathsForSelectedItems.contains(selectedItemIndexPath) {
            print(">Selected items count =", indexPathsForSelectedItems.count)
            return
        }
    }
    
    private func deselect(index: Int) {
        if let indexPathsForSelectedItems = collectionView?.indexPathsForSelectedItems {
            print("<Selected items count =", indexPathsForSelectedItems.count)
        }
    }
    
    private func displayItemOnTapByIndexPath(indexPath: IndexPath){
        print("display Item On Tap By Index Path")
        
        let audio = playlist.audioList[indexPath.row]
        let playerVC = PlayerViewController(audio: audio, for: playerManager)
        navigationController?.pushViewController(playerVC, animated: true)

       // collectionView.deselectRow(at: indexPath, animated: true)
        
    }
}

extension CollectionViewController {
    
    private func setupNavigationBar() {
        
        switch manager.viewMode {
        case .selection:
            collectionView?.allowsMultipleSelection = true
            
            let cancelBarButtonItem = UIBarButtonItem(systemItem: .cancel,  primaryAction: UIAction(handler: {
                [weak self] _ in
                self?.manager.viewMode = .usual
                /// remove all selected items
                self?.collectionView?.reloadData()
            }))
            self.navigationItem.rightBarButtonItems = [cancelBarButtonItem]
        case .usual:
            collectionView?.allowsMultipleSelection = false
            
            let selectBarButtonItem = UIBarButtonItem(title: "Select", primaryAction: UIAction(handler: { [weak self] _ in
                self?.manager.viewMode = .selection
            }))
            self.navigationItem.rightBarButtonItems = [selectBarButtonItem]
        }
    }
}

extension CollectionViewController: CollectionViewManagerDelegate {
    
    func handleViewModeChange() {
        setupNavigationBar()
    }
}

extension CollectionViewController {
    
    private func setUpBindings() {
        
        audioBatchSubscriber = playlist.newAudioBatch.sink { [weak self] audioBatch in
            guard let self = self else { return }
            self.collectionView?.reloadData()
        }
    }
    
    @objc private func updateAudioList() {
        playlist.updateAudioList()
    }

    private func getAddedIndexPaths(_ count: Int) -> [IndexPath] {
        
        var newIndexPaths = [IndexPath]()
        let lastRow = self.playlist.audioList.count
        for row in (lastRow - count)..<lastRow {
            newIndexPaths.append(IndexPath(row: row, section: 0))
        }
        
        return newIndexPaths
    }
}
