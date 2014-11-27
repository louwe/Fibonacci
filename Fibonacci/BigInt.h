//
//  BigInt.h
//  Fibonacci
//
//  Created by Edward Louw on 9/25/14.
//  Copyright (c) 2014 Edward Louw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BigInt : NSObject

@property (strong, nonatomic, readonly) NSArray* number;

+ (BigInt*) bigIntWithNumberArray:(NSArray*) numArray;
+ (BigInt*) bigIntByAddingBigInt:(BigInt*) operand1 toBigInt:(BigInt*) operand2;

- (NSString*) stringValue;

@end
