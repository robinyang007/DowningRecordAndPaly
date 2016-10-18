//
//  ViewController.m
//  CustomProgress
//
//  Created by 主用户 on 16/4/11.
//  Copyright © 2016年 杨文磊. All rights reserved.
//

#import "ViewController.h"
#import "CustomProgress.h"
#import "AFSoundManager.h"
#import "HSDownloadManager.h"
#import "SoundModel.h"
#import "LCAudioManager.h"
#import "RecordPlayManager.h"


@interface ViewController ()<CustomProgressDelegate>
{
    CustomProgress *custompro;
    int present;
}

@property (nonatomic,strong) NSTimer * timer;
@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,strong) CustomProgress * custompro2;
@property (nonatomic,strong) NSMutableArray * playingArray;
@property (nonatomic,copy) NSString * currentUrl;
@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    custompro = [[CustomProgress alloc] initWithFrame:CGRectMake(10, 100, 183, 50)];
    
    custompro.maxValue = 60;
    //设置背景色
    custompro.bgimg.backgroundColor =[UIColor colorWithRed:252/255.0 green:120/255.0 blue:121/255.0 alpha:1];
    custompro.leftimg.backgroundColor =[UIColor colorWithRed:252/255.0 green:252/255.0 blue:252/255.0 alpha:0.35];

    custompro.presentlab.textColor = [UIColor whiteColor];
    
    [self.view addSubview:custompro];
    
    
    self.custompro2 = [[CustomProgress alloc] initWithFrame:CGRectMake(10, 240, 183, 50)];
    
    _custompro2.maxValue = 60;
    //设置背景色
    _custompro2.bgimg.backgroundColor =[UIColor colorWithRed:252/255.0 green:120/255.0 blue:121/255.0 alpha:1];
    _custompro2.leftimg.backgroundColor =[UIColor colorWithRed:252/255.0 green:252/255.0 blue:252/255.0 alpha:0.35];
    
    _custompro2.presentlab.textColor = [UIColor whiteColor];
    
    [self.view addSubview:self.custompro2];
    
    [self initItem];


}


//从网络上获取数据
-(void)initItem
{
    //判断是否已经下载了该 mp3
    
    NSString * urlString = @"http://mp3.haoduoge.com/s/2016-07-15/1468555360.mp3";
    SoundModel * sdmodel = [[SoundModel alloc] init];
    sdmodel.urlString = urlString;
    custompro.delegate = self;
    custompro.sdmodel = sdmodel;
    
    
    
    NSString * urlString2 = @"http://up.haoduoge.com:82/mp3/2016-10-17/1476682900.mp3";
    SoundModel * sdmodel2 = [[SoundModel alloc] init];
    sdmodel2.urlString = urlString2;

    self.custompro2.sdmodel = sdmodel2;
    self.custompro2.delegate = self;
    
    //记录下状态模型..
    
    RecordPlayManager * m1 = [[RecordPlayManager alloc] init];
    m1.urlString = urlString;
    m1.playstate = Stop;
    m1.custoprogress = custompro;
    
    [self.playingArray addObject:m1];
    
    RecordPlayManager * m2 = [[RecordPlayManager alloc] init];
    m2.urlString = urlString2;
    m2.playstate = Stop;
    m2.custoprogress = self.custompro2;
    
    
    [self.playingArray addObject:m2];
    //问题。当画面上出现多个语音的时候 该如何操作..
    //需要一个字典。保存下当前正在进行的 player ,timer ,
    
    
}

#pragma mark -- 实现代理方法..
-(void)customProgressDidTapWithPlayState:(PlayState)state andWithUrl:(NSString *)urlString
{
    //如果两次点击url 不是同一个url
    if(![urlString isEqualToString:self.currentUrl])
    {
        if (self.currentUrl) {
            for (RecordPlayManager * m in self.playingArray) {
                if ([m.urlString isEqualToString:self.currentUrl]) {
                    [m.custoprogress stop];
                    if ([[LCAudioManager manager] isPlaying]) {
                        [[LCAudioManager manager] stopPlaying];
                    }
                    
                    break;
            
                }
            }
        }
    }
    
    //记录上一次播放的状态..
    self.currentUrl = urlString;
}



-(NSMutableArray *)playingArray
{
    if (_playingArray == nil) {
        _playingArray = [NSMutableArray array];
    }
    
    return _playingArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
