import SwiftUI

struct PromptView: UIViewRepresentable {

    func makeUIView(context: UIViewRepresentableContext<PromptView>) -> UIView {
        let textView = PromptTextView()
        let containerView = UIView()

        textView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = true
        containerView.addSubview(textView)

        // we'll inset the textView by 8-points on all sides
        //  so we can see that it's inside the container view

        // avoid auto-layout error/warning messages
        let cTrailing = textView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -64.0)
        cTrailing.priority = .required - 1

        let cBottom = textView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8.0)
        cBottom.priority = .required - 1

        NSLayoutConstraint.activate([

            textView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8.0),
            textView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 64.0),

            // activate trailing and bottom constraints
            cTrailing, cBottom

        ])

        containerView.transform = CGAffineTransform(rotationAngle: (CGFloat)(Double.pi/2))

        return containerView
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PromptView>) { }

}

private class PromptTextView: UITextView {

    private var timer: Timer?
    private var scrollSpeed: CGFloat = 1

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.text = NSLocalizedString("prompt", comment: "")
        self.font = .App.prompt
        self.textColor = .white
        self.backgroundColor = nil
        self.isEditable = false
        self.isUserInteractionEnabled = false
    }

    override func didMoveToSuperview() {
        scrollSpeed = 1
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

        scrollSpeed += 2
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
