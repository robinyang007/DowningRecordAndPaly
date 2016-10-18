//
//  TestTabViewController.m
//  CustomProgress
//
//  Created by Admin on 2016/10/18.
//  Copyright © 2016年 杨文磊. All rights reserved.
//

#import "TestTabViewController.h"
#import "CustomProgress.h"
#import "AFSoundManager.h"
#import "HSDownloadManager.h"
#import "SoundModel.h"
#import "LCAudioManager.h"
#import "RecordPlayManager.h"
#import "TestCell.h"


@interface TestTabViewController ()<CustomProgressDelegate>

@property (nonatomic,strong) NSMutableArray * playingArray;
@property (nonatomic,copy) NSString * currentUrl;
@end

@implementation TestTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self initItem];
}


//从网络上获取数据
-(void)initItem
{
    //判断是否已经下载了该 mp3
    
//    NSString * urlString = @"http://mp3.haoduoge.com/s/2016-07-15/1468555360.mp3";
//    SoundModel * sdmodel = [[SoundModel alloc] init];
//    sdmodel.urlString = urlString;
//
//    
//    
//    
//    NSString * urlString2 = @"http://up.haoduoge.com:82/mp3/2016-10-17/1476682900.mp3";
//    SoundModel * sdmodel2 = [[SoundModel alloc] init];
//    sdmodel2.urlString = urlString2;
//    
//    //http://mp3.haoduoge.com/s/2016-10-18/1476767283.mp3
//    //http://mp3.haoduoge.com/s/2016-10-18/1476722077.mp3
//    //http://mp3.haoduoge.com/s/2016-10-17/1476693381.mp3
//    //http://mp3.haoduoge.com/s/2016-10-17/1476708933.mp3
//    //http://mp3.haoduoge.com/s/2016-10-17/1476693381.mp3
//    //http://mp3.haoduoge.com/s/2016-09-09/1473388972.mp3
//    //记录下状态模型..
//    
//    RecordPlayManager * m1 = [[RecordPlayManager alloc] init];
//    m1.urlString = urlString;
//    m1.playstate = Stop;
//
//    [self.playingArray addObject:m1];
//    
//    RecordPlayManager * m2 = [[RecordPlayManager alloc] init];
//    m2.urlString = urlString2;
//    m2.playstate = Stop;
    
    
    
//    [self.playingArray addObject:m2];
    //问题。当画面上出现多个语音的时候 该如何操作..
    //需要一个字典。保存下当前正在进行的 player ,timer ,
    
    //循环添加
    NSArray * urlStringArr = @[@"http://mp3.haoduoge.com/s/2016-07-15/1468555360.mp3",@"http://up.haoduoge.com:82/mp3/2016-10-17/1476682900.mp3",
                               @"http://mp3.haoduoge.com/s/2016-10-18/1476767283.mp3",@"http://mp3.haoduoge.com/s/2016-10-18/1476722077.mp3",
                               @"http://mp3.haoduoge.com/s/2016-10-17/1476693381.mp3",@"http://mp3.haoduoge.com/s/2016-10-17/1476708933.mp3",
                               @"http://mp3.haoduoge.com/s/2016-10-17/1476693381.mp3",@"http://mp3.haoduoge.com/s/2016-09-09/1473388972.mp3"];
    
    for (NSInteger i = 0; i< 8 ; i++) {
        
        RecordPlayManager * m = [[RecordPlayManager alloc] init];
        m.urlString = urlStringArr[i];
        m.playstate = Stop;
        SoundModel * sdmodel = [[SoundModel alloc] init];
        sdmodel.urlString = m.urlString;
        sdmodel.isReset = NO;
        
        m.sdModel = sdmodel;
        [self.playingArray addObject:m];
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.playingArray.count;
}

static NSString* cellID = @"TestCellID";

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TestCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil)
    {
        cell = [[TestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    
    }
    
    RecordPlayManager * m = self.playingArray[indexPath.row];
    cell.delegate = self;
    cell.sdModel = m.sdModel;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


-(NSMutableArray *)playingArray
{
    if (_playingArray == nil) {
        _playingArray = [NSMutableArray array];
    }
    
    return _playingArray;
}


#pragma mark -- 实现代理方法..
-(void)customProgressDidTapWithPlayState:(PlayState)state andWithUrl:(NSString *)urlString
{
    //如果两次点击url 不是同一个url
    if(![urlString isEqualToString:self.currentUrl])
    {
        if (self.currentUrl) {
            for (NSInteger i = 0; i < self.playingArray.count;i++) {
                
                RecordPlayManager * m = self.playingArray[i];
                
                if ([m.urlString isEqualToString:self.currentUrl]) {
                    
                    //如何清空数据.. 通过获取数据源 修改数据源的数据 来清空timer..
                    m.sdModel.currentPalyTime = 0;
                    m.sdModel.isReset = YES;
                    
                    [self.tableView reloadData];

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



@end
