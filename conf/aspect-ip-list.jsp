<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");

	request.setCharacterEncoding("UTF-8");

	String webRoot = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";

%>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>IP与分机对应关系</title>

    <link rel="stylesheet" type="text/css" href="../css/ext-all-notheme.css" />
    <link rel="stylesheet" type="text/css" href="../css/xtheme-gray.css" />

	<link rel="stylesheet" type="text/css" href="../css/icon.css" />

	<script >
		var webRoot = '<%=webRoot%>';
	</script>

<script type="text/javascript" src="../js/ext-base.js"></script>
<script type="text/javascript" src="../js/ext-all.js"></script>
<script type="text/javascript" src="../js/ext-lang-zh_CN.js"></script>
<script type="text/javascript" src="../js/ext-ui-combo-pagesize.js"></script>
  <style type=text/css>
        /* style rows on mouseover */
        .x-grid3-row-over .x-grid3-cell-inner {
            font-weight: bold;
        }

		.addbtn {
			background-image: url("../images/icons/fam/telephone_add.png");
		}

		.editbtn {
			background-image: url("../images/icons/fam/telephone_edit.png");
		}

		.delbtn {
			background-image: url("../images/icons/fam/telephone_delete.png");
		}
        .titletext {
            font-weight: bold;
        }
		.searchbtn {
			background-image: url("../images/default/dd/qry.gif");
		}
		.gridbtn {
			background-image:url("../images/icons/fam/monitor.png");
		}

        .busy {
			background-color:#dbdbdb;
        }

    </style>
<script type="text/javascript">
var curId = 0;
var win;
var pagesize =25;
var grid;
var dnisForm;
var actiontype = "";
var dataCache;
var stationList = "";


function decodeUrl(url) {
	url = url.replace(/\%3A/g, ':');
	url = url.replace(/\%3B/g, ';');
	return url;
}

var fields = [
			   {name: 'id'},
			   {name: 'station'},
			   {name: 'ip'},
			   {name: 'code'}

			];

Ext.onReady(function(){
	
	Ext.QuickTips.init();
	
	var store = new Ext.data.JsonStore({
		root: 'data',
		totalProperty: 'total',
		remoteSort: false,

		fields: fields,
		
		proxy: new Ext.data.HttpProxy({
			url: window.webRoot + 'AspectIps'
		})
	});

	store.setDefaultSort('station', 'asc');

/* 	store.on('beforeload', function(s, opts) {
		s.removeAll();
	}); */

	var sm = new Ext.grid.CheckboxSelectionModel();
	var columns = [
          
	        sm,
			new Ext.grid.RowNumberer(), 
			{
				header   : 'Station', 
				width    : .4, 
				sortable : false, 
				dataIndex: 'station'
			},
			{
				header   : 'IP', 
				width    : .4, 
				sortable : false, 
				dataIndex: 'ip'
			},
			{
				header   : 'code', 
				width    : .4, 
				sortable : false, 
				dataIndex: 'code'
			}];

	grid = new Ext.grid.GridPanel({
        region: 'center',
		title: 'IP对照关系',
		iconCls: 'gridbtn',
		selModel: sm,
		store: store,
		sortable:true,
		tbar: [
			{
				id: 'btnAdd',
				text: '添加',
				iconCls: 'addbtn',
				listeners: {
					'click': function(obj, e) {
						actiontype = "add";
						win.setTitle("添加");
						win.setIconClass("addbtn");
						extForm.form.reset();
						win.show(this);
					}
				}
			},
			'-',
			{
				id: 'btnEdit',
				text: '修改',
				iconCls: 'editbtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('修改', '请选择要修改的IP对应！');
						} else {
							actiontype = "edit";
							win.setTitle("修改");
							win.setIconClass("editbtn");
							extForm.form.reset();
							extForm.form.setValues(rec.data);
							win.show(this);
						}
					}
				}
			},
			'-',
			{
				id: 'btnDel',
				text: '删除',
				iconCls: 'delbtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('删除IP对应', '请选择要删除的数据！');
						} else {
							Ext.Msg.show({
								title:'删除IP对应',
								msg: '请再次确实是否要将选择的IP对应?',
								buttons: Ext.Msg.YESNOCANCEL,
								fn: function(btn, text) {
									if(btn == "yes") {
										var ids = new Array();
										Ext.each(grid.getSelectionModel().getSelections(), function(rec) {
											ids.push(rec.get('id'));
										});
										grid.el.mask('请求已提交，请等待', 'x-mask-loading');
										Ext.Ajax.request({
											url: window.webRoot + 'AspectIp',
											method: 'POST',
											params: {
												_method: 'DELETE',
												id: ids
											},
											success: function(response,options) {
												grid.el.unmask();
												var respText = Ext.util.JSON.decode(response.responseText);
												if(respText.code == 'OK') {
													var pgbar = grid.getBottomToolbar()
													var activePage = Math.ceil((pgbar.cursor + pgbar.pageSize) / pgbar.pageSize);
													var start = (activePage - 1) * pgbar.pageSize;
													store.load({params:{start:start, limit:pagesize}});
												} else {
													Ext.Msg.alert('删除失败', '删除IP对应失败！');
												}
											},
											failure: function() {
												grid.el.unmask();
												Ext.Msg.alert('删除失败', '删除IP对应失败！');
											}
										});
									}
								},
								icon: Ext.MessageBox.QUESTION
							});						
						}
					}
				}
			},
			'-',
			'IP:&nbsp;&nbsp;',
			new Ext.form.TextField({
				id: 'qryIp',
				enableKeyEvents: true,
				width: 180,
				listeners: 
					{'keypress': function(obj, e) {
							if (e.getKey() == e.ENTER) { 
								Ext.getCmp('btnSearch').fireEvent('click');  
							}
						}
					}
			}),
			'-',
			new Ext.Toolbar.Button({
				iconCls: 'searchbtn',
				id: 'btnSearch',
				text: '查询',
				listeners: 
					{'click': function(obj, e) {
							store.load({params:{start:0, limit:pagesize}});
						}
					}
			}),
			'-',
			new Ext.Toolbar.Button({
				iconCls: 'gridbtn',
				text: '显示全部',
				handler: function() {
					Ext.getCmp('qryIp').setValue('');
					store.load({params:{start:0, limit:pagesize}});
				}
			})
		],
		border: false,
		columns: columns,
		stripeRows: true,
 		viewConfig: {
 			forceFit:true,
 			enableRowBody:true	
 		},
		loadMask: true,
		bbar: new Ext.PagingToolbar({
            plugins: [new Ext.ui.plugins.ComboPageSize({ addToItem: false, prefixText: '每页', postfixText: '条'})],
			pageSize: pagesize,
			store: store,
			displayInfo: true,
			displayMsg: '当前显示第 <font color="blue">{0}</font> 到 <font color="blue">{1}</font> 条记录， 共 <font color="blue">{2}</font> 条记录',
			emptyMsg: "无记录"
		})
	});

	extForm = new Ext.FormPanel({
		labelWidth: 75,
		frame:true,
		width: 350,
		defaults: {width: 230},
		defaultType: 'textfield',

		reader: new Ext.data.JsonReader({root:'data'},fields),

		items: [
			{
				fieldLabel: 'id',
				name: 'id',
				hidden: true
			},
			{
				id: 'txtIp1',
				fieldLabel: '分机',
				name: 'station',
				allowBlank:false
			},
			{
				id: 'txtIp2',
				fieldLabel: 'IP',
				name: 'ip',
				allowBlank:false
			},{
			
				fieldLabel: 'Code',
				name: 'code',
				allowBlank:false
			}
		],

		buttons: [{
			text: '保&nbsp;存',
			handler: function() {
				if(extForm.form.isValid()) {
					if(actiontype == "add") {
						extForm.form.submit({
							url: window.webRoot + 'AspectIp',
							method: 'POST',
							params: {
								_method: 'POST'
							},
							success: function(form, action) {
								Ext.Msg.alert('保存成功', '添加IP对应成功！');
								var pgbar = grid.getBottomToolbar()
								var activePage = Math.ceil((pgbar.cursor + pgbar.pageSize) / pgbar.pageSize);
								var start = (activePage - 1) * pgbar.pageSize;
								store.load({params:{start:start, limit:pagesize}});
								win.hide();
							},
							failure: function(form, action) {
								Ext.Msg.alert('保存失败', '添加IP对应失败！');
							},
							waitMsg: '数据保存中，请稍候...'
						});
					}
					if(actiontype == "edit") {
						var vals = extForm.form.getValues();
						console.log(vals.id);
						extForm.form.submit({
							url: window.webRoot + 'AspectIp/' + vals.id,
							method: 'POST',
							params: {
								_method: 'PUT'
							},
							success: function(form, action) {
								Ext.Msg.alert('修改成功', '修改IP对应成功！');
								var pgbar = grid.getBottomToolbar()
								var activePage = Math.ceil((pgbar.cursor + pgbar.pageSize) / pgbar.pageSize);
								var start = (activePage - 1) * pgbar.pageSize;
								store.load({params:{start:start, limit:pagesize}});
								win.hide();
							},
							failure: function(form, action) {
								Ext.Msg.alert('修改失败', '修改IP对应失败！');
							},
							waitMsg: '数据保存中，请稍候...'
						});
					}
				} else {
					Ext.Msg.alert('提示', '请填写完整在提交！');
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
		title: "添加",
		iconCls: "addbtn",
		items: [extForm]
	});

	store.load({params:{start:0, limit:pagesize}});

	store.on('beforeload', function(loader, node) {
		var ip = Ext.getCmp('qryIp').getValue();
		store.baseParams = {ip:ip};
	});	

    var viewport = new Ext.Viewport({
        layout: 'border',
		autoHeight: true,
		border: false,
        items: [grid]
	});			
});	
	</script>

</head>
<body>
<div id="adduser-win" class="x-hidden"></div>
</body>
</html>
