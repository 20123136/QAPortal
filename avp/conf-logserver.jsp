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
	<title>LogServer配置</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <link rel="stylesheet" type="text/css" href="../css/ext-all.css" />
    <link rel="stylesheet" type="text/css" href="../ux/css/Spinner.css" />
    
    <link rel="stylesheet" type="text/css" href="../css/common.css" />
    <link rel="stylesheet" type="text/css" href="../css/icon.css" />
    <link rel="stylesheet" type="text/css" href="../ux/css/DateTimePicker.css" />

    <script type="text/javascript" src="../js/ext-base.js"></script>
    <script type="text/javascript" src="../js/ext-all.js"></script>

	<script type="text/javascript" src="../js/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../ux/Spinner.js"></script>
    <script type="text/javascript" src="../ux/SpinnerField.js"></script>
    <script type="text/javascript" src="../ux/DateTimeField.js"></script>
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
			title: 'LogServer配置',
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
					title: '日志备份',
					width: 700,
					collapsible: true,
					items :[{
						xtype: 'textfield',
						fieldLabel: '备份文件目录*',
						id: 'txtBackupPath',
						name: 'backupPath',
						width: 520,
						blankText:"备份文件目录不能为空", 
						allowBlank:false
					},{
						xtype: 'displayfield',
						fieldLabel: '',
						html:"<font color='#FF9900'>*</font>&nbsp;&nbsp;<font color='#3399FF'>备份文件目录用于指定压缩后备份文件存放的绝对地址，如:C:\\IVR\\LOG\\Backup</font>"
					},
					{
						xtype: 'spinnerfield',
						fieldLabel: '日志保留天数*',
						id: 'txtKeepDays',
						name: 'keepDays',
						value: 60,
						width: 520,
						allowBlank:false
					},{
						xtype: 'displayfield',
						fieldLabel: '',
						html:"<font color='#FF9900'>*</font>&nbsp;&nbsp;<font color='#3399FF'>日志保留天数用于设定日志最大保存的天数，如果在这个数字之前的日志将被压缩并存入备份目录中</font>"
					},
					new Cls.form.DateTimeField({
						id: 'txtExecuteTime',
						width: 520,
						emptyText: 'HH:mm',
						fieldLabel: '备份执行时间*',
						name: 'executeTime',
						format: 'H:i',			
						allowBlank:false
					}),
					{
						xtype: 'displayfield',
						fieldLabel: '',
						html:"<font color='#FF9900'>*</font>&nbsp;&nbsp;<font color='#3399FF'>备份执行时间用于设定日志备份任务开始执行的时间，如: 01:00</font>"
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
							var typeName = "LogServer";
							items.push('typeId:' + typeName + ';key:BackupPath;value:'+encodeUrl(values.backupPath)+';name:备份文件目录;valueType:String;desc:备份文件目录用于指定压缩后备份文件存放的绝对地址，如:C:\\IVR\\LOG\\Backup');
							items.push('typeId:' + typeName + ';key:ExecuteTime;value:'+encodeUrl(values.executeTime)+';name:备份执行时间;valueType:String;desc:备份执行时间用于设定日志备份任务开始执行的时间，如: 01:00');
							items.push('typeId:' + typeName + ';key:KeepDays;value:'+encodeUrl(values.keepDays)+';name:日志保留天数;valueType:String;desc:日志保留天数用于设定日志最大保存的天数，如果在这个数字之前的日志将被压缩并存入备份目录中');
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
				url: window.webRoot + 'Confs/Type/LogServer',
				method: 'GET',
				success: function(response,options) {
					var respText = Ext.util.JSON.decode(response.responseText);
					if(respText.code == 'OK') {
						Ext.each(respText.data, function(conf){
							if(conf.key == 'BackupPath') {
								Ext.getCmp('txtBackupPath').setValue(decodeUrl(conf.value));
							}
							if(conf.key == 'KeepDays') {
								Ext.getCmp('txtKeepDays').setValue(decodeUrl(conf.value));
							}
							if(conf.key == 'ExecuteTime') {
								Ext.getCmp('txtExecuteTime').setValue(decodeUrl(conf.value));
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
