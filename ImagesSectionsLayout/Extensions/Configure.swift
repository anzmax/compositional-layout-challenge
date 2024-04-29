import UIKit

extension SectionsViewController {
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    func configureDataSource() {
        
        let firstCellRegistration = UICollectionView.CellRegistration<FirstCell, Int> {
            (cell, indexPath, identifier) in
            
            if indexPath.item < self.firstPhotos.count {
                let photo = self.firstPhotos[indexPath.item]
                cell.photo.image = UIImage(named: photo.image)
                cell.contentView.layer.cornerRadius = 10
                cell.contentView.clipsToBounds = true
            } else {
                print("Index out of range for firstPhotos")
            }
            
        }
        
        let secondCellRegistration = UICollectionView.CellRegistration<SecondCell, Int> {
            (cell, indexPath, identifier) in
            
            if indexPath.item < self.secondPhotos.count {
                let photo = self.secondPhotos[indexPath.item]
                cell.photo.image = UIImage(named: photo.image)
                cell.contentView.layer.cornerRadius = 10
                cell.contentView.clipsToBounds = true
            } else {
                print("Index out of range for firstPhotos")
            }
        }
        
        let thirdCellRegistration = UICollectionView.CellRegistration<ThirdCell, Int> {
            (cell, indexPath, identifier) in
            
            if indexPath.item < self.thirdPhotos.count {
                let photo = self.thirdPhotos[indexPath.item]
                cell.photo.image = UIImage(named: photo.image)
                cell.contentView.layer.cornerRadius = 10
                cell.contentView.clipsToBounds = true
            } else {
                print("Index out of range for firstPhotos")
            }
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration
        <HeaderView>(elementKind: SectionsViewController.sectionHeaderElementKind) {
            (headerView, string, indexPath) in
            
            if let sectionKind = SectionLayoutKind(rawValue: indexPath.section) {
                switch sectionKind {
                case .one:
                    headerView.label.text = "Favourite ones"
                    headerView.backgroundColor = .systemBrown.withAlphaComponent(0.1)
                    headerView.layer.cornerRadius = 7
                case .two:
                    headerView.label.text = "Special moments"
                    headerView.backgroundColor = .systemBrown.withAlphaComponent(0.1)
                    headerView.layer.cornerRadius = 7
                case .three:
                    headerView.label.text = "Random photos"
                    headerView.backgroundColor = .systemBrown.withAlphaComponent(0.1)
                    headerView.layer.cornerRadius = 7
                }
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource<SectionLayoutKind, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            if let sectionKind = SectionLayoutKind(rawValue: indexPath.section) {
                switch sectionKind {
                case.one:
                    return collectionView.dequeueConfiguredReusableCell(using: firstCellRegistration, for: indexPath, item: identifier)
                case .two:
                    return collectionView.dequeueConfiguredReusableCell(using: secondCellRegistration, for: indexPath, item: identifier)
                case .three:
                    return collectionView.dequeueConfiguredReusableCell(using: thirdCellRegistration, for: indexPath, item: identifier)
                }
            }
            return nil
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(
                using: kind == SectionsViewController.sectionHeaderElementKind ? headerRegistration : headerRegistration, for: index)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, Int>()
        snapshot.appendSections([.one, .two, .three])
        
        let group = DispatchGroup()
        
        group.enter()
        firstService.fetchFirst { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let firstPhotos):
                self.firstPhotos = firstPhotos
                snapshot.appendItems(Array(0...8), toSection: .one)
                print(firstPhotos)
            case .failure(let error):
                print(error)
            }
        }
        
        group.enter()
        secondService.fetchSecond { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let secondPhotos):
                self.secondPhotos = secondPhotos
                snapshot.appendItems(Array(8...17), toSection: .two)
                print(secondPhotos)
            case .failure(let error):
                print(error)
            }
        }
        
        group.enter()
        thirdService.fetchThird { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let thirdPhotos):
                self.thirdPhotos = thirdPhotos
                snapshot.appendItems(Array(17...25), toSection: .three)
                print(thirdPhotos)
            case .failure(let error):
                print(error)
            }
        }
        
        group.notify(queue: .main) {
            self.dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
}

