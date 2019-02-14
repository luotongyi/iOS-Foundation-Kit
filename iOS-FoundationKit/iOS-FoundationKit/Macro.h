//
//  Macro.h
//  iOS-FoundationKit
//
//  Created by luoty on 2019/1/30.
//  Copyright © 2019年 luoty. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

//正常字体
#define KFONT(x)                    [UIFont systemFontOfSize:x]
//加粗字体
#define KBOLD_FONT(x)               [UIFont boldSystemFontOfSize:x]

//weakSelf 一般在block里面使用
#define ML_WEAK_SELF(weakSelf)      __weak __typeof(&*self)weakSelf = self;

#define ML_STRING_FORMAT(string)         [NSString stringWithFormat:@"%@",(string==nil||[string isKindOfClass:[NSNull class]])?@"":string]

#define ML_LOG( format, ... )         NSLog( @"<%@:(%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__] )

#endif /* Macro_h */
