//
//  ViewController.m
//  VGADemo
//
//  Created by Jason on 2021/12/31.
//

#import "VGAViewController.h"
#import <VGAPlayer/VGAPlayer.h>

@interface VGAViewController ()<IVGAPlayerDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSArray <NSArray *>*_dataList;
    id<IVGAPlayer>_player;
    VGAVideoItem *_videoItem;
}
@property(nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)VGAView *vgaView;
@end

@implementation VGAViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _dataList = @[
        @[@"VGAAlphaModeRGBA",
          @"VGAAlphaModeLeftAlpha",
          @"VGAAlphaModeLeftScaleAlpha",
          @"VGAAlphaModeRightAlpha",
          @"VGAAlphaModeRightScaleAlpha",
          @"VGAAlphaModeHevcWithAlpha"],
        @[@"退后台结束",
          @"短视频(退后台暂停/恢复)",
          @"退后台结束/重新播放"]
    ];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    UIBarButtonItem *destroy = [[UIBarButtonItem alloc] initWithTitle:@"stop" style:(UIBarButtonItemStyleDone) target:self action:@selector(destroy)];
    self.navigationItem.rightBarButtonItems = @[destroy];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"reuseIdentifier"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _dataList[indexPath.section][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
//            NSString *resPath = [[NSBundle mainBundle] pathForResource:@"you rgba path" ofType:@"mp4"];
//            [self playVGA:resPath mode:VGAAlphaModeRGBA];
        } else if (indexPath.row == 1) {
            NSString *resPath = [[NSBundle mainBundle] pathForResource:@"mak_video" ofType:@"mp4"];
            [self playVGA:resPath mode:VGAAlphaModeLeftAlpha];
        } else if (indexPath.row == 2) {
            NSString *resPath = [[NSBundle mainBundle] pathForResource:@"leftScaleAlpha" ofType:@"mp4"];
            [self playVGA:resPath mode:VGAAlphaModeLeftScaleAlpha];
        } else if (indexPath.row == 3) {
            NSString *resPath = [[NSBundle mainBundle] pathForResource:@"mak_video" ofType:@"mp4"];
            [self playVGA:resPath mode:VGAAlphaModeRightAlpha];
        } else if (indexPath.row == 4) {
            NSString *resPath = [[NSBundle mainBundle] pathForResource:@"rightScaleAlpha" ofType:@"mp4"];
            [self playVGA:resPath mode:VGAAlphaModeRightScaleAlpha];
        } else if (indexPath.row == 5) {
            NSString *resPath = [[NSBundle mainBundle] pathForResource:@"hevcWithAlpha" ofType:@"mov"];
            [self playVGA:resPath mode:VGAAlphaModeHevcWithAlpha];
        } else if (indexPath.row == 5) {
            
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            _videoItem.backgroundMode = VGABackgroundModeStop;
        } else if (indexPath.row == 1) {
            _videoItem.backgroundMode = VGABackgroundModePauseAndResume;
        } else if (indexPath.row == 2) {
            _videoItem.backgroundMode = VGABackgroundModeStopAndPlay;
        }
        [_player replaceVideoItem:_videoItem];
    }
}

- (void)destroy {
    if (_player && _vgaView) {
        [_player destroy];
        _player = nil;
        [_vgaView removeFromSuperview];
        _vgaView = nil;
    }
}

#pragma mark -
- (void)playVGA:(NSString *)path mode:(VGAAlphaMode)mode {
    [self destroy];
    VGAViewConfig *config = [[VGAViewConfig alloc] init];
    config.alphaMode = mode;
    config.canvanSize = self.view.bounds.size;
    VGAView *vgaView = [[VGAView alloc] initWithConfig:config];
    vgaView.userInteractionEnabled = NO;
    vgaView.frame = self.view.bounds;
    VGAVideoItem *item = [VGAVideoItem new];
    _videoItem = item;
    [vgaView.player replaceVideoItem:item];
    [vgaView.player loadResource:[NSURL fileURLWithPath:path]];
    [self.view addSubview:vgaView];
    vgaView.player.delegate = self;
    _player = vgaView.player;
    _vgaView = vgaView;
}

- (void)playVgax {
    
}

- (void)playVgaLive {
    
}

- (void)playResumeVga {
    
}

- (void)onReady:(id)player {
    
}
@end
