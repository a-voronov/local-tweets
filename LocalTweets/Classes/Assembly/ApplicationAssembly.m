//
//  ApplicationAssembly.m
//  LocalTweets
//
//  Created by Alexander Voronov on 22/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import "ApplicationAssembly.h"
#import "TyphoonDefinition+Infrastructure.h"
#import "TyphoonConfigPostProcessor.h"
#import "TwitterRequestImpl.h"
#import "TwitterAPIManagerImpl.h"
#import "RecentNearestTweetsGateway.h"
#import "LocalTweetsViewModelImpl.h"


@implementation ApplicationAssembly

#pragma mark - Bootstrapping

- (id)config {
    return [TyphoonDefinition configDefinitionWithName:@"Configuration.plist"];
}

#pragma mark - API

- (id<TwitterAPIManager>)twitterApiManager {
    return [TyphoonDefinition withClass:TwitterAPIManagerImpl.class configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithAssembly:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:self];
        }];
    }];
}

- (id<TwitterRequest>)twitterRequestWithApiMethod:(NSString *)apiMethod requestMethod:(NSString *)requestMethod params:(NSDictionary *)params {
    return [TyphoonDefinition withClass:TwitterRequestImpl.class configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithApiURL:apiMethod:requestMethod:params:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:TyphoonConfig(@"twitterApiUrl")];
            [initializer injectParameterWith:apiMethod];
            [initializer injectParameterWith:requestMethod];
            [initializer injectParameterWith:params];
        }];
    }];
}

- (id<TwitterAPIGateway>)recentNearestTweetsGatewayWithLocationCoords:(NSDictionary *)coords radiusKM:(NSNumber *)radiusKM count:(NSNumber *)count {
    return [TyphoonDefinition withClass:RecentNearestTweetsGateway.class configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithLocationCoords:radiusKM:count:assembly:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:coords];
            [initializer injectParameterWith:radiusKM];
            [initializer injectParameterWith:count];
            [initializer injectParameterWith:self];
        }];
    }];
}

#pragma mark - Presentation

- (id<LocalTweetsViewModel>)localTweetsViewModel {
    return [TyphoonDefinition withClass:LocalTweetsViewModelImpl.class configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithAssembly:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:self];
        }];
    }];
}

@end
