//
//  main.m
//  O-内存管理（ARC）
//
//  Created by qingyun on 16/4/8.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dog.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSString *str1=[[NSString alloc] initWithFormat:@"hello"];
        NSLog(@"str1=%p",str1);
        NSString *str2=str1;
        NSLog(@"str1=%p,str2=%p",str1,str2);
        //改变str1的指向
        str1=[[NSString alloc] initWithFormat:@"qingyun"];
        NSLog(@"str1=%p,str2=%p",str1,str2);
        NSString *str3=str1;
        NSLog(@"str1=%p,str2=%p,str3=%p",str1,str2,str3);
        str2=str3;      
        NSLog(@"str1=%p,str2=%p,str3=%p",str1,str2,str3);
        
        //1.__strong是默认的强引用，会有所有权,所以一般可以省略
        {
            __strong Dog *d1=[Dog new];
            [d1 setName:@"dog-1"];
        }//一出代码块，d1就会被释放
         
        //2.多个强引用指向同一块内存，如果部分失效，但是因为有其他强引用存在，该内存不会立即被释放
        Dog *d2=nil;
        {
            Dog *d3=[Dog new];
            d3.name=@"dog-2";
            d2=d3;
            NSLog(@"d2=%p,d3=%p",d2,d3);
        }
        NSLog(@"d2=%p",d2);
        
        //3.字符串常量存在于常量区，程序结束时才释放，myStr也是一个局部变量，出代码块应该被释放  所以说这种情况下出代码块后该对象是否被销毁不确定
        {
            NSString *myStr=@"qingyun-1";
            NSLog(@"myStr===%p",myStr);
        }
        
        //4.关系比较复杂的时候，很容易不小心让别的对象被释放，尽量避免这种编程,尽量严谨
        Dog *d4=[Dog new];
        [d4 setName:@"dog-3"];
        Dog *d5=[Dog new];
        [d5 setName:@"dog-4"];
        Dog *d6=nil;
        d4=d6;
        d5=d4;
        
        //5.相互强引用会造成循环引用，导致两个对象都无法释放（死锁）
        {
            Dog *d7=[Dog new];
            d7.name=@"dog-5";
            Dog *d8=[Dog new];
            [d8 setName:@"dog-6"];
            
            [d7 setFriend:d8];
            [d8 setFriend:d7];
        }
        
        //6.自身强引用 也会造成内存泄漏，无法释放，自身引用这种模式基本不要使用，违背了低耦合高内键设计原理
        {
            Dog *d9=[Dog new];
            [d9 setName:@"dog-7"];
            [d9 setFriend:d9];
        }
        
        //__weak 弱引用 会将对象自动设置为nil
        __weak Dog *d10=[Dog new];//一创建就会释放置为nil
        [d10 setName:@"dog-8"];
        
        __weak Dog *d11=nil;
        
        {
            Dog *d12=[Dog new];
            [d12 setName:@"dog-9"];
            [d12 play];
            d11=d12;//弱引用一般依赖于强引用,他就可以像强引用一样发送消息
            [d11 play];
            
        }
        NSLog(@"d11==>>%p",d11 );//给nil发送任何消息都是可以的，但是没效果
        NSLog(@"d11==>>%p",&d11 );
        //不安全的弱引用  __unsafe_unretained 不会将对象设置为nil 在以后开发尽量不使用
        __unsafe_unretained Dog *d13=nil;
        {
            Dog *d14=[Dog new];
            [d14 setName:@"dog-10"];
            [d14 play];
            d13=d14;
            d11=d14;
            [d11 play];
            [d13 play];
        }
        NSLog(@"d13==>>%p",d13);
//        [d13 play];//有可能会崩溃，因为d13有可能已经被置为nil
        
        //总的来说：__strong 和__weak已经足够了
        
        //自动释放
        @autoreleasepool {
            Dog *d15=[Dog sharedDog];
            [d15 setName:@"dog-11"];
            Dog *d16=[Dog dogWithName:@"dog-12"];
            [d16 play];
            
            {
                __autoreleasing Dog *d17=[Dog new];//一般来说放在类方法中，可以省略
                [d17 setName:@"dog-13"];
            }
        }
        
        struct Student
        {
//            NSString *name;//C 的结构体里面不能直接写OC的属性
            CFStringRef cfString;
            int age;
        }stu1;
        NSString *myName=@"qingyun";
        stu1.cfString=(__bridge CFStringRef)myName;
        NSLog(@"%@",stu1.cfString);
        
        id obj;//OC任意类型的对象
        void * p;//C的任意类型指针
        //可以向化转换，但需要桥接
        obj=(__bridge id)(p);
        p=(__bridge void *)(obj);
    }
    return 0;
}
