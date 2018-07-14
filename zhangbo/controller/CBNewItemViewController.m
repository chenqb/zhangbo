//
//  CBNewItemViewController.m
//  zhangbo
//
//  Created by 陈权斌 on 2018/6/30.
//  Copyright © 2018年 陈权斌. All rights reserved.
//

#import "CBNewItemViewController.h"
#import "UIColor+ColorChange.h"
#import "CBConst.h"
#import "Masonry.h"
#import <PGDatePickManager.h>
#import "CBContactSelectViewController.h"
#import "DBManager.h"
#import "CBTextField.h"
#import <MBProgressHUD.h>
#import "Util.h"

@interface CBNewItemViewController () <PGDatePickerDelegate, UITextViewDelegate>

@property (nonatomic, weak) CBTextField *amountTextField;
@property (nonatomic, weak) UITextView *descTextView;
@property (nonatomic,weak) UIButton *channelBtn;
@property (nonatomic,weak) UIButton *dateSelectBtn;
@property int channelValue;
@property (nonatomic,weak) UIButton *inputNameBtn;
@property (nonatomic,weak) UILabel *placeHolderLabel;
@property (nonatomic, weak) UISegmentedControl *segment;
@property (nonatomic) NSDate *date;

@end

@implementation CBNewItemViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.date = [NSDate date];
    self.channelValue = 1; //默认为1
    UIView *superView = self.view;
    [superView setBackgroundColor:[UIColor colorWithHexString:kGrayColor]];
//    [newItemVC.view setFrame:CGRectMake(100, 100, 100, 100)];
    
    UIButton *dateSelectBtn = [[UIButton alloc] init];
    [superView addSubview:dateSelectBtn];
    [dateSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(260);
        make.centerX.equalTo(superView.mas_centerX);
    }];
    self.dateSelectBtn = dateSelectBtn;
    [dateSelectBtn setTitleColor:[UIColor colorWithHexString:kThemeColor] forState:UIControlStateNormal];
    [dateSelectBtn setTitle:[Util getDateStringFromDate:self.date] forState:UIControlStateNormal];
//    UIImage *imgArrow = [UIImage imageNamed:@"arrow_down"];
//    [dateSelectBtn setImage:imgArrow forState:UIControlStateNormal];
    [dateSelectBtn addTarget:self action:@selector(dateSelectBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    [dateSelectBtn setImageEdgeInsets:UIEdgeInsetsMake(0, dateSelectBtn.titleLabel.bounds.size.width, 0, -dateSelectBtn.titleLabel.bounds.size.width)];
//    [dateSelectBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -dateSelectBtn.currentImage.size.width, 0, dateSelectBtn.currentImage.size.width)];
    
    
    //取消按钮
    UIButton *dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissBtn setTitle:@"取消" forState:UIControlStateNormal];
    [dismissBtn setTitleColor:[UIColor colorWithHexString:@"888888"] forState:UIControlStateNormal];
    [dismissBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [dismissBtn addTarget:self action:@selector(dismissBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [superView addSubview:dismissBtn];
    [dismissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(dateSelectBtn);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(40);
        make.right.equalTo(superView).with.offset(-8);
    }];

    
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"借出",@"借入"] ];
    [segment setSelectedSegmentIndex:0];
    self.segment = segment;
    [segment setTintColor:[UIColor colorWithHexString:kThemeColor]];
    [superView addSubview:segment];
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dateSelectBtn.mas_bottom).with.offset(10);
        make.left.mas_equalTo(80);
        make.right.mas_equalTo(-80);
        make.height.mas_equalTo(32);
    }];
    
    UIView *contactContainerView  = [[UIView alloc] init];
    contactContainerView.backgroundColor = [UIColor whiteColor];
    [superView addSubview:contactContainerView];
    [contactContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(segment.mas_bottom).with.offset(60);
        make.height.mas_equalTo(46);
    }];
    UILabel *contactLabel = [[UILabel alloc] init];
    [contactLabel setText:@"对方账户"];
    [contactLabel setTextAlignment:NSTextAlignmentRight];
    [contactContainerView addSubview:contactLabel];
    [contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(80);
        make.top.equalTo(contactContainerView.mas_top).with.offset(5);
        make.bottom.equalTo(contactContainerView.mas_bottom).with.offset(-5);
    }];
    
    UIButton *inputNameBtn = [[UIButton alloc]init];
    [inputNameBtn setTitle:@"请选择联系人" forState:UIControlStateNormal];
    [inputNameBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    inputNameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [inputNameBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [inputNameBtn addTarget:self action:@selector(contactSelectBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.inputNameBtn = inputNameBtn;
    [contactContainerView addSubview:inputNameBtn];
    [inputNameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contactLabel.mas_right).with.offset(30);
        make.width.mas_equalTo(200);
        make.top.equalTo(contactLabel);
        make.bottom.equalTo(contactLabel);
    }];
    
    UIButton *selectContactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectContactBtn setImage:[UIImage imageNamed:@"address"] forState:UIControlStateNormal];
    [selectContactBtn addTarget:self action:@selector(contactSelectBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [contactContainerView addSubview:selectContactBtn];
    [selectContactBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
        make.centerY.equalTo(inputNameBtn);
    }];
    
    UIView *amountContainerView = [[UIView alloc] init];
    amountContainerView.backgroundColor = [UIColor whiteColor];
    [superView addSubview:amountContainerView];
    [amountContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(contactContainerView.mas_bottom).with.offset(15);
        make.height.mas_equalTo(46);
    }];
    
    UILabel *amountLabel = [[UILabel alloc]init];
    [amountLabel setText:@"金额(元)"];
    [amountLabel setTextAlignment:NSTextAlignmentRight];
    [amountContainerView addSubview:amountLabel];
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contactLabel);
        make.width.equalTo(contactLabel);
        make.top.equalTo(amountContainerView.mas_top).with.offset(5);
        make.bottom.equalTo(amountContainerView.mas_bottom).with.offset(-5);
    }];
    
    
    CBTextField *amonutTextField = [[CBTextField alloc] init];
    self.amountTextField = amonutTextField;
    [amonutTextField setPlaceholder:@"请输入金额"];
    [amonutTextField setKeyboardType:UIKeyboardTypeNumberPad];
    amonutTextField.inputAccessoryView = [self addToolbar];
    amonutTextField.delegate = self;
    [amountContainerView addSubview:amonutTextField];
    [amonutTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(amountLabel.mas_right).with.offset(30);
        make.right.equalTo(amountContainerView);
        make.top.equalTo(amountContainerView.mas_top).with.offset(5);
        make.bottom.equalTo(amountContainerView.mas_bottom).with.offset(-5);
    }];
    
     
    
    UIView *channelContainerView = [[UIView alloc] init];
    channelContainerView.backgroundColor = [UIColor whiteColor];
    [superView addSubview:channelContainerView];
    [channelContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(amountContainerView.mas_bottom).with.offset(15);
        make.height.mas_equalTo(46);
    }];
    
    UILabel *channelLabel = [[UILabel alloc]init];
    [channelLabel setText:@"交易方式"];
    [channelLabel setTextAlignment:NSTextAlignmentRight];
    [channelContainerView addSubview:channelLabel];
    [channelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contactLabel);
        make.width.equalTo(contactLabel);
        make.top.equalTo(channelContainerView.mas_top).with.offset(5);
        make.bottom.equalTo(channelContainerView.mas_bottom).with.offset(-5);
    }];
    
    UIButton *channelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.channelBtn = channelBtn;
    [channelBtn setTitle:@"支付宝" forState:UIControlStateNormal];
    [channelBtn setTitleColor:[UIColor colorWithHexString:kThemeColor] forState:UIControlStateNormal];
    [channelBtn setImage:[UIImage imageNamed: @"alipay"] forState:UIControlStateNormal];
    [channelBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [channelBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [channelContainerView addSubview:channelBtn];
    [channelBtn addTarget:self action:@selector(channelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [channelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(channelLabel.mas_right).with.offset(30);
        make.width.mas_equalTo(200);
        make.centerY.equalTo(channelLabel);
        make.height.mas_equalTo(30);
    }];
    
    
    UITextView *descTextView= [[UITextView alloc] init];
    descTextView.delegate = self;
    self.descTextView = descTextView;
    descTextView.contentInset = UIEdgeInsetsMake(10, 20, 10, 20);
    descTextView.font = [UIFont systemFontOfSize:16];
    descTextView.backgroundColor = [UIColor whiteColor];
    descTextView.returnKeyType = UIReturnKeyDone;
    [superView addSubview:descTextView];
    [descTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(channelContainerView.mas_bottom).with.offset(15);
        make.height.mas_equalTo(100);
    }];
    
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    self.placeHolderLabel = placeHolderLabel;
    [descTextView addSubview:placeHolderLabel];
    [placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(0);
        make.top.equalTo(descTextView.mas_top).with.offset(5);
        make.height.mas_equalTo(20);
    }];
    placeHolderLabel.textAlignment = NSTextAlignmentLeft;
    placeHolderLabel.font = [UIFont systemFontOfSize:16];
    placeHolderLabel.text = @"请输入备注信息，选填";
    [placeHolderLabel setTextColor:[UIColor lightGrayColor]];
   
    
    UIButton *createBtn = [[UIButton alloc] init];
    [createBtn setBackgroundColor:[UIColor colorWithHexString:kThemeColor]];
    createBtn.layer.cornerRadius = 8;
    [createBtn setTitle:@"确  定" forState:UIControlStateNormal];
    [createBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [createBtn addTarget:self action:@selector(createBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    [createBtn setTitleEdgeInsets:UIEdgeInsetsMake(10,10, 10, 10)];
    [createBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [superView addSubview:createBtn];
    
    [createBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
//        make.centerX.equalTo(newItemVC.view);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(@([UIScreen mainScreen].bounds.size.height)).offset(-70);
    }];
    
}

-(void)dateSelectBtnClicked {
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.textColorOfSelectedRow = [UIColor colorWithHexString:kThemeColor];
    datePicker.lineBackgroundColor = [UIColor colorWithHexString:kThemeColor];
    datePickManager.confirmButtonTextColor = [UIColor colorWithHexString:kThemeColor];
    datePickManager.isShadeBackgroud = YES;
	[datePicker setDate:self.date];
    datePicker.datePickerMode = PGDatePickerModeDate;
    datePicker.delegate = self;
    [self presentViewController:datePickManager animated:false completion:nil];
}

- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSLog(@"dateComponents = %@", dateComponents);
    NSCalendar * calendar = [NSCalendar currentCalendar];
    self.date = [calendar dateFromComponents:dateComponents];
    [self.dateSelectBtn setTitle:[Util getDateStringFromDate:self.date] forState:UIControlStateNormal];
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textFieldShouldReturn");
    [textField resignFirstResponder];
    NSLog(@"输入完成");
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textFieldDidEndEditing");
    
    // todo
    NSLog(@"%@", textField.text);
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldEndEditing");
    return YES;
}


- (UIToolbar *) addToolbar{
    UIToolbar * toolbar = [[UIToolbar alloc] init];
    [toolbar setFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    toolbar.tintColor = [UIColor colorWithHexString:kThemeColor];
    toolbar.backgroundColor = [UIColor grayColor];
    UIBarButtonItem *spaceBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(amountInputDone)];
    toolbar.items = @[spaceBtn, doneBtn];
    return toolbar;
}

-(void)createBtnClicked{
    NSString *name = self.inputNameBtn.titleLabel.text;
    NSString *desc = self.descTextView.text;
	int channel = self.channelValue;
    int amount = [self.amountTextField.text intValue];
    if ([name isEqualToString:@"请选择联系人"] || amount == 0){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请将信息补充完整！";
        hud.label.textColor  = [UIColor whiteColor];
        hud.opaque = 0.75;
        hud.color = [UIColor blackColor];
        [hud hideAnimated:YES afterDelay:1.0];
        return;
    }
    if (self.segment.selectedSegmentIndex == 1 ){
        amount = -1 * amount ;
    }
    [[DBManager sharedInstance] insertRecordWithName:name andDate:self.date andAmount:amount andChannel:channel andDesc:desc];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kRecordChangedAddNotification" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)amountInputDone{
    NSLog(@"完成按钮点击");
    [self.amountTextField resignFirstResponder];
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0 ){
        _placeHolderLabel.text = @"请输入备注信息，选填";
    }else{
        _placeHolderLabel.text = @"";
//        _placeHolderLabel.hidden = YES;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self.descTextView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}
//点击渠道选择按钮弹出
- (void) channelBtnClicked:(id)sender{
    
    UIAlertController *channelSelectVC = [UIAlertController alertControllerWithTitle:@"交易方式" message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *ac1 = [UIAlertAction actionWithTitle:@"支付宝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.channelValue = 1;
        NSLog(@"alipay select");
        [self.channelBtn setTitle:@"支付宝" forState:UIControlStateNormal];
        [self.channelBtn setImage:[UIImage imageNamed:@"alipay"] forState:UIControlStateNormal];
        
    }];
    
    UIAlertAction *ac2 = [UIAlertAction actionWithTitle:@"微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"wechat select");
        self.channelValue = 2;
        [self.channelBtn setTitle:@"微信" forState:UIControlStateNormal];
        [self.channelBtn setImage:[UIImage imageNamed:@"wechat"] forState:UIControlStateNormal];
        
    }];
    
    UIAlertAction *ac3 = [UIAlertAction actionWithTitle:@"银行卡" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"bankcard select");
        self.channelValue = 3;
        [self.channelBtn setTitle:@"银行卡" forState:UIControlStateNormal];
        [self.channelBtn setImage:[UIImage imageNamed:@"bankcard"] forState:UIControlStateNormal];
        
        
    }];
    
    UIAlertAction *ac4 = [UIAlertAction actionWithTitle:@"现金" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"cash select");
        self.channelValue = 4;
        [self.channelBtn setTitle:@"现金" forState:UIControlStateNormal];
        [self.channelBtn setImage:[UIImage imageNamed:@"cash"] forState:UIControlStateNormal];
        
    }];
    
    UIAlertAction *ac5 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"cancel");
    }];
    
    [channelSelectVC addAction:ac1];
    [channelSelectVC addAction:ac2];
    [channelSelectVC addAction:ac3];
    [channelSelectVC addAction:ac4];
    [channelSelectVC addAction:ac5];
    
    [self presentViewController:channelSelectVC animated:YES completion:^{
        
    }];

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


- (void)contactSelectBtnClicked{
    CBContactSelectViewController *contactSelectVC = [[CBContactSelectViewController alloc] init];
    contactSelectVC.contactSelectDelegate = self;
    [self presentViewController:contactSelectVC animated:YES completion:nil];
    
}

- (void)dismissBtnClicked {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)passValue:(NSString *)name{
    [self.inputNameBtn setTitleColor: [UIColor colorWithHexString:kThemeColor] forState:UIControlStateNormal];
    [self.inputNameBtn setTitle:name forState:UIControlStateNormal];
}
@end
