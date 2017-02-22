//
//  PASFindController.m
//  PlayAppStore
//
//  Created by Winn on 2017/2/18.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "PASDiscoverController.h"
#import "Masonry.h"
#import "PASApplicationDetailController.h"


@interface PASDiscoverController ()

@property (nonatomic , strong) UIButton *detailButton;

@end

@implementation PASDiscoverController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configEntranceOfDetailPage];
    
}

- (void)detailButtonClicked:(UIButton *)sender {
    PASApplicationDetailController *detail  = [[PASApplicationDetailController alloc] init];
    [self.navigationController pushViewController:detail animated:YES];
    
}
- (void)configEntranceOfDetailPage {
    [self.view addSubview:self.detailButton];
    [self.detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view.mas_leading).offset(15);
        make.trailing.mas_equalTo(self.view.mas_trailing).offset(-15);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-100);
        make.height.equalTo(@44);
    }];
    
//    self.detailButton.frame = CGRectMake(150, 200, 80, 80);
    

}


- (UIButton *)detailButton {
    if (!_detailButton) {
        _detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _detailButton.backgroundColor = [UIColor orangeColor];
        [_detailButton setTitle:@"Application Detail" forState:UIControlStateNormal];
        [_detailButton addTarget:self action:@selector(detailButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _detailButton;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
