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
	<title>录音备份-邮件报告</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <link rel="stylesheet" type="text/css" href="../css/ext-all-notheme.css" />
    <link rel="stylesheet" type="text/css" href="../css/xtheme-gray.css" />
    <link rel="stylesheet" type="text/css" href="../ux/css/DateTimePicker.css" />
     
	<link rel="stylesheet" type="text/css" href="../css/icon.css" />
   
    <script type="text/javascript" src="../js/ext-base.js"></script>
    <script type="text/javascript" src="../js/ext-all.js"></script>
    <script type="text/javascript" src="../ux/DateTimeField.js"></script>

	<script type="text/javascript" src="../js/ext-lang-zh_CN.js"></script>

	<script >
		var webRoot = '<%=webRoot%>';
	</script>

	<script type="text/javascript">
	var win, form;

	function encodeUrl(url) {
		if(url) {
			url = url.replace(/\:/g, '%3A');
			url = url.replace(/\;/g, '%3B');
			url = url.replace(/\'/g, '%60');
			url = url.replace(/\"/g, '%22');
			url = url.replace(/\=/g, '%3D');
			url = url.replace(/\?/g, '%3F');
			return url;
		} else {
			return '';
		}
	}

	function decodeUrl(url) {
		if(url) {
			url = url.replace(/\%3A/g, ':');
			url = url.replace(/\%3B/g, ';');
			url = url.replace(/\%60/g, '\'');
			url = url.replace(/\%22/g, '"');
			url = url.replace(/\%3D/g, '=');
			url = url.replace(/\%3F/g, '?');
			return url;
		} else {
			return '';
		}
	}

	Ext.onReady(function(){
 	
		Ext.QuickTips.init();

		var form = new Ext.form.FormPanel({
			labelWidth: 75,
			width: 650,
			region:'center',
			title: '邮件报告',
			iconCls: 'settings',
			bodyStyle: 'padding:15px',
			autoScroll: true,
			border: false,
			defaultType: 'textfield',
			defaults: {
				width: 230,
				msgTarget: 'side'
			},
			items: [
				{
					xtype: 'fieldset',
					labelWidth: 110,
					checkboxToggle:false,
					title: 'SMTP',
					defaultType: 'textfield',
					collapsed: false,
					collapsible: true,
					width: 720,
					items :[{
						fieldLabel: '地&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;址(*)',
						id: 'txtIpAddr',
						name: 'ipAddr',
						width: 580,
						allowBlank:false
					},{
						fieldLabel: '帐&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;号(*)',
						id: 'txtUser',
						name: 'smtpuser',
						width: 200,
						allowBlank:false
					}, {
						inputType: 'password',
						id: 'txtPassword',
						fieldLabel: '密&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;码(*)',
						width: 200,
						name: 'smtppassword',
						allowBlank:false
					}, {
						id: 'txtFrom',
						fieldLabel: '发送者邮件地址',
						width: 200,
						name: 'smtpfrom',
						allowBlank:true
					}]
				},
				{
					xtype: 'fieldset',
					labelWidth: 110,
					checkboxToggle:false,
					title: '邮件模板（备份任务）',
					defaultType: 'textfield',
					collapsed: false,
					collapsible: true,
					width: 720,
					items :[{
						fieldLabel: '正&nbsp;&nbsp;常&nbsp;&nbsp;标&nbsp;&nbsp;题(*)',
						id: 'txtMailTitle',
						name: 'mailtitle',
						width: 580,
						allowBlank:false
					},{
						fieldLabel: '异&nbsp;&nbsp;常&nbsp;&nbsp;标&nbsp;&nbsp;题(*)',
						id: 'txtMailTitleFailed',
						name: 'mailtitlefailed',
						width: 580,
						allowBlank:false
					}, {
						fieldLabel: '内&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;容(*)',
						xtype: 'htmleditor',
						id: 'txtMailContent',
						width: 580,
						height: 200,
						name: 'mailcontent',
						allowBlank:false
					}]
				},
				{
					xtype: 'fieldset',
					labelWidth: 110,
					checkboxToggle:false,
					title: '邮件模板（备份报告）',
					defaultType: 'textfield',
					collapsed: false,
					collapsible: true,
					width: 720,
					items :[{
						fieldLabel: '标&nbsp;&nbsp;题(*)',
						id: 'txtReportMailTitle',
						name: 'reportmailtitle',
						width: 580,
						allowBlank:false
					}, {
						fieldLabel: '内&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;容(*)',
						xtype: 'htmleditor',
						id: 'txtReportMailContent',
						width: 580,
						height: 200,
						name: 'reportmailcontent',
						allowBlank:false
					}]
				},
				{
					xtype: 'fieldset',
					labelWidth: 110,
					checkboxToggle:false,
					title: '邮件列表',
					defaultType: 'textfield',
					collapsed: false,
					collapsible: true,
					width: 720,
					items :[{
						fieldLabel: '收&nbsp;&nbsp;件&nbsp;&nbsp;人&nbsp;&nbsp;',
						id: 'txtMailAddressTo',
						name: 'mailaddressto',
						width: 580
					},{
						fieldLabel: '抄&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;送',
						id: 'txtMailAddressCC',
						name: 'mailaddresscc',
						width: 580
					},{
						fieldLabel: '密&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;送',
						id: 'txtMailAddressBCC',
						name: 'mailaddressbcc',
						width: 580
					}]
				}
			],
			buttons: [
				{
					text: '测试连接',
					handler: function() {
						if(form.form.isValid()) {
							var values = form.getForm().getValues();
							var items = new Array();
							
							form.el.mask('请求以提交，请等待', 'x-mask-loading');

							Ext.Ajax.request({
								url: window.webRoot + 'Email/Test',
								method: 'POST',
								params: {
									ipAddr: values.ipAddr,
									smtpuser: values.smtpuser,
									smtppassword: values.smtppassword
								},
								success: function(response,options) {
									form.el.unmask();
									var respText = Ext.util.JSON.decode(response.responseText);
									if(respText.code != 'OK') {
										Ext.Msg.alert('连接失败', respText.message + "（" + respText.code + "）");
									} else {
										Ext.Msg.alert('连接成功', "连接成功！");
									}
								},
								failure: function(response,options) {
									form.el.unmask();
									Ext.Msg.alert('连接失败', '连接失败');
								}
							});
						} else {
							Ext.Msg.alert('提示', '请填写完整再提交！');
						}

					}
				},
				{
					text: '测试邮件',
					handler: function() {
						if(form.form.isValid()) {
							var values = form.getForm().getValues();
							var items = new Array();
							
							form.el.mask('请求以提交，请等待', 'x-mask-loading');

							Ext.Ajax.request({
								url: window.webRoot + 'Email/SampleMail',
								method: 'POST',
								params: {
									ipAddr: values.ipAddr,
									smtpuser: values.smtpuser,
									smtppassword: values.smtppassword
								},
								success: function(response,options) {
									form.el.unmask();
									var respText = Ext.util.JSON.decode(response.responseText);
									if(respText.code != 'OK') {
										Ext.Msg.alert('测试邮件失败', respText.message + "（" + respText.code + "）");
									} else {
										Ext.Msg.alert('测试邮件成功', "测试邮件发送成功！");
									}
								},
								failure: function(response,options) {
									form.el.unmask();
									Ext.Msg.alert('连接失败', '测试邮件发送失败');
								}
							});
						} else {
							Ext.Msg.alert('提示', '请填写完整再提交！');
						}

					}
				},
				{
					text: '保&nbsp;&nbsp;存',
					handler: function() {
						if(form.form.isValid()) {
							var values = form.getForm().getValues();
							var items = new Array();
							var typeName = "BACKUP_EMAIL";
							items.push('typeId:' + typeName + ';key:IpAddr;value:'+encodeUrl(values.ipAddr)+';name:地址;valueType:string');
							items.push('typeId:' + typeName + ';key:SmtpFrom;value:'+encodeUrl(values.smtpfrom)+';name:发送者邮件地址;valueType:string');
							items.push('typeId:' + typeName + ';key:SmtpUser;value:'+encodeUrl(values.smtpuser)+';name:帐号;valueType:string');
							items.push('typeId:' + typeName + ';key:SmtpPassword;value:'+encodeUrl(values.smtppassword)+';name:密码;valueType:string');

							items.push('typeId:' + typeName + ';key:EmailTitle;value:'+encodeUrl(values.mailtitle)+';name:标题;valueType:string');
							items.push('typeId:' + typeName + ';key:EmailTitleFailed;value:'+encodeUrl(values.mailtitlefailed)+';name:异常标题;valueType:string');
							items.push('typeId:' + typeName + ';key:EmailContent;value:'+encodeUrl(values.mailcontent)+';name:内容;valueType:string');

							items.push('typeId:' + typeName + ';key:ReportEmailTitle;value:'+encodeUrl(values.reportmailtitle)+';name:标题;valueType:string');
							items.push('typeId:' + typeName + ';key:ReportEmailContent;value:'+encodeUrl(values.reportmailcontent)+';name:内容;valueType:string');

							items.push('typeId:' + typeName + ';key:EmailAddressTo;value:'+encodeUrl(values.mailaddressto)+';name:收件人;valueType:string');
							items.push('typeId:' + typeName + ';key:EmailAddressCC;value:'+encodeUrl(values.mailaddresscc)+';name:抄送;valueType:string');
							items.push('typeId:' + typeName + ';key:EmailAddressBCC;value:'+encodeUrl(values.mailaddressbcc)+';name:密送;valueType:string');

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
			
		Ext.Ajax.request({
			url: window.webRoot + 'Confs/Type/BACKUP_EMAIL',
			success: function(response,options) {
				var respText = Ext.util.JSON.decode(response.responseText);
				if(respText.code == 'OK') {
					Ext.each(respText.data, function(conf){
						if(conf.key == 'IpAddr') {
							Ext.getCmp('txtIpAddr').setValue(decodeUrl(conf.value));
							return;
						}
						if(conf.key == 'SmtpUser') {
							Ext.getCmp('txtUser').setValue(decodeUrl(conf.value));
							return;
						}
						if(conf.key == 'SmtpPassword') {
							Ext.getCmp('txtPassword').setValue(decodeUrl(conf.value));
							return;
						}
						if(conf.key == 'SmtpFrom') {
							Ext.getCmp('txtFrom').setValue(decodeUrl(conf.value));
							return;
						}
						if(conf.key == 'EmailTitle') {
							Ext.getCmp('txtMailTitle').setValue(decodeUrl(conf.value));
							return;
						}
						if(conf.key == 'EmailTitleFailed') {
							Ext.getCmp('txtMailTitleFailed').setValue(decodeUrl(conf.value));
							return;
						}
						if(conf.key == 'EmailContent') {
							Ext.getCmp('txtMailContent').setValue(decodeUrl(conf.value));
							return;
						}
						if(conf.key == 'ReportEmailTitle') {
							Ext.getCmp('txtReportMailTitle').setValue(decodeUrl(conf.value));
							return;
						}
						if(conf.key == 'ReportEmailContent') {
							Ext.getCmp('txtReportMailContent').setValue(decodeUrl(conf.value));
							return;
						}
						if(conf.key == 'EmailAddressTo') {
							Ext.getCmp('txtMailAddressTo').setValue(decodeUrl(conf.value));
							return;
						}

						if(conf.key == 'EmailAddressCC') {
							Ext.getCmp('txtMailAddressCC').setValue(decodeUrl(conf.value));
							return;
						}

						if(conf.key == 'EmailAddressBCC') {
							Ext.getCmp('txtMailAddressBCC').setValue(decodeUrl(conf.value));
							return;
						}

					});
					//userinfo_tpl.overwrite(Ext.getCmp('user-panel').body, respText.data);
				} else {
				}
			},
			failure: function(response,options) {

			}
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
