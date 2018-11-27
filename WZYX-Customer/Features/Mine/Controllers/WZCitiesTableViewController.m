//
//  WZCitiesTableViewController.m
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2018/11/25.
//  Copyright © 2018年 WZYX. All rights reserved.
//

#import "WZCitiesTableViewController.h"
#import "WZCityInfo.h"

@interface WZCitiesTableViewController ()

@property (strong, nonatomic) NSArray *cityinfo;
@property (strong, nonatomic) NSArray *sectionList;

@end

@implementation WZCitiesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", self.cityinfo[0]);
    self.tableView.allowsMultipleSelection = NO;
    [self setObjects:self.cityinfo];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.cityinfo count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    WZCityInfo *province = (WZCityInfo *)self.cityinfo[section];
    return [province.cities count];
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *section = [NSString stringWithFormat:@"%ld",(long)indexPath.section ];
    NSString *identifier = [section stringByAppendingString:@"citycell"];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    WZCityInfo *province = self.cityinfo[indexPath.section];
    cell.textLabel.text =province.cities[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDataSource

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *oldIndex = [self.tableView indexPathForSelectedRow];
    [tableView cellForRowAtIndexPath:oldIndex].accessoryType = UITableViewCellAccessoryNone;
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark; 
    return indexPath;
}

- (NSArray *)cityinfo {
    if (!_cityinfo) {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"cities.plist" ofType:nil];
        NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
        NSMutableArray *cityInfoArray = [NSMutableArray arrayWithCapacity:[array count]];
        for(NSDictionary *dict in array) {
            WZCityInfo *province = [[WZCityInfo alloc] initWithDictionary:dict];
            [cityInfoArray addObject:province];
        }
//        [dictArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//            NSLocale *locale=[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
//            NSRange string1Range = NSMakeRange(0, [((NSDictionary *)obj1)[@"name"] length]);
//            NSString *first = ((NSDictionary *)obj1)[@"name"];
//            NSString *second = ((NSDictionary *)obj2)[@"name"];
//            return [first compare:second options:0 range:string1Range locale:locale];
//        }];
        _cityinfo = [cityInfoArray copy];
    }
    return _cityinfo;
}

- (void)setObjects:(NSArray *)objects {
    SEL selector = @selector(province);
    NSInteger sectionTitlesCount = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] count];
    
    NSMutableArray *mutableSections = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    for (NSUInteger idx = 0; idx < sectionTitlesCount; idx++) {
        [mutableSections addObject:[NSMutableArray array]];
    }
    
    for (id object in objects) {
        NSInteger sectionNumber = [[UILocalizedIndexedCollation currentCollation] sectionForObject:object collationStringSelector:selector];
        [[mutableSections objectAtIndex:sectionNumber] addObject:object];
    }
    
    for (NSUInteger idx = 0; idx < sectionTitlesCount; idx++) {
        NSArray *objectsForSection = [mutableSections objectAtIndex:idx];
        [mutableSections replaceObjectAtIndex:idx withObject:[[UILocalizedIndexedCollation currentCollation] sortedArrayFromArray:objectsForSection collationStringSelector:selector]];
    }
    //self.cityinfo = mutableSections;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
//}
//
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
//}
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
//}

@end
