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
	<title>事件</title>
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
    <script type="text/javascript" src="../js/app/common/ComboBox.js"></script>
    <script type="text/javascript" src="../js/app/mgr/DataSourceSelector.js"></script>
    <script type="text/javascript" src="../js/app/mgr/WechatUserSelectorWindow.js"></script>
    <script type="text/javascript" src="../js/app/mgr/WechatUserSelectorGrid.js"></script>
    <script type="text/javascript" src="../js/app/rec/WechatUserTwinTriggerField.js"></script>
    <script type="text/javascript" src="../js/app/mgr/WechatTempSelectorWindow.js"></script>
    <script type="text/javascript" src="../js/app/mgr/WechatTempSelectorGrid.js"></script>
    <script type="text/javascript" src="../js/app/rec/WechatTempTwinTriggerField.js"></script>
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


	var field=new Array();
	
	Ext.onReady(function(){
 	
		Ext.QuickTips.init();
		
		field.push(new Ext.app.rec.WechatUserTwinTriggerField({
			id:'txtWechatName',
			name:'wechatname',
			width:530,
			fieldLabel:'用户：'
		}) );
		
		field.push(new Ext.app.rec.WechatUserTwinTriggerField({
			id:'txtWechatTemp',
			name:'wechattemp',
			width:530,
			fieldLabel:'模版：'
		})
		);
		
		field.push(new Ext.app.common.TextField({
			width: 530,
			fieldLabel: '内容：',
			name: 'context'
		}));

		var form = new Ext.form.FormPanel({
			region:'center',
			title: '事件配置',
			iconCls: 'setting',
			bodyStyle: 'padding:15px',
			border: false,
			autoScroll: true,
			defaults: {
				msgTarget: 'qtip'
			},
/* 			items: [
				{
					xtype: 'fieldset',
					labelWidth: 130,
					title: 'xxx事件',
					width: 700,
					items :[{
						xtype: 'textfield',
						fieldLabel: '临时目录*',
						id: 'txtTmpPath',
						name: 'tmpPath',
						width: 520,
						blankText:"临时目录不能为空", 
						allowBlank:false
					},{
						xtype: 'displayfield',
						fieldLabel: '',
						html:"<font color='#FF9900'>*</font>&nbsp;&nbsp;<font color='#3399FF'>临时目录用于指定录音文件调听时临时存放的绝对地址，如:D:\\QA\\TMP</font>"
					},{
						xtype: 'textfield',
						fieldLabel: '语音文件发布地址*',
						id: 'txtVoiceUrl',
						name: 'voiceUrl',
						width: 520,
						blankText:"临时目录不能为空", 
						allowBlank:false
					},{
						xtype: 'displayfield',
						fieldLabel: '',
						html:"<font color='#FF9900'>*</font>&nbsp;&nbsp;<font color='#3399FF'>语音文件发布地址用于指定语音文件发布的URL地址。如: http://127.0.0.1:8080/QAVoice"
					},{
						xtype: 'spinnerfield',
						fieldLabel: '保存天数',
						id: 'txtTmpFileKeepDays',
						name: 'tmpFileKeepDays',
						value: 3,
						width: 60,
						allowBlank:false
					},{
						xtype: 'displayfield',
						fieldLabel: '',
						html:"<font color='#FF9900'>*</font>&nbsp;&nbsp;<font color='#3399FF'>保存天数最大保留的天数</font>"
					}]
				},
				{
					xtype: 'fieldset',
					labelWidth: 130,
					title: '列表',
					width: 700,
					items :[
						{
							xtype: 'spinnerfield',
							fieldLabel: '默认每页记录数(*)',
							id: 'txtPageSize',
							name: 'pagesize',
							value: 25,
							width: 60,
							allowBlank:false
						}
					]
				},
				{
					xtype: 'fieldset',
					labelWidth: 130,
					title: '数据源',
					width: 700,
					items :[
						{
							xtype: 'radiogroup',
							id: 'radioMode',
							fieldLabel: '模式',
							items: [
								{boxLabel: '单数据源模式', name: 'mode', value: 'single', checked: true},
								{boxLabel: '多数据源模式', name: 'mode', value: 'multiple'}
							]
						},
						new Ext.app.mgr.DataSourceSelector({
							fieldLabel: '默认数据源(*)',
							id: 'cmbDataSource',
							hiddenName : 'name',
							valueField: 'name',
							displayField: 'description',
							name: 'datasource',
							width: 420
						})
					]
				},
				{
					xtype: 'fieldset',
					labelWidth: 130,
					title: '显示',
					width: 700,
					items :[
						{
							xtype: 'checkboxgroup',
							id: 'checkHideCode',
							fieldLabel: '号码隐藏',
							columns: 1,
							items: [
								{boxLabel: '隐藏呼入主叫号码', name: 'HideANI', checked: false},
								{boxLabel: '隐藏外拨被叫号码', name: 'HideDNIS', checked: false}
							]
						}
					]
				}
			], */
			buttons: [
				{
					text: '保&nbsp;&nbsp;存',
					handler: function() {
						if(form.form.isValid()) {
							var values = form.getForm().getValues();
							var items = new Array();
							var typeName = "Query";
							items.push('typeId:' + typeName + ';key:TmpFileKeepDays;value:'+encodeUrl(values.tmpFileKeepDays)+';name:保存天数;valueType:String;desc:保存天数最大保留的天数');
							items.push('typeId:' + typeName + ';key:TmpPageSize;value:'+encodeUrl(values.pagesize)+';name:每页记录数;valueType:String;desc:默认每页记录数(*)');
							items.push('typeId:' + typeName + ';key:TmpPath;value:'+encodeUrl(values.tmpPath)+';name:临时目录;valueType:String;desc:临时目录用于指定录音文件调听时临时存放的绝对地址，如:D:\\QA\\TMP');
							items.push('typeId:' + typeName + ';key:VoiceUrl;value:'+encodeUrl(values.voiceUrl)+';name:语音文件发布地址;valueType:String;desc:语音文件发布地址用于指定语音文件发布的URL地址。如: http://127.0.0.1:8080/QAVoice');
							form.el.mask('请求已提交，请等待', 'x-mask-loading');
							Ext.getCmp('checkHideCode').eachItem(function(item){
								if(item.checked) {
									mode = item.value;
								}
								items.push('typeId:' + typeName + ';key:'+item.name+';value:'+item.checked+';name:'+item.boxLabel+';valueType:Boolean');
							});
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
				url: window.webRoot + 'Confs/Type/Query',
				method: 'GET',
				success: function(response,options) {
					var respText = Ext.util.JSON.decode(response.responseText);
					if(respText.code == 'OK') {
						Ext.each(respText.data, function(conf){
							if(conf.key == 'TmpPageSize') {
								Ext.getCmp('txtPageSize').setValue(decodeUrl(conf.value));
							}
							if(conf.key == 'TmpFileKeepDays') {
								Ext.getCmp('txtTmpFileKeepDays').setValue(decodeUrl(conf.value));
							}
							if(conf.key == 'VoiceUrl') {
								Ext.getCmp('txtVoiceUrl').setValue(decodeUrl(conf.value));
							}
							if(conf.key == 'TmpPath') {
								Ext.getCmp('txtTmpPath').setValue(decodeUrl(conf.value));
							}
							if(conf.key == 'HideANI' || conf.key == 'HideDNIS') {
								Ext.getCmp('checkHideCode').eachItem(function(item){
									if(item.name == conf.key) {
										item.setValue(conf.value);
									}
								});
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
