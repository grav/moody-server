//
// Created by Mikkel Gravgaard on 09/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "MOOMenuViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "MOOMoodInputViewController.h"
#import "MOOVizViewController.h"

@implementation MOOMenuViewController {

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"funk"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"funk"];
        cell.textLabel.text = indexPath.row==0?@"Set your mood" : @"Visualize mood";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row==0){
        self.mm_drawerController.centerViewController = [MOOMoodInputViewController new];
    } else {
        self.mm_drawerController.centerViewController = [MOOVizViewController new];
    }
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
}


@end