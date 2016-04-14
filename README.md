# ZJChooseNameByABC
类似通讯录的方式选择人名、地名、学校名等各种名称。(可以用作通讯录或者城市地名选择)

//选择学校例子
![image]=(https://github.com/janZhao/ZJChooseNameByABC/blob/master/ZJChooseNameByABC/ZJChooseNameByABC/sample1.PNG)

//搜索学校例子
![image]=(https://github.com/janZhao/ZJChooseNameByABC/blob/master/ZJChooseNameByABC/ZJChooseNameByABC/sample2.PNG)

详细用法见Demo:

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
