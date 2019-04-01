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
	<title>基本配置</title>
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

		var langStore = new Ext.data.ArrayStore({
            fields: [{
                        name : "value"
                    }, {
                        name : "name"
                    }],
			data: [[1, '中文'], [2, '英文']]
        });

		var envStore = new Ext.data.ArrayStore({
            fields: [{
                        name : "value"
                    }, {
                        name : "name"
                    }],
			data: [['DEV', '开发环境'], ['UAT', 'UAT环境'], ['PAT', 'PAT环境']]
        });

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
					title: '目录',
					width: 700,
					collapsible: true,
					items :[{
						xtype: 'textfield',
						fieldLabel: '语音文件目录*',
						id: 'txtVoicePath',
						name: 'voicePath',
						width: 520,
						blankText:"语音文件目录不能为空", 
						allowBlank:false
					},{
						xtype: 'displayfield',
						fieldLabel: '',
						html:"<font color='#FF9900'>*</font>&nbsp;&nbsp;<font color='#3399FF'>语音文件目录用于指定语音文件存放的绝对地址，如:C:\\IVR\\VOX</font>"
					},{
						xtype: 'textfield',
						fieldLabel: '菜单配置目录*',
						id: 'txtMenuXMLPath',
						name: 'menuXMLPath',
						width: 520,
						blankText:"菜单配置目录不能为空", 
						allowBlank:false
					},{
						xtype: 'displayfield',
						fieldLabel: '',
						html:"<font color='#FF9900'>*</font>&nbsp;&nbsp;<font color='#3399FF'>菜单配置目录用于指定菜单配置文件存放的绝对地址，如:C:\\IVR\\CFG\\MENU</font>"
					},{
						xtype: 'textfield',
						fieldLabel: '本地日志目录*',
						id: 'txtLogPath',
						name: 'logPath',
						width: 520,
						blankText:"本地日志目录不能为空", 
						allowBlank:false
					},{
						xtype: 'displayfield',
						fieldLabel: '',
						html:"<font color='#FF9900'>*</font>&nbsp;&nbsp;<font color='#3399FF'>本地日志目录用于指定本地日志存放的绝对地址，如:C:\\IVR\\LOG</font>"
					},{
						xtype: 'textfield',
						fieldLabel: '传真文件目录*',
						id: 'txtFaxPath',
						name: 'faxPath',
						width: 520,
						blankText:"传真文件目录不能为空", 
						allowBlank:false
					},{
						xtype: 'displayfield',
						fieldLabel: '',
						html:"<font color='#FF9900'>*</font>&nbsp;&nbsp;<font color='#3399FF'>传真文件目录用于指定传真数据文件存放的绝对地址，如:C:\\IVR\\Fax</font>"
					}]
				},
				{
					xtype: 'fieldset',
					labelWidth: 130,
					title: '语音控制',
					collapsible: true,
					width: 700,
					items :[
					{
						xtype: 'combo',
						fieldLabel: '默认语言种类*',
						id: 'cmbDefaultLanguage',
						name: 'defaultLanguage',
						width: 520,
						store : langStore,
						valueField : 'value',
						displayField : 'name',
						mode: 'local',
						typeAhead: true,
						forceSelection: true,
						editable: false,
						triggerAction: 'all',
						selectOnFocus:true,
						hiddenName: 'defaultLanguage',
						allowBlank:false
					},{
						xtype: 'displayfield',
						fieldLabel: '',
						html:"<font color='#FF9900'>*</font>&nbsp;&nbsp;<font color='#3399FF'>进线默认语音种类</font>"
					},
					{
						xtype: 'spinnerfield',
						fieldLabel: '输入超时最大次数',
						id: 'txtMaxTimeoutTimes',
						name: 'maxTimeoutTimes',
						value: 3,
						width: 520,
						allowBlank:false
					},{
						xtype: 'displayfield',
						fieldLabel: '',
						html:"<font color='#FF9900'>*</font>&nbsp;&nbsp;<font color='#3399FF'>客户在IVR中按键输入时，最大允许的超时次数</font>"
					},
					{
						xtype: 'spinnerfield',
						fieldLabel: '输入错误最大次数',
						id: 'txtMaxInputErrorTimes',
						name: 'maxInputErrorTimes',
						value: 3,
						width: 520,
						allowBlank:false
					},{
						xtype: 'displayfield',
						fieldLabel: '',
						html:"<font color='#FF9900'>*</font>&nbsp;&nbsp;<font color='#3399FF'>客户在IVR中按键输入时，最大允许的错误次数</font>"
					}
					]
				},
				{
					xtype: 'fieldset',
					labelWidth: 130,
					title: '环境设置',
					collapsible: true,
					width: 700,
					items :[
					{
						xtype: 'combo',
						fieldLabel: '当前系统环境*',
						id: 'cmbEnv',
						name: 'env',
						width: 520,
						store : envStore,
						valueField : 'value',
						displayField : 'name',
						mode: 'local',
						typeAhead: true,
						forceSelection: true,
						editable: false,
						triggerAction: 'all',
						selectOnFocus:true,
						hiddenName: 'env',
						allowBlank:false
					},{
						xtype: 'displayfield',
						fieldLabel: '',
						html:"<font color='#FF9900'>*</font>&nbsp;&nbsp;<font color='#3399FF'>当前系统环境（开发/UAT/PAT），默认是PAT环境</font>"
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
							var typeName = "Normal";
							items.push('typeId:' + typeName + ';key:VoicePath;value:'+encodeUrl(values.voicePath)+';name:语音文件目录;valueType:String;desc:语音文件目录用于指定语音文件存放的绝对地址，如:C:\\IVR\\VOX');
							items.push('typeId:' + typeName + ';key:MenuXMLPath;value:'+encodeUrl(values.menuXMLPath)+';name:菜单配置目录;valueType:String;desc:菜单配置目录用于指定菜单配置文件存放的绝对地址，如:C:\\IVR\\CFG\\MENU');
							items.push('typeId:' + typeName + ';key:LogPath;value:'+encodeUrl(values.logPath)+';name:本地日志目录;valueType:String;desc:本地日志目录用于指定本地日志存放的绝对地址，如:C:\\IVR\\LOG');
							items.push('typeId:' + typeName + ';key:FaxPath;value:'+encodeUrl(values.faxPath)+';name:传真文件目录;valueType:String;desc:传真文件目录用于指定传真数据文件存放的绝对地址，如:C:\\IVR\\Fax');
							items.push('typeId:' + typeName + ';key:DefaultLanguage;value:'+encodeUrl(values.defaultLanguage)+';name:默认语言种类;valueType:Integer;desc:进线默认语音种类');
							items.push('typeId:' + typeName + ';key:MaxTimeoutTimes;value:'+encodeUrl(values.maxTimeoutTimes)+';name:输入超时最大次数;valueType:Integer;desc:客户在IVR中按键输入时，最大允许的超时次数');
							items.push('typeId:' + typeName + ';key:MaxInputErrorTimes;value:'+encodeUrl(values.maxInputErrorTimes)+';name:输入错误最大次数;valueType:Integer;desc:客户在IVR中按键输入时，最大允许的错误次数');
							items.push('typeId:' + typeName + ';key:ENVType;value:'+encodeUrl(values.env)+';name:系统环境;valueType:String;desc:当前系统环境（开发/UAT/PAT），默认是PAT环境');
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
				url: window.webRoot + 'Confs/Type/Normal',
				method: 'GET',
				success: function(response,options) {
					var respText = Ext.util.JSON.decode(response.responseText);
					if(respText.code == 'OK') {
						Ext.each(respText.data, function(conf){
							if(conf.key == 'VoicePath') {
								Ext.getCmp('txtVoicePath').setValue(decodeUrl(conf.value));
							}
							if(conf.key == 'MenuXMLPath') {
								Ext.getCmp('txtMenuXMLPath').setValue(decodeUrl(conf.value));
							}
							if(conf.key == 'LogPath') {
								Ext.getCmp('txtLogPath').setValue(decodeUrl(conf.value));
							}
							if(conf.key == 'FaxPath') {
								Ext.getCmp('txtFaxPath').setValue(decodeUrl(conf.value));
							}
							if(conf.key == 'DefaultLanguage') {
								Ext.getCmp('cmbDefaultLanguage').setValue(decodeUrl(conf.value));
							}
							if(conf.key == 'MaxTimeoutTimes') {
								Ext.getCmp('txtMaxTimeoutTimes').setValue(decodeUrl(conf.value));
							}
							if(conf.key == 'MaxInputErrorTimes') {
								Ext.getCmp('txtMaxInputErrorTimes').setValue(decodeUrl(conf.value));
							}
							if(conf.key == 'ENVType') {
								Ext.getCmp('cmbEnv').setValue(decodeUrl(conf.value));
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
