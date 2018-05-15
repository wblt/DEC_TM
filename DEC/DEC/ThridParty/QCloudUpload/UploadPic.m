//
//  UploadPic.m
//  Training
//
//  Created by 李林 on 2017/4/30.
//  Copyright © 2017年 胡惜. All rights reserved.
//

#import "UploadPic.h"


@interface UploadPic(){
    int64_t currentTaskid;
}
@end

@implementation UploadPic
+ (instancetype)sharedInstance{
    static UploadPic *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        //kSdkAppId
        instance.myClient = [[COSClient alloc] initWithAppId:@"1254340937" withRegion:@"bj"];
        //设置htpps请求
        [instance.myClient openHTTPSrequset:YES];
        instance.dataArray = [NSMutableArray array];
    });
    return instance;
}

-(void)uploadFileMultipartWithPath:(NSString *)filePath fileName:(NSString*)fileName
              callback:(UploadStatusCallBack)callback
{
    COSObjectPutTask *task = [[COSObjectPutTask alloc] init];
    NSLog(@"-send---taskId---%lld",task.taskId);
    task.multipartUpload = YES;
    currentTaskid = task.taskId;
    NSLog(@"photoPath=%@",filePath);
    task.filePath = filePath;
    task.fileName = fileName;
    task.bucket = @"ala";
    task.attrs = @"customAttribute";
    task.directory = @"file";
    task.insertOnly = YES;
    // 请求签名
    RequestParams *params = [[RequestParams alloc] initWithParams:API_SIGN];
    [[NetworkSingleton shareInstace] httpPost:params withTitle:@"签名" successBlock:^(id data) {
        NSString *code = data[@"code"];
        if (![code isEqualToString:@"1000"]) {
            [SVProgressHUD showErrorWithStatus:data[@"message"]];
            return ;
        }
        NSDictionary *dic = data[@"pd"];
        task.sign = dic[@"sign"];
        [_myClient putObject:task];
    } failureBlock:^(NSError *error) {
        
    }];
    __weak typeof(self) weakSelf = self;
    _myClient.completionHandler = ^(COSTaskRsp *resp, NSDictionary *context){
        COSObjectUploadTaskRsp *rsp = (COSObjectUploadTaskRsp *)resp;
        if (rsp.retCode == 0) {
            NSLog(@"context  = %@",rsp.sourceURL);
            if (callback) {
                callback(rsp.sourceURL);
            }
            [weakSelf.dataArray addObject:rsp.sourceURL];
        }else{
            NSLog(@"-error--%@",rsp.descMsg);
            if (callback) {
                callback(@"");
            }
        }
    };
}

- (NSString *)photoSavePathForURL:(NSURL *)url
{
    NSString *photoSavePath = nil;
    NSString *urlString = [url absoluteString];
    NSString *uuid = nil;
    if (urlString) {
        uuid = [self findUUID:urlString];
    } else {
        uuid = [self uuid];
    }
    NSString *resourceCacheDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/UploadPhoto/"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:resourceCacheDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:resourceCacheDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    photoSavePath = [resourceCacheDir stringByAppendingPathComponent:uuid];
    return photoSavePath;
}

- (NSString *)findUUID:(NSString *)path
{
    if (path.length == 0) {
        return [self uuid];
    }
    int begin = 0;
    int end = 0;
    int i = 0;
    const char * p = [path UTF8String];
    while (*p!='\0') {
        if (*p == '=')
        {
            if (begin == 0) {
                begin = i+1;
            }
        }
        if (*p == '&') {
            if (end == 0)
            {
                end = i;
                break;
            }
        }
        i++;
        p++;
    }
    NSString * uuid = [path substringWithRange:NSMakeRange(begin, end - begin)];
    return  uuid;
}

- (NSString *)uuid
{
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef strUuid = CFUUIDCreateString(kCFAllocatorDefault,uuid);
    NSString * str = [NSString stringWithString:(__bridge NSString *)strUuid];
    CFRelease(strUuid);
    CFRelease(uuid);
    return  str;
}

@end
