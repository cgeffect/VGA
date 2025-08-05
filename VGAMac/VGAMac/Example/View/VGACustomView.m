//
//  VGACustomView.m
//  VGAMac
//
//  Created by Jason on 2021/12/5.
//

#import "VGACustomView.h"
#import "Masonry.h"

@interface VGACustomView ()
{
    NSScrollView *_scrollView;
}
@property(nonatomic, strong)NSButton *inputBtn;
@property(nonatomic, strong)NSButton *outputBtn;
@property(nonatomic, strong)NSTextField *bitrateText;
@property(nonatomic, strong)NSTextField *widthText;
@property(nonatomic, strong)NSTextField *heightText;
@property(nonatomic, strong)NSTextField *compressText;
@end

@implementation VGACustomView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _inputBtn = [NSButton buttonWithTitle:@"输入源" target:self action:@selector(inputAct)];
        [_inputBtn setBordered:NO];
        [_inputBtn setWantsLayer:YES];
        _inputBtn.layer.backgroundColor = NSColor.whiteColor.CGColor;
        _inputBtn.layer.cornerRadius = 10;
        _inputBtn.contentTintColor = NSColor.blackColor;
        [self addSubview:_inputBtn];
        [_inputBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self);
            make.width.mas_equalTo(70);
            make.height.mas_equalTo(40);
        }];
        
        _outputBtn = [NSButton buttonWithTitle:@"输出目录" target:self action:@selector(outputAct)];
        [_outputBtn setBordered:NO];
        [_outputBtn setWantsLayer:YES];
        _outputBtn.layer.backgroundColor = NSColor.whiteColor.CGColor;
        _outputBtn.layer.cornerRadius = 10;
        _outputBtn.contentTintColor = NSColor.blackColor;
        [self addSubview:_outputBtn];
        [_outputBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_inputBtn).offset(200);
            make.top.equalTo(self);
            make.width.mas_equalTo(70);
            make.height.mas_equalTo(40);
        }];

        _comboBoxOut = [[NSComboBox alloc] init];
        _comboBoxOut.buttonBordered = NO;
        [_comboBoxOut setWantsLayer:YES];
        _comboBoxOut.layer.backgroundColor = NSColor.whiteColor.CGColor;
        [self addSubview:_comboBoxOut];
        [_comboBoxOut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_outputBtn.mas_right).offset(20);
            make.centerY.equalTo(_outputBtn.mas_centerY);
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(20);
        }];
        
        [_comboBoxOut addItemsWithObjectValues:@[HevcWithAlpha, LeftAlpha, LeftScaleAlpha, RightAlpha, RightScaleAlpha]];
        [_comboBoxOut selectItemAtIndex:0];
        
        _codecBtn = [NSButton buttonWithTitle:生成 target:self action:@selector(codecAct:)];
        [_codecBtn setBordered:NO];
        [_codecBtn setWantsLayer:YES];
        _codecBtn.layer.backgroundColor = NSColor.whiteColor.CGColor;
        _codecBtn.layer.cornerRadius = 10;
        _codecBtn.contentTintColor = NSColor.blackColor;
        [self addSubview:_codecBtn];
        [_codecBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.top.equalTo(self);
            make.width.mas_equalTo(70);
            make.height.mas_equalTo(40);
        }];

        _clearBtn = [NSButton buttonWithTitle:清除 target:self action:@selector(clearAct:)];
        [_clearBtn setBordered:NO];
        [_clearBtn setWantsLayer:YES];
        _clearBtn.layer.backgroundColor = NSColor.whiteColor.CGColor;
        _clearBtn.layer.cornerRadius = 10;
        _clearBtn.contentTintColor = NSColor.blackColor;
        [self addSubview:_clearBtn];
        [_clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.top.equalTo(_codecBtn.mas_bottom).offset(10);
            make.width.mas_equalTo(70);
            make.height.mas_equalTo(40);
        }];
        
        _comboBox = [[NSComboBox alloc] init];
        _comboBox.buttonBordered = NO;
        [_comboBox setWantsLayer:YES];
        _comboBox.layer.backgroundColor = NSColor.whiteColor.CGColor;
        [self addSubview:_comboBox];
        [_comboBox mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_inputBtn);
            make.top.equalTo(_inputBtn.mas_bottom).offset(10);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(20);
        }];
        
        [_comboBox addItemsWithObjectValues:@[RGBA, LeftAlpha, RightAlpha]];
        [_comboBox selectItemAtIndex:0];
        
        _bitrateText = [[NSTextField alloc] init];
        _bitrateText.placeholderString = @"码率(k)";
        [self addSubview:_bitrateText];
        [_bitrateText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_outputBtn);
            make.top.equalTo(_outputBtn.mas_bottom).offset(10);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(20);
        }];

        _compressText = [[NSTextField alloc] init];
        _compressText.placeholderString = @"hevc with alpha";
        [self addSubview:_compressText];
        [_compressText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_outputBtn);
            make.top.equalTo(_bitrateText.mas_bottom).offset(10);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(20);
        }];
        _compressText.hidden = YES;

        _widthText = [[NSTextField alloc] init];
        _widthText.placeholderString = @"宽度";
        [self addSubview:_widthText];
        [_widthText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bitrateText.mas_right).offset(20);
            make.top.equalTo(_bitrateText.mas_top);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(20);
        }];
        _widthText.target = self;
        _widthText.action = @selector(textValueChange:);
        _widthText.hidden = YES;
        
        _heightText = [[NSTextField alloc] init];
        _heightText.placeholderString = @"高度";
        [self addSubview:_heightText];
        [_heightText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_widthText);
            make.top.equalTo(_widthText.mas_bottom).offset(10);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(20);
        }];
        _heightText.target = self;
        _heightText.action = @selector(textValueChange:);
        _heightText.hidden = YES;
        
        _tabelView = self.tabelView;
        _scrollView = [self getScrollView];
        [self addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self).offset(-20);
            make.top.mas_equalTo(120);
        }];
        _scrollView.documentView = _tabelView;
    }
    return self;
}

- (void)inputAct {
    [self.delegate inputAct];
}

- (void)outputAct {
    [self.delegate outputAct];
}

- (void)codecAct:(NSButton *)btn {
    [self.delegate codecAct:btn];
}

- (void)clearAct:(NSButton *)btn {
    [self.delegate clearAct:btn];
}
- (void)textValueChange:(NSTextField *)text {
    
}

- (NSScrollView *)getScrollView {
    NSScrollView *_scrollView = [[NSScrollView alloc] init];
    _scrollView.hasVerticalScroller = true;
    _scrollView.hasHorizontalScroller = false;
    _scrollView.focusRingType = NSFocusRingTypeNone;
    _scrollView.autohidesScrollers = true;
    _scrollView.borderType = NSBezelBorder;
    _scrollView.translatesAutoresizingMaskIntoConstraints = false;
    return _scrollView;
}
- (NSTableView *)tabelView {
    if (_tabelView) {
        return _tabelView;
    }
    NSTableView *_tabelView = [[NSTableView alloc] init];
    NSTableColumn *column1 = [[NSTableColumn alloc] initWithIdentifier:@"input"];
    column1.title = 输入源;
    column1.minWidth = 300;

    NSTableColumn *column2 = [[NSTableColumn alloc] initWithIdentifier:@"output"];
    column2.title = 输出源;
    column2.minWidth = 300;

    NSTableColumn *column3 = [[NSTableColumn alloc] initWithIdentifier:@"progress"];
    column3.title = 转换进度;
    column3.minWidth = 300;

    [_tabelView addTableColumn:column1];
    [_tabelView addTableColumn:column2];
    [_tabelView addTableColumn:column3];
    _tabelView.allowsColumnReordering = NO;
//    _tabelView.autoresizesSubviews = true;
    _tabelView.focusRingType = NSFocusRingTypeNone;
    [_tabelView sizeLastColumnToFit];
    return _tabelView;
}

- (void)setEnable:(BOOL)enable {
    _enable = enable;
    _bitrateText.enabled = enable;
    _widthText.enabled = enable;
    _heightText.enabled = enable;
}
- (int)bitRate {
    NSString *v = _bitrateText.stringValue;
    return [self getIntValue:v];
}

- (float)quality {
    NSString *v = _compressText.stringValue;
    if (v == nil || v.length == 0) {
        return -1;
    }
    return [v floatValue];
}

- (int)width {
    NSString *v = _widthText.stringValue;
    return [self getIntValue:v];
}
- (int)height {
    NSString *v = _heightText.stringValue;
    return [self getIntValue:v];
}
- (int)getIntValue:(NSString *)v {
    if (v == nil || v.length == 0) {
        return -1;
    }
    return [v intValue];
}
@end
