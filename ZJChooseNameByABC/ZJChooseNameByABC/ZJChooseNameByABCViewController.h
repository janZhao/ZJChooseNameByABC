//
//  ZJChooseNameByABCViewController.h
//  ZJChooseNameByABC
//
//  Created by jyd on 16/4/14.
//  Copyright © 2016年 jydZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJChooseNameByABCViewController : UIViewController

/**
 *  待选择名称<地名或者人名>数组
 */
@property (strong, nonatomic) NSArray *nameArray;

/**
 *  <地名或者人名>--索引数组
 */
@property (strong, nonatomic) NSArray *sectionIndexTitlesArr;

/**
 *  <地名或者人名>--排序分段数组
 */
@property (strong, nonatomic) NSArray *sectionArr;

@end
