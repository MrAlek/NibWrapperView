//
// NibWrapperView.swift
//
// Created by Alek Åström on 2016-01-13.
// Copyright (c) 2015 Alek Åström. (https://github.com/MrAlek)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

@IBDesignable public class NibWrapperView: UIView {
    
    @IBInspectable public var nibName: String? = nil {
        didSet {
            guard nibName != oldValue else {
                return
            }
            
            wrappedView = nibName.flatMap(viewFromNib)
        }
    }
    
    public private(set) var wrappedView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            
            if let view = wrappedView {
                insertSubview(view, atIndex: 0)
                view.translatesAutoresizingMaskIntoConstraints = false
                view.nibWrapper_constraintEdgesToSuperview()
            }
        }
    }
    
    public override func intrinsicContentSize() -> CGSize {
        if let wrappedView = wrappedView {
            return wrappedView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        } else {
            return CGSize(width: UIViewNoIntrinsicMetric, height: UIViewNoIntrinsicMetric)
        }
    }
    
    private func viewFromNib(name: String) -> UIView? {
        let bundle = NSBundle(forClass: self.dynamicType)
        return bundle.loadNibNamed(name, owner: self, options: nil).first as! UIView?
    }
    
}

private extension UIView {
    
    func nibWrapper_constraintEdgesToSuperview() {
        guard let superview = superview else {
            fatalError("Must have a super view to construct constraints")
        }
        
        superview.addConstraint(topAnchor.constraintEqualToAnchor(superview.topAnchor))
        superview.addConstraint(leftAnchor.constraintEqualToAnchor(superview.leftAnchor))
        superview.addConstraint(rightAnchor.constraintEqualToAnchor(superview.rightAnchor))
        superview.addConstraint(bottomAnchor.constraintEqualToAnchor(superview.bottomAnchor))
    }
}
