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
	<title>Genesys Connector</title>
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
		url = url.replace(/\:/g, '%3A');
		url = url.replace(/\;/g, '%3B');
		return url;
	}

	function decodeUrl(url) {
		url = url.replace(/\%3A/g, ':');
		url = url.replace(/\%3B/g, ';');
		return url;
	}

	Ext.onReady(function(){
 	
		Ext.QuickTips.init();

		var vendorStore = new Ext.data.ArrayStore({
            fields: [{
                        name : "value"
                    }, {
                        name : "name"
                    }],
			data: [['Avaya', 'Avaya Connector'], ['Wilcom', 'Wilcom Connector']]
        });

		var form = new Ext.form.FormPanel({
			region:'center',
			title: '配置',
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
					title: '供应商',
					collapsible: true,
					width: 700,
					items :[
					{
						xtype: 'combo',
						fieldLabel: 'Connector 供应商*',
						id: 'cmbVendor',
						name: 'vendor',
						width: 520,
						store : vendorStore,
						valueField : 'value',
						displayField : 'name',
						mode: 'local',
						typeAhead: true,
						forceSelection: true,
						editable: false,
						triggerAction: 'all',
						selectOnFocus:true,
						hiddenName: 'vendor',
						allowBlank:false
					},{
						xtype: 'displayfield',
						fieldLabel: '',
						html:"<font color='#FF9900'>*</font>&nbsp;&nbsp;<font color='#3399FF'>Genesys Connector供应商选择</font>"
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
							var typeName = "Connector";
							items.push('typeId:' + typeName + ';key:Vendor;value:'+encodeUrl(values.vendor)+';name:Connector供应商;valueType:String;desc:Genesys Connector供应商选择');
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
				url: window.webRoot + 'Confs/Type/Connector',
				method: 'GET',
				success: function(response,options) {
					var respText = Ext.util.JSON.decode(response.responseText);
					if(respText.code == 'OK') {
						Ext.each(respText.data, function(conf){
							if(conf.key == 'Vendor') {
								Ext.getCmp('cmbVendor').setValue(decodeUrl(conf.value));
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
