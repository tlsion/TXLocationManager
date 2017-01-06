//
//  ViewController.m
//  TXLocationManagerDemo
//
//  Created by Eton on 2017/1/6.
//  Copyright © 2017年 Tlsion. All rights reserved.
//

#import "ViewController.h"
#import "TXLocationManager.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    self.title = @"位置信息";
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    __weak __typeof(self) weakSelf = self;
    [[TXLocationManager shareLocation] locatePlacemark:^(TXPlacemark *placmark) {
        [weakSelf.tableView reloadData];
    } error:^(NSError *error) {
        NSLog(@"---获取位置信息错误---");
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 9;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"AddressTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    TXPlacemark *placmark = [TXLocationManager shareLocation].placmark;
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"坐标：";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%f,%f",placmark.coordinate.latitude,placmark.coordinate.longitude];
            break;
        case 1:
            cell.textLabel.text = @"国家：";
            cell.detailTextLabel.text = placmark.country;
            break;
        case 2:
            cell.textLabel.text = @"省份：";
            cell.detailTextLabel.text = placmark.province;
            break;
        case 3:
            cell.textLabel.text = @"城市：";
            cell.detailTextLabel.text = placmark.city;
            break;
        case 4:
            cell.textLabel.text = @"地区：";
            cell.detailTextLabel.text = placmark.district;
            break;
        case 5:
            cell.textLabel.text = @"街道：";
            cell.detailTextLabel.text = placmark.street;
            break;
        case 6:
            cell.textLabel.text = @"街道级别信息：";
            cell.detailTextLabel.text = placmark.subStreet;
            break;
        case 7:
            cell.textLabel.text = @"详情地址：";
            cell.detailTextLabel.text = placmark.addressDescription;
            break;
        case 8:
            cell.textLabel.text = @"邮编：";
            cell.detailTextLabel.text = placmark.postalCode;
            break;
            
        default:
            break;
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
