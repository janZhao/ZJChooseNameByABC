//
//  ViewController.m
//  ZJChooseNameByABC
//
//  Created by jyd on 16/4/14.
//  Copyright © 2016年 jydZJ. All rights reserved.
//

#import "ViewController.h"
#import "ZJConstant.h"
#import "ChineseString.h"
#import "ZJChooseNameByABCViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //监听选择变化通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectNameDidChange:) name:ZJSelectNameDidChangeNotification object:nil];
}

-(void)selectNameDidChange:(NSNotification *) note
{
    ChineseString *nameStr = note.userInfo[ZJSelectName];
    
    NSLog(@"--You Choose-->%@----",  nameStr.hanzi);
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"---touchesBegan---");
    
    [self selectNameABC];
}

/**
 * 选择人名或者地名
 */
- (void)selectNameABC
{
    [self.view endEditing:YES];
    
    /**
     *  显示选择的学校
     *  测试用数据
     */
    NSString *tmpStr = @"{\"STATUS\":\"0\",\"result\":[{\"schoolId\":\"123\",\"schoolName\":\"清华大学\"}, {\"schoolId\":\"456\",\"schoolName\":\"北京大学\"}],\"total\":\"1\"}";
    
    NSDictionary *tmpDict = [NSJSONSerialization JSONObjectWithData:[tmpStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    
    NSMutableArray *sourceArr = [[NSMutableArray alloc]init];
    sourceArr = tmpDict[@"result"];
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < [sourceArr count]; i++)
    {
        NSDictionary *dic = sourceArr[i];
        
        ChineseString *item  = [[ChineseString alloc] init];
        item.hanzi           = dic[@"schoolName"];
        item.pinyinAllLetter = dic[@"schoolName"];
        item.idStr           = dic[@"schoolId"];
        
        
        NSString *pinYinResult=[NSString string];
        
        for(int j=0;j<item.hanzi.length;j++)
        {
            NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([item.hanzi characterAtIndex:j])]uppercaseString];
            
            pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
        }
        
        item.pinYin=pinYinResult;
        
        [array addObject:item];
    }
    NSArray  *sectionIndexTitlesArr = [ChineseString IndexArray:array];
    NSArray  *sectionArr            = [ChineseString LetterSortArray:array];
    
    ZJChooseNameByABCViewController *vc = [[ZJChooseNameByABCViewController alloc]init];
    vc.nameArray = array;
    vc.sectionIndexTitlesArr = sectionIndexTitlesArr;
    vc.sectionArr = sectionArr;
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
