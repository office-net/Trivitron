
import UIKit

class CGFloatTextView: UITextView {

    // MARK: Instance variables
    var placeholderText:String = ""  {
        didSet {
            self.placeHolderLabel.text = placeholderText
            self.adjustPlaceholderFrame()
        }
    }
    
    override var font: UIFont! {
        didSet {
            self.placeHolderLabel.font = font
            self.floatingLabel.font = font
        }
    }
    
    override var textColor: UIColor! {
        didSet {
            self.placeHolderLabel.textColor = textColor
            self.floatingLabel.textColor = textColor
        }
    }
    
    private var placeHolderLabel:UILabel
    
    // MARK: FLoatLabel constants.
    
    var floatingLabelText:String = "" {
        didSet {
            self.floatingLabel.text = floatingLabelText
            self.adjustFloatingHolderFrame()
        }
    }
    
    // MARK: Animation constants.
    var animationTime:TimeInterval = 0.3
    var floatingLabelOffset:CGFloat  = 10.0
    


     private var floatingLabel:UILabel
     private var floatingLabelState:Bool = false
    
    
    // MARK: Delegate
    weak var textViewDelegate: UITextViewDelegate?

    // MARK: Initializers
    required init?(coder aDecoder: NSCoder) {
        self.placeHolderLabel = UILabel(frame: CGRect.zero)
        self.floatingLabel = UILabel(frame: CGRect.zero)
        super.init(coder: aDecoder)
        self.commonInitializer()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        self.placeHolderLabel = UILabel(frame: CGRect.zero)
        self.floatingLabel = UILabel(frame: CGRect.zero)
        super.init(frame: frame, textContainer: textContainer)
        self.commonInitializer()
    }
    
}

private extension CGFloatTextView {
    func commonInitializer() {
        self.addSubview(self.placeHolderLabel)
        self.sendSubviewToBack(self.placeHolderLabel)
        self.addSubview(self.floatingLabel)
        self.sendSubviewToBack(self.floatingLabel)
        self.delegate = self
        self.placeHolderLabel.font = self.font
        self.placeHolderLabel.textColor = self.textColor
        self.floatingLabel.alpha = 0.0
        self.clipsToBounds = false
    }
    
    func handleTextChanged() {
        if self.text.count == 0 {
            self.placeHolderLabel.text = self.placeholderText
        }
        else {
            self.placeHolderLabel.text = ""
        }
    }
    
    func adjustPlaceholderFrame() {
        //let oldFrame = self.placeHolderLabel.frame
        let textFieldBounds: CGRect = self.bounds
        let placeholderLabelReqSize: CGSize = self.placeHolderLabel.sizeThatFits(CGSize(width: textFieldBounds.width, height: textFieldBounds.height))
        self.placeHolderLabel.frame = CGRect(x: 2.7, y: 5.0, width: placeholderLabelReqSize.width, height: placeholderLabelReqSize.height)
    }
    
    func adjustFloatingHolderFrame() {
        //let oldFrame = self.floatingLabel.frame
        let textFieldBounds:CGRect = self.bounds
        let floatingLabelReqSize: CGSize = self.floatingLabel.sizeThatFits(CGSize(width: textFieldBounds.width, height: textFieldBounds.height))
        self.floatingLabel.frame = CGRect(x: 2.7, y: 5.0, width: floatingLabelReqSize.width, height: floatingLabelReqSize.height)
    }
    
    func editingBeginAnimation() {
        UIView.animate(withDuration: self.animationTime, animations: { () -> Void in
            let oldFrame = self.floatingLabel.frame
            self.floatingLabel.frame = CGRect(x: oldFrame.origin.x, y:oldFrame.origin.y - (self.floatingLabelOffset + oldFrame.height) , width: oldFrame.width, height: oldFrame.height)
            self.floatingLabel.alpha = 1.0
            self.floatingLabelState = true
        });
    }
    
    func editingEndAnimation() {
        UIView.animate(withDuration: self.animationTime, animations: { () -> Void in
            let oldFrame = self.floatingLabel.frame
            self.floatingLabel.frame = CGRect(x: oldFrame.origin.x, y: oldFrame.origin.y + (self.floatingLabelOffset + oldFrame.height) , width: oldFrame.width, height: oldFrame.height)
            self.floatingLabel.alpha = 0.0;
            self.floatingLabelState = false
        });
    }

}


extension CGFloatTextView:UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if let uwTextFieldDelegate = self.textViewDelegate {
            return uwTextFieldDelegate.textViewShouldBeginEditing!(textView)
        }
        else {
            return true
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        self.handleTextChanged()
        if let uwTextFieldDelegate = self.textViewDelegate {
            return uwTextFieldDelegate.textViewShouldEndEditing!(textView)
        }
        else {
            return true
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.placeHolderLabel.text = ""
        if  textView.text.count > 0 && !self.floatingLabelState {
            self.editingBeginAnimation()
        }
        if let uwTextFieldDelegate = self.textViewDelegate {
            uwTextFieldDelegate.textViewDidBeginEditing!(textView)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.floatingLabelState {
            self.editingEndAnimation()
        }
        if let uwTextFieldDelegate = self.textViewDelegate {
             uwTextFieldDelegate.textViewDidEndEditing!(textView)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if  text.count > 0 && !self.floatingLabelState {
            self.editingBeginAnimation()
        }
        if let uwTextFieldDelegate = self.textViewDelegate {
            return uwTextFieldDelegate.textView!(textView, shouldChangeTextIn: range, replacementText: text)
        }
        else {
            return true
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
          self.handleTextChanged()
        if let uwTextFieldDelegate = self.textViewDelegate {
             uwTextFieldDelegate.textViewDidChange!(textView)
        }
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if let uwTextFieldDelegate = self.textViewDelegate {
             uwTextFieldDelegate.textViewDidChangeSelection!(textView)
        }
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if let uwTextFieldDelegate = self.textViewDelegate {
            return uwTextFieldDelegate.textView!(textView, shouldInteractWith: URL, in: characterRange)
        }
        else {
            return true
        }
    }
    
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange) -> Bool {
        if let uwTextFieldDelegate = self.textViewDelegate {
            return uwTextFieldDelegate.textView!(textView, shouldInteractWith: textAttachment, in: characterRange)
        }
        else {
            return true
        }
    }

}
