//
//  TWSelectCityView.h
//  TWCitySelectView
//  Copyright © 2016年 zhoutai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWSelectCityView : UIView

-(instancetype)initWithTWFrame:(CGRect)rect TWselectCityTitle:(NSString*)title;

/**
 *  显示
 */
-(void)showCityView:(void (^)(NSString *, NSString *, NSString *))selectStr selecCode:(void (^)(NSString *, NSString *, NSString *))selecCode;


@end
