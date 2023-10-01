import UIKit

enum SectionLayoutKind: Int, CaseIterable {
    case one, two, three
    var columnCount: Int {
        switch self {
        case .one:
            return 0
        case .two:
            return 1
        case .three:
            return 2
        }
    }
}

class SectionsViewController: UIViewController {
    
    static let sectionHeaderElementKind = "sectionHeaderElementKind"
    
    var firstService = FirstService()
    var secondService = SecondService()
    var thirdService = ThirdService()

    var firstPhotos = [FirstPhotos]()
    var secondPhotos = [SecondPhotos]()
    var thirdPhotos = [ThirdPhotos]()

    
    var dataSource: UICollectionViewDiffableDataSource<SectionLayoutKind, Int>! = nil
    var collectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
        //updateSnapshot()        
    }
}

extension SectionsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
