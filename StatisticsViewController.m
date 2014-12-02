//
//  StatisticsViewController.m
//  Method To Madness
//
//  Created by Brian Tracy on 9/13/14.
//  Copyright (c) 2014 Brian Tracy. All rights reserved.
//

#import "StatisticsViewController.h"

@interface StatisticsViewController ()
@property (nonatomic) NSArray * scores;
@end

@implementation StatisticsViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor orangeColor];
        
        
        NSURL * url = [NSURL URLWithString:@"http://briantracy.silicode.us/m2mhighscore.php?auth=!!$&action=get"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        self.scores = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        
        for (id x in self.scores) {
            NSLog(@"%@", x);
        }
        NSLog(@"%@", self.scores);
        
        
        UITableView * tb = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        tb.delegate = self;
        tb.dataSource = self;
        
        [self.view addSubview:tb];
        
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.scores.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.scores[indexPath.row][@"score"]];
    
    return cell;
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}
@end
