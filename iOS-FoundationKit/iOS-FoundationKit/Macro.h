//
//  Macro.h
//  iOS-FoundationKit
//
//  Created by luoty on 2019/1/30.
//  Copyright © 2019年 luoty. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#define ML_STRING_FORMAT(string)         [NSString stringWithFormat:@"%@",(string==nil||[string isKindOfClass:[NSNull class]])?@"":string]

#define ML_LOG( format, ... )         NSLog( @"<%@:(%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__] )

#endif /* Macro_h */
