//
//  Macro.h
//  iOS-FoundationKit
//
//  Created by luoty on 2019/1/30.
//  Copyright © 2019年 luoty. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

//获取screen的宽度和高度
#define ML_SCREEN_WIDTH               CGRectGetWidth([[UIScreen mainScreen] bounds])
#define ML_SCREEN_HEIGHT              CGRectGetHeight([[UIScreen mainScreen] bounds])
//正常字体
#define ML_FONT(x)                    [UIFont systemFontOfSize:x]
//加粗字体
#define ML_BOLD_FONT(x)               [UIFont boldSystemFontOfSize:x]

//weakSelf 一般在block里面使用
#define ML_WEAK_SELF(weakSelf)      __weak __typeof(&*self)weakSelf = self;

#define ML_STRING_FORMAT(string)         [NSString stringWithFormat:@"%@",(string==nil||[string isKindOfClass:[NSNull class]])?@"":string]

#define ML_LOG( format, ... )         NSLog( @"<%@:(%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__] )

#endif /* Macro_h */
