//
//  WebModel.m
//  financial
//
//  Created by fanxp on 16/5/8.
//  Copyright © 2016年 聚财道. All rights reserved.
//

#import "WebModel.h"

@implementation WebModel

-(WebModel *)initWithTitle:(NSString *)title Url:(NSString *)url{
    if (self = [super init]) {
        self.title = title;
        self.url = url;
    }
    return self;
}

+(WebModel *)initWithTitle:(NSString *)title Url:(NSString *)url{
    WebModel *webModel = [[WebModel alloc] initWithTitle:title Url:url];
    return webModel;
}
@end
