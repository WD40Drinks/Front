import SwiftUI

struct PromptView: UIViewRepresentable {

    func makeUIView(context: UIViewRepresentableContext<PromptView>) -> UITextView {
        let textView = PromptTextView()
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<PromptView>) { }

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
