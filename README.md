# Flutter App Scheme

[中文说明](https://github.com/flutter-plugin/flutter-scheme/blob/master/README-ZH.md)

## Configuration instructions

### 1、Android configuration instructions
Add `Scheme` in the `AndroidManifest.xml` file of Android in your project according to the following specifications, for example, `android/app/src/main/AndroidManifest.xml`

#### a、Add the following code in `Activity`
```xml
<!--Android Scheme-->
<intent-filter>
  <action android:name="android.intent.action.VIEW" />
  <category android:name="android.intent.category.DEFAULT" />
  <!--Need to be pulled up by the web page must be set-->
  <category android:name="android.intent.category.BROWSABLE" />
  <category android:name="android.intent.category.APP_BROWSER" />
  <!--Agreement part-->
  <data
    android:host="hong.com"
    android:path="/product"
    android:scheme="app" />
</intent-filter>
```

### 2、iOS configuration instructions
In your project, add `Scheme` in the ```Info.plist`'' file in the ios project according to the following specifications, for example: `ios/Runner/Info.plist`

#### a、Add the following code in the `Info.plist` file
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    ...
    <key>CFBundleURLTypes</key><!-- Add Scheme related information -->
    <array>
      <dict>
        <key>CFBundleURLName</key>
        <string>hong.com/product</string>
        <key>CFBundleURLSchemes</key>
        <array>
          <string>app</string><!-- Here's Scheme -->
        </array>
      </dict>
    </array>
    ...
  </dict>
</plist>
```


## Instructions

```
dependencies:
  appscheme: ^1.0.5
```

#### 1、initialize
```
AppScheme appScheme = AppSchemeImpl.getInstance();
```
### 2、getInitScheme
```dart
appScheme.getInitScheme().then((value){
  if(value != null){
    setState(() {
      _platformVersion = "Init  ${value.dataString}";
    });
  }
});
```
### 3、getLatestScheme
```dart
appScheme.getLatestScheme().then((value){
  if(value != null){
    setState(() {
      _platformVersion = "Latest ${value.dataString}";
    });
  }
});
```

### 4、注册从外部打开的Scheme监听信息
```dart
appScheme.registerSchemeListener().listen((event) {
  if(event != null){
    setState(() {
      _platformVersion = "listen ${event.dataString}";
    });
  }
});
```

### 5、example中测试地址

`测试地址`:[https://api.dsfgx.com/a.html](https://api.dsfgx.com/a.html)


## URL Scheme协议格式：
一个完整的完整的URL Scheme协议格式由scheme、host、port、path和query组成，其结构如下所示    
```
<scheme>://<host>:<port>/<path>?<query>
```
xiaoxiongapp://xapi.xiaomanxiong.com/home?redirect_type=1&ios_redirect_url=aaaaaaa.com&android_redirect_url=aaaaaaa.com
如下就是一个自定义的URL
openapp://hhong:80/product?productId=10000007
openapp： 即Scheme 该Scheme协议名称（必填）
hhong： 即Host,代表Scheme作用于哪个地址域（必填）
80： 即port，代表端口号
product：即path，代表打开的页面
param： 即query，代表传递的参数

传递参数的方法跟web端一样，通过问号?分隔，参数名和值之间使用等号=连接，多个参数之间使用&拼接。


## Scheme使用
既然我们使用scheme来做打开app并跳转的逻辑，那这个scheme应该声明在哪里比较合适呢？如果你的应用在启动页（splash）或者在主界面(main)初始化了一些必要的设置，比如必要的token信息检查交易或者一些其它校验等，没有这些信息会造成崩溃的，这个时候我们就需要在启动页来声明这个scheme了，获取scheme信息保存起来，然后在主界面做处理逻辑，如跳转到其它界面等。当然你也可以声明scheme在其它地方，具体得需要看怎么实现业务比较方便。


## HTML 示列
```html
<!DOCTYPE html>
<html>
<head>
    <meta charset='utf-8'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
    <title>测试App Scheme</title>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <meta name="viewport" content="width=device-width,initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
</head>
<body>
    
</body>
</html>

<html>
    <head>
       
    </head>
    <body>
        <div>
            <a href="app://hong.com/product?productId=10000007&">Android、iOS</a>
        </div>

        <div>
            <a href="app://">app:// 无host</a>
        </div>

        <div>
            <a href="app://hong.com">app:// 无path</a>
        </div>

        <div>
            <a href="app://hong.com/product">app:// 无query</a>
        </div>

        <div>
            <a href="intent://hong.com/product?productId=10000007#Intent;scheme=app;end">Android特殊机型</a>
        </div>
        
        <div style="text-align:center;">
            <h4>小熊有好货测试</h4>
            <div>
                <a href="xiaoxiongapp://xapi.xiaomanxiong.com/home?redirect_type=1&ios_redirect_url=www.baidu.com&android_redirect_url=www.baidu.com">测试类型1</a>
            </div>
            <div>
                <a href="intent://xapi.xiaomanxiong.com/home?redirect_type=1&ios_redirect_url=www.baidu.com&android_redirect_url=www.baidu.com#Intent;scheme=xiaoxiongapp;end">(Android特殊机型)测试类型1</a>
            </div>
        </div>
    </body>
</html>
```