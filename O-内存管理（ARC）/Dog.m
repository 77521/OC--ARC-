//
//  Dog.m
//  O-内存管理（ARC）
//
//  Created by qingyun on 16/4/8.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "Dog.h"

@implementation Dog
-(void)setName:(NSString *)name
{
//    if (_name!=name)
//    {
//        [_name release];
//        _name=[name   ];
//    }
    _name=name;//ARC会自动加载release和retain操作
}
-(NSString *)name
{
    return _name;
}
-(void)setFriend:(Dog *)dog
{
    _friend=dog;
}
-(void)play
{
    NSLog(@"%@ is play...",_name);
}
+(Dog *)sharedDog
{
    __autoreleasing Dog *dog=[Dog new];//ARC中在返回对象的方法中，自动会将对象设置为自动释放，__autoreleasing可以省略
    return dog;
}
+(Dog *)dogWithName:(NSString *)name
{
    Dog *dog=[Dog new];
    [dog setName:name];
    return dog;
}
-(void)dealloc
{
    NSLog(@"%@被释放了...%@",_name,self);
//    _name=nil;//ARC一般自动会在释放的时候将对象置为nil
//    [super dealloc];//ARC不在支持，它会自动进行父类对象的释放
}
@end
