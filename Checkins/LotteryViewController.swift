//
//  LotteryViewController.swift
//  Checkins
//
//  Created by youzy on 2024/8/13.
//

import UIKit
import UBase

class LotteryViewController: BaseViewController {
    @IBOutlet weak var lotteryView: LotteryView!
    @IBOutlet weak var button: UIButton!

    init() {
        super.init(nibName: "LotteryViewController", bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        lotteryView.bringSubviewToFront(button)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let items = [
            PrizesView.Item(text: "下次努力 0", image: .checkinsLotteryPrizesNullIcon),
            PrizesView.Item(text: "资料包 1", image: .checkinsLotteryPrizesNullIcon),
            PrizesView.Item(text: "200元京东卡 2", image: .checkinsLotteryPrizesJdcodeIcon),
            PrizesView.Item(text: "专家1对1咨询 3", image: .checkinsLotteryPrizesAdviceIcon),
            PrizesView.Item(text: "志愿卡 4", image: .checkinsLotteryPrizesVipIcon),
            PrizesView.Item(text: "60元优惠券 5", image: .checkinsLotteryPrizesCouponsIcon)
        ]
        lotteryView.configure(items: items)
    }

    @IBAction func lotteryAction() {
        let idx = Int.random(in: 0..<5)
        debugPrint("中奖 idx: ", idx)
        lotteryView.start(to: idx)
    }
}

// MARK: 轮盘View
class LotteryView: UIView {
    private let contentView = UIView()
    /// 轮盘背景
    private let imageView = UIImageView()
    /// 奖品视图， 应该加在contentView
    private let prizesView = UIView()

    private var isAnimating: Bool = false
    private var rotationAngle: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepare()
    }
}

extension LotteryView {
    func prepare() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        imageView.image = .checkinsLotteryWheelIcon
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func configure(items: [PrizesView.Item]) {
        let height = contentView.frame.height / 2 - 30
        let width = tan(radian(30)) * height * 2

        debugPrint("prizes View size: ", width, height)

        var angle: CGFloat = 0

        for item in items {
            let prizesView = PrizesView(frame: CGRect(x: 0, y: 0, width: width, height: height))
            prizesView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
            prizesView.center = CGPoint(x: contentView.frame.width / 2, y: contentView.frame.height / 2)
            prizesView.configure(item: item)

            prizesView.transform = CGAffineTransform(rotationAngle: radian(angle))
            contentView.addSubview(prizesView)

            angle += 60
        }

        contentView.transform = CGAffineTransform(rotationAngle: radian(180))
    }

    func start(to idx: Int) {
        rotationAngle = -radian(CGFloat(60 * idx))
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = radian(360) * 5 + rotationAngle
        animation.duration = CFTimeInterval(5) + 0.5
        animation.isCumulative = false
        animation.delegate = self

        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        contentView.layer.add(animation, forKey: "rotationAnimation")
    }
}

extension LotteryView: CAAnimationDelegate {
    func animationDidStart(_ anim: CAAnimation) {
        isAnimating = true
        debugPrint("animation did start")
    }

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        isAnimating = false
//        // rotateView 旋转到当前位置
        contentView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        contentView.transform = CGAffineTransform(rotationAngle: rotationAngle)
//        delegate?.animationDidStop(anim)
        debugPrint("animation did stop")
    }
}

func radian(_ value: CGFloat) -> CGFloat {
    return value * (.pi / 180)
}

/// 奖品视图
class PrizesView: UIView {
    private let imageView = UIImageView()
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepare()
    }

    func configure(item: Item) {
        label.text = item.text
        imageView.image = item.image
    }
}

extension PrizesView {
    func prepare() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Screen.adapt(12))
        label.textColor = .cCD2901
        addSubview(label)
        addSubview(imageView)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: Screen.adapt(10)),
            label.leftAnchor.constraint(equalTo: leftAnchor, constant: Screen.adapt(5)),
            label.rightAnchor.constraint(equalTo: rightAnchor, constant: Screen.adapt(-5)),
            imageView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: Screen.adapt(5)),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    struct Item {
        var text: String?
        var image: UIImage?
    }
}


