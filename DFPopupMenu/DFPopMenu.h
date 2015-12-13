//
//  DFPopMenu.h
//  DFPopupMenu
//
//  Created by Davon_Feng on 15/12/13.
//  Copyright © 2015年 Davon_Feng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

typedef void(^DFPopMenuDidSelectedBlock)(NSInteger index, NSString *itemNameStr);

@interface DFPopMenuView : UIView
@property(nonatomic, copy) DFPopMenuDidSelectedBlock popMenuDidSelectedBlock;

- (void)showDFMenuWithTargetFrame:(CGRect)targetFrame WithItemNameArray:(NSArray *)itemNameArray withSelectedBlock:(DFPopMenuDidSelectedBlock)block;

- (void)dismissDFMenu:(BOOL)animated;
@end

@interface DFPopMenu : NSObject
+ (instancetype)shareDFPopMenu;

- (void)showDFMenuWithTargetFrame:(CGRect)targetFrame WithItemNameArray:(NSArray *)itemNameArray withSelectedBlock:(DFPopMenuDidSelectedBlock)block;

- (void)dismissDFMenu:(BOOL)animated;
@end


@interface DFPopMenuTableCell : UITableViewCell
@property(nonatomic, strong) UILabel *dFTextLabel;
@end