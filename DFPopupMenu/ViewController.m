//
//  ViewController.m
//  DFPopupMenu
//
//  Created by Davon_Feng on 15/12/13.
//  Copyright © 2015年 Davon_Feng. All rights reserved.
//

#import "ViewController.h"
#import "DFPopMenu.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)button1Action:(id)sender {
    UIButton *button = (UIButton *)sender;
    DFPopMenu *popMenu = [[DFPopMenu alloc] init];
    [popMenu showDFMenuWithTargetFrame:button.frame WithItemNameArray:@[@"请你吃糖",@"哈哈哈哈",@"哈哈哈哈"] withSelectedBlock:^(NSInteger index,NSString *name){
        NSLog(@"index:%d,name:%@",index,name);
    }];
}

- (IBAction)button2Action:(id)sender {
    UIButton *button = (UIButton *)sender;

    [[DFPopMenu shareDFPopMenu] showDFMenuWithTargetFrame:button.frame WithItemNameArray:@[@"哈哈哈哈",@"哈哈哈哈"] withSelectedBlock:^(NSInteger index,NSString *name){
        NSLog(@"index:%d,name:%@",index,name);
    }];
}
- (IBAction)button3Action:(id)sender {
    UIButton *button = (UIButton *)sender;
    DFPopMenu *popMenu = [[DFPopMenu alloc] init];
    [popMenu showDFMenuWithTargetFrame:button.frame WithItemNameArray:@[@"哈哈哈哈",@"请你吃糖",@"哈哈哈哈",@"哈哈哈哈"] withSelectedBlock:^(NSInteger index,NSString *name){
        NSLog(@"index:%d,name:%@",index,name);
    }];
}
- (IBAction)button4Action:(id)sender {
    UIButton *button = (UIButton *)sender;
    DFPopMenu *popMenu = [[DFPopMenu alloc] init];
    [popMenu showDFMenuWithTargetFrame:button.frame WithItemNameArray:@[@"哈哈哈哈",] withSelectedBlock:^(NSInteger index,NSString *name){
        NSLog(@"index:%d,name:%@",index,name);
    }];
}
- (IBAction)button5Action:(id)sender {
    UIButton *button = (UIButton *)sender;
    DFPopMenu *popMenu = [[DFPopMenu alloc] init];
    [popMenu showDFMenuWithTargetFrame:button.frame WithItemNameArray:@[@"哈哈哈哈",@"哈哈哈哈",@"请你吃糖",@"哈哈哈哈",@"哈哈哈哈"] withSelectedBlock:^(NSInteger index,NSString *name){
        NSLog(@"index:%d,name:%@",index,name);
    }];
}

@end
