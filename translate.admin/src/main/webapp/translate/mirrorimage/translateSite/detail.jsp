<%@page import="com.xnx3.j2ee.Global"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.xnx3.com/java_xnx3/xnx3_tld" prefix="x"%>
<jsp:include page="/wm/common/head.jsp">
	<jsp:param name="title" value="详情-也就是点开某个网站进入的更多设置页面" />
</jsp:include>
<script src="https://res.zvo.cn/from.js/from.js"></script> <!-- 表单信息自动填充、获取 https://gitee.com/mail_osc/from.js  -->
<script src="/<%=Global.CACHE_FILE %>Site_language.js"></script>
<script>
//获取源站id
var siteid = getUrlParams('siteid');
</script>

<!-- 顶部导航 - start -->
<div>
	<a href="/translate/mirrorimage/translateSite/list.jsp">源站管理</a> 
	/
	<span class="siteurl">loading...</span> 
</div>
<!-- 顶部导航 - end -->

<!-- 源站本身相关 - start -->
<style>
#site input{ border-style: hidden; }
</style>
<div id="site">
	<h2>源站信息</h2>
	<botton class="layui-btn layui-btn-sm" onclick="editSourceSite();" style="margin-left: 3px;">编辑</botton>
	<div>
		源站id:
		<input type="text" value="加载中..." name="id" />
	</div>
	<div>
		网址:
		<input type="text" value="加载中..." name="url" />
	</div>
	<div>
		语言:
		<input type="text" value="加载中..." name="language" />
	</div>
</div>
<script>
var site; //源站信息
/**
 * 加载源站数据
 */
function loadSiteData() {
	//msg.loading("加载中");
	wm.post("/translate/mirrorimage/translateSite/details.json", {id : siteid}, function(data) {
		//msg.close();
		if (data.result == '1') {
			site = data.translateSite;
			// 将接口获取到的数据自动填充到 div 中的输入框中
			from.fill('site',data.translateSite);
		} else if (data.result == '0') {
			msg.failure(data.info);
		} else {
			msg.failure(result);
		}
	}, "text");
}
loadSiteData();

/**
 * 编辑源站信息
 */
function editSourceSite() {
	layer.open({
		type: 2, 
		title: '编辑源站信息', 
		area: ['450px', '460px'],
		shadeClose: true, // 开启遮罩关闭
		content: '/translate/mirrorimage/translateSite/edit.jsp?id=' + siteid
	});
}
</script>
<!-- 源站本身相关 - end -->


<hr/>


<!-- 翻译控制 - start -->
<div id="site">
	<h2>翻译控制</h2>
	<botton class="layui-btn layui-btn-sm" onclick="editSiteSet();" style="margin-left: 3px;">编辑</botton>
	<div>
		执行的JavaScript：
	</div>
	<div id="translateSiteSet-executeJs">
		加载中...
	</div>
	
	<div>
		执行的JavaScript：
	</div>
	<div id="translateSiteSet-htmlAppendJs">
		加载中...
	</div>
</div>
<script>
/**
 * 加载数据
 */
function loadSiteSetData() {
	wm.post("/translate/mirrorimage/translateSiteSet/details.json", {id : siteid}, function(data) {
		if (data.result == '1') {
			// 将接口获取到的数据自动填充到 form 表单中
			
			document.getElementById('translateSiteSet-executeJs').innerHTML = data.translateSiteSet.executeJs;
			document.getElementById('translateSiteSet-htmlAppendJs').innerHTML = data.translateSiteSet.htmlAppendJs;
		} else if (data.result == '0') {
			msg.failure(data.info);
		} else {
			msg.failure(result);
		}
	}, "text");
}
loadSiteSetData();

/**
 * 编辑翻译控制
 */
function editSiteSet() {
	layer.open({
		type: 2, 
		title: '翻译控制', 
		area: ['750px', '660px'],
		shadeClose: false, // 关闭遮罩关闭
		content: '/translate/mirrorimage/translateSiteSet/edit.jsp?id=' + siteid
	});
}
</script>

<!-- 翻译控制 - end -->

<hr/>

<!-- 翻译队列排队情况 - start -->
<h2>翻译任务排队情况</h2>
<div id="waitingProgress"></div>
<script>
/**
 * 加载数据
 */
function loadWaitingProgressData() {
	wm.post("/translate/generate/waitingProgress.json", {siteid : siteid}, function(data) {
		if (data.result == '1') {
			// 将接口获取到的数据自动填充到 form 表单中
			
			var html = '';
			if(data.allnumber < 1){
				html = '当前没有排队中的执行任务。';
			}else{
				html = '当前有'+data.allnumber+'个网站任务正在排队执行。';
			}
			
			if(data.rank < 0){
				html = html+'其中尚未有您的任务';
			}else if(data.rank - 0 == 0){
				html = html + '您的任务正在被执行中';
			}else{
				html = html+'前面还有'+data.rank+'个网站任务，执行完前面的就到您了';
			}
			document.getElementById('waitingProgress').innerHTML = html;
		} else if (data.result == '0') {
			msg.failure(data.info);
		} else {
			msg.failure(result);
		}
	}, "text");
}
loadWaitingProgressData();
</script>
<!-- 翻译队列排队情况 - end -->

<hr/>

<!-- 翻译语种 - start -->
<style>
#page{ display:none; }
.toubu_xnx3_search_form{ display:none; }
</style>
<h2>翻译语种</h2>
<a href="javascript:editItem(0, '');" class="layui-btn layui-btn-normal" style="float: right; margin-right: 10px;">添加</a>

<jsp:include page="/wm/common/list/formSearch_formStart.jsp"></jsp:include>
<!-- [tag-5] -->
<jsp:include page="/wm/common/list/formSearch_input.jsp">
	<jsp:param name="iw_label" value="绑定的域名" />
	<jsp:param name="iw_name" value="domain" />
</jsp:include>
<jsp:include page="/wm/common/list/formSearch_input.jsp">
	<jsp:param name="iw_label" value="翻译语种" />
	<jsp:param name="iw_name" value="language" />
	<jsp:param name="iw_type" value="select"/>
</jsp:include>
<input type="hidden" name="siteid" value="<%=request.getParameter("siteid") %>" />
<a class="layui-btn" href="javascript:wm.list(1);" style="margin-left: 15px;">搜索</a>
</form>
<div class="iw_table">
	<div class="domain_item" v-for="item in list" id="list" style="padding-top: 3rem;">
		<div class="title">
			翻译语种：{{language[item.language]}} ({{item.language}}) 
			
			<botton class="layui-btn layui-btn-sm"
					:onclick="'editItem(\'' + item.id + '\', \'id=' + item.id + '\');'" style="margin-left: 3px;">编辑</botton>
			<botton class="layui-btn layui-btn-sm"
					:onclick="'deleteItem(\'' + item.id + '\', \'id=' + item.id + '\');'" style="margin-left: 3px;">删除</botton>
		</div>
		<div class="info">
			编号：{{item.id}} 
			&nbsp;&nbsp;&nbsp;
			访问域名：{{item.domain}}
		</div>
		<div class="gongnengcaozuo">
			<span class="siteurl">loading...</span><input type="text" value="/" id="tiaoshiyulan_path" title="您可在次填写调试预览的网页，比如填写 / 那会直接访问首页，填写比如 /a.html 、 /a/b/123.html" />
			<botton class="layui-btn layui-btn-sm" :onclick="'preview(\''+item.id+'\');'" style="margin-left: 3px;">调试预览</botton>
			<br/>
			<botton class="layui-btn layui-btn-sm" :onclick="'fileuploadConfig(\''+item.id+'\', \''+language[item.language]+'\');'" style="margin-left: 3px;">存储设置</botton>
			<br/>
			<botton class="layui-btn layui-btn-sm" :onclick="'generate(\''+item.id+'\', \''+language[item.language]+'\');'" style="margin-left: 3px;">执行翻译</botton>
			<br/>
			<a class="layui-btn layui-btn-sm" :href="'/admin/generate/logList.jsp?siteid='+item.siteid" target="_black" style="margin-left: 3px;">查看日志</a>
		</div>
	</div>
</div>
	
<!-- 通用分页跳转 -->
<jsp:include page="/wm/common/page.jsp"></jsp:include>

<script src="/fileupload-config.js"></script>
<script type="text/javascript">
// 刚进入这个页面，加载第一页的数据
wm.list(1, '/translate/mirrorimage/translateSiteDomain/list.json', function(){
	setTimeout(function(){
		var elements = document.getElementsByClassName("siteurl");
		for (var i = 0; i < elements.length; i++) {
		  elements[i].textContent = site.url;
		}
	}, 500);
});

/**
 * 添加、编辑记录信息
 * @param {Object} id 要编辑的记录的id，为0代表添加
 * @param {Object} name 要编辑的记录的名称
 */
function editItem(id, name) {
	layer.open({
		type: 2, 
		title: id > 0 ? '编辑【' + name + '】' : '添加', 
		area: ['450px', '460px'],
		shadeClose: true, // 开启遮罩关闭
		content: '/translate/mirrorimage/translateSiteDomain/edit.jsp?id=' + id +'&siteid=<%=request.getParameter("siteid") %>'
	});
}

/**
 * 管理
 * @param {Object} id domain.id
 * @param {Object} name 名称
 */
function guanli(id, name) {
	layer.open({
		type: 2, 
		title: '翻译管理【' + name + '】', 
		area: ['550px', '760px'],
		content: './guanli.jsp?id=' + id+'&name='+name
	});
}

/**
 * 根据id删除一条记录
 * @param {Object} id 要删除的记录id
 * @param {Object} name 要删除的记录的名称
 */
function deleteItem(id, name) {
	msg.confirm('是否删除【' + name + '】？', function() {
		// 显示“删除中”的等待提示
		parent.msg.loading("删除中");
		$.post('/translate/mirrorimage/translateSiteDomain/delete.json?id=' + id, function(data) {
			// 关闭“删除中”的等待提示
			parent.msg.close();
			if(data.result == '1') {
				parent.msg.success('操作成功');
				// 刷新当前页
				window.location.reload();
			} else if(data.result == '0') {
				parent.msg.failure(data.info);
			} else { 
				parent.msg.failure();
			}
		});
	}, function() {
		
	});
}

/**
 * 调试预览
 * @param id domain.id
 */
function preview(id) {
	var path = document.getElementById('tiaoshiyulan_path').value;
	if(path.length == ''){
		path = '/';
	}
	window.open('/translate/mirrorimage/translateSiteDomain/preview.jsp?domainid='+id+'&path='+path);
}

/**
 * 存储源的配置
 * @param {Object} id domain.id
 * @param {Object} name 名称
 */
function fileuploadConfig(id, name) {

	fileupload.config.quick.use({
		configUrl:'/translate/generate/translateFileuploadConfig/config.json?key='+id,
		submitUrl:"/translate/generate/translateFileuploadConfig/save.json",	//提交保存的url
		key:id
	});
	
}
 


 /**
  * 根据id,生成这个站点的html  - 提交翻译任务
  * @param {Object} id 要删除的记录id
  * @param {Object} name 要删除的记录的名称
  */
 function generate(id, name) {
 	msg.confirm('是否生成【' + name + '】的翻译html？ 翻译后的html文件会推送到您指定的存储', function() {
 		// 显示“删除中”的等待提示
 		msg.loading("提交中");
 		$.post('/translate/generate/generate.json?domainid=' + id, function(data) {
 			// 关闭“删除中”的等待提示
 			msg.close();
 			if(data.result == '1') {
 				msg.alert(data.info);
 				// 刷新当前页
 				//window.location.reload();
 			} else if(data.result == '0') {
 				parent.msg.failure(data.info);
 			} else { 
 				parent.msg.failure();
 			}
 		});
 	}, function() {
 		
 	});
 }
</script>
<!-- 翻译语种 - end -->


<!-- 底部说明 - start -->
<div style="padding: 20px;color: gray;">
	<div>提示:</div>
	<div><b>调试预览</b>：对某个页面进行翻译预览。它的作用是进行精细的调控，比如翻译之后的页面感觉某个地方不合适，或者某个图片没翻译好，可以通过此来进行调试，因为它可以针对某一个具体的页面进行调试预览，速度会很快，十来秒就能取得翻译的结果，而不需要生成整个网站后在取查看某个页面的翻译结果。
		<br/>
		当这个调试的页面感觉翻译没问题后，您就可以放心的对整站进行翻译了
	</div>
	<div><b>存储设置</b>：配置这个语种翻译之后的网页，是要存储在什么地方。比如，翻译的语种是日本，您可以在华为云OBS开通一个日本的OBS云存储，配置上，然后将日本这个语种的访问域名绑定到华为云OBS，如此当日本的用户访问时，访问到的是本国的存储节点，达到秒开。
		<br/>
		存储方式支持SFTP、FTP、华为云OBS、阿里云OSS、七牛云Kodo……多种存储方式，您可以选择您最熟悉的存储方式配置上。 
		<br/>
		（自定义存储能力扩展有开源项目 <a href="https://gitee.com/mail_osc/FileUpload" target="_black" />FileUpload</a> 提供支持）
	</div>
	<div><b>执行翻译</b>：
		进行翻译，执行翻译，将原本网站翻译为指定语种，并存储到上面您自己设置的存储位置进行存储。
		<br/>
		【注意】
		<br/>1. 测试阶段，当前只是将首页进行了翻译，如果您感觉整体没问题了，要真正对全站进行翻译，可以喊我，给你放开
		<br/>2. 点击执行后，会创建一个翻译任务，翻译任务并不会立即执行，而是进入排队期，前面排队的任务（包括别人的）都执行完后才会执行您此次的翻译任务。您可以通过“查看日志”来时时查看任务执行情况
	</div>
	<div><b>查看日志</b>：
		执行翻译任务后，每翻译一个页面，都会将翻译的页面进行写日志。您可以通过此处日志记录，来查看翻译的执行情况。
	</div>
</div>
<!-- 底部说明 - end -->


<jsp:include page="/wm/common/foot.jsp"></jsp:include>