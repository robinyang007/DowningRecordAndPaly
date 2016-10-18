//
//  CustomProgress.h
//  WisdomPioneer
//
//  Created by 主用户 on 16/4/11.
//  Copyright © 2016年 江萧. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFSoundItem.h"
#import "SoundModel.h"
#import "RecordPlayManager.h"


@protocol CustomProgressDelegate <NSObject>

-(void)customProgressDidTapWithPlayState:(PlayState)state andWithUrl:(NSString *)urlString;

@end

@interface CustomProgress : UIView
@property(nonatomic, retain)UIImageView *bgimg;
@property(nonatomic, retain)UIImageView *leftimg;
@property(nonatomic, retain)UILabel *presentlab;
@property(nonatomic)float maxValue;
@property (nonatomic,assign) NSInteger currentIndex;
-(void)setPresent:(CGFloat)present;


@property (nonatomic,strong) SoundModel * sdmodel;

//定义代理..
@property (nonatomic,weak) id<CustomProgressDelegate> delegate;

//通过暴露方法来控制播放那个。停止哪个..
-(void)stop;


@end
