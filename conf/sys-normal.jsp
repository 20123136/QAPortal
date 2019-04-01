<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List"%>
<%
	response.setHeader("Pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.setHeader("Expires","0");

	request.setCharacterEncoding("UTF-8");	
	
	String webRoot = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<html>
<head>
	<title>系统配置</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <link rel="stylesheet" type="text/css" href="../css/ext-all-notheme.css" />
    <link rel="stylesheet" type="text/css" href="../css/xtheme-gray.css" />

	<link rel="stylesheet" type="text/css" href="../ux/css/Spinner.css" />
    
    <link rel="stylesheet" type="text/css" href="../css/common.css" />
    <link rel="stylesheet" type="text/css" href="../css/icon.css" />

    <script type="text/javascript" src="../js/ext-base.js"></script>
    <script type="text/javascript" src="../js/ext-all.js"></script>

	<script type="text/javascript" src="../js/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../ux/Spinner.js"></script>
    <script type="text/javascript" src="../ux/SpinnerField.js"></script>
	<script >
		var webRoot = '<%=webRoot%>';
	</script>

	<script type="text/javascript">
	var win, form;

	function encodeUrl(url) {
		if(url) {
			url = url.replace(/\:/g, '%3A');
			url = url.replace(/\;/g, '%3B');
			return url;
		} else {
			return '';
		}
	}

	function decodeUrl(url) {
		if(url) {
			url = url.replace(/\%3A/g, ':');
			url = url.replace(/\%3B/g, ';');
			return url;
		} else {
			return '';
		}
	}

	Ext.onReady(function(){
 	
		Ext.QuickTips.init();

		var form = new Ext.form.FormPanel({
			region:'center',
			title: '配置',
			iconCls: 'setting',
			bodyStyle: 'padding:15px',
			border: false,
			autoScroll: true,
			defaults: {
				msgTarget: 'qtip'
			},
			items: [
				{
					xtype: 'fieldset',
					labelWidth: 130,
					title: '系统',
					width: 700,
					collapsible: true,
					items :[{
						xtype: 'radiogroup',
						fieldLabel: '系统类型*',
						id: 'txtSysType',
						name: 'sysType',
						items: [
							{boxLabel: '录音查询系统', name: 'sysType', checked: true},
							{boxLabel: '质检系统', name: 'sysType'}
						]
					},{
						xtype: 'displayfield',
						fieldLabel: '',
						html:"<font color='#FF9900'>*</font>&nbsp;&nbsp;<font color='#3399FF'>设定当前系统运行的模式</font>"
					},{
						xtype: 'radiogroup',
						fieldLabel: '录音表模式*',
						id: 'txtSysMethod',
						name: 'sysMethod',
						items: [
							{boxLabel: '按月切表', name: 'sysMethod'},
							{boxLabel: '没有切表', name: 'sysMethod',checked: true}
						]
					},{
						xtype: 'displayfield',
						fieldLabel: '',
						html:"<font color='#FF9900'>*</font>&nbsp;&nbsp;<font color='#3399FF'>录音表是否有按月切表,默认是没有切表模式</font>"
					}]
				},
				{
					xtype: 'fieldset',
					labelWidth: 130,
					title: '密码',
					width: 700,
					collapsible: true,
					items :[{
						xtype: 'textfield',
						fieldLabel: '初始密码*',
						id: 'txtDefaultPassword',
						name: 'defaultPassword',
						width: 520,
						blankText:"初始密码不能为空", 
						allowBlank:false
					},{
						xtype: 'displayfield',
						fieldLabel: '',
						html:"<font color='#FF9900'>*</font>&nbsp;&nbsp;<font color='#3399FF'>初始密码用于设定用户初始的登录密码</font>"
					}]
				},
				{
					xtype: 'fieldset',
					labelWidth: 130,
					title: '会话',
					width: 700,
					collapsible: true,
					items :[
					{
						xtype: 'spinnerfield',
						fieldLabel: '会话有效时间',
						id: 'txtSessiontTimeout',
						name: 'sessionTimeout',
						value: 20,
						width: 60,
						allowBlank:false
					},{
						xtype: 'displayfield',
						fieldLabel: '',
						html:"<font color='#FF9900'>*</font>&nbsp;&nbsp;<font color='#3399FF'>会话最大超时时间（分钟）</font>"
					}]
				}
			],
			buttons: [
				{
					text: '保&nbsp;&nbsp;存',
					handler: function() {
						if(form.form.isValid()) {
							var values = form.getForm().getValues();
							var items = new Array();
							var typeName = "Sys";

							var sysTypeCmp = Ext.getCmp('txtSysType');
							var sysType = '';
							
							if(sysTypeCmp.items.items[0].getValue()) {
								sysType = 'RecordQuery';
							} else if (sysTypeCmp.items.items[1].getValue()) {
								sysType = 'QA';
							} else {
								sysType = 'RecordQuery';
							}
							
							sysTypeCmp = Ext.getCmp('txtSysMethod');
							var sysMethod ='';
							if(sysTypeCmp.items.items[0].getValue()) {
								sysMethod = 'true';
							} else {
								sysMethod = 'false';
							}
							

							items.push('typeId:' + typeName + ';key:SysType;value:'+sysType+';name:系统类型;valueType:String;desc:设定当前系统运行的模式');
							items.push('typeId:' + typeName + ';key:SysMethod;value:'+sysMethod+';name:录音表模式;valueType:String;desc:设定当前系统录音表运行是否有切表');
							items.push('typeId:' + typeName + ';key:DefaultPassword;value:'+encodeUrl(values.defaultPassword)+';name:初始密码;valueType:String;desc:初始密码用于设定用户初始的登录密码');
							items.push('typeId:' + typeName + ';key:SessionTimeout;value:'+encodeUrl(values.sessionTimeout)+';name:会话有效时间;valueType:String;desc:会话最大超时时间（分钟）');
							form.el.mask('请求已提交，请等待', 'x-mask-loading');
							
							Ext.Ajax.request({
								url: window.webRoot + 'Confs',
								method: 'POST',
								params: {
									item: items
								},
								success: function(response,options) {
									form.el.unmask();
									var respText = Ext.util.JSON.decode(response.responseText);
									if(respText.code != 'OK') {
										Ext.Msg.alert('保存失败', respText.message + "（" + respText.code + "）");
									} else {
										Ext.Msg.alert('保存成功', "保存成功！");
									}
								},
								failure: function(response,options) {
									form.el.unmask();
									Ext.Msg.alert('保存失败', '保存失败！');
								}
							});
						} else {
							Ext.Msg.alert('提示', '请填写完整再提交！');
						}

					}
				},
				{
					text: '取&nbsp;&nbsp;消',
					handler: function() {
						document.location.href = '../blank.jsp';
					}

				}
			]
        });
			
		form.on('render', function() {
			form.el.mask('查询中，请等待', 'x-mask-loading');
			Ext.Ajax.request({
				url: window.webRoot + 'Confs/Type/Sys',
				method: 'GET',
				success: function(response,options) {
					var respText = Ext.util.JSON.decode(response.responseText);
					if(respText.code == 'OK') {
						Ext.each(respText.data, function(conf){
							if(conf.key == 'DefaultPassword') {
								Ext.getCmp('txtDefaultPassword').setValue(decodeUrl(conf.value));
							}
							if(conf.key == 'SessionTimeout') {
								Ext.getCmp('txtSessiontTimeout').setValue(decodeUrl(conf.value));
							}
							if(conf.key == 'SysType') {
								var sysTypeCmp = Ext.getCmp('txtSysType');
								if(conf.value == 'RecordQuery') {
									sysTypeCmp.items.items[0].setValue(true);
								} else if (conf.value == 'QA') {
									sysTypeCmp.items.items[1].setValue(true);
								} else {
									sysTypeCmp.items.items[0].setValue(true);
								}
							}
							if(conf.key == 'SysMethod'){
								var sysTypeCmp = Ext.getCmp('txtSysMethod');
								if(conf.value=='true'){
									sysTypeCmp.items.items[0].setValue(true);
								}else{
									sysTypeCmp.items.items[0].setValue(false);
								}
							}
						});
					} else {
						Ext.Msg.alert('查询失败', respText.message + "（" + respText.code + "）");
					}
					form.el.unmask();
				},
				failure: function(response,options) {
					Ext.Msg.alert('查询失败', "获取配置失败！");
					form.el.unmask();
				}
			});
		});
		
		new Ext.Viewport({
			layout: 'border',
			border: false,
			items: [
				form
			],
			renderTo: Ext.getBody()
		});

    });
    </script>
</head>
<body>
</body>
</html>
