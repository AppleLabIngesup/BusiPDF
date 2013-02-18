//
// Created by mathieuamiot on 18/02/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ALNetEngine.h"


@implementation ALNetEngine

+ (ALNetEngine *)instance
{
    static ALNetEngine *_instance = nil;

    @synchronized (self)
    {
        if (_instance == nil)
        {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

@end