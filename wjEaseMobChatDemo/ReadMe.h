// 1.如果集成遇到 image not found
    // 解决办法是在general->embedded binaries中添加hypenate.framework

// 2.自动登录需求
    // (1).如果曾经登录过，下次启动程序，下次直接进入到主界面，
    // (2).在后台发送一个登录请求给服务器(用户名和密码当一次登录的时候就要保存到沙盒)
        // 环信内部已经实现了自动登录的功能
        // <1>[[EMClient sharedClient].options setIsAutoLogin:YES]; 设置自动登录的开关
        // <2>BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin; 判断用户是否登录过
        // <3> - (void)autoLoginDidCompleteWithError:(EMError *)error; 自动登录的回调方法
// 3.在其他设备登录，有个代理方法可以监听到: - (void)userAccountDidLoginFromOtherDevice;
    // 在演示其他设备进行登录的时候，一定要设置两个应用的appkey是一致的。


// 4.好友
    // (1)实现添加好友的界面
    // (2)发送添加好友的请求给服务器
    // (3)监听好友对申请的回复(但凡是监听功能，都是通过代理进行实现的，添加代理的时候，对象不能死，所以要放在AppDelegate里)
        // 添加代理
            // [EMClient sharedClient].contactManager addDelegate: delegateQueue:
        // 实现两个代理方法
            // 同意 - (void)friendRequestDidApproveByUser:(NSString *)aUsername;
            // 拒绝 - (void)friendRequestDidDeclineByUser:(NSString *)aUsername;
    // (4)显示好友
        // 默认情况下，好友的数据会保存在本地的数据库中
        // 开发中只需要获取到数据库中的好友数据就可以了
        // 如果本地没有好友的数据，需要从服务器进行获取


// 5.实现通讯录的顶部排版

// 6.实现监听好友的添加申请
    // 业务
        // (1)监听 ‘好友的添加申请’
            // 好友模块的代理可以实现(appDelegate)
        // (2)保存 ‘好友的添加申请’ 的数据到数据库中(sqlite)->存在环信的自带的数据库中
            // 默认环信内部不会保存 '好友的添加申请' 的数据
            // 创建表-> creat table if not exisits friendRequest (userName text, message text);
            // 插入数据-> insert friendRequest(userName, message) values(?,?)
            // 使用FMDB框架
        // (3)设置通讯录的tabbar的item的badge数字
        // (4)设置‘新朋友’的badge
        // (5)点击新朋友显示'好友申请的列表'
        // (6)同意或拒绝添加好友
        // (7)刷新好友列表的数据(好友关系的建立)
            // <1>好友同意了我的请求
            // <2>我同意了好友的请求
// 7.开发中的技巧:
    // (1)添加.pch文件
    // (2)自定义log日志

// 8.导入EaseUI到项目
    // (1)直接拖入EaseUI文件到项目
    // (2)使用cocoaPods导入
        // pod 'MBProgressHUD', '~> 0.9'
        // pod 'SDWebImage', '~> 3.7'
        // pod 'MJRefresh', '~> 3.1.12'
        // pod 'MWPhotoBrowser', '~> 2.1.2'
    // (3)在当前自己项目的pch添加下面的内容
        // #ifdef __OBJC__
           // #import <UIKit/UIKit.h>
        // #endif

// 9.使用EaseUI聊天界面
    // 写一个类继承EaseMessageViewController来使用

// 10.继承EaseUI的问题
    // (1)需要拿到相册等的权限
    // (2)聊天界面的中英文的问题(多语言的国际化问题)
        // <1>访问http://blog.sina.com.cn/s/blog_7b9d64af0101jncz.html
        // <2>把环信demo中的localizable.strings的内容拷贝到当前的项目中

// 11.历史回话
    // (1)历史回话的数据
    // (2)显示cell内容

// 12. 未读消息数和会话列表的更新
    // (1)添加chatManage的代理
    // (2)收到消息 (收到未读消息监听) 监听 : - (void)messagesDidReceive:(NSArray *)aMessages;
    // (3)会话列表发生变化 监听 : - (void)conversationListDidUpdate:(NSArray *)aConversationList;

// 13.设置状态栏样式
    // (1)默认情况下，状态栏的样式是由控制器进行决定的
    // (2)如果控制器来实现，需要在自定义一个导航控制器，内部中实现一个-> - (UIStatusBarStyle)preferredStatusBarStyle
    // (3)第二种方式来实现 UIApplication来实现
        // <1>  [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        // <2>info.plist文件进行配置View controller-based status bar appearance == NO 

// 14.表格多选的实现
    // (1)实现tableview的editing方法
    // (2)实现一个代理方法
        // - (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
            // return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
        // }

// 15.自定义扩展 -> 发送名片消息
    // (1)工具栏添加一个按钮
    // (2)发送名片消息
    // (3)显示名片的cell（发送cell和接收的cell）
        // <1>xib创建一个cell
    // (4)在wjChatVC控制器里添加自定义cell,只需要通过代理方法进行实现







