//
//  MenuInfoCell.swift
//  AnaMile
//
//  Created by ビ ユウ on 2018/02/26.
//

import UIKit

final class MenuInfoCell: UITableViewCell {
    
    /// Icon
    @IBOutlet private weak var icon: UIImageView!
    
    /// New mark
    @IBOutlet private weak var newMark: UIImageView!
    
    /// タイトル
    @IBOutlet private weak var categoryLabel: UILabel!
    
    /// タイトル
    @IBOutlet private weak var title: UILabel!
    
    /// 詳細
    @IBOutlet private weak var detail: UILabel!
    
    ///containerView
    @IBOutlet private weak var containerView: UIView!
    
    static let iconLeadingOffset = CGFloat(15.0)
    
    static let containerLeadingOffset = CGFloat(8.0)
    
    static let containerTrailingOffset = CGFloat(8.0)
    
    private var cellEntity: boArticle?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = 6
        containerView.layer.borderColor = UIColor.black.cgColor
        
        containerView.layer.shadowOpacity = 0.8
        containerView.layer.shadowOffset = CGSize(width: 0, height: 6)
        containerView.layer.shadowRadius = 6
        containerView.layer.shadowColor = UIColor.gray.cgColor
        containerView.layer.masksToBounds = false

    }
    
    /**
     Cell構成
     
     - parameter entity: entity
     */
    func configureCell(entity: boArticle) {
        cellEntity = entity
        selectionStyle = .none
        
        layer.masksToBounds = false
        
        newMark.isHidden = true
        categoryLabel.text = getDateFromTimeStamp(timeStamp: Double(entity.date))
        title.text = entity.title
        detail.text = entity.detail
        
    }
    
    func getDateFromTimeStamp(timeStamp : Double) -> String {
        
        let date = Date(timeIntervalSince1970: timeStamp)
        
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd MMM YY, hh:mm a"
        // UnComment below to get only time
        //  dayTimePeriodFormatter.dateFormat = "hh:mm a"
        
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
    }

}
