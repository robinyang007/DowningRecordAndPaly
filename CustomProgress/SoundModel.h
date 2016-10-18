//
//  SoundModel.h
//  CustomProgress
//
//  Created by Admin on 2016/10/15.
//  Copyright © 2016年 江萧. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFSoundItem.h"


typedef enum
{
    NETWORK = 0,
    LOCAL = 1
    
}SoundType;

@interface SoundModel : NSObject

@property (nonatomic,strong) AFSoundItem * soundItem;
@property (nonatomic,assign) SoundType type;
@property (nonatomic,copy) NSString * recordPath;
@property (nonatomic,copy) NSString * urlString;
@property (nonatomic,assign) NSInteger currentPalyTime;
@property (nonatomic,assign) BOOL isReset;


@end
