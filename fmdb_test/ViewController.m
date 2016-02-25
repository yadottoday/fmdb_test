//
//  ViewController.m
//  fmdb_test
//
//  Created by 王庆华 on 16/2/22.
//  Copyright © 2016年 王庆华. All rights reserved.
//

#import "ViewController.h"
#import "User.h"
#import "DataBaseManage.h"
#import "AppDelegate.h"


@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray *user;
@property (nonatomic, weak) UIView *topView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *ageLabel;
@property (nonatomic, weak) UITextField *nameTF;
@property (nonatomic, weak) UITextField *ageTF;
@property (nonatomic, weak) UIButton *clickBtn;
@property (nonatomic, strong) NSArray *datasource;

@end

@implementation ViewController

-(NSArray *)datasource {
    
    if (!_datasource) {
        _datasource = [NSArray array];
        
    }
    return _datasource;
}

- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.frame = CGRectMake(20, 50, 50, 30);
        nameLabel.text = @"姓名";
        [self.topView addSubview:nameLabel];
        _nameLabel = nameLabel;
        
    }
    return _nameLabel;
}

- (UILabel *)ageLabel {
    
    if (!_ageLabel) {
        UILabel *ageLabel = [[UILabel alloc] init];
        ageLabel.frame = CGRectMake(20, 100, 50, 30);
        ageLabel.text = @"年龄";
        [self.topView addSubview:ageLabel];
        _ageLabel = ageLabel;
        
    }
    return _ageLabel;
}

-(UITextField *)nameTF {
    
    if (!_nameTF) {
        
        UITextField *nameTF = [[UITextField alloc] init];
        nameTF.frame = CGRectMake(70, 50, 150, 30);
        [self.topView addSubview:nameTF];
        nameTF.placeholder = @"请输入您的名字";
        _nameTF = nameTF;
        
    }
    return _nameTF;
}

- (UITextField *)ageTF {
    
    if (!_ageTF) {
        
        UITextField *ageTF = [[UITextField alloc] init];
        ageTF.frame = CGRectMake(70, 100, 150, 30);
        [self.topView addSubview:ageTF];
        ageTF.placeholder = @"请输入您的年龄";
        _ageTF = ageTF;
        
    }
    return _ageTF;
}

- (UIButton *)clickBtn {
    
    if (!_clickBtn) {
        
        UIButton *clickBtn = [[UIButton alloc] init];
        clickBtn.frame = CGRectMake(20, 150, [UIScreen mainScreen].bounds.size.width - 40, 30);
        [clickBtn setTitle:@"确定" forState:UIControlStateNormal];
       
        [clickBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        clickBtn.backgroundColor = [UIColor redColor];
        [self.topView addSubview:clickBtn];
        
        _clickBtn = clickBtn;
    }
    return _clickBtn;
}

- (UIView *)topView {
    
    if (!_topView) {
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200);
        [self.view addSubview:view];
        view.backgroundColor = [UIColor cyanColor];
        
        _topView = view;
    }
    return _topView;
}

-(UITableView *)tableView {
    
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] init];
        tableView.frame = CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 200);
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        _tableView = tableView;
        
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /**
     *  获取AppDelegate对象
     */
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    NSLog(@"%@", delegate.window);
    
    NSLog(@"%@",[DataBaseManage test]);
    
//    [self insertData];
    
    [self queryAllData];
    
    
    [[DataBaseManage dataBaseManager] delectUserObjectFromDatabaseWithName:@"name1"];
    
    
    [self setupView];
}

- (void)setupView {
    
    [self tableView];
    [self topView];
    [self nameTF];
    [self ageTF];
    [self nameLabel];
    [self ageLabel];
    [self clickBtn];
    [self datasource];
}

- (void)queryAllData {
    
    NSArray *array = [[DataBaseManage dataBaseManager] queryAllUserObjectsFromDatabase];
    
    _datasource = array;
    for (User * user in array) {
        
        NSLog(@"%@-%d",user.name,user.age);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
 

}

- (void)insertData {
    
    for (int i = 0; i < 20; i ++) {
        User *user = [[User alloc] init];
        user.name = [NSString stringWithFormat:@"name%d",i + 1];
        
        user.age = i + 30;
        
        BOOL isOK = [[DataBaseManage dataBaseManager] insertIntoTableWithObject:user];
        
        NSLog(@"%@",isOK?@"成功":@"失败");
    }
}


#pragma mark 
- (void)btnClick {
    
    User *user = [[User alloc] init];
    user.name = _nameTF.text;
    user.age = [_ageTF.text intValue];
    
 BOOL isOK = [[DataBaseManage dataBaseManager] insertIntoTableWithObject:user];
    
    if (isOK) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"插入数据" message:@"插入成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alert show];
     
        _datasource = nil;
        _datasource = [[DataBaseManage dataBaseManager] queryAllUserObjectsFromDatabase];
        
        [self.tableView reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellName = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    
    User *user = _datasource[indexPath.row];
    cell.textLabel.text = user.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"--%d--",user.age];

    return cell;
}


@end
