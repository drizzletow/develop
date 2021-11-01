# 一 uniapp



# 二 UniCloud

## 云存储
## 云函数
## 云数据库
## uni-id
## 5.clientDB



# 三 Project

## 时间格式
```javascript
//1. 时间过滤器 (使用方法：如 {{article.publishTime | formatDate}} 视图层调用)
//filters 与 methods 同级
filters: {
    formatDate: function(d) {
    	var date = new Date(d);
    	var month = date.getMonth() + 1;
    	var hours = date.getHours();
    	if (hours < 10)
    		hours = "0" + hours;
    	var minutes = date.getMinutes();
    	if (minutes < 10)
    		minutes = "0" + minutes;
    	var time = date.getFullYear() + "-" + month + "-" + date.getDate() +
    		" " + hours + ":" + minutes;
    	return time;
    }
},
```

```javascript
//2.写在 APP.vue 中 (数据处理过程中调用)
<script>	
// 对Date的扩展，将 Date 转化为指定格式的String
// 月(M)、日(d)、小时(h)、分(m)、秒(s)、季度(q) 可以用 1-2 个占位符，
// 年(y)可以用 1-4 个占位符，毫秒(S)只能用 1 个占位符(是 1-3 位的数字)
// 使用方法（例子）：
// (new Date()).Format("yyyy-MM-dd hh:mm:ss.S") ==> 2006-07-02 08:09:04.423
// (new Date()).Format("yyyy-M-d h:m:s.S")      ==> 2006-7-2 8:9:4.18
// var myDate=(new Date()).Format("yyyy-MM-dd");
// var myTime=(new Date()).Format("hh:mm:ss");
Date.prototype.Format=function(fmt) {
	var o= {
		"M+": this.getMonth()+1, //月份
			"d+": this.getDate(), //日
			"h+": this.getHours(), //小时
			"m+": this.getMinutes(), //分
			"s+": this.getSeconds(), //秒
			"q+": Math.floor((this.getMonth()+3)/3), //季度
			"S": this.getMilliseconds() //毫秒
	};
	if(/(y+)/.test(fmt)) fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));
	for(var k in o) if(new RegExp("("+ k +")").test(fmt)) fmt=fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));
	return fmt;
}
</script>

//可全局调用，使用方法：
this.article.publishTime = (new Date(this.article.publishTime)).Format("yyyy-MM-dd hh:mm");
```


## 多图片上传
```javascript
// 封装上传多个图片的异步函数，返回图片链接数组
uploadImages(imageData){
	let imagesList = [];
	let promiseArr = [];
	return new Promise((resolve,reject)=>{
		// 逐一生成上传图片的 promise 对象，并加入到promiseArr数组中
		for (var i = 0; i < imageData.length; i++) {
			let tempUrl = imageData[i];
			let cloudPath = this.getRandomString(32)+Date.now()+'.'+this.getExtName(tempUrl);
			let p = new Promise((resolve,reject)=>{
				uniCloud.uploadFile({
					filePath:tempUrl,
					cloudPath:cloudPath,
				}).then(res=>{
					imagesList.push(res.fileID);
					resolve();
				}).catch(err=>{
					reject();
				})
			})
			promiseArr.push(p);
		}
		// 执行完promiseArr里面所有的promise对象后、返回 云端图片链接数组imagesList
		Promise.all(promiseArr).then(res=>{
			resolve(imagesList);
		})
	})
},
//生成随机字符串
getRandomString(len) {
　　len = len || 32;
　　var $chars = 'ABCDEFGHJKMNPQRSTWXYZabcdefhijkmnprstwxyz2345678';    /****默认去掉了容易混淆的字符oOLl,9gq,Vv,Uu,I1****/
　　var maxPos = $chars.length;
　　var pwd = '';
　　for (var i = 0; i < len; i++) {
　　　　pwd += $chars.charAt(Math.floor(Math.random() * maxPos));
　　}
　　return pwd;
},
//获取文件拓展名
getExtName(filename){
  if(!filename||typeof filename!='string'){
     return false
  };
  let a = filename.split('').reverse().join('');
  let b = a.substring(0,a.search(/\./)).split('').reverse().join('');
  return b
},
```
```javascript
//例：出入临时图片路径数组，返回图片链接数组
data.imagesList = await this.uploadImages(this.imageData);
```

## 顶部导航栏
```js
<template>
	<view class="navbar">
		<view class="navbar-fixed">
			<!-- 状态栏（动态高度） -->
			<view :style="{height:statusBarHeight+'px'}"></view>
			<view class="navbar-content" :style="{height:navBarHeight+'px',width:windowWidth+'px'}">
				content
			</view>
		</view>
		<view :style="{height:statusBarHeight+navBarHeight+'px'}"></view>
	</view>
</template>

<script>
	export default {
		data() {
			return {
				statusBarHeight: 20,
				navBarHeight: 45,
				windowWidth: 375,
				val: ''
			};
		},

		created() {
			// 获取手机信息
			const info = uni.getSystemInfoSync();
			// 设置状态栏的高度
			this.statusBarHeight = info.statusBarHeight;
			this.windowWidth = info.windowWidth;

			// 设置搜索框的宽度（留出小程序右侧胶囊的宽度） h5 app mp-alipay 没有胶囊
			// #ifndef H5 || MP-ALIPAY || APP-PLUS
			// 获取胶囊位置信息
			const menuButtonInfo = uni.getMenuButtonBoundingClientRect();
			// (胶囊底部高度 - 状态栏的高度) + (胶囊顶部高度 - 状态栏内的高度) = 导航栏的高度
			this.navBarHeight = (menuButtonInfo.bottom - info.statusBarHeight) + (menuButtonInfo.top - info.statusBarHeight);
			this.windowWidth = menuButtonInfo.left;
			// #endif
		}
	}
</script>

<style lang="scss">
	.navbar {	
		.navbar-fixed {
			position: fixed;
			left: 0;
			top: 0;
			z-index: 999;
			width: 100%;
			background: linear-gradient(45deg, rgb(12, 159, 254), rgb(234, 255, 182));

			.navbar-content {
				display: flex;
				justify-content: center;
				align-items: center;
				box-sizing: border-box;
				padding: 0 15px;
				height: 45px;
			}
		}
	}
</style>

```