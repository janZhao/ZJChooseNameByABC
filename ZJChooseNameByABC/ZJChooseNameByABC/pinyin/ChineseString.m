//
//  ChineseString.m
//  YZX_ChineseSorting
//
//  Created by Suilongkeji on 13-10-29.
//  Copyright (c) 2013年 Suilongkeji. All rights reserved.
//

#import "ChineseString.h"

@implementation ChineseString
@synthesize hanzi;
@synthesize pinYin;

#pragma mark - 返回tableview右方 indexArray
+(NSMutableArray*)IndexArray:(NSArray*)stringArr
{
    NSMutableArray *tempArray = [self ReturnSortChineseArrar:stringArr];
    NSMutableArray *A_Result=[NSMutableArray array];
    NSString *tempString ;
    
    for (NSString* object in tempArray)
    {
        NSString *pinyin = [((ChineseString*)object).pinYin substringToIndex:1];
        //不同
        if(![tempString isEqualToString:pinyin])
        {
           // NSLog(@"IndexArray----->%@",pinyin);
            [A_Result addObject:pinyin];
            tempString = pinyin;
        }
    }
    
    return A_Result;

}

#pragma mark - 返回联系人
+(NSMutableArray*)LetterSortArray:(NSArray*)stringArr
{
    NSMutableArray *tempArray = [self ReturnSortChineseArrar:stringArr];
    NSMutableArray *LetterResult=[NSMutableArray array];
    NSMutableArray *item = [NSMutableArray array];
    NSString *tempString ;
    //拼音分组
    for (NSString* object in tempArray) {

         NSString *pinyin = [((ChineseString*)object).pinYin substringToIndex:1];
         //NSString *string = ((ChineseString*)object).string;
         //NSString *idStr   =  ((ChineseString*)object).idStr;
        //不同
        if(![tempString isEqualToString:pinyin])
        {
            //分组
            item = [NSMutableArray array];
            //[item addObject:string];
            [item  addObject:(ChineseString*)object];
            [LetterResult addObject:item];
            //遍历
            tempString = pinyin;
        }else//相同
        {
            //[item addObject:string];
            [item  addObject:(ChineseString*)object];
        }
    }
    return LetterResult;
}




//过滤指定字符串   里面的指定字符根据自己的需要添加
+(NSString*)RemoveSpecialCharacter: (NSString *)str {
    NSRange urgentRange = [str rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @",.？、 ~￥#&<>《》()[]{}【】^@/￡¤|§¨「」『』￠￢￣~@#&*（）——+|《》$_€"]];
    if (urgentRange.location != NSNotFound)
    {
        return [self RemoveSpecialCharacter:[str stringByReplacingCharactersInRange:urgentRange withString:@""]];
    }
    return str;
}

///////////////////
//
//返回排序好的字符拼音
//
///////////////////
+(NSMutableArray*)ReturnSortChineseArrar:(NSArray*)stringArr
{
    //获取字符串中文字的拼音首字母并与字符串共同存放
    NSMutableArray *chineseStringsArray=[NSMutableArray array];
    for(int i=0;i<[stringArr count];i++)
    {
        ChineseString *chineseString=[[ChineseString alloc]init];
        //chineseString.string=[NSString stringWithString:[stringArr objectAtIndex:i]];
        chineseString.hanzi = [NSString stringWithString:((ChineseString *)[stringArr objectAtIndex:i]).hanzi];
        chineseString.idStr  = [NSString stringWithString:((ChineseString *)[stringArr objectAtIndex:i]).idStr];
        
        if(chineseString.hanzi==nil){
            chineseString.hanzi=@"";
        }
        //去除两端空格和回车
        chineseString.hanzi  = [chineseString.hanzi stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        
        //此方法存在一些问题 有些字符过滤不了
        //NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""];
        //chineseString.string = [chineseString.string stringByTrimmingCharactersInSet:set];
        
        
        //这里我自己写了一个递归过滤指定字符串   RemoveSpecialCharacter
        chineseString.hanzi =[ChineseString RemoveSpecialCharacter:chineseString.hanzi];
       // NSLog(@"string====%@",chineseString.string);
        
        
        //判断首字符是否为字母
        NSString *regex = @"[A-Za-z]+";
        NSPredicate*predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        
        if ([predicate evaluateWithObject:chineseString.hanzi])
        {
            //首字母大写
            chineseString.pinYin = [chineseString.hanzi capitalizedString] ;
        }else{
            if(![chineseString.hanzi isEqualToString:@""]){
                NSString *pinYinResult=[NSString string];
                for(int j=0;j<chineseString.hanzi.length;j++)
                {
                    //#define HANZI_START 19968
                    //#define HANZI_COUNT 20902
                    //适应里面无汉字的时候、假如只有英文拼音的话 add by zhaojian 2016-04-12
                    NSString *singlePinyinLetter= @"";
                    
                    unichar hanzi = [chineseString.hanzi characterAtIndex:j];
                    
                    int index = hanzi - 19968;
                    if (index >= 0 && index <= 20902)
                    {
                        singlePinyinLetter=[[NSString stringWithFormat:@"%c", pinyinFirstLetter([chineseString.hanzi characterAtIndex:j])]uppercaseString];
                    }
                    else
                    {
                        singlePinyinLetter=[[NSString stringWithFormat:@"%c",[chineseString.hanzi characterAtIndex:j]]uppercaseString];
                    }
                    
                    //comment by zhaojian
                    //NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([chineseString.hanzi characterAtIndex:j])]uppercaseString];
                    
                    pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
                }
                chineseString.pinYin=pinYinResult;
            }else{
                chineseString.pinYin=@"";
            }
        }
        [chineseStringsArray addObject:chineseString];
    }
    //按照拼音首字母对这些Strings进行排序
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];

    return chineseStringsArray;
}

//
//for(int i=0;i<[chineseStringsArray count];i++){
//    // NSLog(@"chineseStringsArray====%@",((ChineseString*)[chineseStringsArray objectAtIndex:i]).pinYin);
//}
//// NSLog(@"-----------------------------");
#pragma mark - 返回一组字母排序数组
+(NSMutableArray*)SortArray:(NSArray*)stringArr
{
    NSMutableArray *tempArray = [self ReturnSortChineseArrar:stringArr];
    
    //把排序好的内容从ChineseString类中提取出来
    NSMutableArray *result=[NSMutableArray array];
    for(int i=0;i<[stringArr count];i++){
        [result addObject:((ChineseString*)[tempArray objectAtIndex:i]).hanzi];
        NSLog(@"SortArray----->%@",((ChineseString*)[tempArray objectAtIndex:i]).hanzi);
    }
    return result;
}

-(void)setPinyinAllLetter:(NSString *)pinyinAllLetter
{
    _pinyinAllLetter = [self pinyinAllLetter:pinyinAllLetter];
}

/**
 *  拼音全称
 */
- (NSString *) pinyinAllLetter:(NSString*)sourceString {
    NSMutableString *source = [sourceString mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *strUrl = [source stringByReplacingOccurrencesOfString:@" " withString:@""];
    return strUrl;
}

@end