//
//  BMConnectionDelegate.m
//  BMInstaCollage
//
//  Created by Bogdan Matveev on 17.02.15.
//  Copyright (c) 2015 BOGDAN MATVEEV. All rights reserved.
//
#define INSTAGRAM_CLIENT_ID @"c956dcccb3bd4e14b4527dec35055a60"

#import "BMConnectionDelegate.h"
@interface BMConnectionDelegate()
@property (nonatomic, strong) NSMutableArray *mediaDataArray;
@end
@implementation BMConnectionDelegate

- (void)findUserWithNickName:(NSString*)nickName
{
	[self.delegate showIndicatorView];
	self.mediaDataArray = [NSMutableArray array];
	
    NSString *getUserInfoUrlString = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/search?q=%@&client_id=%@",nickName,INSTAGRAM_CLIENT_ID];
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:getUserInfoUrlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error)
        {
            NSError *jsonParsingError;
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
            if (!jsonParsingError)
            {
                NSDictionary *meta = jsonData[@"meta"];
                if ([meta[@"code"] integerValue] == 200 )
                {
					NSArray *dataArray = jsonData[@"data"];
					if (dataArray.count){
						NSDictionary *userInfo =dataArray[0];
						NSString *userId = userInfo[@"id"];
                        [self getMainUserInfoForId:userId];
					}
                    else
                    {
                        [self.delegate sendAlertWithMessage:@"Ошибка. Пользователь не найден"];
						[self.delegate hideIndicatorView];

                    }
                }
                else
                {
					[self.delegate hideIndicatorView];
                    [self.delegate sendAlertWithMessage:@"Ошибка при получении данных"];
                }
            }
        }
    }] resume];

}
- (void)getMainUserInfoForId:(NSString*)userId
{
    NSString *getUserInfoUrlString = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/?client_id=%@",userId,INSTAGRAM_CLIENT_ID];
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:getUserInfoUrlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error)
        {
            NSError *jsonParsingError;
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
            if (!jsonParsingError)
            {
                NSDictionary *meta = jsonData[@"meta"];
                if ([meta[@"code"] integerValue] == 200)
                {
                    NSString *mediaCounts = jsonData[@"data"][@"counts"][@"media"];
                    [self getMostPopularPhotosForUserId:userId mediaCounts:mediaCounts paginationUrl:nil];
                }
                else
                {
					[self.delegate hideIndicatorView];
                    [self.delegate sendAlertWithMessage:@"Ошибка при получении данных"];
                }
            }
        }
    }] resume];
}

- (void)getMostPopularPhotosForUserId:(NSString*)userId mediaCounts:(NSString*)mediaCounts paginationUrl:(NSString*)paginationUrl
{
    
    NSString *mediaInfoUrl;
    if (paginationUrl)
        mediaInfoUrl = paginationUrl;
    else
        mediaInfoUrl = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/media/recent?count=%li&client_id=%@",userId,mediaCounts.integerValue, INSTAGRAM_CLIENT_ID];
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:mediaInfoUrl] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error)
        {
            NSError *jsonParsingError;
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
            if (!jsonParsingError)
            {
                NSDictionary *meta = jsonData[@"meta"];
                if ([meta[@"code"] integerValue] == 200)
                {
                    [self.mediaDataArray addObjectsFromArray:jsonData[@"data"]];
                    NSString *paginationString = jsonData[@"pagination"][@"next_url"];
                    
                    // Рекурсивно вызываем метод, если у пользователя много изображений
                    if (paginationString)
                        [self getMostPopularPhotosForUserId:userId mediaCounts:mediaCounts paginationUrl:paginationString];
                    else
                        [self proceedWithMedia];
                }
                else
                {
					[self.delegate hideIndicatorView];
                    [self.delegate sendAlertWithMessage:@"Ошибка при получении данных"];
                }
            }
        }
    }] resume];
}

- (void) proceedWithMedia
{
    [self.mediaDataArray sortUsingComparator:^NSComparisonResult(NSDictionary *firstData, NSDictionary *secondData) {
        NSNumber *firstDataLikes = firstData[@"likes"][@"count"];
        NSNumber *secondDataLikes = secondData[@"likes"][@"count"];
        return [secondDataLikes compare:firstDataLikes];
    }];
	[self.delegate hideIndicatorView];
	[self.delegate proceedWithMediaArray:self.mediaDataArray];
	self.mediaDataArray = nil;
}
@end
