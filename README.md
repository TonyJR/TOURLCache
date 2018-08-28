# TOURLCache

==============

TOURLCache是针对App网络性能的优化器，可以大幅提升网络性能，对UIWebView的增幅最为明显。通常情况下可以提高30%以上的访问速度。
对于UIWebView主要解决了两个问题：
1、连接重用问题，UIWebView的底层访问默认使用的是NSURLConnection，TOURLCache可以将NSURLConnection的GET请求替换为NSURLSession。
2、HTTPS内容缓存问题，UIWebView默认不会对https内容进行缓存。TOURLCache可以解决这个问题
3、离线浏览，TOURLCache可以提供UIWebView的离线浏览
