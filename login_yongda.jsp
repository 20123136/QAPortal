<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
	response.setHeader("Pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.setHeader("Expires","0");

	request.setCharacterEncoding("UTF-8");	
	
	String webRoot = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!--	<title>华帝 -- 录音查询及质检系统 登录</title> -->
	<title>井星 -- 录音查询系统 登录</title>
    <link rel="stylesheet" type="text/css" href="./css/ext-all-notheme.css" />
    <link rel="stylesheet" type="text/css" href="./css/xtheme-gray.css" />
	<link rel="stylesheet" type="text/css" href="./css/icon.css"/>

	<style>
		.user {
			background: url(./images/icons/fam/user.png) no-repeat 2px 2px;
		}

		.key {
			background: url(./images/icons/fam/key.png) no-repeat 2px 2px;
		}

		.key,.user {
			background-color: #FFFFFF;
			padding-left: 20px;
			font-size: 12px;
		}
	</style>
	<script >
		var webRoot = '<%=webRoot%>';
	</script>
    <script type="text/javascript" src="js/ext-base.js"></script>
    <script type="text/javascript" src="js/ext-all-debug.js"></script>
    <script type="text/javascript" src="js/func.js"></script>

	<script type="text/javascript"> 
	
	Ext.onReady(function() {

		try {
			if(parent.parent.parent.document.title != document.title) {
				parent.parent.parent.document.location.href = "<%=webRoot%>/login.jsp";
			}
		} catch (e) {
			try {
				if(parent.parent.document.title != document.title) {
					parent.parent.document.location.href = "<%=webRoot%>/login.jsp";
				}
			} catch (e) {
				try {
					if(parent.document.title != document.title) {
						parent.document.location.href = "<%=webRoot%>/login.jsp";
					}
				} catch (e) {
				}
			}
		}
		
		var fields = [
				   {name: 'name'},
				   {name: 'ipAddr'},
				   {name: 'port'},
				   {name: 'isPrimary'}
				];
		
		var serverStore = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			remoteSort: false,

			fields: fields,
			
			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'Servers'
			})

		});

		serverStore.setDefaultSort('name', 'asc');

		serverStore.load();

		var panel = new Ext.Panel({
			el : 'hello-tabs',
			autoTabs : true,
			deferredRender : false,
			border : false,
			items : {
				xtype : 'tabpanel',
				id : 'loginTabs',
				activeTab : 0,
				height : 180,
				border : false,
				items : [{
					title : "身份认证",
					xtype : 'form',
					id : 'loginForm',
					defaults : {
						width : 260
					},
					bodyStyle : 'padding:20 0 0 50',
					defaultType : 'textfield',
					labelWidth : 60,
					labelSeparator : '：',
					items : [{
								fieldLabel : '帐&nbsp;号',
								name : 'loginname',
								id : 'account',
								cls : 'user',
								blankText : '帐号不能为空,请输入!',
								maxLength : 30,
								maxLengthText : '账号的最大长度为30个字符',
								allowBlank : false,
								listeners : {
									specialkey : function(field, e) {
										if (e.getKey() == Ext.EventObject.ENTER) {
											Ext.getCmp('password').focus();
										}
									}
								}
							}, {
								fieldLabel : '密&nbsp;码',
								name : 'password',
								id : 'password',
								cls : 'key',
								inputType : 'password',
								blankText : '密码不能为空,请输入!',
								maxLength : 20,
								maxLengthText : '密码的最大长度为20个字符',
								allowBlank : false,
								listeners : {
									specialkey : function(field, e) {
										if (e.getKey() == Ext.EventObject.ENTER) {
											login();
										}
									}
								}
							}, {
								xtype: 'combo',
								fieldLabel: '服务器',
								id: 'cmbServer',
								name: 'server',
								store : serverStore,
								valueField : 'name',
								displayField : 'name',
								mode: 'local',
								typeAhead: true,
								forceSelection: true,
								editable: false,
								triggerAction: 'all',
								selectOnFocus:true,
								hiddenName: 'server',
								allowBlank:false
							}, {
								id : 'id_reg_panel',
								xtype : 'panel',
								border : false,
								hidden : true,
								html : '<br><span id=\'messageTip\' style=\'color:red\'>&nbsp;</span>'
							}]
				}, {
					title : '关于',
					contentEl : 'aboutDiv',
					defaults : {
						width : 230
					}
				}]
			}
		});

		// 清除按钮上下文菜单
		var mainMenu = new Ext.menu.Menu({
					id : 'mainMenu',
					items : [{
						text : '清除记忆',
						iconCls : 'clear_state',
						handler : function() {
							clearCookie('wilcom.login.account');
							clearCookie('wilcom.login.server');
							var account = Ext.getCmp('loginForm').findById('account');
							var server = Ext.getCmp('loginForm').findById('cmbServer');
							Ext.getCmp('loginForm').form.reset();
							account.setValue('');
							server.setValue('');
							account.focus();
						}
					}]
				});

		var win = new Ext.Window({
			title : '井星 -- 录音查询系统',
			renderTo : Ext.getBody(),
			layout : 'fit',
			width : 440,
			height : 300,
			closeAction : 'hide',
			plain : true,
			modal : true,
			collapsible : true,
			titleCollapse : true,
			maximizable : false,
			draggable : false,
			closable : false,
			resizable : false,
			animateTarget : document.body,
			items : panel,
			buttons : [{
				text : '&nbsp;登录',
				iconCls : 'login',
				handler : function() {
					if (Ext.isIE) {
						login();
					} else {
						login();
					}
				}
			}, {
				text : '&nbsp;选项',
				iconCls : 'setting',
				menu : mainMenu
			}]
		});

		win.show();

		win.on('show', function() {
			setTimeout(function() {
						var account = Ext.getCmp('loginForm').findById('account');
						var password = Ext.getCmp('loginForm').findById('password');
						var server = Ext.getCmp('loginForm').findById('cmbServer');
						var c_account = getCookie('wilcom.login.account');
						var c_server = getCookie('wilcom.login.server');
						account.setValue(c_account);
						server.setValue(c_server);
						if (Ext.isEmpty(c_account)) {
							account.focus();
						} else {
							password.focus();
						}
					}, 200);
		}, this);

		/**
		 * 提交登陆请求
		 */
		function login() {
			if (Ext.getCmp('loginForm').form.isValid()) {
				Ext.getCmp('loginForm').form.submit({
					url : 'Login',
					waitTitle : '提示',
					method : 'POST',
					waitMsg : '正在验证您的身份,请稍候.....',
					success : function(form, action) {
						var account = Ext.getCmp('loginForm').findById('account');
						var server = Ext.getCmp('loginForm').findById('cmbServer');
						setCookie("wilcom.login.account", account.getValue(), 240);
						setCookie("wilcom.login.server", server.getValue(), 240);
						window.location.href = 'index.jsp';
					},
					failure : function(form, action) {
						switch (action.failureType) {
							case Ext.form.Action.CLIENT_INVALID:
								Ext.Msg.alert('登录失败', '数据字段格式错误！');
								break;
							case Ext.form.Action.CONNECT_FAILURE:
								Ext.Msg.alert('登录失败', '连接异常！');
								break;
							case Ext.form.Action.SERVER_INVALID:
							   Ext.Msg.alert('登录失败', action.result.message);
						}
					}
				});
			}
		}

	});
	</script>
</head>
<body>
	<div id="hello-win" class="x-hidden">
	<div id="hello-tabs"><img border="0" width="430" height="60" src="./images/login_logo.jpg" />
	</div>
	</div>
	<div id="aboutDiv" class="x-hidden"
		style='color: black; padding-left: 10px; padding-top: 10px; font-size: 12px'>
	井星录音查询系统 1.0v (Wilcom&reg)<br>
	<br>
	<br>
	官方网站:<a href="http://www.wilcom.com.cn" target="_blank">www.wilcom.com.cn</a>
	</div>
</body>
</html>