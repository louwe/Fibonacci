//
//  BigInt.m
//  Fibonacci
//
//  Created by Edward Louw on 9/25/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "BigInt.h"

// Represent an integer that can grow to arbitrary number of digits.
// Objects of this class are immutable for simplicity and data integrity.
@interface BigInt ()

@property (strong, nonatomic) NSArray* number;

@end

@implementation BigInt

// Creates a BigInt object using the specified number array.
+ (BigInt*) bigIntWithNumberArray:(NSArray *)numArray {
    BigInt* retVal = [BigInt new];

    retVal.number = numArray;

    return retVal;
}

// Adds two BigInt objects together and returns a new BigInt.
+ (BigInt*) bigIntByAddingBigInt:(BigInt*) operand1 toBigInt:(BigInt*) operand2 {
    // First, find out the size of each operands.
    // Pick the larger of the two.
    // Create the result array with the capacity of the larger count + 1 for carry.
    NSUInteger operand1Count = operand1.number.count;
    NSUInteger operand2Count = operand2.number.count;
    NSUInteger totalCount = operand1Count > operand2Count ? operand1Count : operand2Count;
    NSMutableArray* retVal = [NSMutableArray arrayWithCapacity:totalCount + 1];

    // Initialize carry to nothing.
    NSUInteger carry = 0;
    for(int i = 0; i < totalCount; i++) {
        // Extract the two operand digits at the current position.
        // If the digit does not exist, default to 0.
        // Add the two digits and carry from last iteration together.
        NSNumber* num1 = i < operand1.number.count ? operand1.number[i] : @0;
        NSNumber* num2 = i < operand2.number.count ? operand2.number[i] : @0;
        NSUInteger sum = num1.unsignedIntegerValue + num2.unsignedIntegerValue + carry;

        // If the sum is less than 10, we do not have to worry about carry.
        // Else, assign the least significant digit to the current sum and set the carry for next iteration.
        if(sum <= 9) {
            carry = 0;
            retVal[i] = [NSNumber numberWithUnsignedInteger:sum];
        } else {
            carry = 1;
            retVal[i] = [NSNumber numberWithUnsignedInteger:sum % 10];
        }
    }

    // If a carry exists at the end of the sum, we have an extra digit to add.
    if(carry > 0) {
        [retVal addObject:@(carry)];
    }

    return [BigInt bigIntWithNumberArray:retVal];
}

// Return a string representation of this BigInt object.
- (NSString*) stringValue {
    NSMutableString* retVal = [NSMutableString new];

    // Build the string starting from the most significant digit to the least significant digit (left to right).
    // Because the number store index 0 represents the least significant digit, iterate using a reversed enumerator.
    for (NSNumber* num in [self.number reverseObjectEnumerator]) {
        [retVal appendFormat:@"%@", num];
    }

    return retVal;
}

@end
