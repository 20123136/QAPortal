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
	<title>数据字典-相对时间范围类型</title>

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

<script type="text/javascript">
	var curId = 0;
	var win;
	var pagesize = 25;
	var grid;
	var form;
	var actiontype = "";

	var fields = [
				   {name: 'id'},
				   {name: 'name'},
				   {name: 'desc'},
				   {name: 'value'},
				   {name: 'typeId'},
				   {name: 'status'}
				];

	function buttonMove(toward){
		var sm = grid.getSelectionModel();
		var data = sm.getSelections();
		if (sm.hasSelection()) {
			//获取选择行第1行
			var rec = sm.getSelected();
			var ds = grid.getStore();
			//默认的插入行
			var rowIndex = ds.indexOfId(rec.id) + toward;
			//判断插入是否已选择，如果已选择，重新获取插入行
			var ri = []; //插入行的行号数组
			for (var i = 1; i < data.length; i++) {
				var index = ds.indexOfId(data[i].id)
				ri.push(index);
			}
			//对插入行数组进行排序，下移顺序排序，上移反序排序
			if (toward == 1) {
				ri.sort(function(x, y){
					if (parseInt(x) > parseInt(y))
						return 1
					else
						return -1
				})
			}
			else {
				ri.sort(function(x, y){
					if (parseInt(x) > parseInt(y))
						return -1
					else
						return 1
				})
			}
			//如果插入行是选择行，则插入行前移或后移
			for (var i = 0; i < ri.length; i++) {
				if (rowIndex == ri[i])
					rowIndex += toward;
			}

			//更新按钮状态
			if(rowIndex > 0) {
				Ext.getCmp('btnMoveUp').setDisabled(false);
			} else {
				Ext.getCmp('btnMoveUp').setDisabled(true);
			}
			if(rowIndex < ds.getCount() - 1) {
				Ext.getCmp('btnMoveDown').setDisabled(false);
			} else {
				Ext.getCmp('btnMoveDown').setDisabled(true);
			}

			//判断插入行是否已在顶部或底部，不是则执行移动操作
			if (rowIndex < 0) {
				Ext.Msg.alert('信息', '记录已在顶部');
			}
			else
				if (rowIndex >= ds.getCount()) {
					Ext.Msg.alert('信息', '记录已在底部');
				}
				else {
					move(rowIndex, data);
				}
		}
		else {
			Ext.Msg.alert('信息', '请选择记录');
		}
	}

	function move(rindex, data){
		var ds = grid.getStore(), rdata = ds.getAt(rindex); // 获取插入行的记录
		var toward = 0; // 默认是上移操作
		var index = ds.indexOfId(data[0].id);

		if (rindex > index){
			toward = 1 // 如果是下移，修改方向值
		}

		// 移除选择行
		for (i = 0; i < data.length; i++) {
			ds.remove(ds.getById(data[i].id));
		}
		// 根据id获取插入行的新位置并根据移动操作计算出插入位置
		rindex = ds.indexOfId(rdata.id) + toward;
		// 从插入位置依次插入选择行
		for (i = 0; i < data.length; i++) {
			ds.insert(rindex, data[i]);
			rindex++;
		}

		var sm = grid.getSelectionModel();
		if (sm)sm.selectRecords(data);// 重新选择选择行
		
		Ext.getCmp('btnSave').setDisabled(false);
	}

	Ext.onReady(function(){
		var store = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			remoteSort: true,

			fields: fields,
			
			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'Dicts/Type/RELATIVE_TIME_TYPE'
			})

		});

		var toolbar = new Ext.Toolbar({
			width: '100%'
		});

		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnReflash',
				text: '刷新',
				iconCls: 'refreshbtn',
				listeners: {
					'click': function(obj, e) {
						store.reload(store.lastOptions);
					}
				}
			})
		);
		toolbar.addSeparator();

		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnAdd',
				text: '添加',
				iconCls: 'dictaddbtn',
				listeners: {
					'click': function(obj, e) {
						actiontype = "add";
						win.setTitle("添加范围类型");
						win.setIconClass("dictaddbtn");
						win.show(this);
						form.form.reset();
					}
				}
			})
		);
		toolbar.addSeparator()
	
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnEdit',
				text: '编辑',
				disabled: true,
				iconCls: 'dicteditbtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('编辑范围类型', '请选择要修改的范围类型！');
						} else {
							actiontype = "edit";
							win.setTitle("编辑范围类型");
							win.setIconClass("dicteditbtn");
							win.show(this);
							form.form.reset();
							form.form.setValues(rec.data);
						}
					}
				}
			})
		);
		toolbar.addSeparator();
		
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnDelete',
				text: '删除',
				disabled: true,
				iconCls: 'dictdelbtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('删除范围类型', '请选择要删除的范围类型！');
						} else {
							Ext.Msg.show({
								title:'删除范围类型',
								msg: '请再次确实是否要将选择的范围类型删除?',
								buttons: Ext.Msg.YESNOCANCEL,
								fn: function(btn, text) {
									if(btn == "yes") {
										var ids = new Array();
										Ext.each(grid.getSelectionModel().getSelections(), function(rec) {
											ids.push(rec.get('id'));
										});
										grid.el.mask('请求已提交，请等待', 'x-mask-loading');
										Ext.Ajax.request({
											url: window.webRoot + 'Dict',
											method: 'POST',
											params: {
												_method: 'DELETE',
												id: ids
											},
											success: function(response,options) {
												grid.el.unmask();
												var respText = Ext.util.JSON.decode(response.responseText);
												if(respText.code == 'OK') {
													store.load();
												} else {
													Ext.Msg.alert('删除失败', '删除范围类型失败！');
												}
											},
											failure: function() {
												grid.el.unmask();
												Ext.Msg.alert('删除失败', '删除范围类型失败！');
											}
										});
									}
								},
								icon: Ext.MessageBox.QUESTION
							});						
						}
					}
				}
			})
		);
		toolbar.addSeparator();
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnMoveUp',
				text: '上移',
				disabled: true,
				iconCls: 'upbtn',
                scope: this,
				listeners: {
					'click': function(obj, e) {
						buttonMove(-1);
					}
                }
			})
		);
		toolbar.addSeparator();
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnMoveDown',
				text: '下移',
				disabled: true,
				iconCls: 'downbtn',
                scope: this,
				listeners: {
					'click': function(obj, e) {
						buttonMove(1);
					}
                }
			})
		);
		toolbar.addSeparator();
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnSave',
				text: '保存顺序',
				disabled: true,
				iconCls: 'savebtn',
                scope: this,
				listeners: {
					'click': function(obj, e) {
						Ext.Msg.show({
							title:'保存顺序',
							msg: '请再次确实是否要保存当前顺序?',
							buttons: Ext.Msg.YESNOCANCEL,
							fn: function(btn, text) {
								if(btn == "yes") {
									var ids = new Array();
									for (var i = 0; i < grid.getStore().getCount(); i++) {
										ids.push(grid.getStore().data.items[i].id);
									}
									grid.el.mask('请求已提交，请等待', 'x-mask-loading');
									Ext.Ajax.request({
										url: window.webRoot + 'Dict/Order',
										method: 'POST',
										params: {
											_method: 'PUT',
											id: ids
										},
										success: function(response,options) {
											grid.el.unmask();
											var respText = Ext.util.JSON.decode(response.responseText);
											if(respText.code == 'OK') {
												Ext.getCmp('btnSave').setDisabled(true);
												Ext.Msg.alert('保存成功', '保存顺序成功！');
											} else {
												Ext.Msg.alert('保存失败', '保存顺序失败！');
											}
										},
										failure: function() {
											grid.el.unmask();
											Ext.Msg.alert('保存失败', '保存顺序失败！');
										}
									});
								}
							},
							icon: Ext.MessageBox.QUESTION
						});
					}
                }
			})
		);
		toolbar.addSeparator();


		var sm = new Ext.grid.CheckboxSelectionModel();

		grid = new Ext.grid.GridPanel({
			title: '相对时间范围类型',
			iconCls: 'dictbtn',
            region: 'center',
			tbar: toolbar,
			store: store,
			border: false,
			selModel: sm,
			enableDragDrop : true,
			ddGroup: 'gridDD', 
			dropConfig: {appendOnly:false}, 
			columns: [
				sm, 
				new Ext.grid.RowNumberer(), 
				{
					header   : '名称', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'name'
				},
				{
					header   : '值', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'value'
				},
				{
					header   : '描述', 
					width    : .3, 
					sortable : true, 
					dataIndex: 'desc'
				}
			],
//			stripeRows: true,
			height: 600,
			width: '100%',
			viewConfig: {forceFit:true}, 
			loadMask: true
		});

		grid.addListener('render', function(obj, e) {
			new Ext.dd.DropTarget(grid.getEl(), {  
				ddGroup: 'gridDD',  
				copy    : false,  
				notifyDrop: function (dd, e, data) {  
					//选择行  
					var rows = grid.getSelectionModel().getSelections();  
					//选择行数  
					var count = rows.length;  
					//拖动到几行  
					var dropIndex = dd.getDragData(e).rowIndex;  
					var array=[];  
					for(var i=0;i<count;i++){  
						var index = dropIndex+i;  
						array.push(index);  
					}  
					grid.getStore().remove(grid.getStore().getById(data.selections[0].id));  
					grid.getStore().insert(dropIndex,data.selections);   
					grid.getSelectionModel().selectRows(array);   
					grid.getView().refresh();     
					Ext.getCmp('btnSave').setDisabled(false);
				}  
			}); 
		});    


		/** 列表双击操作 Start */
		grid.addListener('rowdblclick', function(obj, e) {
			Ext.getCmp('btnEdit').fireEvent('click'); 
		});    
		/** 列表双击操作 End */
		
		/** 列表右键点击菜单 Start */
		var rightClick = new Ext.menu.Menu();
			rightClick.add({
				text : '添加',
				iconCls : 'dictaddbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnAdd').fireEvent('click'); 
					}
			});
			rightClick.add({
				text : '编辑',
				iconCls : 'dicteditbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnEdit').fireEvent('click'); 
					}
			});
			rightClick.add({
				text : '删除',
				iconCls : 'dictdelbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnDelete').fireEvent('click'); 
					}
			});
		grid.addListener('rowcontextmenu', function(client, rowIndex, e) {
			e.preventDefault();
            rightClick.showAt(e.getXY());
		});
		/** 列表右键点击菜单 End */	  
		
		grid.on('rowclick', function(grid, rowIndex, e) {
			try {
				Ext.getCmp('btnEdit').setDisabled(false);
				Ext.getCmp('btnDelete').setDisabled(false);
				if(rowIndex > 0) {
					Ext.getCmp('btnMoveUp').setDisabled(false);
				} else {
					Ext.getCmp('btnMoveUp').setDisabled(true);
				}
				if(rowIndex < grid.getStore().getCount() - 1) {
					Ext.getCmp('btnMoveDown').setDisabled(false);
				} else {
					Ext.getCmp('btnMoveDown').setDisabled(true);
				}
			} catch (e)	{
			}
		});
		
		store.load({params:{start:0, limit:pagesize}});

		form = new Ext.FormPanel({
			labelWidth: 75,
			frame:true,
			width: 520,
			defaults: {width: 200},
			defaultType: 'textfield',

			items: [
				{
					fieldLabel: 'id',
					name: 'id',
					hidden:true
				},{
					fieldLabel: '名称(*)',
					name: 'name',
					width: 200,
					allowBlank:false
				},{
					fieldLabel: '值(*)',
					name: 'value',
					width: 200,
					allowBlank:false
				},{
					fieldLabel: '描述',
					name: 'desc',
					width: 380,
					allowBlank:true
				}
			],

			buttons: [{
				text: '保&nbsp;存',
				handler: function() {
					if(form.form.isValid()) {
						if(actiontype == "add") {
							form.form.submit({
								url: window.webRoot + 'Dict/Type/RELATIVE_TIME_TYPE',
								method: 'POST',
								params: {
									_method: 'POST'
								},
								success: function(form, action) {
									Ext.Msg.alert('保存成功', '添加范围类型成功！');
									store.load();
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
											Ext.Msg.alert('保存失败', '添加范围类型失败！(' + action.result.message + ')');
									}
								},
								waitMsg: '数据保存中，请稍候...'
							});
						}
						if(actiontype == "edit") {
							var vals = form.form.getValues();
							form.form.submit({
								url: window.webRoot + 'Dict/' + vals.id,
								method: 'POST',
								params: {
									_method: 'PUT'
								},
								success: function(form, action) {
									Ext.Msg.alert('修改成功', '修改范围类型成功！');
									store.load();
									win.hide();
								},
								failure: function(form, action) {
									switch (action.failureType) {
										case Ext.form.Action.CLIENT_INVALID:
											Ext.Msg.alert('修改失败', '数据字段格式错误！');
											break;
										case Ext.form.Action.CONNECT_FAILURE:
											Ext.Msg.alert('修改失败', '连接异常！');
											break;
										case Ext.form.Action.SERVER_INVALID:
											Ext.Msg.alert('修改失败', '修改范围类型失败！(' + action.result.message + ')');
									}
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

		store.on('beforeload', function(loader, node) {
		});	
		
		var viewport = new Ext.Viewport({
			layout: 'border',
			autoHeight: true,
			border: false,
			items: [grid]
		});	

		win = new Ext.Window({
			layout:'fit',
			width: 520,
			height:180,
			closeAction:'hide',
			modal: true,
			plain: true,
			title: "添加范围类型",
			iconCls: "addbtn",
			items: [form]
		});
		
	});	
	</script>

</head>
<body>
</body>
</html>
