import SwiftUI

struct PromptView: UIViewRepresentable {

    private let promptTextView: PromptTextView
    private let label: UILabel
    private let containerView: UIView

    init() {
        self.promptTextView = PromptTextView()
        self.label = UILabel()
        self.containerView = UIView()
    }

    func makeUIView(context: UIViewRepresentableContext<PromptView>) -> UIView {
        let view = PromptScrollView()
        view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        return view
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PromptView>) { }
}

private class PromptTextView: UITextView {

    private var timer: Timer?
    private var scrollSpeed: CGFloat = 0

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.text = NSLocalizedString("prompt", comment: "")
        self.font = .App.prompt
        self.textColor = .white
        self.backgroundColor = nil
        self.isEditable = false
        self.isUserInteractionEnabled = false
    }

    func startScrolling() {
        scrollSpeed = 0
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
            self.updateScroll()
        }
    }

    private func updateScroll() {
        let newContentOffset = CGPoint(
            x: self.contentOffset.x,
            y: self.contentOffset.y + scrollSpeed
        )

        guard abs(newContentOffset.y - self.contentSize.height) > 100 else {
            self.timer?.invalidate()
            return
        }

        UIView.animate(withDuration: 0.6) {
            self.contentOffset = newContentOffset
        }

        scrollSpeed += 1
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private class PromptScrollView: UIView {

    private var didUpdateConstraints = false

    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = UIScreen.main.bounds.width
        return stack
    }()

    private let readyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("ready", comment: "")
        label.textColor = .white
        label.font = .App.promptTitle
        return label
    }()

    private let textView: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = NSLocalizedString("prompt", comment: "")
        text.textColor = .white
        text.font = .App.prompt
        text.numberOfLines = 0
        return text
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(readyLabel)
        stackView.addArrangedSubview(textView)
    }

    override func updateConstraints() {
        guard !didUpdateConstraints else {
            super.updateConstraints()
            return
        }

        NSLayoutConstraint.activate([
            scrollView.frameLayoutGuide.topAnchor.constraint(equalTo: topAnchor),
            scrollView.frameLayoutGuide.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.frameLayoutGuide.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 64),
            scrollView.frameLayoutGuide.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -64)
        ])

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: UIScreen.main.bounds.width / 2 - 80),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        didUpdateConstraints = true
        super.updateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
