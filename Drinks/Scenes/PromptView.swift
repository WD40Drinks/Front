import SwiftUI

struct PromptView: UIViewRepresentable {

    private let textView: PromptTextView
    private let label: UILabel
    private let containerView: UIView

    init() {
        self.textView = PromptTextView()
        self.label = UILabel()
        self.containerView = UIView()
        label.text = NSLocalizedString("ready", comment: "")
        label.textColor = .white
        label.font = .App.promptTitle
    }

    func makeUIView(context: UIViewRepresentableContext<PromptView>) -> UIView {
        containerView.translatesAutoresizingMaskIntoConstraints = true

        textView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(textView)

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8.0),
            textView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8.0),
            textView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 64.0),
            textView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -64.0)
        ])

        label.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])

        containerView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        textView.alpha = 0

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
                textView.alpha = 1
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            textView.startScrolling()
        }

        return containerView
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
