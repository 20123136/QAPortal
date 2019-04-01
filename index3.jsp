<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
	response.setHeader("Pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.setHeader("Expires","0");

	request.setCharacterEncoding("UTF-8");	
	
	String webRoot = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<html>
<head>
	<title>东方CJ -- 录音查询及质检系统</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <link rel="stylesheet" type="text/css" href="./css/ext-all-notheme.css" />
    <link rel="stylesheet" type="text/css" href="./css/xtheme-gray.css" />
    <link rel="stylesheet" type="text/css" href="./css/common.css" />
    <link rel="stylesheet" type="text/css" href="./css/icon.css" />
    
	<script >
		var webRoot = '<%=webRoot%>';
	</script>
    <script type="text/javascript" src="./js/ext-base.js"></script>
    <script type="text/javascript" src="./js/ext-all.js"></script>
    <script type="text/javascript" src="./ux/TabCloseMenu.js"></script>
	<script type="text/javascript" src="./js/ext-lang-zh_CN.js"></script>
	<script type="text/javascript" src="./js/func.js"></script>

	<script type="text/javascript">
	var win, form;

	function go(name) {
		var tree = Ext.getCmp('tree-panel');
		tree.items.each(function(item) { 
			item.items.each(function(item) { 
				item.items.each(function(item) { 
					if(item.text == name) item.fireEvent('click');
				});
			});
		});
	}
	
	function goHome() {
		Ext.getCmp('tabApps').setActiveTab(0);
	}

	Ext.onReady(function(){
        
		var menu_tree = new Ext.Panel({
			region: 'center',
			id: 'tree-panel',
			width: 200,
			height:400,
			minSize: 175,
			maxSize: 400,
			split: true,
			border:false,		
			layout: {
				type: 'accordion',
				animate: true
			},
			items: [
				new Ext.Panel({
					title: '&nbsp;&nbsp;录音查询',
					border: false,
					layout: 'border',
					collapsed: true,
					iconCls: 'monitor',
					items: [
						new Ext.menu.Menu({
							region: 'center',
							defaults: { xtype:'menuitem'},
							floating: false,
							listeners: {
								'click': function(menu, menuitem, e){
									var tabs = Ext.getCmp('tabApps');
									var isExist = false;
									tabs.items.each(function(item) {  
										if(item.taburl == menuitem.url) {
											isExist = true;
											item.show();
											return false;
										}
									});   

									var menuurl = decodeURL(menuitem.url);

									if(!isExist) {
										Ext.getCmp('tabApps').add({
											title: menuitem.text,
											iconCls: menuitem.iconCls,
											taburl: menuitem.url,
											border: false,
											html: '<iframe frameborder="no" border=0 height="100%" width="100%" src="'+menuurl+'"></iframe>',
											closable:true
										}).show()
									}
								}
							},
							items: [
								{
									text: '录音查询',
									url: 'query/layout.jsp',
									iconCls: 'services'
								},
								{
									text: '我的录音',
									url: 'query/self-list.jsp',
									iconCls: 'logbtn'
								},
								{
									text: '调听历史',
									url: 'query/history.jsp',
									iconCls: 'logbtn'
								},
								{
									text: '收藏夹',
									url: 'query/favorite.jsp',
									iconCls: 'logbtn'
								}
							]
						})
					]
				}),
				new Ext.Panel({
					title: '&nbsp;&nbsp;质检',
					border: false,
					layout: 'border',
					collapsed: true,
					iconCls: 'voicemgrbtn',
					items: [
						new Ext.menu.Menu({
							region: 'center',
							defaults: { xtype:'menuitem'},
							floating: false,
							listeners: {
								'click': function(menu, menuitem, e){
									var tabs = Ext.getCmp('tabApps');
									var isExist = false;
									tabs.items.each(function(item) {  
										if(item.taburl == menuitem.url) {
											isExist = true;
											item.show();
											return false;
										}
									});   

									var menuurl = decodeURL(menuitem.url);

									if(!isExist) {
										Ext.getCmp('tabApps').add({
											title: menuitem.text,
											iconCls: menuitem.iconCls,
											taburl: menuitem.url,
											border: false,
											html: '<iframe frameborder="no" border=0 height="100%" width="100%" src="'+menuurl+'"></iframe>',
											closable:true
										}).show()
									}
								}
							},
							items: [
								{
									text: '质检查询',
									url: 'qa/layout.jsp',
									iconCls: 'voicebtn'
								},
								{
									text: '我的质检',
									url: 'qa/self-list.jsp',
									iconCls: 'voicebtn'
								},
								{
									text: '我的质检任务',
									url: 'qa/self-task-list.jsp',
									iconCls: 'voicebtn'
								},
								{
									text: '质检单查询',
									url: 'qa/form-query',
									iconCls: 'voicebtn'
								},
								{
									text: '质检',
									url: 'qa/quality.jsp',
									iconCls: 'voicebtn'
								},
								{
									text: '质检列表',
									url: 'qa/quality-list.jsp',
									iconCls: 'voicebtn'
								},
								{
									text: '评分界面',
									url: 'qa/scorePage.jsp',
									iconCls: 'voicebtn'
								},
								{
									text: 'html',
									url: 'qa/html.jsp',
									iconCls: 'voicebtn'
								}
							]
						})
					]
				}),
				new Ext.Panel({
					title: '&nbsp;&nbsp;统计报表',
					border: false,
					layout: 'border',
					collapsed: true,
					iconCls: 'voicemgrbtn',
					items: [
						new Ext.menu.Menu({
							region: 'center',
							defaults: { xtype:'menuitem'},
							floating: false,
							listeners: {
								'click': function(menu, menuitem, e){
									var tabs = Ext.getCmp('tabApps');
									var isExist = false;
									tabs.items.each(function(item) {  
										if(item.taburl == menuitem.url) {
											isExist = true;
											item.show();
											return false;
										}
									});   

									var menuurl = decodeURL(menuitem.url);

									if(!isExist) {
										Ext.getCmp('tabApps').add({
											title: menuitem.text,
											iconCls: menuitem.iconCls,
											taburl: menuitem.url,
											border: false,
											html: '<iframe frameborder="no" border=0 height="100%" width="100%" src="'+menuurl+'"></iframe>',
											closable:true
										}).show()
									}
								}
							},
							items: [
								{
									text: '评分结果统计',
									url: 'report/score-report.jsp',
									iconCls: 'voicebtn'
								},
								{
									text: '评分平均结果统计',
									url: 'report/avg-score-report.jsp',
									iconCls: 'voicebtn'
								},
								{
									text: '评级结果统计',
									url: 'report/grade-report.jsp',
									iconCls: 'voicebtn'
								},
								{
									text: '评级平均结果统计',
									url: 'report/avg-grade-report.jsp',
									iconCls: 'voicebtn'
								}
							]
						})
					]
				}),
				new Ext.Panel({
					title: '&nbsp;&nbsp;系统管理',
					border: false,
					layout: 'border',
					collapsed: true,
					iconCls: 'setting',
					items: [
						new Ext.menu.Menu({
							region: 'center',
							defaults: { xtype:'menuitem'},
							floating: false,
							listeners: {
								'click': function(menu, menuitem, e){
									var tabs = Ext.getCmp('tabApps');
									var isExist = false;
									tabs.items.each(function(item) {  
										if(item.taburl == menuitem.url) {
											isExist = true;
											item.show();
											return false;
										}
									});   

									var menuurl = decodeURL(menuitem.url);

									if(!isExist) {
										Ext.getCmp('tabApps').add({
											title: menuitem.text,
											iconCls: menuitem.iconCls,
											taburl: menuitem.url,
											border: false,
											html: '<iframe frameborder="no" border=0 height="100%" width="100%" src="'+menuurl+'"></iframe>',
											closable:true
										}).show()
									}
								}
							},
							items: [
								{
									text: '用户管理',
									url: 'sys/user-list.jsp',
									iconCls: 'settingbtn'
								},
								{
									text: '组织架构管理',
									url: 'sys/dept-list.jsp',
									iconCls: 'settingbtn'
								},
								{
									text: '角色管理',
									url: 'sys/role-list.jsp',
									iconCls: 'settingbtn'
								}
							]
						})
					]
				}),
				new Ext.Panel({
					title: '&nbsp;&nbsp;自动分配',
					border: false,
					layout: 'border',
					collapsed: true,
					iconCls: 'setting',
					items: [
						new Ext.menu.Menu({
							region: 'center',
							defaults: { xtype:'menuitem'},
							floating: false,
							listeners: {
								'click': function(menu, menuitem, e){
									var tabs = Ext.getCmp('tabApps');
									var isExist = false;
									tabs.items.each(function(item) {  
										if(item.taburl == menuitem.url) {
											isExist = true;
											item.show();
											return false;
										}
									});   

									var menuurl = decodeURL(menuitem.url);

									if(!isExist) {
										Ext.getCmp('tabApps').add({
											title: menuitem.text,
											iconCls: menuitem.iconCls,
											taburl: menuitem.url,
											border: false,
											html: '<iframe frameborder="no" border=0 height="100%" width="100%" src="'+menuurl+'"></iframe>',
											closable:true
										}).show()
									}
								}
							},
							items: [
								{
									text: '任务管理',
									url: 'assign/task-list.jsp',
									iconCls: 'settingbtn'
								}
							]
						})
					]
				}),
				new Ext.Panel({
					title: '&nbsp;&nbsp;系统管理',
					border: false,
					layout: 'border',
					collapsed: true,
					iconCls: 'setting',
					items: [
						new Ext.menu.Menu({
							region: 'center',
							defaults: { xtype:'menuitem'},
							floating: false,
							listeners: {
								'click': function(menu, menuitem, e){
									var tabs = Ext.getCmp('tabApps');
									var isExist = false;
									tabs.items.each(function(item) {  
										if(item.taburl == menuitem.url) {
											isExist = true;
											item.show();
											return false;
										}
									});   

									var menuurl = decodeURL(menuitem.url);

									if(!isExist) {
										Ext.getCmp('tabApps').add({
											title: menuitem.text,
											iconCls: menuitem.iconCls,
											taburl: menuitem.url,
											border: false,
											html: '<iframe frameborder="no" border=0 height="100%" width="100%" src="'+menuurl+'"></iframe>',
											closable:true
										}).show()
									}
								}
							},
							items: [
								{
									text: '配置',
									url: 'conf/conf.jsp',
									iconCls: 'settingbtn'
								},
								{
									text: '录音文件服务器管理',
									url: 'sys/filepath-list.jsp',
									iconCls: 'settingbtn'
								},
								{
									text: '权限管理',
									url: 'sys/privilege-list.jsp',
									iconCls: 'settingbtn'
								},
								{
									text: '会话管理',
									url: 'sys/session-list.jsp',
									iconCls: 'settingbtn'
								}
							]
						})
					]
				})
			]
		});

		var userinfo_tpl = new Ext.Template([
			'名称&nbsp;:&nbsp;&nbsp;&nbsp;{name}<br/>',
			'IpAddr&nbsp;:&nbsp;&nbsp;&nbsp;{ipAddr}<br/>',
			'端口&nbsp;:&nbsp;&nbsp;&nbsp;{port}<br/>'
		]);

        var viewport = new Ext.Viewport({
            layout: 'border',
            items: [
				new Ext.BoxComponent({
					region: 'north',
					height: 80,
					border: false,
					contentEl: 'layout-title'
				}), {
					region: 'west',
					title: '功能菜单',
					iconCls: 'menutree',
					width: 200,
					height:500,
					margins: '0 2 0 0',
					collapsible: true,
					items:[menu_tree, {
							region: 'south',
							id: 'user-panel',
							height:200,
							width: 200,
							title:"服务器信息",
							iconCls: 'userinfo',
							border:false,
							bodyStyle: {
								background: '#ffffff',
								padding: '7px',
								font: '9pt 仿宋'
							},
							collapsible: true
						}
					]
				},
				new Ext.TabPanel({
					id: 'tabApps',
					enableTabScroll:true,
					defaults: {autoScroll:true},
					region: 'center',
					plugins: new Ext.ux.TabCloseMenu({
						closeTabText: '关闭当前页签',
						closeOtherTabsText: '关闭其它页签',
						closeAllTabsText: '关闭所有页签'
					}),
					items: [{
						id: 'tabHome',
						title: '主页',
						iconCls: 'house',
						taburl: 'home.jsp',
						html: '<iframe frameborder="no" border=0 height="100%" width="100%" src="blank.jsp" scrolling="auto"></iframe>',
						autoScroll: true
					}]
				})
			]
        });
		
		
		//修改密码
		form = new Ext.FormPanel({
			labelWidth: 75,
			frame:true,
			width: 350,
			defaults: {width: 230},
			defaultType: 'textfield',

			items: [{
					fieldLabel: '旧密码',
					name: 'oldpwd',
					allowBlank:false,
					inputType: 'password'
				},{
					fieldLabel: '新密码',
					name: 'newpwd',
					allowBlank:false,
					inputType: 'password'
				},{
					fieldLabel: '重复新密码',
					name: 'renewpwd',
					allowBlank:false,
					inputType: 'password'
				} 
			],

			buttons: [{
				text: '保&nbsp;存',
				handler: function() {
					if(form.form.isValid()) {
						var values = form.getForm().getValues();
						if(values.newpwd != values.renewpwd) {
							Ext.Msg.alert('输入错误', '两次输入的新密码不一致！');
						} else {
							form.form.submit({
								url: './rest/user/password',
								method: 'POST',
								params: {
									_method: 'PUT'
								},
								success: function(form, action) {
									Ext.Msg.alert('保存成功', '密码修改成功！');
									win.hide();
								},
								failure: function(form, action) {
									switch (action.failureType) {
										case Ext.form.Action.CLIENT_INVALID:
											Ext.Msg.alert('保存失败', '数据字段格式错误！');
											break;
										case Ext.form.Action.CONNECT_FAILURE:
											Ext.Msg.alert('保存失败', '连接异常！');
											break;
										case Ext.form.Action.SERVER_INVALID:
										   Ext.Msg.alert('保存失败', action.result.msg);
								   }
								},
								waitMsg: '数据保存中，请稍候...'
							});
						}
					} else {
						Ext.Msg.alert('提示', '请填写完整再提交！');
					}
				}
			},{
				text: '取&nbsp;消',
				handler: function() {
					win.hide();
				}
			}]
		});

		win = new Ext.Window({
			applyTo:'adduser-win',
			layout:'fit',
			width: 350,
			height:180,
			closeAction:'hide',
			modal: true,
			plain: true,
			title: "修改密码",
			iconCls: "pri"
		});

		Ext.Ajax.request({
			url: 'Server/Active/Info',
			success: function(response,options) {
				var respText = Ext.util.JSON.decode(response.responseText);
				if(respText.code == 'OK') {
					userinfo_tpl.overwrite(Ext.getCmp('user-panel').body, respText.data);
				} else {
				}
			},
			failure: function(response,options) {
			}
		});

		Ext.getCmp('tabHome').show();
    });

	function MenuOnMouseOver(obj) {
		Ext.get(obj).addClass("x-menu-item-active");
	}

	function MenuOnMouseOut(obj) {
		Ext.get(obj).removeClass("x-menu-item-active");
	}

	function doQuit() {
		Ext.Ajax.request({
			url: 'Logout',
			success: function(response,options) {
				top.document.location.href = './login.jsp';
			},
			failure: function(response,options) {
				top.document.location.href = './login.jsp';
			}
		});
	}

	function doExit() {
		Ext.Ajax.request({
			url: 'Logout',
			success: function(response,options) {
				self.opener=null;
				self.close();
			},
			failure: function(response,options) {
				self.opener=null;
				self.close();
			}
		});
	}

	function doChangePwd() {
		form.form.reset();
		win.show();
	}
    </script>
</head>
<body onbeforeunload='doExit();return false'>
	<div id="layout-title">
		<table background="images/ocj_bg.jpg" width="100%" cellpadding="0" cellspacing="0" height="67">
			<tr>
				<td class="title" width="500px">
					<img src='images/ocj-1.jpg' border=0>
				</td>
			  <td valign="middle" align="right" width="*">
				<TABLE cellpadding="0" cellspacing="0" border='0'  height="100%">
				<TR>
				  <TD width="16"><img src="images/icons/fam/house.png"></TD>
				  <TD style="padding-top:4px;padding-left:2px;"><a class="nav-link" href="#" onclick="goHome()">主页</a></TD>
				  <TD width="12px;">&nbsp;&nbsp;</TD>
				  <TD width="16"><img src="images/icons/fam/key.png"></TD>
				  <TD style="padding-top:4px;padding-left:2px;"><a class="nav-link" href="#" onclick='doChangePwd()'>修改密码</a></TD>
				  <TD width="12px;">&nbsp;&nbsp;</TD>
				  <TD width="16"><img src="images/icons/fam/delete.png"></TD>
				  <TD style="padding-top:4px;padding-left:2px;"><a class="nav-link" style="cursor:pointer;" onclick="doQuit()">退出</a></TD>
				  <TD width="12px;">&nbsp;&nbsp;</TD>
				</TR>
				</TABLE>
			  </td>
			</tr>
		</table>
	</div> 
    <div id="west" class="x-hide-display"></div>
    <div id="tabs" class="x-hide-display"></div>
	<div id="adduser-win" class="x-hidden"></div>
</body>
</html>
