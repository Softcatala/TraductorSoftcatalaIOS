//
// Created by Marcos Grau on 28/02/14.
// Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#import "Language.h"


@implementation Language {

}
- (instancetype)initWithCode:(NSString *)code andName:(NSString *)name {
    self = [super init];
    if (self) {
        _code = code;
        _name = name;
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_code forKey:@"code"];
    [encoder encodeObject:_name forKey:@"name"];
}

- (id)initWithCoder:(NSCoder * )coder
{
    if (self = [super init])
    {
        _code = [coder decodeObjectForKey:@"code"];
        _name = [coder decodeObjectForKey:@"name"];
    }
    return self;
}
@end