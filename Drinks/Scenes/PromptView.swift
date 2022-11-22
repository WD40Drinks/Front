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
        containerView.translatesAutoresizingMaskIntoConstraints = true
        containerView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))

        configurePromptText()
        configureLabel()

        scheduleAnimations()

        return containerView
    }

    private func configurePromptText() {
        promptTextView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(promptTextView)

        NSLayoutConstraint.activate([
            promptTextView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8.0),
            promptTextView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8.0),
            promptTextView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 64.0),
            promptTextView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -64.0)
        ])
    }

    private func configureLabel() {
        label.text = NSLocalizedString("ready", comment: "")
        label.textColor = .white
        label.font = .App.promptTitle

        label.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }

    private func scheduleAnimations() {
        promptTextView.alpha = 0

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            UIView.animate(withDuration: 1.0) {
                label.alpha = 0
                label.text = NSLocalizedString("go", comment: "")
                label.alpha = 1
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            UIView.animate(withDuration: 1.0) {
                label.alpha = 0
                promptTextView.alpha = 1
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            promptTextView.startScrolling()
        }
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
