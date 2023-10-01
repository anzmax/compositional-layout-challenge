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
            
            let photo = self.firstPhotos[indexPath.item]
            cell.photo.image = UIImage(named: photo.image)
            cell.contentView.layer.cornerRadius = 10
            cell.contentView.clipsToBounds = true
            
//            if indexPath.item < self.firstPhotos.count {
//                let photo = self.firstPhotos[indexPath.item]
//                cell.photo.image = UIImage(named: photo.image)
//                cell.contentView.layer.cornerRadius = 10
//                cell.contentView.clipsToBounds = true
//            } else {
//                print("Index out of range for firstPhotos")
//            }

        }
        
        let secondCellRegistration = UICollectionView.CellRegistration<SecondCell, Int> {
            (cell, indexPath, identifier) in
            
            let photo = self.secondPhotos[indexPath.item]
            cell.photo.image = UIImage(named: photo.image)
            cell.contentView.layer.cornerRadius = 10
            cell.contentView.clipsToBounds = true
            
//            if indexPath.item < self.secondPhotos.count {
//                let photo = self.secondPhotos[indexPath.item]
//                cell.photo.image = UIImage(named: photo.image)
//                cell.contentView.layer.cornerRadius = 10
//                cell.contentView.clipsToBounds = true
//            } else {
//                print("Index out of range for firstPhotos")
//            }
        }
        
        let thirdCellRegistration = UICollectionView.CellRegistration<ThirdCell, Int> {
            (cell, indexPath, identifier) in
            
            let photo = self.thirdPhotos[indexPath.item]
            cell.photo.image = UIImage(named: photo.image)
            cell.contentView.layer.cornerRadius = 10
            cell.contentView.clipsToBounds = true
            
//            if indexPath.item < self.thirdPhotos.count {
//                let photo = self.thirdPhotos[indexPath.item]
//                cell.photo.image = UIImage(named: photo.image)
//                cell.contentView.layer.cornerRadius = 10
//                cell.contentView.clipsToBounds = true
//            } else {
//                print("Index out of range for firstPhotos")
//            }
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

        //Вариант 1
        
                var snapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, Int>()
                snapshot.appendSections([.one, .two, .three])
        
                let group = DispatchGroup()
        
                group.enter()
                firstService.fetchFirst { [weak self] result in
                    defer {
                        group.leave()
                    }
                    switch result {
                    case .success(let fetchedFirstPhotos):
                        self?.firstPhotos = fetchedFirstPhotos
                        snapshot.appendItems(Array(0..<fetchedFirstPhotos.count), toSection: .one)
                        print(fetchedFirstPhotos)
                    case .failure(let error):
                        print(error)
                    }
                }
        
                group.enter()
                secondService.fetchSecond { [weak self] result in
                    defer {
                        group.leave()
                    }
                    switch result {
                    case .success(let fetchedSecondPhotos):
                        self?.secondPhotos = fetchedSecondPhotos
                        snapshot.appendItems(Array(0..<fetchedSecondPhotos.count), toSection: .two)
                        print(fetchedSecondPhotos)
                    case .failure(let error):
                        print(error)
                    }
                }
        
                group.enter()
                thirdService.fetchThird { [weak self] result in
                    defer {
                        group.leave()
                    }
                    switch result {
                    case .success(let fetchedThirdPhotos):
                        self?.thirdPhotos = fetchedThirdPhotos
                        snapshot.appendItems(Array(0..<fetchedThirdPhotos.count), toSection: .three)
                        print(fetchedThirdPhotos)
                    case .failure(let error):
                        print(error)
                    }
                }
        
                group.notify(queue: .main) {
                    self.dataSource.apply(snapshot, animatingDifferences: false)
                }
        
        
        //Вариант 2
//        
//                var snapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, Int>()
//                snapshot.appendSections([.one, .two, .three])
//        
//                firstService.fetchFirst { [weak self] result in
//                    switch result {
//                    case .success(let fetchedFirstPhotos):
//                        self?.firstPhotos = fetchedFirstPhotos
//                        self?.updateSnapshot()
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
//        
//                secondService.fetchSecond { [weak self] result in
//                    switch result {
//                    case .success(let fetchedSecondPhotos):
//                        self?.secondPhotos = fetchedSecondPhotos
//                        self?.updateSnapshot()
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
//        
//                thirdService.fetchThird { [weak self] result in
//                    switch result {
//                    case .success(let fetchedThirdPhotos):
//                        self?.thirdPhotos = fetchedThirdPhotos
//                        self?.updateSnapshot()
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
        
        
        //Вариант 3
        
//                var snapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, Int>()
//                snapshot.appendSections([.one, .two, .three])
//        
//                firstService.fetchFirst { [weak self] result in
//                    switch result {
//                    case .success(let fetchedFirstPhotos):
//                        self?.firstPhotos = fetchedFirstPhotos
//                        snapshot.appendItems(Array(0..<fetchedFirstPhotos.count), toSection: .one)
//                        DispatchQueue.main.async {
//                            self?.dataSource.apply(snapshot, animatingDifferences: false)
//                        }
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
//        
//                secondService.fetchSecond { [weak self] result in
//                    switch result {
//                    case .success(let fetchedSecondPhotos):
//                        self?.secondPhotos = fetchedSecondPhotos
//                        sleep(3)
//                        snapshot.appendItems(Array(0..<fetchedSecondPhotos.count), toSection: .two)
//                        DispatchQueue.main.async {
//                            self?.dataSource.apply(snapshot, animatingDifferences: false)
//                        }
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
//        
//                thirdService.fetchThird { [weak self] result in
//                    switch result {
//                    case .success(let fetchedThirdPhotos):
//                        self?.thirdPhotos = fetchedThirdPhotos
//                        snapshot.appendItems(Array(0..<fetchedThirdPhotos.count), toSection: .three)
//                        DispatchQueue.main.async {
//                            self?.dataSource.apply(snapshot, animatingDifferences: false)
//                        }
//                    case .failure(let error):
//                        print(error)
//                    }
//                }

        
        
        //Вариант 4


//                let itemsPerSection = [PhotoData.photos1.count, PhotoData.photos2.count, PhotoData.photos3.count]
//                var snapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, Int>()
//                SectionLayoutKind.allCases.forEach {
//                    snapshot.appendSections([$0])
//                    let sectionIndex = $0.rawValue
//                    let currentItemsPerSection = itemsPerSection[sectionIndex]
//                    let itemOffset = sectionIndex * currentItemsPerSection
//                    let itemUpperbound = itemOffset + currentItemsPerSection
//                    snapshot.appendItems(Array(itemOffset..<itemUpperbound))
//                }
//                dataSource.apply(snapshot, animatingDifferences: false)
        
        // Вариант 5
        
//        var firstSnapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, Int>()
//        var secondSnapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, Int>()
//        var thirdSnapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, Int>()
//
//        firstSnapshot.appendSections([.one])
//        secondSnapshot.appendSections([.two])
//        thirdSnapshot.appendSections([.three])
//
//        firstService.fetchFirst { [weak self] result in
//            switch result {
//            case .success(let fetchedFirstPhotos):
//                self?.firstPhotos = fetchedFirstPhotos
//                let itemsToAdd = Array(0..<fetchedFirstPhotos.count)
//                firstSnapshot.appendItems(itemsToAdd, toSection: .one)
//                DispatchQueue.main.async {
//                    self?.dataSource.apply(firstSnapshot, animatingDifferences: true)
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
//
//        secondService.fetchSecond { [weak self] result in
//            switch result {
//            case .success(let fetchedSecondPhotos):
//                self?.secondPhotos = fetchedSecondPhotos
//                sleep(3)
//                let itemsToAdd = Array(0..<fetchedSecondPhotos.count)
//                secondSnapshot.appendItems(itemsToAdd, toSection: .two)
//                DispatchQueue.main.async {
//                    self?.dataSource.apply(secondSnapshot, animatingDifferences: true)
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
//
//        thirdService.fetchThird { [weak self] result in
//            switch result {
//            case .success(let fetchedThirdPhotos):
//                self?.thirdPhotos = fetchedThirdPhotos
//                let itemsToAdd = Array(0..<fetchedThirdPhotos.count)
//                thirdSnapshot.appendItems(itemsToAdd, toSection: .three)
//                DispatchQueue.main.async {
//                    self?.dataSource.apply(thirdSnapshot, animatingDifferences: true)
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }


    }
    
//    func updateSnapshot() {
//        var snapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, Int>()
//        snapshot.appendSections([.one, .two, .three])
//        if firstPhotos.isEmpty == false {
//            snapshot.appendItems(Array(0..<firstPhotos.count), toSection: .one)
//        }
//        if secondPhotos.isEmpty == false {
//            snapshot.appendItems(Array(0..<secondPhotos.count), toSection: .two)
//        }
//        if thirdPhotos.isEmpty == false {
//            snapshot.appendItems(Array(0..<thirdPhotos.count), toSection: .three)
//        }
//        dataSource.apply(snapshot, animatingDifferences: false)
//    }
}

