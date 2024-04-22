//
//  BPSelectTaskViewModel.h
//  Persevere
//
//  Created by 张博添 on 2024/4/15.
//

#import <UIKit/UIKit.h>
#import "ARUtility.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^loadTasksFinishedBlock)(BOOL success);

@protocol BPSelectTaskViewModelDelegate <NSObject>

- (void)didSelectTaskAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface BPSelectTaskViewModel : NSObject
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<BPSelectTaskViewModelDelegate> delegate;
@property (nonatomic, strong, readonly) NSArray *selectedTasksArray;
@property (nonatomic, assign) BPARType type;

- (void)loadTasksFinished:(loadTasksFinishedBlock)finishedBlock;



@end

NS_ASSUME_NONNULL_END
