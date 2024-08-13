//
//  ViewController.swift
//  Checkins
//
//  Created by youzy on 2024/8/12.
//

import UIKit

struct Screen {
    static let width = UIScreen.main.bounds.width
}

extension NSLayoutConstraint {
    private enum Key {
        static var value = "isAdaptScreen"
    }

    @IBInspectable
    /// 是否适配屏幕，以375宽度为准计算约束constant
    var isAdaptScreen: Bool {
        get {
            return withUnsafePointer(to: Key.value) { pointer in
                return objc_getAssociatedObject(self, pointer) as? Bool ?? false
            }
        }
        set {
            withUnsafePointer(to: Key.value) { pointer in
                if newValue {
                    let value = constant
                    constant = value * Screen.width / 375
                }
                objc_setAssociatedObject(self, pointer, newValue, .OBJC_ASSOCIATION_ASSIGN)
            }
        }
    }
}

class ViewController: UIViewController {

    private let cellId = "cell"

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CheckinsDateCell
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 60) / 7
        debugPrint(collectionView.frame.width, view.frame.size, Screen.width, "cell width:", width)
        return CGSize(width: width, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
}

class CheckinsDateCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
}
