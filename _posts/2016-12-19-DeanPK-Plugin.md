---
layout: post
title:  "课程评价，分分钟结束"
image: ''
date:   2016-12-19 00:00:00
tags:
description: ''
categories:
serie: introduce
---

十二月十二日，我以 `HackSwjtu` 的身份上线了一款 Chrome 插件。这款插件可以跳过西南交通大学教务系统的教师评课环节，实现一键评课无需等待地选课和查看个人最新的成绩。这款插件拥有三个模块功能，即**一键课程评价**、**一键导师评价**、**一键暑期实习评价**和**自助学期评价**。

<img src="http://ofmxkmiv3.bkt.clouddn.com/HackSwjtuDeanPK-logo.png" width="200px"/>

## 为什么要做这个插件？

在每学期的期末考试后，在寒暑假的前几天大家都会悬着心，因为害怕挂科（当然，学霸们关心的是是否上 90 分）。基本上每天都要去刷一下是否出分了。当出分的那个时刻，总会有个恶心的东西挡在前面摩你的性子，那就是这个评价的逻辑。

在每次查看成绩之前，教务网总会耽误你最少 1 分钟的时间去填写很多大家都不关心的东西，十分琐碎。然而却没有同学去关心这些东西，更有甚者为了大家口中的“增加自己的人品”，无论这一门课好与坏，都会给其优评。因此造成 80% 数据都是违心的、不真实的。

![无缘无故为啥要评价你，MD智障。](http://ofmxkmiv3.bkt.clouddn.com/install-flow2.png)

那么这些评价有什么影响呢？至少我们学生是看不到的，而且也不会影响到各门课程老师的收入，更不会与老师的职称评级挂钩。因此，我们认定这个东西是没有任何意义的东西。于是我开始研发这款插件。

如果一个学期平均有 10 门课程，一次评价课程的时间需要花费 5 分钟，那么每一个学年你都能增加 1.667 小时的有效时间，无论是阅读还是 Coding。

## 关于 HackSwjtuDeanPK Chrome Plugin 的开发逻辑

在评课页面中，发现其数据提交函数 `go()` 的逻辑，是将每次你选择的问题答案 ID 和问题的 ID 获取下来，然后进行数据提交，上传到教务之星的服务器。这个提交方式十分的暴露、未加密，也就留下了一丝漏洞。以下便是提交数据的 js 代码片段（jQuery）。

```javascript
$.post("AssessAction?SetAction=answer",
   {
   	  // 题目的 id 数据集集合序列化（JSON 格式）
       id: ids,
       // 选择答案的 id 数据集合序列化（JSON 格式）
       answer: ans,
       assess_id: $("input[name='assess_id']").val(),
       templateFlag: "1"
   }, function(data) {
       if (data.flag) {
           alert("提交成功");
       }
       history.go(-1);
   }
);
```

我用 jQuery 在页面中动态的获取出问题 ID，而选择答案根据好评和差评的选择情况，来定制获取答案 ID，自己拟造一个答案集合的序列化字符串。并且将提交数据的方法改写成一个新的函数并且一起嵌入至所在页面的 js 环境中。

```javascript
function badit(ind) {
	// 通过选择器方法获取所有的 radio 控件
    var radios = $(':radio');
    var ps = $("input[name='problem_id']");
    var firstVal = radios[ind].value;
    var dg_ans = '', dg_ids = '';
    // 组装数据，制造模拟答案 ID 序列化字符串
    for (var i = 1; i <= 18; ++ i) {
        index = Number(ind) + (i - 1) * 5;
        console.log(radios[index]);
        if (i == 17) {
            var dg_ans_ind = Math.floor(Math.random() * (courses_pk_good.length - 1 - 0) + 0);
            dg_ans += ',' + courses_pk_good[dg_ans_ind];
            continue;
        } else if (i == 18) {
            var dg_ids_ind = Math.floor(Math.random() * (courses_pk_correct.length - 1 - 0) + 0);
            dg_ans += ',' + courses_pk_correct[dg_ids_ind];
            continue;
        } else {
            num = (Number(firstVal) + (i - 1) * 5);
            dg_ans += ',' + num;
        }
    }
	// 将静态评价一同传入答案数据的序列化字符串中
    for (i = 0; i < ps.length; ++ i) {
        code = ps[i].value;
        dg_ids += ',' + code;
    }

    $.post("AssessAction?SetAction=answer",
        {
            id: dg_ids,
            answer: dg_ans,
            assess_id: $("input[name='assess_id']").val(),
            templateFlag: "0"
        },
        function(data) {
            if (data.flag) {
                alert("教务君说提交成功。返回上一个页面刷新即可。");
            }
            history.go(-1);
        }
    );
}
```

另外用户友好相关，插件的按钮处理中通过页面的 dom 获取出页面的按钮样式，并且添加了两个按钮。即在匹配页面中你可以看到的 *一键好评* 和 *一键差评*。最终的效果在 Chrome 浏览器中如下所示：

![](http://ofmxkmiv3.bkt.clouddn.com/HackSwjtuDeanPK-screenshot2.png)

## 载入 HackSwjtuDeanPK Chrome Plugin

首先，你需要有一个 Chrome。然后请转到 [Github](https://github.com/HackSwjtu/HackSwjtuDeanPK/releases/tag/1.0) 去下载测试版的 `crx` 插件包程序。打开 Chrome 的 [Extension](chrome://extensions/) 的页面，将 `crx` 插件包拖入浏览器后即可安装，勾选后重启即可开始使用。

![](http://ofmxkmiv3.bkt.clouddn.com/install-flow.png)


当然，这里更推荐的是使用 [Github 的 README.md](https://github.com/HackSwjtu/HackSwjtuDeanPK/blob/master/README.md) 中的开发者版。由于作者没有上架至 Goolge 市场，所以 `crx` 的插件包有时会产生不信任的状态，导致差价无法使用。

如果在安装中遇到了难处，请再仔细阅读一遍帮助文档，如还有问题，可与我邮件联系。

## HackSwjtuDeanPK-ff Firefox Add-on

最新的版本中，我们对 firefox 浏览器也做了插件的迁移，具体的源码和使用方法可以参看 Github 上的 [HackSwjtuDeanPK-ff](https://github.com/HackSwjtu/HackSwjtuDeanPK-ff) 仓库。

Firefox 的扩展程序安装相对于 Chrome 来说较为复杂些，由于作者没有为附加组件签名，所以需要使用调试模式进行安装。

首先需要打开插件[下载页面](https://github.com/HackSwjtu/HackSwjtuDeanPK-ff/releases/tag/1.0)，下载 `HackSwjtuDeanPK-ff.xpi` 文件。然后在附加组件管理器页面中，打开 `扩展` -> `设置` -> `调试附加组件`。

![](http://ofmxkmiv3.bkt.clouddn.com/ff-install-flow.png)

在 `附加组件` 页面中点击 `临时加载附加组件` 按钮，浏览找到刚刚下载的 `xpi` 文件添加即可使用。

![](http://ofmxkmiv3.bkt.clouddn.com/ff-install-flow2.png)

## 结语

虽然没有什么革命性的创造，但是我们希望我们的交大生活更加的高效，而不是无故的浪费我们的大学时光。当然 HackSwjtu 一向致力于改善交大信息化水平，让更多的同学感受到互联网的魅力所在。

如果有对我们的线上组织有兴趣的话，可以见[此处]()的申请方式来与我们联系。来做一位 😎 （这样的）SwjtuHacker ！


![](/assets/img/banner.svg)






