//
//  NSDictionary+WD.h
//  Business
//
//  Created by apple on 16/6/22.
//  Copyright © 2016年 jikang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (WD)
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
- (NSString *)descriptionWithLocale:(id)locale;
@end
