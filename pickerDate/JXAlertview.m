//
//  JXAlertview.m
//  customalert
//
//  Created by jiangxiao on 14-7-8.
//  Copyright (c) 2014年 jiangxiao. All rights reserved.
//

#import "JXAlertview.h"
#import "UIView+Extension.h"
#define WDW [UIScreen mainScreen].bounds.size.width
#define WDH [UIScreen mainScreen].bounds.size.height
@implementation JXAlertview
{
    UIView *view;
    UIButton *discover;
    int tag;
    UIButton *Scancelbtn;
    UIButton *Ssurebtn;
    
}
@synthesize title,message,cancelbtn,surebtn;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.y = 104;
        self.width = WDW;
        self.x = 0;
        self.height = 0;
    }
    return self;
}
-(void)initwithtitle:(NSString *)str andmessage:(NSString *)str1 andcancelbtn:(NSString *)cancel andotherbtn:(NSString *)other
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    
    self.backgroundColor = [UIColor whiteColor];
    self.userInteractionEnabled = YES;
//    self.layer.borderColor = [UIColor clearColor].CGColor;
//    self.layer.borderWidth =  1;
//    self.layer.cornerRadius = 15;
//    [self.layer setMasksToBounds:YES];
    
//    title = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, self.frame.size.width-10, 30)];
//    title.text = str;
//    title.textAlignment = NSTextAlignmentCenter;
//    title.font = [UIFont systemFontOfSize:20];
//    title.textColor = [UIColor blackColor];
//    [self addSubview:title];
    
    message = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, self.frame.size.width-10, 50)];
    message.textAlignment = NSTextAlignmentCenter;
    message.font = [UIFont systemFontOfSize:18];
    message.textColor = [UIColor blackColor];
    message.numberOfLines = 0;
    message.text = str1;
    CGSize size = [str1 sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(self.frame.size.width-10, 9999999999999999)];
    message.frame =CGRectMake(5, 35, self.frame.size.width-10, size.height+5);
    if (self.frame.origin.y == 0) {
        self.frame = CGRectMake((keyWindow.frame.size.width-280)/2, (keyWindow.frame.size.height-140)/2, 250, 40+size.height);
    }
    [self addSubview:message];
    
    cancelbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    Scancelbtn = cancelbtn;
    [cancelbtn addTarget:self action:@selector(selectbtn:) forControlEvents:UIControlEventTouchUpInside];
    [cancelbtn setTitle:cancel forState:0];
    cancelbtn.tag = 1;
    
    surebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    Ssurebtn = surebtn;
    [surebtn addTarget:self action:@selector(selectbtn:) forControlEvents:UIControlEventTouchUpInside];
    [surebtn setTitle:other forState:0];
    surebtn.tag = 2;
    [cancelbtn setBackgroundColor:[UIColor lightGrayColor]];
    [surebtn setBackgroundColor:[UIColor greenColor]];
    if (cancel == nil &&other != nil) {
        surebtn.frame = CGRectMake(10, self.frame.size.height-45, 260, 35);
        surebtn.layer.borderColor = [UIColor clearColor].CGColor;
        surebtn.layer.borderWidth =  1;
        surebtn.layer.cornerRadius = 5;
        [surebtn.layer setMasksToBounds:YES];
        [self addSubview:surebtn];
    }else if(cancel != nil &&other == nil)
    {
        cancelbtn.frame = CGRectMake(10, self.frame.size.height-45, 260, 35);
        cancelbtn.layer.borderColor = [UIColor clearColor].CGColor;
        cancelbtn.layer.borderWidth =  1;
        cancelbtn.layer.cornerRadius = 5;
        [cancelbtn.layer setMasksToBounds:YES];
        [self addSubview:cancelbtn];
    }else
    {
    }
    
}
//点击
-(void)selectbtn:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 1) {
        [self dismmis];
    }else if(btn.tag == 2){
        [self.delegate btnindex:(int)btn.tag :(int)self.tag];
        [self dismmis];
    }
}


//出现
-(void)show
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    view = [[UIView alloc] initWithFrame:keyWindow.bounds];
    UIButton *discovers = [[UIButton alloc] init];
    discovers.frame = keyWindow.bounds;
    [discover addTarget:self action:@selector(dismmis) forControlEvents:UIControlEventTouchDown];
    discover = discovers;
    [keyWindow addSubview:discovers];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismmis)];
    view.userInteractionEnabled = YES;
    view.y = 104;
    view.height = WDH - 104;
    [UIView animateWithDuration:0.3 animations:^{
        view.alpha = 0.3;
        view.backgroundColor = [UIColor blackColor];

        [view addGestureRecognizer:tap];
        [keyWindow addSubview:view];
        
        self.alpha = 1;
        [keyWindow addSubview:self];
        [keyWindow bringSubviewToFront:self];
        self.height = 260;
    } completion:^(BOOL finished) {
        Scancelbtn.frame = CGRectMake(10, 280-75, self.frame.size.width/2-20, 35);
        [self addSubview:Scancelbtn];
        
        Ssurebtn.frame = CGRectMake(self.frame.size.width/2+10, 280-75, self.frame.size.width/2-20, 35);
        [self addSubview:Ssurebtn];
    }];
    
    
//    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animation];
//    bounceAnimation.duration = 0.3;
//    bounceAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    bounceAnimation.values = [NSArray arrayWithObjects:
//                              [NSNumber numberWithFloat:0.01],
//                              [NSNumber numberWithFloat:1.1],
//                              [NSNumber numberWithFloat:0.9],
//                              [NSNumber numberWithFloat:1.0],
//                              nil];
//    
//    [self.layer addAnimation:bounceAnimation forKey:@"transform.scale"];
//    
//    CABasicAnimation *fadeInAnimation = [CABasicAnimation animation];
//    fadeInAnimation.duration = 0.3;
//    fadeInAnimation.fromValue = [NSNumber numberWithFloat:0];
//    fadeInAnimation.toValue = [NSNumber numberWithFloat:1];
//    [self.superview.layer addAnimation:fadeInAnimation forKey:@"opacity"];
    
    
}
//出现
-(void)showview
{
    tag = 5;
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    view = [[UIView alloc] initWithFrame:keyWindow.bounds];
    view.alpha = 0.3;
    view.backgroundColor = [UIColor blackColor];
    view.y = 104;
    view.height = WDH - 104;
    [keyWindow addSubview:view];
    
    self.alpha = 1;
    [keyWindow addSubview:self];
    [keyWindow bringSubviewToFront:self];
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.3;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionFade;
    animation.subtype = kCATransitionFromBottom;
    [self.layer addAnimation:animation forKey:@"animation"];
    
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animation];
    fadeInAnimation.duration = 0.3;
    fadeInAnimation.fromValue = [NSNumber numberWithFloat:0];
    fadeInAnimation.toValue = [NSNumber numberWithFloat:1];
    [self.superview.layer addAnimation:fadeInAnimation forKey:@"opacity"];
}
//消失
-(void)dismmis1
{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         self.transform = CGAffineTransformConcat(self.transform, CGAffineTransformMakeScale(0.01, 0.01));
         view.alpha = 0;
     }
                     completion:^(BOOL finished)
     {
         [view removeFromSuperview];
         [self removeFromSuperview];
         
     }];
}
//消失
-(void)dismmis
{
    
    [UIView animateWithDuration:0.3 animations:^{
        view.alpha = 0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        [discover removeFromSuperview];
        [self removeFromSuperview];
    }];
//    [UIView animateWithDuration:0.3
//                          delay:0.0
//                        options:UIViewAnimationOptionCurveEaseInOut
//                     animations:^
//     {
////         self.transform = CGAffineTransformConcat(self.transform, CGAffineTransformMakeScale(0.01, 0.01));
////         self.height = 0;
////         view.height = 0;
//     }
//                     completion:^(BOOL finished)
//     {
//         view.alpha = 0;
//
//
//
//         [view removeFromSuperview];
//         [self removeFromSuperview];
//     }];
//    [self.delegate btnindex:2 :2];
}


@end
