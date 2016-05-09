//
//  ViewController.m
//  financial
//
//  Created by 火爆私厨 on 16/5/6.
//  Copyright © 2016年 聚财道. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    
    __weak IBOutlet UIImageView *_backgroud;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _backgroud.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickImage)];
    [_backgroud addGestureRecognizer:singleTap];
}

-(void)onClickImage{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    UIViewController *view = [sb instantiateInitialViewController];
    
    //----
    
    [view setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    
    [self presentViewController:view animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
