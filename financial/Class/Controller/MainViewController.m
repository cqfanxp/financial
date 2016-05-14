//
//  MainViewController.m
//  financial
//
//  Created by 火爆私厨 on 16/5/6.
//  Copyright © 2016年 聚财道. All rights reserved.
//

#import "MainViewController.h"
#include "Public.h"
#import "AppListCell.h"
#import "WebViewController.h"

@interface MainViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    
    UICollectionView *_collection;
    //应用数据
    NSMutableArray *_appData;
    
    UIImageView *_blan;
    
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    _blan = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_width/1.8)];
//    _blan.image = [UIImage imageNamed:@"blan.jpg"];
//    [self.view addSubview:_blan];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];

    [self initData];
    
    [self initLayout];
    
    if (IS_IPAD) {
        NSLog(@"ipad");
    }else{
        NSLog(@"iphone");
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark 初始化数据
-(void)initData{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        //获得所有应用数据
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"menu_app" ofType:@"plist"];
        _appData = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
        
        //排序
        [_appData sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1[@"sequence"] floatValue] > [obj2[@"sequence"] floatValue];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_collection reloadData];
        });
    });
    
}
#pragma mark 初始化布局
-(void)initLayout{
    
    float headH = (screen_width/1.8);
    if (!IS_IPAD) {
        headH = (screen_width/1);
    }
    
    //初始化colletionView的布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //最小左右间距
    layout.minimumInteritemSpacing = 0.5;
    //最小上下间距
    layout.minimumLineSpacing = 1;
    
    //初始化collectionView
    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height) collectionViewLayout:layout];
    //设置代理
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.backgroundColor = RGB(240, 239, 237);
    
    _collection.contentInset = UIEdgeInsetsMake(headH/2, 0, 0, 0);
    
//    float num = HeadH;
//    
//    float a = screen_width;
    
    _blan = [[UIImageView alloc] init];
    _blan.image = [UIImage imageNamed:@"blan.jpg"];
    _blan.frame = CGRectMake(0, -headH/2, screen_width, headH/2);
    _blan.userInteractionEnabled = YES;
//    _blan.contentMode = UIViewContentModeScaleAspectFill;
    [_collection addSubview:_blan];
    
    //注册Cell AppListIpadCell
    if (IS_IPAD) {
        [_collection registerNib:[UINib nibWithNibName:@"AppListIpadCell" bundle:nil] forCellWithReuseIdentifier:@"AppListCell"];
    }else{
        [_collection registerNib:[UINib nibWithNibName:@"AppListCell" bundle:nil] forCellWithReuseIdentifier:@"AppListCell"];
    }
    
    
    [self.view addSubview:_collection];

}

#pragma mark 重写UICollectionView 方法
#pragma mark 返回每个分组的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_appData count];
}
#pragma mark 返回分组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark 定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(screen_width/3-0.5, screen_width/3-12);
}

#pragma mark 定义每个UICollectionView 的 分组margin
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}


#pragma mark 返回Cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item  = [_appData objectAtIndex:indexPath.row];
    
    AppListCell *cell = [AppListCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    cell.nameLabel.text = item[@"name"];
    cell.iconImg.image = [UIImage imageNamed:item[@"icon"]];
    return cell;
}

#pragma mark 跳转到对应的功能
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *item = [_appData objectAtIndex:indexPath.row];
    if ([[item objectForKey:@"controller"] isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"功能暂未开放，敬请期待..." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([item[@"appType"] intValue] == 1001) {
        UIViewController *viewController = [[NSClassFromString([item objectForKey:@"controller"]) alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    if ([item[@"appType"] intValue] == 1002) {
        WebViewController *webView = [[WebViewController alloc] init];
        webView.webModel = [WebModel initWithTitle:item[@"name"] Url:item[@"url"]];
        [self.navigationController pushViewController:webView animated:YES];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
