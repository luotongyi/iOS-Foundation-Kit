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

+ (NSString *)hexStringFromData:(NSData *)data
{
    if (!data) {
        return nil;
    }
    Byte *bytes = (Byte *)[data bytes];
    NSMutableString *hexStr = [NSMutableString stringWithCapacity:data.length*2];
    for (int i=0;i<[data length];i++) {
        [hexStr appendFormat:@"%02X",bytes[i]];
    }
    return [hexStr lowercaseString];
}

+ (NSString *)hexStringFromString:(NSString *)plainText
{
    NSData *myD = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSString *hexStr = [self hexStringFromData:myD];
    return hexStr;
}

+ (NSData *)dataFromHexString:(NSString *)hexString
{
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i/2] = (char)anInt;
    }
    NSData *data = [NSData dataWithBytes:myBuffer length:hexString.length/2];
    return data;
}

@end
