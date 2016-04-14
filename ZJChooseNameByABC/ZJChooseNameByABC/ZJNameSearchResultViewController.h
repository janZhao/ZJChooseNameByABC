//
//  ZJNameSearchResultViewController.h
//  ZJChooseNameByABC
//
//  Created by jyd on 16/4/14.
//  Copyright © 2016年 jydZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJNameSearchResultViewController : UITableViewController

@property (nonatomic, copy) NSString *searchText;

/**
 * <地名或者人名>数组
 */
@property (nonatomic, strong) NSArray *nameArray;

/**
 * 查询结果<地名或者人名>数组
 */
@property (nonatomic, strong) NSMutableArray *resultNames;

@end
