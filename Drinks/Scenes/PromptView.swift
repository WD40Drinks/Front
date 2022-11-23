import SwiftUI

struct PromptView: UIViewControllerRepresentable {

    @Binding var isShowing: Bool

    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = PromptScrollViewController(isShowing: $isShowing)
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}

private class PromptScrollViewController: UIViewController {

    @Binding var isShowing: Bool
    private var timer: Timer?
    private var scrollSpeed: CGFloat = 0

    init(isShowing: Binding<Bool>) {
        self._isShowing = isShowing
        super.init(nibName: nil, bundle: nil)
    }

    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        return view
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = UIScreen.main.bounds.width / 2
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

    private let emptyFrameView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        createViewHierarchy()
        activateConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            UIView.animate(withDuration: 1.0) {
                self.readyLabel.text = NSLocalizedString("go", comment: "")
            }

            self.startScrolling()
        }
    }

    func startScrolling() {
        scrollSpeed = 20
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true) { _ in
            self.updateScroll()
        }
    }

    private func updateScroll() {
        let newContentOffset = CGPoint(
            x: scrollView.contentOffset.x,
            y: scrollView.contentOffset.y + scrollSpeed
        )

        guard scrollView.contentSize.height > newContentOffset.y else {
            self.timer?.invalidate()
            stopShowingGame()
            return
        }

        UIView.animate(withDuration: 1.2) {
            self.scrollView.contentOffset = newContentOffset
        }

        scrollSpeed += 1
    }

    private func stopShowingGame() {
        DispatchQueue.main.async {
            withAnimation { self.isShowing = false }
        }
    }

    private func createViewHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(readyLabel)
        stackView.addArrangedSubview(textView)
        stackView.addArrangedSubview(emptyFrameView)
    }

    private func activateConstraints() {
        NSLayoutConstraint.activate([
            scrollView.frameLayoutGuide.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.frameLayoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.frameLayoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 64),
            scrollView.frameLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -64)
        ])

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.topAnchor,
                constant: UIScreen.main.bounds.width / 2 - 80
            ),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        NSLayoutConstraint.activate([
            emptyFrameView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
