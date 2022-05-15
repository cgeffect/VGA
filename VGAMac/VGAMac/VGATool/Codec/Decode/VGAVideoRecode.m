//
//  VGAVideoRecode.m
//  VGAMac
//
//  Created by Jason on 2022/1/9.
//

#import "VGAVideoRecode.h"
//https://zhuanlan.zhihu.com/p/145592911
@implementation VGAVideoRecode

/*
 ffmpeg -c:a libfdk_aac -i in.aac -f s16le out.pcm
 ffmpeg -i test.aac -f s16le test.pcm
 ffplay -ar 44100 -ac 2 -f s16le -i test.pcm
 ```
  备注：-i 表示指定的输入文件
        -f 表示强制使用的格式
        -ar 表示播放的音频数据的采样率
        -ac 表示播放的音频数据的通道数
 ```

 ffplay -ar 48000 -ac 2 -f f32le Test.pcm
 ffplay -video_size 720x720 -pixel_format yuv420p Test.yuv
 S16LE：S(signed)代表有符号，LE(little endian)为小端存储（先存低字节，再存高字节）

 */
+ (void)recodeInput:(NSString *)input outputPath:(NSString *)output {
    NSString *ffmpegPath = [[NSBundle mainBundle] pathForResource:@"ffmpeg" ofType:@""];
    NSPipe *pipe = [NSPipe pipe];
    NSFileHandle * read = [pipe fileHandleForReading];
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath: ffmpegPath];
    NSArray *arguments = @[@"-i", input, output];
    NSLog(@"arguments : %@",arguments);
    [task setArguments: arguments];
    [task setStandardOutput: pipe];
    [task launch];
    [task waitUntilExit];

    [self dumpMessage:read task:task];

}

/*
 ffmpeg -i test.mp4  -vn -acodec aac test.aac
 ```
  备注：-i 表示输入文件
        -vm disable video / 丢掉视频
        -acodec 设置音频编码格式
  ```
  libfdk_aac解码器，解码出来的PCM格式：s16
  aac解码器，解码出来的PCM格式：ftlp float planne
  新版ffmpeg 解码aac 默认为 AV_SAMPLE_FMT_FLTP
  总结 ffmpeg 输出的pcm是平面格式
  libfdk_aac解码器，解码出来的PCM格式：s16
  aac解码器，解码出来的PCM格式：ftlp
 */
+ (void)extractAAC:(NSString *)input outputPath:(NSString *)output {
    NSString *ffmpegPath = [[NSBundle mainBundle] pathForResource:@"ffmpeg" ofType:@""];
    NSPipe *pipe = [NSPipe pipe];
    NSFileHandle * read = [pipe fileHandleForReading];
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath: ffmpegPath];
    NSArray *arguments = @[@"-i", input, @"-vn", @"-acodec", @"aac", output];
    NSLog(@"arguments : %@",arguments);
    [task setArguments: arguments];
    [task setStandardOutput: pipe];
    [task launch];
    [task waitUntilExit];

    [self dumpMessage:read task:task];
}

/**
 * ffmpeg -i test.aac -f s16le test.pcm
 */
+ (void)extractPCM:(NSString *)input outputPath:(NSString *)output {
    NSString *ffmpegPath = [[NSBundle mainBundle] pathForResource:@"ffmpeg" ofType:@""];
    NSPipe *pipe = [NSPipe pipe];
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath: ffmpegPath];
    NSArray *arguments = @[@"-i", input, @"-f", @"s16le", @"pcm", output];
    NSLog(@"arguments : %@",arguments);
    [task setArguments: arguments];
    [task setStandardOutput: pipe];
    [task launch];
    [task waitUntilExit];

    NSFileHandle * read = [pipe fileHandleForReading];
    [self dumpMessage:read task:task];
}

+ (void)extractMp3:(NSString *)input outputPath:(NSString *)output {
    NSString *ffmpegPath = [[NSBundle mainBundle] pathForResource:@"ffmpeg" ofType:@""];
    NSPipe *pipe = [NSPipe pipe];
    NSFileHandle * read = [pipe fileHandleForReading];
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath: ffmpegPath];
    NSArray *arguments = @[@"-i", input, @"-vn", @"-acodec", @"mp3", output];
    [task setArguments: arguments];
    [task setStandardOutput: pipe];
    [task launch];
    [task waitUntilExit];
    
    [self dumpMessage:read task:task];
}

+ (void)addTask {

    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath: @"/bin/sh"];
    NSString *commandStr = @"last | grep reboot";
    NSArray *arguments = [NSArray arrayWithObjects:@"-c",commandStr,nil];
    NSLog(@"arguments : %@",arguments);
    [task setArguments: arguments];
    
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    
    [task launch];
    
    [self dumpMessage:file task:task];

}

/**
 * ffmpeg -i 1.mp4 -i 1.m4a -vcodec copy -acodec copy output.mp4
 * 视频向音频合并, 以视频时长
 */
+ (BOOL)muxVideo:(NSString *)vPath toAudio:(NSString *)aPath output:(NSString *)output {
    NSString *ffmpegPath = [[NSBundle mainBundle] pathForResource:@"ffmpeg" ofType:@""];
    NSPipe *pipe = [NSPipe pipe];
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath: ffmpegPath];
    NSArray *arguments = @[@"-i", vPath, @"-i", aPath, @"-vcodec", @"copy", @"-acodec", @"copy", output];
    [task setArguments: arguments];
    [task setStandardOutput: pipe];
    [task launch];
    [task waitUntilExit];
    
    NSFileHandle * read = [pipe fileHandleForReading];
    [self dumpMessage:read task:task];
    return YES;
}

+ (BOOL)muxAudio:(NSString *)aPath toVideo:(NSString *)vPath output:(NSString *)output {
    return YES;
}

+ (void)dumpMessage:(NSFileHandle *)handle task:(NSTask *)task {
    NSError *error = nil;
    NSData* data = [handle readDataToEndOfFileAndReturnError:&error];
    NSString* string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (error) {
        NSLog(@"string: %@, error: %@",string, error);
    }
    if (![task isRunning]) {
        int status = [task terminationStatus];
        if (status == 0) {
            NSLog(@"Task succeeded.");
        } else {
            NSLog(@"Task failed.");
        }
    }

}

/*
 视频

 1.获取视频流信息
 用ffprobe可以获取到视频的所有流的具体信息

 ffprobe -print_format json -show_streams -i input.mp4
 1
 2.多个视频拼接
 可以将几个视频拼接成一个视频 -f 表示采用concat协议，-c 表示采用什么编码器 copy表示不重新编码，如果是x264 表示将采用x264进行重新编码。

 ffmpeg -y -f concat -i videolist.txt -c copy  output.mp4
 1
 3.视频截图
 截一张图
 -ss 表示在视频的多少S 截取一张图

 ffmpeg -y -ss 8 -i input.mp4 -f image2 -vframes 1 output.jpg
 1
 截多张图
 -r 表示每秒截多少张图； -qscale 表示生成的截图质量，该值越小图片质量越好；%5d.jpg 表示生成的截图的命令规则，5位数的整数命名。

 ffmpeg -y -ss 0 -i input.mp4 -f image2  -r 1 -t 8 -qscale 1 ./jpgs/%5d.jpg
 1
 4.给视频加上水印图片

 ffmpeg -y -i input.mp4  -i ./logo.png filter_complex "overlay=0:0:enable=between(t,0,2)" -c:v libx264 -c:a aac -strict -2 output.mp4
 1
 5.图片合成视频

 ffmpeg -y -f image2 -framerate 10 -i ./jpgs/%05d.jpg -c:v libx264 -r 25 -pix_fmt yuv420p output.mp4
 1
 6.视频添加背景音乐

 ffmpeg -y -i input.mp4 -i ainiyiwannian.wav -filter_complex "[0:a] pan=stereo|c0=1*c0|c1=1*c1 [a1], [1:a] pan=stereo|c0=1*c0|c1=1*c1 [a2],[a1][a2]amix=duration=first,pan=stereo|c0<c0+c1|c1<c2+c3,pan=mono|c0=c0+c1[a]" -map "[a]" -map 0:v -c:v libx264 -c:a aac -strict -2 -ac 2 output.mp4
 1
 7.将视频去除音频

 ffmpeg -y -i source.mp4 -an -vcodec copy output.mp4
 1
 8.设置视频的音量
 -vol 设置视频的音量，是以%为单位，500表示500%

 ffmpeg -y -i source.mp4 -vol 500 -strict -2 -vcodec copy output.mp4
 1
 9.视频转码
 -vcodec 指定视频编码器，-acodec 指定音频编码器
 ffmpeg -y -i input.mp4 -vcodec libx264 -acodec copy output.mp4
 音频处理

 1.从视频中提取音频
 ffmpeg -y -i source.mp4 -vn output.wav
 2.将音频用lpcm格式重新编码，指定采样率
 ffmpeg -y -i source.wav -acodec pcm_s16le -ar 44100 output.wav
 */
@end
