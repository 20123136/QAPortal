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
	<title>传真配置</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <link rel="stylesheet" type="text/css" href="../css/ext-all.css" />
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
		}
		return url;
	}

	function decodeUrl(url) {
		if(url) {
			url = url.replace(/\%3A/g, ':');
			url = url.replace(/\%3B/g, ';');
		}
		return url;
	}

	Ext.onReady(function(){
 	
		Ext.QuickTips.init();

		var form = new Ext.form.FormPanel({
			region:'center',
			title: '传真配置',
			iconCls: 'setting',
			bodyStyle: 'padding:15px',
			border: false,
			defaults: {
				msgTarget: 'qtip'
			},
			items: [
				{
					xtype: 'fieldset',
					labelWidth: 130,
					title: '传真验证',
					width: 700,
					collapsible: true,
					items :[{
						xtype: 'spinnerfield',
						fieldLabel: '当日最大传真数*',
						id: 'txtFaxMaxCount',
						name: 'faxMaxCount',
						value: 10,
						width: 520,
						allowBlank:false
					}]
				},
				{
					xtype: 'fieldset',
					labelWidth: 130,
					title: '传真服务器',
					width: 700,
					collapsible: true,
					items :[{
						xtype: 'textfield',
						fieldLabel: '地址*',
						id: 'txtFaxAddr',
						name: 'faxAddr',
						width: 520,
						blankText:"传真服务器地址不能为空", 
						allowBlank:false
					},{
						xtype: 'textfield',
						fieldLabel: '端口*',
						id: 'txtFaxPort',
						name: 'faxPort',
						width: 520,
						blankText:"传真服务器端口不能为空", 
						allowBlank:false
					},{
						xtype: 'spinnerfield',
						fieldLabel: '超时时长(秒)*',
						id: 'txtFaxTimeout',
						name: 'faxTimeout',
						value: 3,
						width: 520,
						allowBlank:false
					}]
				},
				{
					xtype: 'fieldset',
					labelWidth: 130,
					title: '传真文件服务器',
					collapsible: true,
					width: 700,
					items :[
					{
						xtype: 'textfield',
						fieldLabel: 'Ftp地址*',
						id: 'txtFaxDocAddr',
						name: 'faxDocAddr',
						width: 520,
						blankText:"传真文件服务器地址不能为空", 
						allowBlank:false
					},{
						xtype: 'textfield',
						fieldLabel: 'Ftp端口*',
						id: 'txtFaxDocPort',
						name: 'faxDocPort',
						width: 520,
						blankText:"传真文件服务器端口不能为空", 
						allowBlank:false
					},{
						xtype: 'textfield',
						fieldLabel: 'Ftp用户名*',
						id: 'txtFaxDocUser',
						name: 'faxDocUser',
						width: 520,
						blankText:"传真文件服务器用户名不能为空", 
						allowBlank:false
					},{
						xtype: 'textfield',
						fieldLabel: 'Ftp密码*',
						id: 'txtFaxDocPassword',
						name: 'faxDocPassword',
						width: 520,
						blankText:"传真文件服务器密码不能为空", 
						allowBlank:false
					},{
						xtype: 'textfield',
						fieldLabel: 'Ftp初始目录',
						id: 'txtFaxDocPath',
						name: 'faxDocPath',
						width: 520,
						allowBlank:true
					}
					]
				}
			],
			buttons: [
				{
					text: '保&nbsp;&nbsp;存',
					handler: function() {
						if(form.form.isValid()) {
							var values = form.getForm().getValues();
							var items = new Array();
							var typeName = "Fax";
							items.push('typeId:' + typeName + ';key:FaxAddr;value:'+encodeUrl(values.faxAddr)+';name:地址;valueType:String;desc:');
							items.push('typeId:' + typeName + ';key:FaxPort;value:'+encodeUrl(values.faxPort)+';name:端口;valueType:String;desc:');
							items.push('typeId:' + typeName + ';key:FaxTimeout;value:'+encodeUrl(values.faxTimeout)+';name:超时时长;valueType:Integer;desc:');
							items.push('typeId:' + typeName + ';key:FaxDocAddr;value:'+encodeUrl(values.faxDocAddr)+';name:Ftp地址;valueType:String;desc:');
							items.push('typeId:' + typeName + ';key:FaxDocPort;value:'+encodeUrl(values.faxDocPort)+';name:Ftp端口;valueType:String;desc:');
							items.push('typeId:' + typeName + ';key:FaxDocUser;value:'+encodeUrl(values.faxDocUser)+';name:Ftp用户名;valueType:String;desc:');
							items.push('typeId:' + typeName + ';key:FaxDocPassword;value:'+encodeUrl(values.faxDocPassword)+';name:Ftp密码;valueType:String;desc:');
							items.push('typeId:' + typeName + ';key:FaxDocPath;value:'+encodeUrl(values.faxDocPath)+';name:Ftp初始目录;valueType:String;desc:');
							items.push('typeId:' + typeName + ';key:FaxMaxCount;value:'+encodeUrl(values.faxMaxCount)+';name:当日最大传真数;valueType:String;desc:');

							form.el.mask('请求以提交，请等待', 'x-mask-loading');
							
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
				url: window.webRoot + 'Confs/Type/Fax',
				method: 'GET',
				success: function(response,options) {
					var respText = Ext.util.JSON.decode(response.responseText);
					if(respText.code == 'OK') {
						Ext.each(respText.data, function(conf){
							if(conf.key == 'FaxDocAddr') {
								Ext.getCmp('txtFaxDocAddr').setValue(decodeUrl(conf.value));
							}
							if(conf.key == 'FaxDocPort') {
								Ext.getCmp('txtFaxDocPort').setValue(decodeUrl(conf.value));
							}
							if(conf.key == 'FaxDocUser') {
								Ext.getCmp('txtFaxDocUser').setValue(decodeUrl(conf.value));
							}
							if(conf.key == 'FaxDocPassword') {
								Ext.getCmp('txtFaxDocPassword').setValue(decodeUrl(conf.value));
							}
							if(conf.key == 'FaxDocPath') {
								Ext.getCmp('txtFaxDocPath').setValue(decodeUrl(conf.value));
							}
							if(conf.key == 'FaxAddr') {
								Ext.getCmp('txtFaxAddr').setValue(decodeUrl(conf.value));
							}
							if(conf.key == 'FaxPort') {
								Ext.getCmp('txtFaxPort').setValue(decodeUrl(conf.value));
							}
							if(conf.key == 'FaxTimeout') {
								Ext.getCmp('txtFaxTimeout').setValue(decodeUrl(conf.value));
							}
							if(conf.key == 'FaxMaxCount') {
								Ext.getCmp('txtFaxMaxCount').setValue(decodeUrl(conf.value));
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
