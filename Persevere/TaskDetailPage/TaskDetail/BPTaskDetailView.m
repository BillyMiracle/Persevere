//
//  BPTaskDetailView.m
//  Persevere
//
//  Created by 张博添 on 2023/11/5.
//

#import <FQDateTimePicker/FQDateTimePicker.h>

#import "BPTaskDetailView.h"
#import "BPSectionHeaderView.h"
#import "BPInputShortTextTableViewCell.h"
#import "BPInputLongTextTableViewCell.h"
#import "BPSelectWeekdayTableViewCell.h"
#import "BPSelectDateOrTimeTableViewCell.h"
#import "BPSelectColorTableViewCell.h"
#import "BPSelectImageTableViewCell.h"
#import "BPUIHelper.h"
#import "BPDateHelper.h"
#import "DateTools.h"
#import "UITextField+BPIndexPath.h"
#import "UITextView+BPIndexPath.h"
#import "HXPhotoPicker.h"
#import "NSDate+DateTools.h"

static const CGFloat sectionHeaderViewHeight = 45.0f;

@interface BPTaskDetailView()
<
UITableViewDelegate,
UITableViewDataSource,
BPWeekdayPickerDelegate,
BPColorPickerDelegate,
UITextViewDelegate,
FQDateTimePickerViewDelegate,
HXCustomNavigationControllerDelegate
>

@property (nonatomic, strong) UITableView *detailTableView;

@property (nonatomic, strong) NSArray <NSString*>*titleArray;

/// 必选标题框
@property (nonatomic, strong) BPSectionHeaderView *requiredSectionHeader;
/// 可选标题框
@property (nonatomic, strong) BPSectionHeaderView *optionalSectionHeader;

@property (nonatomic, strong) TaskModel *currentTaskModel;

@property (nonatomic, strong) FQDateTimePickerView *dateTimePickerView;

@property (nonatomic, strong) UIAlertController *selectEndDateAlert;
@property (nonatomic, strong) UIAlertController *selectRemindTimeAlert;
@property (nonatomic, strong) UIAlertController *selectImageAlert;

@property (nonatomic, strong) HXPhotoManager *hxPhotoManager;
/// 相册页
@property (nonatomic, strong) HXCustomNavigationController *hxPhotoNavigationController;

@end

@implementation BPTaskDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor bp_backgroundThemeColor];
//    [self addSubview:self.weekdayPickerView];
//    [self addSubview:self.colorPickerView];
    [self addSubview:self.detailTableView];
    return self;
}

- (void)refreshAllViews {
    
}

- (NSString *)cellTitleWithIndexPath:(NSIndexPath *)indexPath {
    NSInteger count = 0;
    for (int i = 0; i < indexPath.section; i++) {
        count += [self tableView:self.detailTableView numberOfRowsInSection:i];
    }
    count += indexPath.row;
    if (count < self.titleArray.count) {
        return [self.titleArray objectAtIndex:count];
    }
    return @"";
}

- (TaskModel *)getCurrentTaskInfo {
    return self.currentTaskModel;
}

// MARK: 选择weekDay
- (void)didChangeWeekdays:(NSArray *_Nonnull)selectedWeekdays {
//    NSLog(@"%@", selectedWeekdays);
    self.currentTaskModel.reminderDays = selectedWeekdays;
}

// MARK: 选择颜色
- (void)didChangeColor:(NSInteger)selectedColorIndex {
//    NSLog(@"%ld", selectedColorIndex);
    self.currentTaskModel.type = selectedColorIndex;
}

// MARK: 选择开始、结束、提醒时间
/// 选择开始时间
- (void)selectStartDate {
    self.dateTimePickerView.title = @"请选择开始日期";
    self.dateTimePickerView.pickerModel = FQDateTimePickerModelDate;
    self.dateTimePickerView.minDate = [NSDate new];
    [self.dateTimePickerView showPickerInView:self];
}

/// 选择结束时间
- (void)selectEndDate {
    [self.parentViewController presentViewController:self.selectEndDateAlert animated:YES completion:nil];
}

- (void)selectEndDate:(BOOL)toInfinity {
    if (toInfinity) {// 结束时间无限期
        self.currentTaskModel.endDate = nil;
        // 选择后刷新列表
        [self.detailTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    } else {// 选择结束时间
        self.dateTimePickerView.title = @"请选择结束日期";
        self.dateTimePickerView.pickerModel = FQDateTimePickerModelDate;
        self.dateTimePickerView.minDate = self.currentTaskModel.startDate;
        [self.dateTimePickerView showPickerInView:self];
    }
}

/// 选择提醒时间
- (void)selectRemindTime {
    [self.parentViewController presentViewController:self.selectRemindTimeAlert animated:YES completion:nil];
}

- (void)selectRemindTimeWithShouldRemind:(BOOL)shouldRemind {
    if (!shouldRemind) {// 不提醒
        self.currentTaskModel.reminderTime = nil;
        // 选择后刷新列表
        [self.detailTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
    } else {// 选择提醒时间
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setHour:0];
        [components setMinute:0];
        NSDate *min = [calendar dateFromComponents:components];
        self.dateTimePickerView.title = @"请选择提醒时间";
        self.dateTimePickerView.pickerModel = FQDateTimePickerModelTime;
        self.dateTimePickerView.minDate = min;
        [self.dateTimePickerView showPickerInView:self];
    }
}

- (void)confirmActionFQDateTimePicker:(FQDateTimePickerView *)pickerView WithDate:(NSDate *)date withDateString:(NSString *)dateStr {
//    NSLog(@"%@---%@", date, dateStr);
    if ([pickerView.title isEqualToString:@"请选择开始日期"]) {
        NSLog(@"start, %@", date);
        self.currentTaskModel.startDate = date;
        // 选择后刷新列表
        [self.detailTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    } else if ([pickerView.title isEqualToString:@"请选择结束日期"]) {
        NSLog(@"end, %@", date);
        self.currentTaskModel.endDate = date;
        // 选择后刷新列表
        [self.detailTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    } else if ([pickerView.title isEqualToString:@"请选择提醒时间"]) {
        NSLog(@"remind, %@", date);
        self.currentTaskModel.reminderTime = date;
        // 选择后刷新列表
        [self.detailTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

// MARK: 选择图片
- (void)selectImage {
    [self.parentViewController presentViewController:self.selectImageAlert animated:YES completion:nil];
}

- (void)selectImageFromAlbum {
    [self.parentViewController presentViewController:self.hxPhotoNavigationController animated:YES completion:nil];
}

- (void)selectImageFromCamera {
    
}

// 删除照片后
- (void)deleteImage {
    self.currentTaskModel.imageData = nil;
//    [self.detailTableView reloadData];
    [self.detailTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
}

// 选择照片后
- (void)photoNavigationViewController:(HXCustomNavigationController *)photoNavigationViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original {
//    NSLog(@"%@", photoList);
    if (photoList.count == 1) {
        self.currentTaskModel.imageData = UIImageJPEGRepresentation(photoList.firstObject.previewPhoto, 1);
//        [self.detailTableView reloadData];
        [self.detailTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
        [self.detailTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:3] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
}

- (void)photoNavigationViewControllerDidCancel:(HXCustomNavigationController *)photoNavigationViewController {
    
}

// MARK: 文字改变

- (void)titleTextFieldDidChangeValue:(id)sender {
    UITextField *textField = (UITextField *)sender;
    self.currentTaskModel.name = textField.text;
}

- (void)urlTextFieldDidChangeValue:(id)sender {
    UITextField *textField = (UITextField *)sender;
    self.currentTaskModel.link = textField.text;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self textDidEndEditingAtIndexPath:textView.indexPath withText:textView.text];
}

- (void)textViewDidChange:(UITextView *)textView {
    [self textDidEndEditingAtIndexPath:textView.indexPath withText:textView.text];
}

- (void)textDidEndEditingAtIndexPath:(NSIndexPath *)indexPath withText:(NSString *)text {
    if (indexPath.section == 3 && indexPath.row == 1) {// 任务备注
        self.currentTaskModel.memo = text;
    }
}

// MARK: Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
        case 1:
        case 2:
            return 2;
        case 3:
            return 3;
        default:
            return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3 && indexPath.row == 1) {
        return 140;
    } else if (indexPath.section == 3 && indexPath.row == 2) {
        if (self.currentTaskModel.imageData) {
            return 200;
        }
    }
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
        case 1:
            return sectionHeaderViewHeight;
        case 2:
        case 3:
            return 8.0f;
        default:
            return CGFLOAT_MIN;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.requiredSectionHeader;
        case 1:
            return self.optionalSectionHeader;
        default:
            return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"%@", indexPath);
}

// MARK: 返回cell

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        // 任务名称
        BPInputShortTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inputShortText" forIndexPath:indexPath];
        cell.isTopBorder = YES;
        cell.bp_titleLabel.text = [self cellTitleWithIndexPath:indexPath];
        [cell.inputTextField removeTarget:self action:@selector(titleTextFieldDidChangeValue:) forControlEvents:UIControlEventEditingChanged];
        [cell.inputTextField addTarget:self action:@selector(titleTextFieldDidChangeValue:) forControlEvents:UIControlEventEditingChanged];
        cell.inputTextField.indexPath = indexPath;
        cell.inputTextField.text = self.currentTaskModel.name;
        return cell;
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        // 完成weekday
        BPSelectWeekdayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectWeekday" forIndexPath:indexPath];
        cell.weekdayPickerView.delegate = self;
        cell.isBottomBorder = YES;
        cell.bp_titleLabel.text = [self cellTitleWithIndexPath:indexPath];
        [cell.weekdayPickerView refreshViewsWithSelectedWeekDayArray:self.currentTaskModel.reminderDays];
        return cell;
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        // 开始时间
        BPSelectDateOrTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectDateOrTime" forIndexPath:indexPath];
        cell.isTopBorder = YES;
        cell.bp_titleLabel.text = [self cellTitleWithIndexPath:indexPath];
        [cell.selecetDateButton setTitle:[self.currentTaskModel.startDate formattedDateWithFormat:(NSString *)BPDateFormat] forState:UIControlStateNormal];
        [cell.selecetDateButton addTarget:self action:@selector(selectStartDate) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        // 结束时间
        BPSelectDateOrTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectDateOrTime" forIndexPath:indexPath];
        cell.isBottomBorder = YES;
        cell.bp_titleLabel.text = [self cellTitleWithIndexPath:indexPath];
        if (self.currentTaskModel.endDate == nil) {
            [cell.selecetDateButton setTitle:(NSString *)BPEndlessString forState:UIControlStateNormal];
        } else {
            [cell.selecetDateButton setTitle:[self.currentTaskModel.endDate formattedDateWithFormat:(NSString *)BPDateFormat] forState:UIControlStateNormal];
        }
        [cell.selecetDateButton addTarget:self action:@selector(selectEndDate) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else if (indexPath.section == 2 && indexPath.row == 0) {
        // 任务类别（颜色）
        BPSelectColorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectColor" forIndexPath:indexPath];
        cell.colorPickerView.delegate = self;
        [cell.colorPickerView refreshViewsWithSelectedItem:self.currentTaskModel.type];
        cell.isTopBorder = YES;
        cell.isBottomBorder = NO;
        cell.bp_titleLabel.text = [self cellTitleWithIndexPath:indexPath];
        return cell;
    } else if (indexPath.section == 2 && indexPath.row == 1) {
        // 提醒时间
        BPSelectDateOrTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectDateOrTime" forIndexPath:indexPath];
        cell.isBottomBorder = YES;
        cell.bp_titleLabel.text = [self cellTitleWithIndexPath:indexPath];
        if (self.currentTaskModel.reminderTime == nil) {
            [cell.selecetDateButton setTitle:@"无提醒" forState:UIControlStateNormal];
        } else {
            [cell.selecetDateButton setTitle:[self.currentTaskModel.reminderTime formattedDateWithFormat:@"HH:mm"] forState:UIControlStateNormal];
        }
        [cell.selecetDateButton addTarget:self action:@selector(selectRemindTime) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else if (indexPath.section == 3 && indexPath.row == 0) {
        // 任务关联链接
        BPInputShortTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inputShortText" forIndexPath:indexPath];
        cell.isTopBorder = YES;
        cell.bp_titleLabel.text = [self cellTitleWithIndexPath:indexPath];
        cell.inputTextField.placeholder = @"请输入 http:// 前缀的网址";
        cell.inputTextField.keyboardType = UIKeyboardTypeURL;
        [cell.inputTextField removeTarget:self action:@selector(urlTextFieldDidChangeValue:) forControlEvents:UIControlEventEditingChanged];
        [cell.inputTextField addTarget:self action:@selector(urlTextFieldDidChangeValue:) forControlEvents:UIControlEventEditingChanged];
        cell.inputTextField.indexPath = indexPath;
        return cell;
    } else if (indexPath.section == 3 && indexPath.row == 1) {
        // 任务备注
        BPInputLongTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inputLongText" forIndexPath:indexPath];
        cell.bp_titleLabel.text = [self cellTitleWithIndexPath:indexPath];
        cell.inputTextView.delegate = self;
        cell.inputTextView.indexPath = indexPath;
        return cell;
    } else if (indexPath.section == 3 && indexPath.row == 2) {
        // 关联图片
        BPSelectImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectImage" forIndexPath:indexPath];
        cell.isBottomBorder = YES;
        cell.bp_titleLabel.text = [self cellTitleWithIndexPath:indexPath];
        NSString *selectText = @"";
        if (self.currentTaskModel.imageData == nil) {
            selectText = @"添加图片";
            cell.deleteImageButton.hidden = YES;
            cell.customImageButton.hidden = YES;
        } else {
            UIImage *image = [UIImage imageWithData:self.currentTaskModel.imageData];
            [cell.customImageButton setBackgroundImage:image forState:UIControlStateNormal];
            [cell.customImageButton setBackgroundImage:image forState:UIControlStateHighlighted];
            cell.imageSize = image.size;
            cell.customImageButton.hidden = NO;
            selectText = @"更改图片";
            cell.deleteImageButton.hidden = NO;
        }
        [cell.selectImageButton setTitle:selectText forState:UIControlStateNormal];
        [cell.deleteImageButton setTitle:@"删除图片" forState:UIControlStateNormal];
        [cell.selectImageButton addTarget:self action:@selector(selectImage) forControlEvents:UIControlEventTouchUpInside];
        [cell.deleteImageButton addTarget:self action:@selector(deleteImage) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

// MARK: Getters

- (HXPhotoManager *)hxPhotoManager {
    if (!_hxPhotoManager) {
        _hxPhotoManager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _hxPhotoManager.configuration.photoMaxNum = 1;
        _hxPhotoManager.configuration.themeColor = [UIColor bp_defaultThemeColor];
        _hxPhotoManager.configuration.navBarBackgroudColor = [UIColor whiteColor];
    }
    return _hxPhotoManager;
}

- (HXCustomNavigationController *)hxPhotoNavigationController {
    if (!_hxPhotoNavigationController) {
        _hxPhotoNavigationController = [[HXCustomNavigationController alloc] initWithManager:self.hxPhotoManager delegate:self];
    }
    return _hxPhotoNavigationController;
}

- (FQDateTimePickerView *)dateTimePickerView {
    if (!_dateTimePickerView) {
        _dateTimePickerView = [[FQDateTimePickerView alloc] init];
        _dateTimePickerView.delegate = self;
        _dateTimePickerView.cancelColor = [UIColor systemRedColor];
        _dateTimePickerView.confirmColor = [UIColor systemBlueColor];
        _dateTimePickerView.pickerColor = [UIColor blackColor];
        _dateTimePickerView.maskBackgroundColor = [UIColor clearColor];
        _dateTimePickerView.pickerBackgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        _dateTimePickerView.titleColor = [UIColor blackColor];
        _dateTimePickerView.unitsData = nil;
    }
    return _dateTimePickerView;
}

- (UIAlertController *)selectEndDateAlert {
    if (!_selectEndDateAlert) {
        _selectEndDateAlert = [UIAlertController alertControllerWithTitle:@"选择结束时间" message:nil preferredStyle:UIAlertControllerStyleActionSheet];// style 为 sheet
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *toInf = [UIAlertAction actionWithTitle:@"设置为无限期" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self selectEndDate:YES];
        }];//handler里可以写需要的函数
        UIAlertAction *selectTime = [UIAlertAction actionWithTitle:@"选择时间" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self selectEndDate:NO];
        }];//同理
        [_selectEndDateAlert addAction:cancle];
        [_selectEndDateAlert addAction:toInf];
        [_selectEndDateAlert addAction:selectTime];
    }
    return _selectEndDateAlert;
}

- (UIAlertController *)selectRemindTimeAlert {
    if (!_selectRemindTimeAlert) {
        _selectRemindTimeAlert = [UIAlertController alertControllerWithTitle:@"选择提醒时间" message:nil preferredStyle:UIAlertControllerStyleActionSheet];// style 为 sheet
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *noRemind = [UIAlertAction actionWithTitle:@"设置为无提醒" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self selectRemindTimeWithShouldRemind:NO];
        }];
        UIAlertAction *selectTime = [UIAlertAction actionWithTitle:@"选择时间" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self selectRemindTimeWithShouldRemind:YES];
        }];
        [_selectRemindTimeAlert addAction:cancle];
        [_selectRemindTimeAlert addAction:noRemind];
        [_selectRemindTimeAlert addAction:selectTime];
    }
    return _selectRemindTimeAlert;
}

- (UIAlertController *)selectImageAlert {
    if (!_selectImageAlert) {
        _selectImageAlert = [UIAlertController alertControllerWithTitle:@"选择一张图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];// style 为 sheet
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *photoAlbum = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self selectImageFromAlbum];
        }];
        UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self selectImageFromCamera];
        }];
        [_selectImageAlert addAction:cancle];
        [_selectImageAlert addAction:photoAlbum];
        [_selectImageAlert addAction:camera];
    }
    return _selectImageAlert;
}

- (TaskModel *)currentTaskModel {
    if (!_currentTaskModel) {
        if (self.dataSource.task != nil) {
            _currentTaskModel = self.dataSource.task;
        } else {
            _currentTaskModel = [[TaskModel alloc] init];
            _currentTaskModel.startDate = [NSDate dateWithYear:[[NSDate date] year] month:[[NSDate date] month] day:[[NSDate date] day]];
        }
    }
    return _currentTaskModel;
}

- (UITableView *)detailTableView {
    if (!_detailTableView) {
        _detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bp_width, self.bp_height) style:UITableViewStyleGrouped];
        _detailTableView.delegate = self;
        _detailTableView.sectionFooterHeight = 0;
        _detailTableView.sectionHeaderHeight = 0;
        _detailTableView.dataSource = self;
        _detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _detailTableView.backgroundColor = [UIColor bp_backgroundThemeColor];
        [_detailTableView registerClass:[BPInputShortTextTableViewCell class] forCellReuseIdentifier:@"inputShortText"];
        [_detailTableView registerClass:[BPInputLongTextTableViewCell class] forCellReuseIdentifier:@"inputLongText"];
        [_detailTableView registerClass:[BPSelectWeekdayTableViewCell class] forCellReuseIdentifier:@"selectWeekday"];
        [_detailTableView registerClass:[BPSelectDateOrTimeTableViewCell class] forCellReuseIdentifier:@"selectDateOrTime"];
        [_detailTableView registerClass:[BPSelectColorTableViewCell class] forCellReuseIdentifier:@"selectColor"];
        [_detailTableView registerClass:[BPSelectImageTableViewCell class] forCellReuseIdentifier:@"selectImage"];
    }
    return _detailTableView;
}

- (BPSectionHeaderView *)requiredSectionHeader {
    if (!_requiredSectionHeader) {
        _requiredSectionHeader = [[BPSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.bp_width, sectionHeaderViewHeight) title:@"必填信息"];
    }
    return _requiredSectionHeader;
}

- (BPSectionHeaderView *)optionalSectionHeader {
    if (!_optionalSectionHeader) {
        _optionalSectionHeader = [[BPSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.bp_width, sectionHeaderViewHeight) title:@"选填信息"];
    }
    return _optionalSectionHeader;
}

- (NSArray <NSString *>*)titleArray {
    return @[@"任务名称", @"完成时间", @"开始时间", @"结束时间", @"任务类别", @"提醒时间", @"任务链接", @"任务备注", @"相关图片"];
}

@end
