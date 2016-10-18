//
//  RecordPlayManager.h
//  CustomProgress
//
//  Created by Admin on 2016/10/17.
//  Copyright © 2016年 江萧. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SoundModel;
@class CustomProgress;
typedef enum
{
    Playing = 0,
    Paused = 1,
    Stop = 2
    
}PlayState;


@interface RecordPlayManager : NSObject

@property (nonatomic,copy) NSString * urlString;
@property (nonatomic,assign) PlayState playstate;
@property (nonatomic,strong) CustomProgress * custoprogress;
@property (nonatomic,strong) SoundModel *sdModel;

@end
