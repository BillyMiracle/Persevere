//
//  NSString+BPAddition.m
//  Persevere
//
//  Created by 张博添 on 2023/11/11.
//

#import "NSString+BPAddition.h"

@implementation NSString (BPAddition)

//单行的
- (CGSize)textSizeWithFont:(UIFont*)font {
    CGSize textSize = [self sizeWithAttributes:@{NSFontAttributeName:font}];
    textSize = CGSizeMake((NSInteger)ceil(textSize.width), (NSInteger)ceil(textSize.height));
    return textSize;
}

/**
 根据字体、行数、行间距和constrainedWidth计算多行文本占据的size
 **/
- (CGSize)textSizeWithFont:(UIFont*)font
             numberOfLines:(NSInteger)numberOfLines
               lineSpacing:(CGFloat)lineSpacing
          constrainedWidth:(CGFloat)constrainedWidth
          isLimitedToLines:(BOOL *)isLimitedToLines {

    if (self.length == 0) {
        return CGSizeZero;
    }
    CGFloat oneLineHeight = font.lineHeight;
    CGSize textSize = [self boundingRectWithSize:CGSizeMake(constrainedWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;

    CGFloat rows = textSize.height / oneLineHeight;
    CGFloat realHeight = oneLineHeight;
    // 0 不限制行数
    if (numberOfLines == 0) {
        if (rows >= 1) {
            realHeight = (rows * oneLineHeight) + (rows - 1) * lineSpacing;
        }
    } else {
        if (rows > numberOfLines) {
            rows = numberOfLines;
            if (isLimitedToLines) {
                *isLimitedToLines = YES;  //被限制
            }
        }
        realHeight = (rows * oneLineHeight) + (rows - 1) * lineSpacing;
    }
    return CGSizeMake(ceil(constrainedWidth),ceil(realHeight));
}

+ (NSString *)changetoLower:(NSString *)str {
    for (NSInteger i = 0; i < str.length; i++) {
        if ([str characterAtIndex:i] >= 'A' && [str characterAtIndex:i] <= 'Z') {
            char temp = [str characterAtIndex:i]+32;
            NSRange range = NSMakeRange(i, 1);
            str = [str stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"%c",temp]];
        }
    }
    return str;
}

+ (NSString *)transformToPinyin:(NSString *)searchtext {
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:searchtext];
    //将汉字转变为拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转变后的str每个字是旁边是有空格分开的
    NSArray *pinyinArray = [str componentsSeparatedByString:@" "];
    NSMutableString *allString = [NSMutableString new];
    int count = 0;
    //这是把汉字的拼音全部拼接起来
    for (int  i = 0; i < pinyinArray.count; i++) {
        for(int i = 0; i < pinyinArray.count;i++) {
            if (i == count) {
                [allString appendString:@"#"];
                //区分第几个字母
            }
            [allString appendFormat:@"%@",pinyinArray[i]];
        }
        [allString appendString:@","];
        count ++;
    }
    NSMutableString *initialStr = [NSMutableString new];
    //这是把汉字的首字母拼接起来
    for (NSString *s in pinyinArray) {
        if (s.length > 0) {
            [initialStr appendString:[s substringToIndex:1]];
        }
    }
    [allString appendFormat:@"#%@", initialStr];
    [allString appendFormat:@",#%@", searchtext];
    return allString;
}

@end
