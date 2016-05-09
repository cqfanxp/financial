//
//  WebModel.h
//  financial
//
//  Created by fanxp on 16/5/8.
//  Copyright © 2016年 聚财道. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebModel : NSObject

@property(nonatomic,strong) NSString *title;

@property(nonatomic,strong) NSString *url;

-(WebModel *)initWithTitle:(NSString *)title Url:(NSString *)url;

+(WebModel *)initWithTitle:(NSString *)title Url:(NSString *)url;
@end
