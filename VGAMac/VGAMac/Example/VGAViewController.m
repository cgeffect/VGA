//
//  ViewController.m
//  VGAMac
//
//  Created by Jason on 2021/12/2.
//

#import "VGAViewController.h"
#import "VGAConvertEncoder.h"
#import "VGATaskManager.h"
#import "VGAPreviewController.h"
#import "VGACustomView.h"
#import "VGAVideoRecode.h"

@interface VGAViewController ()<NSTableViewDelegate, NSTableViewDataSource, VGAEncodeDelegate, VGACustomViewDelegate>
{
    NSMutableDictionary <NSString *, VGAFileParam *>* _progressDic;
    dispatch_queue_t _encode_queue;
    NSMutableArray *_convertList;
    VGACustomView *_customView;
    float _bitRate, _width, _height, _qualityAlpha;
    VGAConvertEncoder *_encoder;
    NSButton *_btn;
}
@property(nonatomic, strong)NSTableView *inputTab;
@property(nonatomic, strong)NSComboBox *comboBox;
@property(nonatomic, strong)NSComboBox *comboBoxOut;
@property(nonatomic, strong)NSButton *startBtn;
@property(nonatomic, strong)VGATaskManager *manager;
@end

@implementation VGAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initResource];
}

- (void)initView {
    _customView = [[VGACustomView alloc] init];
    _customView.delegate = self;
    [self.view addSubview:_customView];
    [_customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.view).offset(20);
        make.bottom.equalTo(self.view);
    }];
    _comboBox = _customView.comboBox;
    _comboBoxOut = _customView.comboBoxOut;
    _startBtn = _customView.codecBtn;
    _inputTab = _customView.tabelView;
    _inputTab.delegate = self;
    _inputTab.dataSource = self;
    _inputTab.target = self;
    _inputTab.action = @selector(onTableCellClick);
}

- (void)initResource {
    _manager = [[VGATaskManager alloc] init];
    _progressDic = [NSMutableDictionary dictionary];
    _convertList = [NSMutableArray array];
    _encode_queue = dispatch_queue_create("com.vga.encode.queue", DISPATCH_QUEUE_CONCURRENT);
}

- (void)onTableCellClick {
    NSInteger colum = _inputTab.clickedColumn;
    NSInteger row = _inputTab.clickedRow;
    if (colum < 0 || row < 0) {
        return;
    }
    NSStoryboard *sb = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    VGAPreviewController *vc = [sb instantiateControllerWithIdentifier:@"SKVideoPlayerController"];
    if (_manager.srcURLs.count > 0) {
        vc.srcPath = _manager.srcURLs[row].path;
        NSLog(@"%@", _manager.srcURLs[row].path);
    }
    if (_manager.outURLs.count > 0) {
        vc.dstPath = _manager.outURLs[row].path;
        NSLog(@"%@", _manager.outURLs[row].path);
    }
    vc.inputMode = _encoder.inputMode;
    vc.outputMode = _encoder.outputMode;

    vc.view.frame = self.view.bounds;
    NSLog(@"%ld %ld", colum, row);
    [self presentViewControllerAsModalWindow:vc];
}

// MARK: - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return _manager.srcURLs.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if ([tableColumn.title isEqualToString:输入源]) {
        if (_manager.srcURLs.count == 0) {
            return @"";
        }
        float fileSize = [((NSNumber *)_manager.srcFileSizes[row]) floatValue];
        NSString *text = [NSString stringWithFormat:@"%fM - %@", fileSize, _manager.srcURLs[row].path.lastPathComponent];
        return text;
    } else if ([tableColumn.title isEqualToString:输出源]) {
        if (_manager.outURLs.count == 0) {
            return @"";
        }
        VGAFileParam *number = [_progressDic objectForKey:_manager.srcURLs[row].path];
        if (number) {
            NSString *text = [NSString stringWithFormat:@"%fM - %@", number.fileSize, _manager.outURLs[row].path.lastPathComponent];
            return text;
        } else {
            float fileSize = [VGATaskManager getFileSize:_manager.outURLs[row].path];
            NSString *text = [NSString stringWithFormat:@"%fM - %@", fileSize, _manager.outURLs[row].path.lastPathComponent];
            return text;
        }
    } else if ([tableColumn.title isEqualToString:转换进度]) {
        if (_progressDic.allKeys.count == 0) {
            return @"0%";
        }
        VGAFileParam *number = [_progressDic objectForKey:_manager.srcURLs[row].path];
        return [NSString stringWithFormat:@"%f%%", number.progress * 100];
    }
    return nil;
}

// MARK: - NSTableViewDelegate
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 20;
}
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSString *iden = @"tableColumn.identifier";
    NSView *cell = [tableView makeViewWithIdentifier:iden owner:self];
    if (cell == nil) {
        cell = [[NSTextField alloc] init];
        ((NSTextField *)cell).editable = NO;
        cell.identifier = iden;
    }
    ((NSTextField *)cell).stringValue = _manager.srcURLs[row].path;
    return cell;
}

#pragma mark - action

- (void)inputAct {
    [self reset];
    NSOpenPanel *panel = [[NSOpenPanel alloc] init];
    panel.canChooseFiles = YES;
    panel.canChooseDirectories = YES;
    panel.allowsMultipleSelection = YES;
    [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse result) {
        if (result == NSModalResponseOK) {
            if (panel.URLs.count == 1) {
                BOOL isDic = NO;
                [[NSFileManager defaultManager] fileExistsAtPath:panel.URL.relativePath isDirectory:&isDic];
                if (isDic) {
                    NSArray *list = [self contentsOf:panel.URL];
                    self->_manager.srcURLs = list;
                } else {
                    self->_manager.srcURLs = panel.URLs;
                }
            } else { //文件
                self->_manager.srcURLs = panel.URLs;
            }
        }
        self->_customView.enable = self->_manager.srcURLs.count > 1 ? NO : YES;
        [self->_inputTab reloadData];
    }];
}

- (void)outputAct {
    NSOpenPanel *panel = [[NSOpenPanel alloc] init];
    panel.canChooseDirectories = YES;
    [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse result) {
        if (result == NSModalResponseOK) {
            if (panel.URLs.count == 1) {
                BOOL isDic = NO;
                [[NSFileManager defaultManager] fileExistsAtPath:panel.URL.relativePath isDirectory:&isDic];
                if (isDic) {
                    self->_manager.outDicURL = panel.URL;
                } else {
                    self->_manager.outURLs = panel.URLs;
                }
            }
        }
        [self->_inputTab reloadData];
    }];
}

- (void)codecAct:(NSButton *)sender {
    [sender setTitle:@"转码中"];
    sender.enabled = NO;
    
    for (int i = 0; i < _manager.srcURLs.count; i++) {
        VGAFileParam *param = [[VGAFileParam alloc] init];
        param.progress = 0;
        param.fileSize = 0;
        [_progressDic setObject:param forKey:_manager.srcURLs[i].path];
    }
    int inputMode = VGAInputAlphaModeRGBA;
    if ([self->_comboBox.objectValueOfSelectedItem isEqualToString:RGBA]) {
        inputMode = VGAInputAlphaModeRGBA;
    } else if ([self->_comboBox.objectValueOfSelectedItem isEqualToString:LeftAlpha]) {
        inputMode = VGAInputAlphaModeLeftAlpha;
    } else if ([self->_comboBox.objectValueOfSelectedItem isEqualToString:RightAlpha]) {
        inputMode = VGAInputAlphaModeRightAlpha;
    }
    
    int outputMode = VGAOutputAlphaModeHevcWithAlpha;
    if ([self->_comboBoxOut.objectValueOfSelectedItem isEqualToString:HevcWithAlpha]) {
        outputMode = VGAOutputAlphaModeHevcWithAlpha;
    } else if ([self->_comboBoxOut.objectValueOfSelectedItem isEqualToString:LeftAlpha]) {
        outputMode = VGAOutputAlphaModeLeftAlpha;
    } else if ([self->_comboBoxOut.objectValueOfSelectedItem isEqualToString:LeftScaleAlpha]) {
        outputMode = VGAOutputAlphaModeLeftScaleAlpha;
    } else if ([self->_comboBoxOut.objectValueOfSelectedItem isEqualToString:RightAlpha]) {
        outputMode = VGAOutputAlphaModeRightAlpha;
    } else if ([self->_comboBoxOut.objectValueOfSelectedItem isEqualToString:RightScaleAlpha]) {
        outputMode = VGAOutputAlphaModeRightScaleAlpha;
    }
    _bitRate = _customView.bitRate;
    _width = _customView.width;
    _height = _customView.height;
    _qualityAlpha = _customView.quality;
    for (int i = 0; i < _manager.srcURLs.count; i++) {
        dispatch_async(_encode_queue, ^{
            NSURL *srcURL = self->_manager.srcURLs[i];
            NSURL *outURL = self->_manager.outURLs[i];
            [self doTask:srcURL outURL:outURL mode:inputMode output:outputMode];
        });
    }
}

- (void)doTask:(NSURL *)srcURL outURL:(NSURL *)outURL mode:(VGAInputAlphaMode)inputMode output:(VGAOutputAlphaMode)output {    
    VGAConvertEncoder *encode = [[VGAConvertEncoder alloc] init];
    encode.inputMode = inputMode;
    encode.outputMode = output;
    encode.srcIden = srcURL.path;
    encode.dstIden = outURL.path;
    encode.delegate = self;
    _encoder = encode;
    if (_bitRate > 0) {
        encode.averageBitRate = _bitRate;
    }
    if (_width > 0 && _height > 0) {
        encode.width = _width;
        encode.height = _height;
    }
    if (_qualityAlpha >= 0 && _qualityAlpha <= 1) {
        encode.qualityForAlpha = _qualityAlpha;
    }
    [encode gotoEncode:srcURL outUrl:outURL];
    [self->_convertList addObject:encode];
}
- (void)videoEncode:(VGAConvertEncoder *)thiz progress:(float)progress {
    VGAFileParam *param = [_progressDic objectForKey:thiz.srcIden];
    param.progress = progress;
    if (progress >= 1) {
        float fileSize = [VGATaskManager getFileSize:thiz.dstIden];
        param.fileSize = fileSize;
        if ([self isAllOK]) {
            NSLog(@"All OK");
            [_startBtn setTitle:生成];
            _startBtn.enabled = YES;
        }
    }
    [_progressDic setObject:param forKey:thiz.srcIden];
    [_inputTab reloadData];
}

- (void)videoEncode:(VGAConvertEncoder *)thiz notSupport:(BOOL)sup {
    [_startBtn setTitle:生成];
    _startBtn.enabled = YES;
}

- (void)reset {
    [_manager clearOutURL];
    [_progressDic removeAllObjects];
}

- (NSArray <NSURL *>*)contentsOf:(NSURL *)folder {
    NSError *error = nil;
    NSMutableArray *pathURLList = [NSMutableArray array];
    NSArray<NSString *> * pathList = [NSFileManager.defaultManager contentsOfDirectoryAtPath:folder.path error:&error];
    for (NSString *path in pathList) {
        //隐藏文件该怎么移除
        if ([path containsString:@".DS_Store"]) {
            continue;
        }
        NSURL *filePath = [folder URLByAppendingPathComponent:path];
        NSLog(@"%@", filePath);
        [pathURLList addObject:filePath];
    }
    return pathURLList;
}

- (BOOL)isAllOK {
    BOOL isAllOK = YES;
    for (NSString *key in _progressDic.allKeys) {
        VGAFileParam *param = [_progressDic objectForKey:key];
        if (param.progress < 1) {
            isAllOK = NO;
        }
    }
    return isAllOK;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}
@end

