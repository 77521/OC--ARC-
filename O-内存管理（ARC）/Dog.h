//
//  Dog.h
//  O-内存管理（ARC）
//
//  Created by qingyun on 16/4/8.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dog : NSObject
{
    NSString *_name;
    __weak Dog *_friend;//解决循环引用和自身引用造成的内存泄漏
}
-(void)setName:(NSString *)name;//setter
-(NSString*)name;//getter方法
-(void)setFriend:(Dog *)dog;
-(void)play;
+(Dog *)sharedDog;
+(Dog *)dogWithName:(NSString *)name;
@end
