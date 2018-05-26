//
//  FlowAPI.h
//  Keepcaring
//
//  Created by mac on 2017/12/11.
//  Copyright © 2017年 mac. All rights reserved.
//

#ifndef FlowAPI_h
#define FlowAPI_h



// 主服务器地址
#define SERVER_IP         @"http://139.196.225.206:8082"

// USER
// 登录
#define API_LOGIN       SERVER_IP@"/app/user/login"
// 注册验证码
#define API_REGIST_CODE SERVER_IP@"/app/user/sysendMess"
// 注册
#define API_REGIST       SERVER_IP@"/app/user/syreg"
// 忘记密码验证码
#define API_FGPWD_CODE   SERVER_IP@"/app/user/sysendMessFG"
//忘记密码
#define API_FGPWD    SERVER_IP@"/app/user/forget"
//安全密码短信验证码
#define API_AQPWD_CODE  SERVER_IP@"/app/user/sysendMessAQ"


//INDEX
// 公告
#define API_NOTICE     SERVER_IP@"/app/index/notice"
// 我的好友
#define API_MY_FRIENDS SERVER_IP@"/app/index/friends"
//记录步数
#define API_DAYSTEP SERVER_IP@"/app/index/dayStep"
//邀请好友
#define API_INVITATION SERVER_IP@"/app/index/invitation"
//释放记录
#define API_RELEASE SERVER_IP@"/app/index/release"
//释放详情
#define API_RELEASEDTTAIIL SERVER_IP@"/app/index/releaseDetaiil"
//零钱包转入算力钱包
#define API_TRANSFERRED SERVER_IP@"/app/index/transferred"
//首页
#define API_HOMEPAGE   SERVER_IP@"/app/index/homePage"

//MARKET
//MARKET - K线图
#define API_depth SERVER_IP@"/app/market/depth"
//买单
#define API_buy  SERVER_IP@"/app/market/buy"
// 买单列表
#define API_buyList SERVER_IP@"/app/market/buyList"
// 卖单列表
#define API_sellList SERVER_IP@"/app/market/sellList"
//市场列表
#define API_marketList SERVER_IP@"/app/market/marketList"
//挂单
#define API_sell SERVER_IP@"/app/market/sell"
//指导价 点击挂单时候获取
#define API_price SERVER_IP@"/app/market/price"
//订单取消
#define API_orderCancle SERVER_IP@"/app/market/orderCancle"
//订单已付款(测试过审核也可用此接口)
#define API_pay SERVER_IP@"/app/market/pay"
//订单确认收款
#define API_surePay SERVER_IP@"/app/market/surePay"
//订单详情
#define API_orderDetail SERVER_IP@"/app/market/orderDetail"

#define API_releaseDepth SERVER_IP@"/app/market/releaseDepth"

// TOOL
// 修改个人信息
#define API_CGPERSONMSG   SERVER_IP@"/app/tool/cgPersonMes"
// 修改安全密码
#define API_ANPASSW   SERVER_IP@"/app/tool/aqPassw"
// 修改手机号码
#define API_PHONECG   SERVER_IP@"/app/tool/phoneCg"
// 修改登陆密码
#define API_CGPASSWORD   SERVER_IP@"/app/tool/changePassw"
// 修改支付信息
#define API_cgPayMes   SERVER_IP@"/app/tool/cgPayMes"
// 查询支付信息
#define API_payMes SERVER_IP@"/app/tool/payMes"

//  MY
//设置复利
#define API_CGFl  SERVER_IP@"/app/my/cgFl"
//能量兑换
#define API_CHANGEENERGY  SERVER_IP@"/app/my/changeEnergy"
//能量兑换页面
#define API_CGENERGYMES  SERVER_IP@"/app/my/cgEnergyMes"
//发送
#define API_SEND  SERVER_IP@"/app/my/send"
//可发送内容
#define API_SENDMES  SERVER_IP@"/app/my/sendMes"
//复利状态
#define API_IFFL   SERVER_IP@"/app/my/ifFl"
//接收状态
#define API_RECEIVEDETAIL   SERVER_IP@"/app/my/receiveDetail"
//转账记录
#define API_SENDDETAIL   SERVER_IP@"/app/my/sendDetail"
//运动记录
#define API_STEPDETAIL   SERVER_IP@"/app/my/stepDetail"

// 获取签名
#define API_SIGN SERVER_IP@"/upload/signCreate"


#endif /* FlowAPI_h */
