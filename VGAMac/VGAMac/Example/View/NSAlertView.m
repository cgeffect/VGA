//
//  NSAlertView.m
//  VGAMac
//
//  Created by Jason on 2022/1/9.
//

#import "NSAlertView.h"

@implementation NSAlertView

+ (void)alertView:(NSString *)msg confirm:(void(^)(void))okBlock cancel:(void(^)(void))block {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *message = msg;
        NSAlert *alert = [NSAlert new];
        [alert addButtonWithTitle:@"确定"];
        [alert addButtonWithTitle:@"取消"];
        [alert setMessageText:message];
        [alert setAlertStyle:NSAlertStyleCritical];
        [alert beginSheetModalForWindow:NSApplication.sharedApplication.mainWindow completionHandler:^(NSModalResponse returnCode) {
            if(returnCode == NSAlertFirstButtonReturn){
               //确定
                okBlock();
            }else if(returnCode == NSAlertSecondButtonReturn){
               //取消
                block();
            }
        }];
    });
}

@end
