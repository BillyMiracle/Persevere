//
//  BPInfoTabView.h
//  Persevere
//
//  Created by zhangbotian on 2024/3/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BPInfoTabViewModel : NSObject

/// 链接
@property (nonatomic, strong, nullable) NSString *link;
/// 图片
@property (nonatomic, strong, nullable) UIImage *image;
/// 备注
@property (nonatomic, strong, nullable) NSString *memo;

/// 初始化
/// @param link 链接
/// @param image 图片
/// @param memo 备注
- (instancetype)initWithLink:(NSString * _Nullable)link image:(UIImage * _Nullable)image memo:(NSString * _Nullable)memo;

@end

@protocol BPInfoTabViewDelegate <NSObject>

- (void)didSelectLink;
- (void)didSelectImage;
- (void)didSelectMemo;

@end

@interface BPInfoTabView : UIView

@property (nonatomic, weak) id<BPInfoTabViewDelegate> delegate;

- (instancetype)initWithModel:(BPInfoTabViewModel *)model;
- (instancetype)initWithFrame:(CGRect)frame model:(BPInfoTabViewModel *)model;
- (void)refreshWithModel:(BPInfoTabViewModel *)model;

@end

NS_ASSUME_NONNULL_END
