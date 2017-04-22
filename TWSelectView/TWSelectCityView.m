//
//  TWSelectCityView.m
//  TWCitySelectView
//
//  Copyright © 2016年 zhoutai. All rights reserved.
//

#import "TWSelectCityView.h"
#import "NSDictionary+WD.h"
#define TWW self.frame.size.width
#define TWH self.frame.size.height

#define TWRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define BtnW 60
#define toolH 40
#define BJH 260

@interface TWSelectCityView ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    
    UIView *_BJView;                //一个view，工具栏和pickview都是添加到上面，便于管理
    
    NSArray *_AllARY;          //取出所有数据(json类型，在pilst里面)
    NSMutableArray *_ProvinceAry;          //只装省份的数组
    NSMutableArray *_CityAry;              //只装城市的数组
    NSMutableArray *_DistrictAry;          //只装区的数组（还有县）
    UIPickerView *_pickView;        //最主要的选择器
    
    NSInteger _proIndex;            //用于记录选中哪个省的索引
    NSInteger _cityIndex;           //用于记录选中哪个市的索引
    NSInteger _districtIndex;       //用于记录选中哪个区的索引
}

@property (copy, nonatomic) void (^sele)(NSString *proviceStr,NSString *cityStr,NSString *distr);
@property (copy, nonatomic) void (^selCode)(NSString *proviceCode,NSString *cityCode,NSString *diCode);


@end

@implementation TWSelectCityView




-(instancetype)initWithTWFrame:(CGRect)rect TWselectCityTitle:(NSString *)title{
    if (self = [super initWithFrame:rect]) {
        
        _ProvinceAry = [NSMutableArray array];
        _CityAry = [NSMutableArray array];
        _DistrictAry = [NSMutableArray array];
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        }];
        
        
//        _AllARY = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"]];
        _AllARY = [self redJson];
        
        for (NSDictionary *dci in _AllARY) {
//            [_ProvinceAry addObject:[[dci allKeys] firstObject]];
            [_ProvinceAry addObject:[dci objectForKey:@"name"]];
        }
        
        if (!_ProvinceAry.count) {
            NSLog(@"卧槽，你连数据都没有，你也敢来调用");
        }
        
        //显示pickview和按钮最底下的view
        _BJView = [[UIView alloc] initWithFrame:CGRectMake(0, TWH, TWW, BJH)];
        [self addSubview:_BJView];
        
        UIView *tool = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, TWW, toolH)];
        tool.backgroundColor = TWRGB(237, 236, 234);
        [_BJView addSubview:tool];
        
        /**
         按钮+中间可以显示标题的UILabel
         */
        UIButton *left = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        left.frame = CGRectMake(0, 0, BtnW, toolH);
        [left setTitle:@"取消" forState:UIControlStateNormal];
        [left addTarget:self action:@selector(leftBTN) forControlEvents:UIControlEventTouchUpInside];
        [tool addSubview:left];
        
        UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(left.frame.size.width, 0, TWW-(left.frame.size.width*2), toolH)];
        titleLB.text = title;
        titleLB.textAlignment = NSTextAlignmentCenter;
        [tool addSubview:titleLB];
        
        UIButton *right = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        right.frame = CGRectMake(TWW-BtnW ,0,BtnW, toolH);
        [right setTitle:@"确定" forState:UIControlStateNormal];
        [right addTarget:self action:@selector(rightBTN) forControlEvents:UIControlEventTouchUpInside];
        [tool addSubview:right];


        _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,toolH, TWW, _BJView.frame.size.height-toolH)];
        _pickView.delegate = self;
        _pickView.dataSource = self;
        _pickView.backgroundColor = TWRGB(237, 237, 237);
        [_BJView addSubview:_pickView];
        
        
        //初始化
        NSDictionary *dci = _AllARY[_proIndex];
        NSMutableArray *cityArr = [NSMutableArray array];
        NSMutableArray *disArr = [NSMutableArray array];
        NSArray *tmp = [dci objectForKey:@"cityList"];
        for (NSDictionary *item in tmp) {
            [cityArr addObject:[item objectForKey:@"name"]];
        }
        NSArray *districts = [[[dci objectForKey:@"cityList"] firstObject] objectForKey:@"areaList"];
        for (NSDictionary *distrItem in districts) {
            [disArr addObject:[distrItem objectForKey:@"name"]];
        }
        _CityAry = [NSMutableArray arrayWithArray:cityArr];
        _DistrictAry = [NSMutableArray arrayWithArray:disArr];
        
        
       
    }
    return self;
    
}

//自定义每个pickview的label
-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = [UILabel new];
    pickerLabel.numberOfLines = 0;
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    [pickerLabel setFont:[UIFont boldSystemFontOfSize:18]];
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

/**
 *  下面几个委托方法
 *
 */

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0) {
        _proIndex = row;
        _cityIndex = 0;
        _districtIndex = 0;
        
        NSLog(@"%ld",(long)row);
        NSMutableArray *tmpArr = [NSMutableArray array];
        NSMutableArray *districtArr = [NSMutableArray array];
        for (NSDictionary *cityDci in [_AllARY[_proIndex] valueForKeyPath:@"cityList"]) {
            [tmpArr addObject:[cityDci objectForKey:@"name"]];
        }
//        NSArray *firstCityList = [_AllARY[_proIndex] valueForKeyPath:@"cityList"];
        
        for (NSDictionary *item in [[[_AllARY[_proIndex] valueForKeyPath:@"cityList"] firstObject]  objectForKey:@"areaList"]) {
            [districtArr addObject:item[@"name"]];
        }
        _CityAry = [NSMutableArray arrayWithArray:tmpArr];
        [_pickView reloadComponent:1];
        [_pickView selectRow:0 inComponent:1 animated:YES];
        
        _DistrictAry = [NSMutableArray arrayWithArray:districtArr];
        [_pickView reloadComponent:2];
        [_pickView selectRow:0 inComponent:2 animated:YES];
        
        
    }
    
    if (component == 1) {
        _cityIndex = row;
        _districtIndex = 0;
        NSLog(@"%ld-----%ld", _proIndex, _cityIndex);
        NSMutableArray *districtArr = [NSMutableArray array];
        NSArray *cityListArr = [_AllARY[_proIndex] valueForKeyPath:@"cityList"];
        
        for (NSDictionary *item in [cityListArr[_cityIndex] objectForKey:@"areaList"]) {
            NSLog(@"%@",item[@"name"]);
            [districtArr addObject:item[@"name"]];
        }

        _DistrictAry = [NSMutableArray arrayWithArray:districtArr];
        [_pickView reloadComponent:2];
        [_pickView selectRow:0 inComponent:2 animated:YES];
        
        
    }
    
    if (component == 2) {
        _districtIndex = row;
        
    }
    
    
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return [_ProvinceAry objectAtIndex:row];
    }else if (component == 1){
        return [_CityAry objectAtIndex:row];
    }else if (component == 2){
        return [_DistrictAry objectAtIndex:row];
    }
    
    return nil;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component==0) {
        return _ProvinceAry.count;
    }else if (component == 1){
        return _CityAry.count;
    }else if (component == 2){
        return _DistrictAry.count;
    }
    
    return 0;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

/**
 *  左边的取消按钮
 */
-(void)leftBTN{
    __weak typeof(UIView*)blockview = _BJView;
    __weak typeof(self)blockself = self;
    __block int blockH = TWH;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect bjf = blockview.frame;
        bjf.origin.y = blockH;
        blockview.frame = bjf;
        blockself.alpha = 0.1;
    } completion:^(BOOL finished) {
        [blockself removeFromSuperview];
    }];
    
}

/**
 *  右边的确认按钮
 */
-(void)rightBTN{
    __weak typeof(UIView*)blockview = _BJView;
    __weak typeof(self)blockself = self;
    __block int blockH = TWH;
    
    NSString *provinceCode = [NSString stringWithFormat:@"%ld", (long)_proIndex];
    NSString *cityCode = [NSString stringWithFormat:@"%ld", (long)_cityIndex];
    NSString *districtCode = [NSString stringWithFormat:@"%ld", (long)_districtIndex];
    
    [self getCode];
    
    if (self.sele) {
        self.sele(_ProvinceAry[_proIndex],_CityAry[_cityIndex],_DistrictAry[_districtIndex]);
    }
    if (self.selCode) {
        self.selCode(provinceCode, cityCode, districtCode);
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect bjf = blockview.frame;
        bjf.origin.y = blockH;
        blockview.frame = bjf;
        blockself.alpha = 0.1;
    } completion:^(BOOL finished) {
        [blockself removeFromSuperview];
    }];
}

- (void)getCode
{
    NSString *provinceCode = [_AllARY[_proIndex] valueForKeyPath:@"code"];
    NSArray *tmp = [_AllARY[_proIndex] valueForKeyPath:@"cityList"];
    NSString *cityCode = [tmp[_cityIndex] objectForKey:@"code"];
    NSArray *tmpArea = [tmp[_cityIndex] objectForKey:@"areaList"];
    NSString *distCode = [tmpArea[_districtIndex] objectForKey:@"code"];
    [[NSUserDefaults standardUserDefaults] setObject:provinceCode forKey:@"provinceCode"];
    [[NSUserDefaults standardUserDefaults] setObject:cityCode forKey:@"cityCode"];
    [[NSUserDefaults standardUserDefaults] setObject:distCode forKey:@"distCode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(void)showCityView:(void (^)(NSString *, NSString *, NSString *))selectStr selecCode:(void (^)(NSString *, NSString *, NSString *))selecCode{
    
    self.sele = selectStr;
    self.selCode = selecCode;
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    __weak typeof(UIView*)blockview = _BJView;
    __block int blockH = TWH;
    __block int bjH = BJH;

    [UIView animateWithDuration:0.3 animations:^{
        CGRect bjf = blockview.frame;
        bjf.origin.y = blockH-bjH;
        blockview.frame = bjf;
    }];
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(_BJView.frame, point)) {
        [self leftBTN];
    }

}


- (NSArray *)redJson
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"areaList.json" ofType:nil];
    NSLog(@"%@", path);
    NSArray *array = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableLeaves error:nil];
    return array;
}

@end
