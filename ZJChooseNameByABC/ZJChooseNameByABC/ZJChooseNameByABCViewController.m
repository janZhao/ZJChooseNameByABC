//
//  ZJChooseNameByABCViewController.m
//  ZJChooseNameByABC
//
//  Created by jyd on 16/4/14.
//  Copyright © 2016年 jydZJ. All rights reserved.
//

#import "ZJChooseNameByABCViewController.h"
#import "ZJNameSearchResultViewController.h"
#import "ChineseString.h"
#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"
#import "UIView+AutoLayout.h"
#import "ZJConstant.h"

@interface ZJChooseNameByABCViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//遮罩
@property (weak, nonatomic) IBOutlet UIButton *coverBtn;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic, weak) ZJNameSearchResultViewController *nameSearchResult;

@end

@implementation ZJChooseNameByABCViewController

- (ZJNameSearchResultViewController *)nameSearchResult
{
    if (!_nameSearchResult) {
        ZJNameSearchResultViewController *nameSearchResult = [[ZJNameSearchResultViewController alloc] init];
        [self addChildViewController:nameSearchResult];
        nameSearchResult.nameArray = self.nameArray;
        self.nameSearchResult = nameSearchResult;
        
        [self.view addSubview:self.nameSearchResult.view];
        [self.nameSearchResult.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.nameSearchResult.view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.searchBar withOffset:15];
    }
    
    return _nameSearchResult;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 基本设置
    self.title = @"请选择";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(close) image:@"btn_navigation_close" highImage:@"btn_navigation_close_hl"];
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"bg_navigationBar_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch] forBarMetrics:UIBarMetricsDefault];
    
    self.tableView.sectionIndexColor = [UIColor blackColor];
    
    self.coverBtn.autoresizingMask = UIViewAutoresizingNone;
    
    [self.searchBar setBackgroundImage:[[UIImage imageNamed:@"bg_search_textfield"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch]];
}

/**
 *  点击遮盖
 */
- (IBAction)coverClick:(UIButton *)sender
{
    [self.searchBar resignFirstResponder];
}

/**
 *  返回对应的Section个数
 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionIndexTitlesArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sectionArr[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = ((ChineseString *)self.sectionArr[indexPath.section][indexPath.row]).hanzi;
    
    return cell;
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionIndexTitlesArr;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sectionIndexTitlesArr[section];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:ZJSelectNameDidChangeNotification object:nil userInfo:@{ZJSelectName : self.sectionArr[indexPath.section][indexPath.row]}];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 搜索框代理方法
/**
 *  键盘弹出:搜索框开始编辑文字
 */
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // 1.隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    // 2.修改搜索框的背景图片
    [searchBar setBackgroundImage:[[UIImage imageNamed:@"bg_search_textfield_hl"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch]];
    
    // 3.显示搜索框右边的取消按钮
    [searchBar setShowsCancelButton:YES animated:YES];
    
    // 4.显示遮盖
    self.coverBtn.alpha = 0.5;
    
}

/**
 *  键盘退下:搜索框结束编辑文字
 */
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    // 1.显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    // 2.修改搜索框的背景图片
    [searchBar setBackgroundImage:[[UIImage imageNamed:@"bg_search_textfield"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch]];
    
    // 3.隐藏搜索框右边的取消按钮
    [searchBar setShowsCancelButton:NO animated:YES];
    
    // 4.隐藏遮盖
    self.coverBtn.alpha = 0.0;
    
    // 5.移除搜索结果
    self.nameSearchResult.view.hidden = YES;
    searchBar.text = nil;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

/**
 *  搜索框里面的文字变化的时候调用
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length) {
        self.nameSearchResult.view.hidden = NO;
        self.nameSearchResult.searchText = searchText;
    } else {
        self.nameSearchResult.view.hidden = YES;
    }
}

@end
