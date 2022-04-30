import UIKit

@IBDesignable class TextViewWithPlaceholder: UITextView {
    
    override var text: String! { // Ensures that the placeholder text is never returned as the field's text
        get {
            if showingPlaceholder {
                return "" // When showing the placeholder, there's no real text to return
            } else { return super.text }
        }
        set {
            if showingPlaceholder {
                removePlaceholderFormatting() // If the placeholder text is what's being changed, it's no longer the placeholder
            }
            super.text = newValue
        }
    }
    @IBInspectable var placeholderText: String = ""
    @IBInspectable var placeholderTextColor: UIColor = .placeholderText
    private var showingPlaceholder: Bool = true // Keeps track of whether the field is currently showing a placeholder
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if text.isEmpty {
            showPlaceholderText() // Load up the placeholder text when first appearing, but not if coming back to a view where text was already entered
        }
    }
    
    override public func becomeFirstResponder() -> Bool {
        
        // If the current text is the placeholder, remove it
        if showingPlaceholder {
            text = nil
            removePlaceholderFormatting()
        }
        return super.becomeFirstResponder()
    }
    
    override public func resignFirstResponder() -> Bool {
        
        // If there's no text, put the placeholder back
        if text.isEmpty {
            showPlaceholderText()
        }
        return super.resignFirstResponder()
    }
    
    private func showPlaceholderText() {
        
        text = placeholderText
        showingPlaceholder = true
        textColor = placeholderTextColor
    }
    
    private func removePlaceholderFormatting() {
        
        showingPlaceholder = false
        textColor = nil // Put the text back to the default, unmodified color
    }
}
