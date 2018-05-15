//
//  UploadPic.h
//  Training
//
//  Created by 李林 on 2017/4/30.
//  Copyright © 2017年 胡惜. All rights reserved.
//

#import "COSClient.h"
#import "COSTask.h"

typedef void (^UploadStatusCallBack) (NSString *url);
@interface UploadPic : NSObject
@property(nonatomic,strong)COSClient *myClient;
@property(nonatomic,strong)NSString *sign;
@property(nonatomic,strong)NSMutableArray* dataArray;
+ (instancetype)sharedInstance;
-(void)uploadFileMultipartWithPath:(NSString *)filePath fileName:(NSString*)fileName
callback:(UploadStatusCallBack)callback;
- (NSString *)photoSavePathForURL:(NSURL *)url;
@end
