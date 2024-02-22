//
//  BPSelectImageTableViewCell.h
//  Persevere
//
//  Created by 张博添 on 2023/11/7.
//

#import "BPTaskDetailBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface BPSelectImageTableViewCell : BPTaskDetailBaseTableViewCell

@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UIButton *selectImageButton;
@property (nonatomic, strong) UIButton *deleteImageButton;
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, strong) UIButton *customImageButton;

@end

NS_ASSUME_NONNULL_END
