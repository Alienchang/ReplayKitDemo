//
//  ViewController.m
//  ReplayKitDemo
//
//  Created by Alienchang on 2017/2/16.
//  Copyright © 2017年 Alienchang. All rights reserved.
//

#import "ViewController.h"
#import <ReplayKit/ReplayKit.h>
@interface ViewController ()<RPScreenRecorderDelegate ,RPPreviewViewControllerDelegate>{
    BOOL _recording;
    CGFloat _screenWidth;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, _screenWidth - 40, 100)];
    [self.view addSubview:textView];
    [textView becomeFirstResponder];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(textView.frame) + 20, _screenWidth - 40, 44)];
    [button setBackgroundColor:[UIColor redColor]];
    [button setTitle:@"开始录制" forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    [button addTarget:self action:@selector(startRecord:) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view, typically from a nib.
}
#pragma mark --RPScreenRecorderDelegate
- (void)screenRecorder:(RPScreenRecorder *)screenRecorder didStopRecordingWithError:(NSError *)error previewViewController:(nullable RPPreviewViewController *)previewViewController{
    
}
- (void)screenRecorderDidChangeAvailability:(RPScreenRecorder *)screenRecorder{

}

#pragma mark --RPPreviewViewControllerDelegate
- (void)previewControllerDidFinish:(RPPreviewViewController *)previewController{
    [previewController dismissViewControllerAnimated:YES completion:nil];
}
- (void)previewController:(RPPreviewViewController *)previewController didFinishWithActivityTypes:(NSSet<NSString *> *)activityTypes{
    NSLog(@"activityTypes == %@",activityTypes);
}

- (void)cancelRecord{
    //停止录制
    RPScreenRecorder *screenRecorder = [RPScreenRecorder sharedRecorder];
    [screenRecorder discardRecordingWithHandler:^{
        
    }];
}
- (void)startRecord:(UIButton *)button{
    
    _recording = !_recording;
    RPScreenRecorder *screenRecorder = [RPScreenRecorder sharedRecorder];
    if (_recording) {
        [button setTitle:@"录制中" forState:UIControlStateNormal];
        [screenRecorder setMicrophoneEnabled:YES];
        [screenRecorder setCameraEnabled:YES];
        [screenRecorder setDelegate:self];
        [screenRecorder startRecordingWithHandler:^(NSError * _Nullable error) {
            [screenRecorder.cameraPreviewView setFrame:CGRectMake((_screenWidth - 100) / 2, CGRectGetMaxY(button.frame) + 20, 100, 100)];
            [self.view addSubview:screenRecorder.cameraPreviewView];
        }];
    }else{
        [button setTitle:@"开始录制" forState:UIControlStateNormal];
        [screenRecorder stopRecordingWithHandler:^(RPPreviewViewController * _Nullable previewViewController, NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@",error);
            }else{
                [previewViewController setPreviewControllerDelegate:self];
                [previewViewController setModalPresentationStyle:UIModalPresentationFullScreen];
                [self presentViewController:previewViewController animated:YES completion:nil];
            }
        }];
    }
}


@end
