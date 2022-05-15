//
//  VGACustomView.h
//  VGAMac
//
//  Created by Jason on 2021/12/5.
//

#import <Cocoa/Cocoa.h>
#import "Masonry.h"

NS_ASSUME_NONNULL_BEGIN

#define RGBA @"RGBA"
#define LeftAlpha @"LeftAlpha"
#define RightAlpha @"RightAlpha"

#define HevcWithAlpha @"HevcWithAlpha"
#define LeftAlpha @"LeftAlpha"
#define RightAlpha @"RightAlpha"
#define LeftScaleAlpha @"LeftScaleAlpha"
#define RightScaleAlpha @"RightScaleAlpha"

#define 输出源 @"输出源"
#define 输入源 @"输入源"
#define 转换进度 @"转换进度"
#define 生成 @"生成"

@protocol VGACustomViewDelegate <NSObject>
- (void)inputAct;
- (void)outputAct;
- (void)codecAct:(NSButton *)btn;

@end

@interface VGACustomView : NSView
@property(nonatomic, strong)NSButton *codecBtn;
@property(nonatomic, strong)NSComboBox *comboBox;
@property(nonatomic, strong)NSComboBox *comboBoxOut;
@property(nonatomic, strong)NSTableView *tabelView;
@property(nonatomic, weak)id<VGACustomViewDelegate>delegate;
@property(nonatomic, assign, readonly)int bitRate;
@property(nonatomic, assign, readonly)float quality;
@property(nonatomic, assign, readonly)int width;
@property(nonatomic, assign, readonly)int height;
@property(nonatomic, assign)BOOL enable;
@property(nonatomic, assign)float aspect;
@end

NS_ASSUME_NONNULL_END
