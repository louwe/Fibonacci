//
//  FibTableViewController.m
//  Fibonacci
//
//  Created by Edward Louw on 9/25/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "FibTableViewController.h"
#import "BigInt.h"

const static int BATCH_SIZE = 20;

@interface FibTableViewController ()

@property NSMutableArray* fibCache;

@end

@implementation FibTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize the initial fibonacci cache with BATCH_SIZE terms.
    self.fibCache = [NSMutableArray arrayWithCapacity:BATCH_SIZE];
    [self nextBatch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.fibCache.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FibCell" forIndexPath:indexPath];
    
    // Configure the cell...
    BigInt* numToDisplay = self.fibCache[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [numToDisplay stringValue]];
    
    return cell;
}

// Extend the table as needed with new terms.
- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == self.fibCache.count - 1) {
        [self nextBatch];
        [tableView reloadData];
    }
}

// Generate BATCH_SIZE fibonacci terms at a time.
- (void) nextBatch {
    NSUInteger cacheCount = self.fibCache.count;
    for(NSUInteger i = cacheCount; i < cacheCount + BATCH_SIZE; i++) {
        [self fib:i];
    }
}

// This approach is the most scalable.
// It generates the first two seeding terms using the Binet formula and caches them as BigInt objects.
// It then performs the sums of the terms using BigInt's own method.
- (BigInt*) fib:(NSInteger) index {
    BigInt* retVal = nil;
    if(index < 2) {
        retVal = [BigInt bigIntWithNumberArray:@[@([self fibBinet:index])]];
    } else {
        BigInt* num1 = self.fibCache[index - 2];
        BigInt* num2 = self.fibCache[index - 1];
        retVal = [BigInt bigIntByAddingBigInt:num1 toBigInt:num2];
    }

    if(retVal) {
        self.fibCache[index] = retVal;
    }

    return retVal;
}

// This approach utilizes the Binet formula to calculate the n-th term.
// The result of the following equation is rounded down to get the integer result.
//                     n
//       /       ___  \
//      |  1 + \/ 5   |
//      |  ---------  |
//       \      2     /      1
// Fn = ----------------  + ---
//            ___            2
//          \/ 5
// Unsigned long long seems to only be able to hold valid results for up to 20 significant figures.
// This limit is encountered on the 94-th term.
- (unsigned long long) fibBinet:(NSInteger) index {
    return floor(pow((1 + sqrt(5)) / 2, index) / sqrt(5) + 0.5);
}

// Recursive method is incredibly CPU and memory intensive.
- (NSDecimalNumber*) fibRecursive:(NSInteger) index {
    NSDecimalNumber* retVal = [NSDecimalNumber decimalNumberWithString:@"0"];

    // Set our first two stop conditions as 0 and 1.
    // Any successive terms beyond 0 and 1 are simply recursive sums of the previous two terms.
    if(index == 0) {
        retVal = [NSDecimalNumber decimalNumberWithString:@"0"];
    } else if(index == 1) {
        retVal = [NSDecimalNumber decimalNumberWithString:@"1"];
    } else {
        retVal = [[self fibRecursive:index - 2] decimalNumberByAdding:[self fibRecursive:index - 1]];
    }

    return retVal;
}


@end
