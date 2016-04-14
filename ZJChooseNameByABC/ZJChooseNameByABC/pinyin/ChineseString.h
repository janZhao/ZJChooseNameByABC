//
//  ChineseString.h
//  YZX_ChineseSorting
//
//  Created by Suilongkeji on 13-10-29.
//  Copyright (c) 2013年 Suilongkeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "pinyin.h"

@interface ChineseString : NSObject

/**
 *  id
 */
@property (nonatomic, copy) NSString  *idStr;

/**
 *  汉字
 */
@property(retain,nonatomic)NSString *hanzi;

/**
 *  汉字对应拼音首字母
 */
@property(retain,nonatomic)NSString *pinYin;

//-----  返回tableview右方indexArray
+(NSMutableArray*)IndexArray:(NSArray*)stringArr;

//-----  返回联系人
+(NSMutableArray*)LetterSortArray:(NSArray*)stringArr;



///----------------------
//返回一组字母排序数组(中英混排)
+(NSMutableArray*)SortArray:(NSArray*)stringArr;

/**
 *  对应汉字全拼音
 */
@property (nonatomic, copy) NSString *pinyinAllLetter;

@end