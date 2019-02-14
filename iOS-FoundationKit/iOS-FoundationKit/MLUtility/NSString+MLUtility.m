//
//  NSString+MLUtility.m
//  iOS-FoundationKit
//
//  Created by luoty on 2019/2/14.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import "NSString+MLUtility.h"

@implementation NSString (MLUtility)

- (BOOL)isNumber
{
    NSString *numberRegex = @"[0-9]+";
    NSPredicate *regexNumber = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    return [regexNumber evaluateWithObject:self];
}

- (BOOL)isValidEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isValidIdentity
{
    NSString *identityRegex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",identityRegex];
    return [identityCardPredicate evaluateWithObject:self];
}

- (BOOL) isValidBankCardNumber
{
    NSString* const BANKCARD = @"^(\\d{16}|\\d{19})$";
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", BANKCARD];
    return [predicate evaluateWithObject:self];
}

- (CGSize)MLSizeFormat:(UIFont *)font maxWith:(CGFloat)width
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return size;
}


@end
