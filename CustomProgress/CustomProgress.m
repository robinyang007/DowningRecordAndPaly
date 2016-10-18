
//
//  CustomProgress.m
//  WisdomPioneer
//
//  Created by 主用户 on 16/4/11.
//  Copyright © 2016年 江萧. All rights reserved.
//

#import "CustomProgress.h"
#import "LCAudioManager.h"
#import "AFSoundPlayback.h"

#import "HSDownloadManager.h"


typedef enum
{
    Ready = 0,
    NeedDown = 1,
    Downloading = 2
    
}FileState;

@interface CustomProgress()

@property (nonatomic,strong) NSTimer * timer;
@property (nonatomic,assign) PlayState currentState;
//动画
@property (nonatomic, strong) UIImageView *messageVoiceStatusImageView;
//播放队列
@property (nonatomic, strong) AFSoundPlayback *playBlack;
@property (nonatomic, assign) FileState fileState;
@property (nonatomic,strong) UIActivityIndicatorView * indicatorview;


//记录当前正在播放的 和timer
@property (nonatomic,strong) NSMutableDictionary * cacheRecordDict;

@end

@implementation CustomProgress
@synthesize bgimg,leftimg,presentlab;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        bgimg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        bgimg.layer.borderColor = [UIColor clearColor].CGColor;
        bgimg.layer.borderWidth =  1;
        bgimg.layer.cornerRadius = 5;
        [bgimg.layer setMasksToBounds:YES];

        [self addSubview:bgimg];
        leftimg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, self.frame.size.height)];
        leftimg.layer.borderColor = [UIColor clearColor].CGColor;
        leftimg.layer.borderWidth =  1;
        leftimg.layer.cornerRadius = 5;
        [leftimg.layer setMasksToBounds:YES];
        [self addSubview:leftimg];
        
        presentlab = [[UILabel alloc] initWithFrame:bgimg.bounds];
        presentlab.textAlignment = NSTextAlignmentCenter;
        
        presentlab.textColor = [UIColor whiteColor];
        presentlab.font = [UIFont systemFontOfSize:16];
        [self addSubview:presentlab];

        //添加动画
        self.messageVoiceStatusImageView.frame = CGRectMake(10, 15, 20, 20);
        [self addSubview:self.messageVoiceStatusImageView];
        
        
        //添加转菊花
        self.indicatorview.frame = CGRectMake(self.frame.size.width - 25, 15, 20, 20);
        
        [self addSubview:self.indicatorview];
        
        self.indicatorview.hidden = YES;
        
        
        self.currentState = Stop;
        //给自己添加tap 事件
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beginOrStop)];
        
        [self addGestureRecognizer:tapGesture];
        
    }
    return self;
}



-(void)initRecordFrom
{
    //判定是否存在该文件。 并且要判定 文件大小是否相等..
    if ([HSDownloadManager isExistFile:self.sdmodel.urlString]) {
        
        //播放本地音频文件..
        NSString * localPath = [HSDownloadManager getLocalPathFromUrl:self.sdmodel.urlString];
        self.sdmodel.type = LOCAL;
        self.sdmodel.recordPath = localPath;
        CGFloat duration = [LCAudioManager durationWithAudio:[NSURL fileURLWithPath:localPath]];
        self.maxValue = duration;
        
    }
    else
    {
        
        self.sdmodel.type = NETWORK;
        
    }
    
    if (self.sdmodel.type == LOCAL) {
        self.fileState = Ready;
    }
    else{
        self.fileState = NeedDown;
    }
}


//开始或者暂停
-(void)beginOrStop
{
    

    
    if(self.currentState == Stop || self.currentState == Paused)
    {
        __weak typeof(self) wself = self;
        //判断播放的方式
        if (self.sdmodel.type == LOCAL) {
            //播放本地音频

            self.userInteractionEnabled = YES;
            //结束转菊花
            self.indicatorview.hidden = YES;
            //开始转菊花
            [self.indicatorview stopAnimating];
            
            //使用自定义timer 来计数..
        
            NSLog(@"%@",self.sdmodel.recordPath);
          
            
            if ([self.delegate respondsToSelector:@selector(customProgressDidTapWithPlayState:andWithUrl:)]) {
                [self.delegate customProgressDidTapWithPlayState:Playing andWithUrl:self.sdmodel.urlString];
            }
            
            [[LCAudioManager manager]playingWithRecordPath:self.sdmodel.recordPath atTime:self.sdmodel.currentPalyTime  completion:^(NSError *error) {
               
                if ([self.delegate respondsToSelector:@selector(customProgressDidTapWithPlayState:andWithUrl:)]) {
                    [self.delegate customProgressDidTapWithPlayState:Stop andWithUrl:self.sdmodel.urlString];
                }
                
                [wself stop];
            }];

            [self playing];
            
            
            //点击的时候要调用代理。更新状态

        }
        else
        {
            if (self.fileState == NeedDown) {

                self.indicatorview.hidden = NO;
                //开始转菊花
                [self.indicatorview startAnimating];
                
                wself.fileState = Downloading;
                
                
                self.userInteractionEnabled = NO;
                
                
                if ([self.delegate respondsToSelector:@selector(customProgressDidTapWithPlayState:andWithUrl:)]) {
                    [self.delegate customProgressDidTapWithPlayState:Playing andWithUrl:self.sdmodel.urlString];
                }
 
                //需要提示用户等待..
                [[HSDownloadManager sharedInstance]download:self.sdmodel.urlString progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
                 
                    //下载到本地..
                    
                    NSLog(@"download progress = %lf",progress);
                    
                } state:^(DownloadState state) {
                    
                    if (state == DownloadStateCompleted) {
                        
                        
                        wself.fileState = Ready;

                        NSString * recordPath = [HSDownloadManager getLocalPathFromUrl:wself.sdmodel.urlString];
                        //下载完成标志成本地
                        wself.sdmodel.type = LOCAL;
                        wself.sdmodel.recordPath =recordPath;
                        
                        CGFloat duration = [LCAudioManager durationWithAudio:[NSURL fileURLWithPath:recordPath]];
                        wself.maxValue = duration;

                        NSLog(@"%@",[NSThread currentThread]);
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [wself stop];
                            
                            self.userInteractionEnabled = YES;
                            //结束转菊花
                            self.indicatorview.hidden = YES;
                            //开始转菊花
                            [self.indicatorview stopAnimating];

                            
                            if ([self.delegate respondsToSelector:@selector(customProgressDidTapWithPlayState:andWithUrl:)]) {
                                [self.delegate customProgressDidTapWithPlayState:Playing andWithUrl:self.sdmodel.urlString];
                            }
                            [wself playing];
                        });

                        //如果完成下载 开始播放..
                        [[LCAudioManager manager]playingWithRecordPath:recordPath atTime:wself.sdmodel.currentPalyTime completion:^(NSError *error) {
                            
                            [wself stop];
                            
                            if ([self.delegate respondsToSelector:@selector(customProgressDidTapWithPlayState:andWithUrl:)]) {
                                [self.delegate customProgressDidTapWithPlayState:Stop andWithUrl:self.sdmodel.urlString];
                            }

                        }];
  
                    }
                }];
            }
            else if(self.fileState == Downloading)
            {
                self.userInteractionEnabled = YES;
//                //结束转菊花
//                self.indicatorview.hidden = YES;
//                //开始转菊花
//                [self.indicatorview stopAnimating];
                
                wself.fileState = NeedDown;
                
                //暂停这个任务..
                [[HSDownloadManager sharedInstance]download:self.sdmodel.urlString progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
                    NSLog(@"download progress = %lf",progress);
                    
                } state:^(DownloadState state) {
                    
                    if (state == DownloadStateSuspended) {
                     
                    }
                }];
   
                return;
            }
            else{
                
                [self playing];
                NSString * recordPath = [HSDownloadManager getLocalPathFromUrl:self.sdmodel.urlString];
                [[LCAudioManager manager]playingWithRecordPath:recordPath completion:^(NSError *error) {
                    [wself stop];
                }];

            }
            
            
           
            
            //使用网络播放..
//            _playBlack = [[AFSoundPlayback alloc] initWithItem:self.sdmodel.soundItem];
//            [_playBlack play];
//
//         
//            [self.playBlack listenFeedbackUpdatesWithBlock:^(AFSoundItem *item) {
//                NSLog(@"Item duration: %ld - time elapsed: %ld", (long)item.duration, (long)item.timePlayed);
//                if (item.timePlayed > 0  && item.timePlayed <= 1) {
//                    self.messageVoiceStatusImageView.highlighted = YES;
//                    [self.messageVoiceStatusImageView startAnimating];
//                }
//               
//                self.maxValue = item.duration;
//                self.currentIndex = item.timePlayed;
//                [self setPresent: self.currentIndex];
//                
//            } andFinishedBlock:^{
//                
//                self.messageVoiceStatusImageView.highlighted = NO;
//                [self.messageVoiceStatusImageView stopAnimating];
//                self.currentState = Paused;
//                [self pause];
//            }];
        }
        
        if ([self.delegate respondsToSelector:@selector(customProgressDidTapWithPlayState:andWithUrl:)]) {
            [self.delegate customProgressDidTapWithPlayState:Playing andWithUrl:self.sdmodel.urlString];
        }
        
      
       
    }
    else{
        
        self.userInteractionEnabled = YES;
        
        //结束转菊花
        self.indicatorview.hidden = YES;
        //开始转菊花
        [self.indicatorview stopAnimating];
        
        if (self.sdmodel.type == LOCAL) {
            [[LCAudioManager manager] stopPlaying];
        }
        else{
            
        }

        
        self.messageVoiceStatusImageView.highlighted = NO;
        [self.messageVoiceStatusImageView stopAnimating];
        self.currentState = Paused;
        [self pause];
        
        //调用方法提示是 暂停状态..
        if ([self.delegate respondsToSelector:@selector(customProgressDidTapWithPlayState:andWithUrl:)]) {
            [self.delegate customProgressDidTapWithPlayState:Paused andWithUrl:self.sdmodel.urlString];
        }

        
    }
    
}

-(void)playing
{
    self.currentState = Playing;
    self.messageVoiceStatusImageView.highlighted = YES;
    [self.messageVoiceStatusImageView startAnimating];
    [self began];
}



//开始..
-(void)began
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(BeginCount) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}

//开始计时的函数
-(void)BeginCount
{
    self.sdmodel.currentPalyTime++;
    if (self.sdmodel.currentPalyTime<=self.maxValue) {
        [self setPresent:self.sdmodel.currentPalyTime];
    }
    else{
        self.sdmodel.currentPalyTime =0 ;
        [self setPresent:self.sdmodel.currentPalyTime];
        [self.timer invalidate];
        self.timer = nil;
        
    }
}

//暂停
-(void)pause
{
    [self.timer invalidate];
    self.timer = nil;
}

//停止
-(void)stop
{
    self.sdmodel.currentPalyTime = 0;
    [self setPresent:self.sdmodel.currentPalyTime];
    [self.timer invalidate];
    self.timer = nil;
    //停止动画
    self.currentState = Stop;
    self.messageVoiceStatusImageView.highlighted = NO;
    [self.messageVoiceStatusImageView stopAnimating];

}


-(void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
}

-(void)setPresent:(CGFloat)present
{
    
    //赋值..
    
    presentlab.text = [NSString stringWithFormat:@"%.1f/%.1f",present,self.maxValue];
    leftimg.frame = CGRectMake(0, 0, self.frame.size.width/self.maxValue*present, self.frame.size.height);
}

- (UIImageView *)messageVoiceStatusImageView {
    if (!_messageVoiceStatusImageView) {
        _messageVoiceStatusImageView = [[UIImageView alloc] init];
        _messageVoiceStatusImageView.image = [UIImage imageNamed:@"message_voice_receiver_normal"] ;
        UIImage *image1 = [UIImage imageNamed:@"message_voice_receiver_playing_1"];
        UIImage *image2 = [UIImage imageNamed:@"message_voice_receiver_playing_2"];
        UIImage *image3 = [UIImage imageNamed:@"message_voice_receiver_playing_3"];
        _messageVoiceStatusImageView.highlightedAnimationImages = @[image1,image2,image3];
        _messageVoiceStatusImageView.animationDuration = 1.5f;
        _messageVoiceStatusImageView.animationRepeatCount = NSUIntegerMax;
    }
    return _messageVoiceStatusImageView;
}

-(UIActivityIndicatorView *)indicatorview
{
    if (_indicatorview == nil) {
        
        _indicatorview = [[UIActivityIndicatorView alloc] init];
        _indicatorview.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        
    }
    return _indicatorview;
}


-(void)setSdmodel:(SoundModel *)sdmodel
{
    _sdmodel = sdmodel;
    
    //初始化参数..
    [self initRecordFrom];
    
    //如果设置了 播放时间为 0 清空计时..
    if (self.sdmodel.isReset) {
        [self stop];
        self.sdmodel.isReset = NO;
    }
    
  
}

#pragma mark -- 保存字典..
-(NSMutableDictionary *)cacheRecordDict
{
    if (_cacheRecordDict == nil) {
        _cacheRecordDict = [NSMutableDictionary dictionary];
    }
    
    return _cacheRecordDict;
}

@end
