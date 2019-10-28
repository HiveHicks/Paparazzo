import ImageSource
import UIKit

final class SelectedPhotosBarView: UIView {
    
    let lastPhotoThumbnailView = UIImageView()
    private let penultimatePhotoThumbnailView = UIImageView()
    let label = UILabel()
    private let button = UIButton()
    
    private let lastPhotoThumbnailSize = CGSize(width: 48, height: 36)
    private let penultimatePhotoThumbnailSize = CGSize(width: 43, height: 32)
    
    var onButtonTap: (() -> ())?
    var onLastPhotoThumbnailTap: (() -> ())?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        layer.cornerRadius = 10
        
        lastPhotoThumbnailView.contentMode = .scaleAspectFill
        lastPhotoThumbnailView.clipsToBounds = true
        lastPhotoThumbnailView.layer.cornerRadius = 5
        
        penultimatePhotoThumbnailView.contentMode = .scaleAspectFill
        penultimatePhotoThumbnailView.clipsToBounds = true
        penultimatePhotoThumbnailView.alpha = 0.26
        penultimatePhotoThumbnailView.layer.cornerRadius = 5
        
        button.titleEdgeInsets = UIEdgeInsets(top: 10, left: 24, bottom: 11, right: 24)
        button.layer.backgroundColor = UIColor(red: 0, green: 0.67, blue: 1, alpha: 1).cgColor
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
        
        lastPhotoThumbnailView.isUserInteractionEnabled = true
        lastPhotoThumbnailView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(handleLastPhotoThumbnailTap))
        )
        
        addSubview(penultimatePhotoThumbnailView)
        addSubview(lastPhotoThumbnailView)
        addSubview(label)
        addSubview(button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SelectedPhotosBarView
    func setLastImage(_ imageSource: ImageSource?, resultHandler: ((ImageRequestResult<UIImage>) -> ())? = nil) {
        lastPhotoThumbnailView.setImage(
            fromSource: imageSource,
            size: lastPhotoThumbnailSize,
            resultHandler: resultHandler
        )
    }
    
    func setPenultimateImage(_ imageSource: ImageSource?, resultHandler: ((ImageRequestResult<UIImage>) -> ())? = nil) {
        penultimatePhotoThumbnailView.setImage(
            fromSource: imageSource,
            size: penultimatePhotoThumbnailSize,
            resultHandler: resultHandler
        )
    }
    
    func setTheme(_ theme: NewCameraUITheme) {
        label.font = theme.newCameraPhotosCountFont
        button.titleLabel?.font = theme.newCameraDoneButtonFont
    }
    
    func setDoneButtonTitle(_ title: String) {
        button.setTitle(title, for: .normal)
        setNeedsLayout()
    }
    
    func setHidden(_ isHidden: Bool, animated: Bool) {
        guard self.isHidden != isHidden else { return }
        
        if animated && isHidden {
            transform = .identity
            
            UIView.animate(
                withDuration: 0.15,
                animations: {
                    self.alpha = 0
                    self.transform = CGAffineTransform(translationX: 0, y: 5)
                },
                completion: { _ in
                    self.isHidden = true
                    self.transform = .identity
                }
            )
        } else if animated && !isHidden {
            self.isHidden = false
            
            alpha = 0
            transform = CGAffineTransform(translationX: 0, y: 5)
            
            UIView.animate(
                withDuration: 0.15,
                animations: {
                    self.alpha = 1
                    self.transform = .identity
                }
            )
        } else {
            self.isHidden = isHidden
        }
    }
    
    // MARK: - UIView
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: 72)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        lastPhotoThumbnailView.layout(
            left: bounds.left + 15,
            top: bounds.top + 18,
            width: lastPhotoThumbnailSize.width,
            height: lastPhotoThumbnailSize.height
        )
        
        penultimatePhotoThumbnailView.layout(
            left: bounds.left + 19,
            top: lastPhotoThumbnailView.top + 9,
            width: penultimatePhotoThumbnailSize.width,
            height: penultimatePhotoThumbnailSize.height
        )
        
        let buttonLabelSize = button.titleLabel?.sizeThatFits() ?? .zero
        
        button.sizeToFit()
        button.size = CGSize(  // sizeToFit() doesn't work for some reason
            width: buttonLabelSize.width + button.titleEdgeInsets.left + button.titleEdgeInsets.right,
            height: buttonLabelSize.height + button.titleEdgeInsets.top + button.titleEdgeInsets.bottom
        )
        button.right = bounds.right - 16
        button.centerY = bounds.centerY
        
        label.layout(
            left: lastPhotoThumbnailView.right + 8,
            right: button.left - 16,
            top: bounds.top,
            bottom: bounds.bottom
        )
    }
    
    // MARK: - Private - Event handlers
    @objc private func handleButtonTap() {
        onButtonTap?()
    }
    
    @objc private func handleLastPhotoThumbnailTap() {
        onLastPhotoThumbnailTap?()
    }
}