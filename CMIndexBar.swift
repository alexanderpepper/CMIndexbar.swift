//  Converted to Swift 4 by Swiftify v4.2.36673 - https://objectivec2swift.com/
//
//  indexBar.h
//
//  Created by Craig Merchant on 07/04/2011.
//  Copyright 2011 RaptorApps. All rights reserved.
//

import Foundation
import QuartzCore

protocol CMIndexBarDelegate: NSObjectProtocol {
    func indexSelectionDidChange(_ indexBar: CMIndexBar, index: Int, title: String)
}

class CMIndexBar: UIView {
    weak var delegate: (NSObject & CMIndexBarDelegate)?
    var highlightedBackgroundColor: UIColor?
    var textColor: UIColor?
    var font: UIFont?

    override init(frame: CGRect) {
        super.init(frame: frame)

        // Defaults
        backgroundColor = UIColor.clear
        textColor = Colors.chapterIndexColor()
        highlightedBackgroundColor = UIColor.clear
        font = UIFont(name: Constants.timesNewRomanBold, size: 12.0)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setIndexes(_ indexes: [String]) {
        clearIndex()
        let count = indexes.count
        for i in 0..<count {
            var ypos: Float
            if i == 0 {
                ypos = 0
            } else if i == count - 1 {
                ypos = Float(frame.size.height - 24.0)
            } else {
                var sectionheight = Float(((frame.size.height - 24.0) / CGFloat(count)))
                sectionheight = sectionheight + (sectionheight / Float(count))

                ypos = sectionheight * Float(i)
            }

            let label = UILabel(frame: CGRect(x: 0, y: CGFloat(ypos), width: frame.size.width, height: 24.0))
            label.textAlignment = .center
            label.text = indexes[i]
            label.font = font ?? label.font
            label.backgroundColor = UIColor.clear
            label.textColor = textColor ?? label.textColor
            addSubview(label)
        }
    }

    func clearIndex() {
        for subview: UIView in subviews {
            subview.removeFromSuperview()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        var i: Int = 0
        var subcount: Int = 0
        for subview: UIView in subviews {
            if subview is UILabel {
                subcount += 1
            }
        }

        for subview: UIView in subviews {
            if subview is UILabel {
                var ypos: Float

                if i == 0 {
                    ypos = 0
                } else if i == subcount - 1 {
                    ypos = Float(frame.size.height - 24.0)
                } else {
                    var sectionheight = Float(((frame.size.height - 24.0) / CGFloat(subcount)))
                    sectionheight = sectionheight + (sectionheight / Float(subcount))
                    ypos = sectionheight * Float(i)
                }
                subview.frame = CGRect(x: 0, y: CGFloat(ypos), width: frame.size.width, height: 24.0)
                i += 1
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        let backgroundview = UIView(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height))
        backgroundview.backgroundColor = highlightedBackgroundColor
        backgroundview.layer.cornerRadius = bounds.size.width / 2
        backgroundview.layer.masksToBounds = true
        backgroundview.tag = 767
        addSubview(backgroundview)
        sendSubviewToBack(backgroundview)

        if delegate == nil {
            return
        }

        let touchPoint: CGPoint? = (event?.touches(for: self)?.first)?.location(in: self)
        if (touchPoint?.x ?? 0.0) < 0 {
            return
        }

        var title = ""
        var count: Int = 0
        for subview in subviews {
            if let subview = subview as? UILabel {
                if (touchPoint?.y ?? 0.0) < subview.frame.origin.y + subview.frame.size.height {
                    count += 1
                    title = subview.text ?? ""
                    break
                }
                count += 1
                title = subview.text ?? ""
            }
        }

        delegate?.indexSelectionDidChange(self, index: count, title: title)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)

        if delegate == nil {
            return
        }

        let touchPoint: CGPoint? = (event?.touches(for: self)?.first)?.location(in: self)
        if (touchPoint?.x ?? 0.0) < 0 {
            return
        }

        var title = ""
        var count = 0
        for subview in subviews {
            if let subview = subview as? UILabel {
                if (touchPoint?.y ?? 0.0) < subview.frame.origin.y + subview.frame.size.height {
                    count += 1
                    title = subview.text ?? ""
                    break
                }
                count += 1
                title = subview.text ?? ""
            }
        }

        delegate?.indexSelectionDidChange(self, index: count, title: title)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        touchesEndedOrCancelled(touches, with: event)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        touchesEndedOrCancelled(touches, with: event)
    }

    func touchesEndedOrCancelled(_ touches: Set<AnyHashable>?, with event: UIEvent?) {
        let backgroundView = viewWithTag(767)
        backgroundView?.removeFromSuperview()
    }
}

