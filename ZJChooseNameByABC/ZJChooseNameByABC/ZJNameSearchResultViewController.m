//
//  ZJNameSearchResultViewController.m
//  ZJChooseNameByABC
//
//  Created by jyd on 16/4/14.
//  Copyright © 2016年 jydZJ. All rights reserved.
//

#import "ZJNameSearchResultViewController.h"
#import "ChineseString.h"
#import "ZJConstant.h"

@implementation ZJNameSearchResultViewController

-(NSMutableArray *)resultNames
{
    if (_resultNames == nil) {
        _resultNames = [NSMutableArray array];
    }
    
    return _resultNames;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)setSearchText:(NSString *)searchText
{
    _searchText = [searchText copy];
    
    //searchText = searchText.lowercaseString;
    
    //不区分大小写 | 忽略 "-" 符号的比较
    NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
    
    self.resultNames = [NSMutableArray array];
    
    // 根据关键字搜索想要的<地名或者人名>数据
    for (ChineseString *item in self.nameArray)
    {
        
        NSRange hanziRange = [item.hanzi rangeOfString:searchText options:searchOptions range:NSMakeRange(0, item.hanzi.length)];
        
        NSRange pinyinRange = [item.pinYin rangeOfString:searchText options:searchOptions range:NSMakeRange(0, item.pinYin.length)];
        
        //NSRange pinyinAllRange = [item.pinyinAllLetter rangeOfString:searchText options:searchOptions range:NSMakeRange(0, item.pinyinAllLetter.length)];
        
        if (hanziRange.length || pinyinRange.length)
        {
            [self.resultNames addObject:item];
        }
        
        //if ([item.hanzi containsString:searchText] || [item.pinyinAllLetter containsString:searchText] || [item.pinYin containsString:searchText]) {
        //    [self.resultSchools addObject:item];
        //}
    }
    
    // 谓词\过滤器:能利用一定的条件从一个数组中过滤出想要的数据
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hanzi contains %@ or pinyinAllLetter contains %@", searchText, searchText];
    //self.resultSchools = [self.schoolArray filteredArrayUsingPredicate:predicate];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"name";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    cell.textLabel.text = ((ChineseString *)self.resultNames[indexPath.row]).hanzi;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"共有%lu个搜索结果", (unsigned long)self.resultNames.count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //发出通知
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:ZJSelectNameDidChangeNotification object:nil userInfo:@{ZJSelectName : self.resultNames[indexPath.row]}];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
