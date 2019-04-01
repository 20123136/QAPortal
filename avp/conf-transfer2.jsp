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
	<title>转接设置</title>

	<link rel="stylesheet" type="text/css" href="../css/ext-all.css" />

    <link rel="stylesheet" type="text/css" href="../css/common.css" />
    <link rel="stylesheet" type="text/css" href="../css/icon.css" />

	<script >
		var webRoot = '<%=webRoot%>';
	</script>

<script type="text/javascript" src="../js/ext-base.js"></script>
<script type="text/javascript" src="../js/ext-all.js"></script>
<script type="text/javascript" src="../js/ext-lang-zh_CN.js"></script>
<script type="text/javascript" src="../js/ext-ui-combo-pagesize.js"></script>
<script type="text/javascript" src="../js/app/common/ComboBox.js"></script>
<script type="text/javascript" src="../js/app/avp/TransferTypeSelector.js"></script>
<script type="text/javascript" src="../js/app/avp/SiteSelector.js"></script>
<script type="text/javascript">
	var curId = 0;
	var win;
	var pagesize = 25;
	var grid;
	var form;
	var actiontype = "";

	var fields = [
				   {name: 'id'},
				   {name: 'type'},
				   {name: 'desc'},
				   {name: 'name'},
				   {name: 'site'},
				   {name: 'routePoint'},
				   {name: 'order'},
				   {name: 'status'}
				];

	function showStatus(val) {
		if(val == '0') {
			return '<font style="color:green">已启用</font>';
		} else if(val == '1') {
			return '<font style="color:red">已停用</font>';
		} else {
			'';
		}
	}

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
			remoteSort: false,

			fields: fields,

			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'Conf/Transfers'
			})

		});

		store.setDefaultSort('type', 'asc');

		var toolbarHelp = new Ext.Toolbar({
			width: '100%'
		});

		toolbarHelp.addButton(
			new Ext.form.DisplayField({
				fieldLabel: '',
				style: {align: 'right'},
				html:"&nbsp;&nbsp;<font color='#FF9900'>*</font>&nbsp;&nbsp;<font color='#646464'>转接设置页面用户维护IVR转接路由点的配置，系统将根据此配置来决定转接操作需要转接到的目标号码。如果未找到相应记录，将转接失败</font>"
			})
		);

		var toolbar = new Ext.Toolbar({
			width: '100%'
		});

		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnRefresh',
				text: '刷新',
				iconCls: 'refreshbtn',
				listeners: {
					'click': function(obj, e) {
						grid.getStore().reload();
					}
				}
			})
		);
		toolbar.addSeparator()
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnAdd',
				text: '添加',
				iconCls: 'confaddbtn',
				listeners: {
					'click': function(obj, e) {
						actiontype = "add";
						win.setTitle("转接规则");
						win.setIconClass("confaddbtn");
						form.getForm().reset();
						win.show(this);
					}
				}
			})
		);
		toolbar.addSeparator()
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnEdit',
				text: '编辑',
				disabled: true,
				iconCls: 'confeditbtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('编辑进线判断规则', '请选择要修改的进线判断规则！');
						} else {
							actiontype = "edit";
							win.setTitle("编辑进线判断规则");
							win.setIconClass("confeditbtn");
							form.getForm().reset();
							form.getForm().setValues(rec.data);
							win.show(this);
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
				iconCls: 'confdelbtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('删除进线判断规则', '请选择要删除的进线判断规则！');
						} else {
							Ext.Msg.show({
								title:'删除进线判断规则',
								msg: '请再次确实是否要将选择的进线判断规则删除?',
								buttons: Ext.Msg.YESNOCANCEL,
								fn: function(btn, text) {
									if(btn == "yes") {
										var ids = new Array();
										Ext.each(grid.getSelectionModel().getSelections(), function(rec) {
											ids.push(rec.get('id'));
										});
										grid.el.mask('请求以提交，请等待', 'x-mask-loading');
										Ext.Ajax.request({
											url: window.webRoot + 'Conf',
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
													Ext.Msg.alert('删除失败', '删除进线判断规则失败！');
												}
											},
											failure: function() {
												grid.el.unmask();
												Ext.Msg.alert('删除失败', '删除进线判断规则失败！');
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
							title:'保存进线判断规则顺序',
							msg: '请再次确实是否要保存进线判断规则顺序?',
							buttons: Ext.Msg.YESNOCANCEL,
							fn: function(btn, text) {
								if(btn == "yes") {
									var ids = new Array();
									for (var i = 0; i < grid.getStore().getCount(); i++) {
										ids.push(grid.getStore().data.items[i].id);
									}
									grid.el.mask('请求以提交，请等待', 'x-mask-loading');
									Ext.Ajax.request({
										url: window.webRoot + 'Conf/Order',
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
												Ext.Msg.alert('保存成功', '保存转接规则顺序成功！');
											} else {
												Ext.Msg.alert('保存失败', '保存转接规则顺序失败！');
											}
										},
										failure: function() {
											grid.el.unmask();
											Ext.Msg.alert('保存失败', '保存转接规则顺序失败！');
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
            region: 'center',
			tbar: toolbarHelp,
			store: store,
			border: false,
			selModel: sm,
			enableDragDrop : true,
			enableDrag: true,
			columns: [
				sm,
				new Ext.grid.RowNumberer(),
				{
					header   : '地点',
					width    : .2,
					sortable : false,
					dataIndex: 'site'
				},
				{
					header   : '转接类型',
					width    : .2,
					sortable : false,
					dataIndex: 'type'
				},
				{
					header   : '目标号码',
					width    : .2,
					sortable : false,
					dataIndex: 'routePoint'
				},
				{
					header   : '描述',
					width    : .6,
					sortable : false,
					dataIndex: 'desc'
				},
				{
					header   : '状态',
					width    : .1,
					sortable : false,
					dataIndex: 'status',
					renderer : showStatus
				}
			],
			stripeRows: true,
			height: 600,
			width: '100%',
			viewConfig: {forceFit:true},
			loadMask: true,
			listeners : {
				'render' : function() {
					toolbar.render(this.tbar);
				}
            }
		});

		/** 列表双击操作 Start */
		grid.addListener('rowdblclick', function(obj, e) {
						Ext.getCmp('btnEdit').fireEvent('click');
					});
		/** 列表双击操作 End */

		/** 列表右键点击菜单 Start */
		var rightClick = new Ext.menu.Menu();
		rightClick.add({
			text : '刷新',
			iconCls : 'refreshbtn',
			handler : function(obj, e) {
					Ext.getCmp('btnRefresh').fireEvent('click'); 
				}
		});
		rightClick.addSeparator();
		rightClick.add({
			text : '添加',
			iconCls : 'confaddbtn',
			handler : function(obj, e) {
					Ext.getCmp('btnAdd').fireEvent('click');
				}
		});
		rightClick.add({
			text : '编辑',
			iconCls : 'confeditbtn',
			handler : function(obj, e) {
					Ext.getCmp('btnEdit').fireEvent('click');
				}
		});
		rightClick.add({
			text : '删除',
			iconCls : 'confdelbtn',
			handler : function(obj, e) {
					Ext.getCmp('btnDelete').fireEvent('click');
				}
		});
		rightClick.addSeparator();
		rightClick.add({
			text : '上移',
			iconCls : 'upbtn',
			handler : function(obj, e) {
					Ext.getCmp('btnMoveUp').fireEvent('click');
				}
		});
		rightClick.add({
			text : '下移',
			iconCls : 'downbtn',
			handler : function(obj, e) {
					Ext.getCmp('btnMoveDown').fireEvent('click');
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
				Ext.getCmp('btnMoveUp').setDisabled(false);
				Ext.getCmp('btnMoveDown').setDisabled(false);
			} catch (e)	{
			}
		});

		store.load({params:{start:0, limit:pagesize}});


		form = new Ext.FormPanel({
			labelWidth: 95,
			frame:true,
			width: 520,
			defaultType: 'textfield',

			items: [
				{
					fieldLabel: 'id',
					name: 'id',
					hidden:true
				},{
					fieldLabel: 'order',
					name: 'order',
					hidden:true
				},{
					fieldLabel: 'status',
					name: 'status',
					hidden:true
				},
				new Ext.app.avp.SiteSelector({
					fieldLabel: '地点(*)',
					name: 'site',
					width: 380,
					allowBlank:false,
					hiddenName: 'site'
				}),
				new Ext.app.avp.TransferTypeSelector({
					fieldLabel: '转接类型(*)',
					name: 'type',
					width: 380,
					allowBlank:false,
					hiddenName: 'type'
				}),{
					fieldLabel: '目标号码(*)',
					name: 'routePoint',
					width: 380,
					allowBlank:false
				},{
					xtype: 'textarea',
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
								url: window.webRoot + 'Conf/Transfer',
								method: 'POST',
								params: {
									_method: 'POST'
								},
								success: function(form, action) {
									Ext.Msg.alert('保存成功', '转接规则成功！');
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
											Ext.Msg.alert('保存失败', '转接规则失败！(' + action.result.message + ')');
									}
								},
								waitMsg: '数据保存中，请稍候...'
							});
						}
						if(actiontype == "edit") {
							var vals = form.form.getValues();
							form.form.submit({
								url: window.webRoot + 'Conf/Transfer/' + vals.id,
								method: 'POST',
								params: {
									_method: 'PUT'
								},
								success: function(form, action) {
									Ext.Msg.alert('修改成功', '修改进线判断规则成功！');
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
											Ext.Msg.alert('修改失败', '修改进线判断规则失败！(' + action.result.message + ')');
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

		var viewport = new Ext.Viewport({
			layout: 'border',
			autoHeight: true,
			border: false,
			items: [grid]
		});

		win = new Ext.Window({
			layout:'fit',
			width: 520,
			height:240,
			closeAction:'hide',
			modal: true,
			plain: true,
			title: "转接规则",
			iconCls: "addbtn",
			items: [form]
		});

		/** 行拖动 */
        new Ext.dd.DropTarget(grid.getEl(), {
            ddGroup: grid.ddGroup || 'GridDD',
            grid: grid,
            gridDropTarget: this,
            notifyDrop: function(dd, e, data){

                var t = e.getTarget();// 获取选择行
                var rindex = this.grid.view.findRowIndex(t);
                if (rindex === false)
                    return false;
                var ds = this.grid.getStore();
                var rdata = ds.getAt(rindex);

                // 判断插入行是否选择行，如果是不允许插入
                for (i = 0; i < data.selections.length; i++) {
                    var rowIndex = ds.indexOfId(data.selections[i].id);
                    if (rindex == rowIndex)
                        rindex = false;
                }
                move(rindex, data.selections)
                return true;
            },

            notifyOver: function(dd, e, data){
                var t = e.getTarget();
                var rindex = this.grid.view.findRowIndex(t);
                var ds = this.grid.getStore();
                for (i = 0; i < data.selections.length; i++) {
                    var rowIndex = ds.indexOfId(data.selections[i].id);
                    if (rindex == rowIndex)
                        rindex = false;
                }
                return (rindex === false) ? this.dropNotAllowed : this.dropAllowed;
            }
        });
	});
	</script>
</head>
</html>
