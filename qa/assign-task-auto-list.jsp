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
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>自动质检抽样任务管理</title>
 
    <link rel="stylesheet" type="text/css" href="../css/ext-all-notheme.css" />
    <link rel="stylesheet" type="text/css" href="../css/xtheme-gray.css" />

    <link rel="stylesheet" type="text/css" href="../css/icon.css" />
    <link rel="stylesheet" type="text/css" href="../css/common.css" />
	<script>
		var webRoot = '<%=webRoot%>';
	</script>
 
    <script type="text/javascript" src="../js/ext-base-debug.js"></script>
    <script type="text/javascript" src="../js/ext-all-debug.js"></script>
    <script type="text/javascript" src="../js/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../js/ext-ui-combo-pagesize.js"></script>
    <script type="text/javascript" src="../ux/ColumnHeaderGroup.js"></script>

	<script type="text/javascript" src="../js/func.js"></script>

	<script type="text/javascript">
	var curId = 0;
	var pagesize = 25;
	var grid;

	var hisgrid, hiswin;

	var fields = [
				   {name: 'id'},
				   {name: 'no'},
				   {name: 'desc'},
				   {name: 'typeId'},
				   {name: 'scheduleType'},
				   {name: 'scheduleTime'},
				   {name: 'createUserName'},
				   {name: 'createUserId'},
				   {name: 'createTime'},
				   {name: 'displayExecuteTime'},
				   {name: 'displayCompleteTime'},
				   {name: 'displaySpentTime'},
				   {name: 'displayCreateTime'},
				   {name: 'executeResult'},
				   {name: 'executeStatus'},
				   {name: 'executeLogId'},
				   {name: 'lastResultId'},
				   {name: 'sampleTotal'},
				   {name: 'sampleCountPlan'},
				   {name: 'sampleCountPractice'},
				   {name: 'userCountPlan'},
				   {name: 'userCountPractice'},
				   {name: 'statusComplete'},
				   {name: 'statusUncomplete'},
				   {name: 'completeRate'},
				   {name: 'status'},
				  /*  {name: 'firstQaTime'}, */
				   {name: 'lastQaTime'}
				];

	function showSchedultType(v, p, rec, rowIndex) {
		if(v == '2') {
			return '每日任务';
		} else if(v == '3') {
			return '每周任务';
		} else if(v == '4') {
			return '每月任务';
		} else {
			return '';
		}
	}

	function showExecuteStatus(v, p, rec, rowIndex) {
		if(rec.get('executeStatus') == 'Begin') {
			return '初始化中';
		} else if(rec.get('executeStatus') == 'doQuery') {
			return '抽样查询中';
		} else if(rec.get('executeStatus') == 'doSample') {
			return '抽样中';
		} else if(rec.get('executeStatus') == 'doAssign') {
			return '分配中';
		} else if(rec.get('executeStatus') == 'doSave') {
			return '保存中';
		} else if(rec.get('executeStatus') == 'Rollback') {
			return '已回退';
		} else if(rec.get('executeStatus') == 'End') {
			if(rec.get('executeResult') == '000') {
				return '<font color=green>正常</font>';
			} else {
				return '<font color=red>异常</font>';
			}
		} else {
			return '';
		}
	}

	function showStatus(v, p, rec, rowIndex) {
		if(v == 'ENABLE') {
			return '<img src=../images/icons/fam/accept.png>';
		} else if(v == 'DISABLE') {
			return '<img src=../images/icons/fam/delete.png>';
		} else if(v == 'RUNNING') {
			return '<img src=../images/loading.gif>';
		} else {
			return '';
		}
	}

	function showUserCount(v, p, rec, rowIndex) {
		if(v > 0) {
			return '<a href=# onclick=\'doViewUserStat("' + rec.get('no') + '","' + rec.get('executeLogId') + '")\'>' + v + '</a>';
		} else {
			return v;
		}
	}

	function showTotal(v, p, rec, rowIndex) {
		if(v > 0) {
			return '<a href=# onclick=\'doViewDetail("' + rec.get('no') + '","' + rec.get('executeLogId') + '","Total")\'>' + v + '</a>';
		} else {
			return v;
		}
	}

	function showComplete(v, p, rec, rowIndex) {
		if(v > 0) {
			return '<a href=# onclick=\'doViewDetail("' + rec.get('no') + '","' + rec.get('executeLogId') + '", "Complete")\'>' + v + '</a>';
		} else {
			return v;
		}
	}

	function showUncomplete(v, p, rec, rowIndex) {
		if(v > 0) {
			return '<a href=# onclick=\'doViewDetail("' + rec.get('no') + '","' + rec.get('executeLogId') + '", "Uncomplete")\'>' + v + '</a>';
		} else {
			return v;
		}
	}

	function showCompleteRate(v, p, rec, rowIndex) {
		return v + '%';
	}

	function doViewDetail(taskNo, logId, status) {
		parent.tabs.add({
			title: '明细记录(' + taskNo + ')',
			iconCls: 'commentsbtn',
			margins:'0 0 0 0',
			autoScroll:true,
			autoWidth:true,
			closable:true,
			html:'<iframe src="assign-task-detail-list.jsp?taskNo=' + taskNo + '&logId=' + logId + '&status=' + status + '" border=0 width="100%" height="100%" frameborder="no" scrolling="auto"></iframe>'
		}).show();
	}

	function doViewUserStat(taskNo, logId) {
		parent.tabs.add({
			title: '质检员统计(' + taskNo + ')',
			iconCls: 'groupbtn',
			margins:'0 0 0 0',
			autoScroll:true,
			autoWidth:true,
			closable:true,
			html:'<iframe src="assign-task-user-stat.jsp?taskNo=' + taskNo + '&logId=' + logId + '" border=0 width="100%" height="100%" frameborder="no" scrolling="auto"></iframe>'
		}).show();
	}

	Ext.onReady(function(){
		var store = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			idProperty: 'id',
			remoteSort: false,

			fields: fields,
			
			restful: true,
			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'QASample/Tasks/AUTO'
			})
		});
    
		store.setDefaultSort('createTime', 'desc');

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
		
		/** Start 启用任务 */
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnEnable',
				text: '启用',
				disabled: true,
				iconCls: 'enablebtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('启用任务', '请选择要启用的任务！');
						} else {
							Ext.Msg.show({
								title:'启用任务?',
								msg: '请再次确实是否要启用已选中的任务?',
								buttons: Ext.Msg.YESNOCANCEL,
								fn: function(btn, text) {
									if(btn == "yes") {
										Ext.Ajax.request({
											url: window.webRoot + 'QASample/Task/' + rec.get('no') + '/Enable',
											method: 'GET',
											success: function(response,options) {
												var respText = Ext.util.JSON.decode(response.responseText);
												if(respText.code != 'OK') {
													Ext.Msg.alert('启用失败', respText.message + "（" + respText.code + "）");
												} else {
													rec.set('status', 'ENABLE');
													Ext.getCmp('btnEnable').setDisabled(true);
													Ext.getCmp('btnDisable').setDisabled(false);
													var pgbar = grid.getBottomToolbar();
													var activePage = Math.ceil((pgbar.cursor + pgbar.pageSize) / pgbar.pageSize);
													var start = (activePage - 1) * pgbar.pageSize;
													store.load({params:{start:start, limit:pagesize}});
												}
											},
											failure: function(response,options) {
												Ext.Msg.alert('启用失败', '启用任务失败！');
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
		/** End 启用任务 */
		
		/** Start 停用任务 */
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnDisable',
				text: '停用',
				disabled: true,
				iconCls: 'disablebtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('停用任务', '请选择要停用的任务！');
						} else {
							Ext.Msg.show({
								title:'停用任务?',
								msg: '请再次确实是否要停用已选中的任务?',
								buttons: Ext.Msg.YESNOCANCEL,
								fn: function(btn, text) {
									if(btn == "yes") {
										Ext.Ajax.request({
											url: window.webRoot + 'QASample/Task/' + rec.get('no') + '/Disable',
											method: 'GET',
											success: function(response,options) {
												var respText = Ext.util.JSON.decode(response.responseText);
												if(respText.code != 'OK') {
													Ext.Msg.alert('停用失败', respText.message + "（" + respText.code + "）");
												} else {
													rec.set('status', 'DISABLE');
													Ext.getCmp('btnEnable').setDisabled(false);
													Ext.getCmp('btnDisable').setDisabled(true);
													var pgbar = grid.getBottomToolbar();
													var activePage = Math.ceil((pgbar.cursor + pgbar.pageSize) / pgbar.pageSize);
													var start = (activePage - 1) * pgbar.pageSize;
													store.load({params:{start:start, limit:pagesize}});
												}
											},
											failure: function(response,options) {
												Ext.Msg.alert('停用失败', '停用任务失败！');
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
		/** End 停用任务 */
		
		/** Start 回退任务 */
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnRollback',
				text: '回退',
				disabled: true,
				iconCls: 'rollbackbtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('回退任务', '请选择要回退的任务！');
						} else {
							Ext.Msg.show({
								title:'回退任务?',
								msg: '请再次确实是否要回退已选中的任务? 已完成质检的记录无法回退！',
								buttons: Ext.Msg.YESNOCANCEL,
								fn: function(btn, text) {
									if(btn == "yes") {
										Ext.Ajax.request({
											url: window.webRoot + 'QASample/Task/' + rec.get('no') + '/Rollback/' + rec.get('executeLogId'),
											method: 'GET',
											success: function(response,options) {
												var respText = Ext.util.JSON.decode(response.responseText);
												if(respText.code != 'OK') {
													Ext.Msg.alert('回退失败', respText.message + "（" + respText.code + "）");
												} else {
													rec.set('executeStatus', 'Rollback');
													rec.set('sampleTotal', respText.data.sampleTotal);
													rec.set('statusComplete', respText.data.statusComplete);
													rec.set('statusUncomplete', respText.data.statusUncomplete);
													rec.set('completeRate', respText.data.completeRate);
													store.loadData(rec, true);
												}
											},
											failure: function(response,options) {
												Ext.Msg.alert('回退失败', '回退任务失败！');
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
		/** End 回退任务 */
		
		/** Start 删除任务 */
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnDelete',
				text: '删除',
				disabled: true,
				iconCls: 'qaassign',
				listeners: {
					'click': function(obj, e) {
						
						var rec = grid.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('删除任务', '请选择要删除的任务！');
						} else {
							Ext.Msg.show({
								title:'删除任务?',
								msg: '请再次确实是否要将选中的任务删除?',
								buttons: Ext.Msg.YESNOCANCEL,
								fn: function(btn, text) {
									if(btn == "yes") {
										var ids = new Array();
										Ext.each(grid.getSelectionModel().getSelections(), function(rec) {
											ids.push(rec.get('id'));
										});
										Ext.Ajax.request({
											url: window.webRoot + 'QASample/Task/delete',
											method: 'POST',
											params: {
												_method: 'DELETE',
												id: ids
											},
											success: function(response,options) {
												var respText = Ext.util.JSON.decode(response.responseText);
												if(respText.code != 'OK') {
													Ext.Msg.alert('删除失败', respText.message + "（" + respText.code + "）");
												} else {
													var pgbar = grid.getBottomToolbar();
													var activePage = Math.ceil((pgbar.cursor + pgbar.pageSize) / pgbar.pageSize);
													var start = (activePage - 1) * pgbar.pageSize;
													store.load({params:{start:start, limit:pagesize}});
												}
											},
											failure: function(response,options) {
												Ext.Msg.alert('删除失败', '删除任务失败！');
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
		/** End 删除任务 */
		
		/** Start 查看任务详情 */
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnViewInfo',
				text: '任务详情',
				disabled: true,
				iconCls: 'commentbtn',
				listeners: {
					'click': function(obj, e) {
						actiontype = "add";
						win.setTitle("任务详情");
						win.setIconClass("commentbtn");
						win.show(this);
					}
				}
			})
		);
		toolbar.addSeparator();
		/** End 查看任务详情 */
		
		/** Start 查看明细记录 */
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnViewDetail',
				text: '明细记录',
				disabled: true,
				iconCls: 'commentsbtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						doViewDetail(rec.get('no'), rec.get('executeLogId'));
					}
				}
			})
		);
		toolbar.addSeparator();
		/** End 查看明细记录 */
		
		/** Start 查看质检员统计 */
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnViewUserStat',
				text: '质检员统计',
				disabled: true,
				iconCls: 'groupbtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						doViewUserStat(rec.get('no'), rec.get('executeLogId'));
					}
				}
			})
		);
		toolbar.addSeparator();
		/** End 查看明细记录 */
		
		/** Start 查看执行历史 */
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnViewHistory',
				text: '执行历史',
				disabled: true,
				iconCls: 'gridbtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						hisgrid.getStore().removeAll();
						hisgrid.getStore().proxy.setUrl(window.webRoot + 'QASample/Task/' + rec.get('no') + '/History', true);
						hisgrid.getStore().load();
						hiswin.title = '执行历史（' + rec.get('no') + ' : ' + rec.get('desc') + '）'
						hiswin.show();
					}
				}
			})
		);
		toolbar.addSeparator();
		/** End 查看明细记录 */

		var sm = new Ext.grid.CheckboxSelectionModel();

		/** Start 汇总标题 */
		var groupColsObj =  [
			{header: '&nbsp;', colspan: 1, align: 'center'},
			{header: '任务描述', colspan: 5, align: 'center'},
			{header: '执行情况（最近一次）', colspan: 2, align: 'center'},
			{header: '抽样统计', colspan: 6, align: 'center'}
		]

		/** End 汇总标题 */

		grid = new Ext.grid.GridPanel({
            region: 'center',
			tbar: toolbar,
			store: store,
			border: false,
			selModel: sm,
			plugins: new Ext.ux.grid.ColumnHeaderGroup({
					rows: [groupColsObj]
			}),
			columns: [
				sm, 
				{
					header   : '&nbsp;', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'status',
					renderer : showStatus
				},
				{
					header   : '编号', 
					width    : .3, 
					sortable : true, 
					dataIndex: 'no'
				},
				{
					header   : '说明', 
					width    : .4, 
					sortable : true, 
					dataIndex: 'desc'
				},
				{
					header   : '计划类型', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'scheduleType',
					renderer : showSchedultType
				},
				{
					header   : '执行时间', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'scheduleTime'
				},
				{
					header   : '执行开始时间', 
					width    : .3, 
					sortable : true, 
					dataIndex: 'displayExecuteTime'
				},
				{
					header   : '执行结果', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'executeStatus',
					renderer : showExecuteStatus
				},
				{
					header   : '抽样人数', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'userCountPractice',
					renderer : showUserCount
				},
				{
					header   : '抽样总数', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'sampleTotal',
					renderer : showTotal
				},
				{
					header   : '已质检量', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'statusComplete',
					renderer : showComplete
				},
				{
					header   : '未质检量', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'statusUncomplete',
					renderer : showUncomplete
				},
				{
					header   : '达成率', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'completeRate',
					renderer : showCompleteRate
				},
/* 				{
					header   : '质检开始时间', 
					width    : .3, 
					sortable : true, 
					dataIndex: 'firstQaTime',
					renderer: function(v, p, record, rowIndex){
						var date = new Date();
						return v > date.getTime() ? '' : formatDateTime(v);
					}
				}, */
				{
					header   : '质检完成时间', 
					width    : .3, 
					sortable : true, 
					dataIndex: 'lastQaTime',
					renderer: function(v, p, record, rowIndex){
						return record.get('sampleTotal') > record.get('statusComplete') ? '' : formatDateTime(v);
					}
				}
			],
			stripeRows: true,
			height: 600,
			width: '100%',
			viewConfig: {forceFit:true}, 
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

		/** 列表双击操作 Start */
		grid.addListener('rowdblclick', function(obj, e) {
						Ext.getCmp('btnViewInfo').fireEvent('click'); 
					});    
		/** 列表双击操作 End */
		
		/** 列表右键点击菜单 Start */
		var rightClick = new Ext.menu.Menu();
			rightClick.add({
				text : '任务详情',
				iconCls : 'commentbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnViewInfo').fireEvent('click'); 
					}
			});
			rightClick.add({
				text : '明细记录',
				iconCls : 'commentsbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnViewDetail').fireEvent('click'); 
					}
			});
			rightClick.add({
				text : '质检员统计',
				iconCls : 'groupbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnViewUserStat').fireEvent('click'); 
					}
			});

		grid.addListener('rowcontextmenu', function(client, rowIndex, e) {
			e.preventDefault();
            rightClick.showAt(e.getXY());
		});
		/** 列表右键点击菜单 End */	  
		
		grid.getSelectionModel().on('rowselect', function(obj, rowIndex, rec) {
			if(obj.getCount() > 0) {
				rec = obj.getSelected();
				try{
					Ext.getCmp('btnViewInfo').setDisabled(false);
					Ext.getCmp('btnViewDetail').setDisabled(false);
					Ext.getCmp('btnViewUserStat').setDisabled(false);
					Ext.getCmp('btnDelete').setDisabled(false);
					Ext.getCmp('btnViewHistory').setDisabled(false);
					if(rec.get('status') == 'ENABLE') {
						Ext.getCmp('btnEnable').setDisabled(true);
						Ext.getCmp('btnDisable').setDisabled(false);
					} else {
						Ext.getCmp('btnEnable').setDisabled(false);
						Ext.getCmp('btnDisable').setDisabled(true);
					}
					if(rec.get('sampleTotal') > rec.get('statusComplete')) {
						Ext.getCmp('btnRollback').setDisabled(false);
					} else {
						Ext.getCmp('btnRollback').setDisabled(true);
					}
				} catch (e) {
				}
			} else {
				try{
					Ext.getCmp('btnViewInfo').setDisabled(true);
					Ext.getCmp('btnViewDetail').setDisabled(true);
					Ext.getCmp('btnViewUserStat').setDisabled(true);
					Ext.getCmp('btnDelete').setDisabled(true);
					Ext.getCmp('btnViewHistory').setDisabled(true);
					Ext.getCmp('btnEnable').setDisabled(true);
					Ext.getCmp('btnDisable').setDisabled(true);
					Ext.getCmp('btnRollback').setDisabled(true);
				} catch (e) {
				}
			}
		});
		
		grid.getSelectionModel().on('rowdeselect', function(obj, rowIndex, rec) {
			if(obj.getCount() > 0) {
				rec = obj.getSelected();
				try{
					Ext.getCmp('btnViewInfo').setDisabled(false);
					Ext.getCmp('btnViewDetail').setDisabled(false);
					Ext.getCmp('btnViewUserStat').setDisabled(false);
					Ext.getCmp('btnDelete').setDisabled(false);
					Ext.getCmp('btnViewHistory').setDisabled(false);
					if(rec.get('status') == 'ENABLE') {
						Ext.getCmp('btnEnable').setDisabled(true);
						Ext.getCmp('btnDisable').setDisabled(false);
					} else {
						Ext.getCmp('btnEnable').setDisabled(false);
						Ext.getCmp('btnDisable').setDisabled(true);
					}
					if(rec.get('sampleTotal') > rec.get('statusComplete')) {
						Ext.getCmp('btnRollback').setDisabled(false);
					} else {
						Ext.getCmp('btnRollback').setDisabled(true);
					}
				} catch (e) {
				}
			} else {
				try{
					Ext.getCmp('btnViewInfo').setDisabled(true);
					Ext.getCmp('btnViewDetail').setDisabled(true);
					Ext.getCmp('btnViewUserStat').setDisabled(true);
					Ext.getCmp('btnDelete').setDisabled(true);
					Ext.getCmp('btnViewHistory').setDisabled(true);
					Ext.getCmp('btnEnable').setDisabled(true);
					Ext.getCmp('btnDisable').setDisabled(true);
					Ext.getCmp('btnRollback').setDisabled(true);
				} catch (e) {
				}
			}
		});
		
		store.load({params:{start:0, limit:pagesize}});

		/** 任务详情 Start */

		var fieldSets = new Array();

		fieldSets.push(
			new Ext.form.FieldSet({
				title: '抽检条件',
				collapsible: true,
				collapsed: false,
				autoHeight: true,
				items: [
					{
						border: false,
						fieldLabel: '',
						width: 650,
						html: '<table width=600 align=center border="0" cellpadding="0" cellspacing="5" width="100%">' +
								'<tr>' +
								'<td width=100 align=left>时间范围: </td>' +
								'<td width=500 align=left><span id=spanTimeRange style="color:blue;"></span></td>' +
								'</tr>' +
								'<tr>' +
								'<td width=100 align=left valgin=top>抽检对象: </td>' +
								'<td width=500 align=left><span id=spanAgentNos style="color:blue;"></span></td>' +
								'</tr>' +
								'<tr>' +
								'<td width=100 align=left valgin=top>抽检组别: </td>' +
								'<td width=500 align=left><span id=spanDeptIds style="color:blue;"></span></td>' +
								'</tr>' +
								'<tr>' +
								'<td width=100 align=left valgin=top>通话时长(秒): </td>' +
								'<td width=500 align=left><span id=spanCallTime style="color:blue;"></span></td>' +
								'</tr>' +
								'<tr>' +
								'<td width=100 align=left valgin=top>呼叫类型: </td>' +
								'<td width=500 align=left><span id=spanCallType style="color:blue;"></span></td>' +
								'</tr>' +
							   '</table>'
					}
				]
			})
		);

		fieldSets.push(
			new Ext.form.FieldSet({
				title: '抽检方式',
				collapsible: true,
				collapsed: false,
				autoHeight: true,
				items: [
					{
						border: false,
						fieldLabel: '',
						width: 650,
						html: '<table width=600 align=center border="0" cellpadding="0" cellspacing="5" width="100%">' +
								'<tr>' +
								'<td width=100 align=left>抽检方式: </td>' +
								'<td width=500 align=left><span id=spanSampleType style="color:blue;"></span></td>' +
								'</tr>' +
							   '</table>'
					}
				]
			})
		);

		fieldSets.push(
			new Ext.form.FieldSet({
				title: '分配方式',
				collapsible: true,
				collapsed: false,
				autoHeight: true,
				items: [
					{
						border: false,
						fieldLabel: '',
						width: 650,
						html: '<table width=600 align=center border="0" cellpadding="0" cellspacing="5" width="100%">' +
								'<tr>' +
								'<td width=100 align=left>分配方式: </td>' +
								'<td width=500 align=left><span id=spanAssignType style="color:blue;"></span></td>' +
								'</tr>' +
								'<tr>' +
								'<td width=100 align=left>分配对象: </td>' +
								'<td width=500 align=left><span id=spanAssignUsers style="color:blue;"></span></td>' +
								'</tr>' +
							   '</table>'
					}
				]
			})
		);

		var infoForm = new Ext.form.FormPanel({
			width: 686,
			border	: false,
			bodyStyle: 'padding: 10px',
			defaults: {
				anchor: '0'
			},

			items : fieldSets
		});

		win = new Ext.Window({
			width: 700,
			height:389,
			closeAction:'hide',
			modal: true,
			plain: true,
			title: "任务详情",
			iconCls: "addbtn",
			items: [infoForm],
			buttons: [
			{
				text: '关&nbsp;&nbsp;闭',
				handler: function(){
					win.hide();
				}
			}]
		});

		win.on('show', function() {
			var rec = grid.getSelectionModel().getSelected();
			
			Ext.Ajax.request({
				url: window.webRoot + 'QASample/Task/' + rec.get('no') + '/Info',
				success: function(res) {
					var respText = Ext.decode(res.responseText);   
					if(respText.code == 'OK') {
						Ext.getDom('spanTimeRange').innerHTML = respText.data.dateRange;
						Ext.getDom('spanAgentNos').innerHTML = respText.data.agentNames;
						Ext.getDom('spanDeptIds').innerHTML = respText.data.deptNames;
						Ext.getDom('spanCallTime').innerHTML = respText.data.callTime;
						Ext.getDom('spanCallType').innerHTML = respText.data.callType;
						Ext.getDom('spanSampleType').innerHTML = respText.data.sampleType;
						Ext.getDom('spanAssignType').innerHTML = respText.data.assignType;
						Ext.getDom('spanAssignUsers').innerHTML = respText.data.userNames;
					} else {
						Ext.Msg.alert('查询失败', '查询抽样任务详情失败！');
					}
				},
				failure: function(res) {
					Ext.Msg.alert('查询失败', '查询抽样任务详情失败！');
				},
				method: 'GET', 
				timeout: 3000
			});
		});
		/** 任务详情 End */	  

		/** 执行历史 Start */
	var hisfields = [
				   {name: 'id'},
				   {name: 'no'},
				   {name: 'displayExecuteTime'},
				   {name: 'displayCompleteTime'},
				   {name: 'displaySpentTime'},
				   {name: 'executeTime'},
				   {name: 'executeResult'},
				   {name: 'executeStatus'},
				   {name: 'executeLogId'},
				   {name: 'sampleTotal'},
				   {name: 'sampleCountPlan'},
				   {name: 'sampleCountPractice'},
				   {name: 'userCountPlan'},
				   {name: 'userCountPractice'},
				   {name: 'statusComplete'},
				   {name: 'statusUncomplete'},
				   {name: 'completeRate'},
				  /*  {name: 'firstQaTime'}, */
				   {name: 'lastQaTime'}
				];
		
		var hisstore = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			idProperty: 'id',
			remoteSort: false,

			fields: hisfields,
			
			url: 'empty.jsp'
		});
    
		hisstore.setDefaultSort('executeTime', 'desc');
		
		var hisGroupColsObj =  [
			{header: '&nbsp;', colspan: 1, align: 'center'},
			{header: '执行情况', colspan: 2, align: 'center'},
			{header: '抽样统计', colspan: 6, align: 'center'}
		]

		hisgrid = new Ext.grid.GridPanel({
            region: 'center',
			store: hisstore,
			border: false,
			plugins: new Ext.ux.grid.ColumnHeaderGroup({
					rows: [hisGroupColsObj]
			}),
			columns: [
				new Ext.grid.RowNumberer(),
				{
					header   : '执行开始时间', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'displayExecuteTime'
				},
				{
					header   : '执行结果', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'executeStatus',
					renderer : showExecuteStatus
				},
				{
					header   : '人数', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'userCountPractice',
					renderer : showUserCount
				},
				{
					header   : '抽样数', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'sampleTotal',
					renderer : showTotal
				},
				{
					header   : '已质检量', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'statusComplete',
					renderer : showComplete
				},
				{
					header   : '未质检量', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'statusUncomplete',
					renderer : showUncomplete
				},
				{
					header   : '达成率', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'completeRate',
					renderer : showCompleteRate
				},
/* 				{
					header   : '质检开始时间', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'firstQaTime',
					renderer: function(v, p, record, rowIndex){
						var date = new Date();
						return v > date.getTime() ? '' : formatDateTime(v);
					}
				}, */
				{
					header   : '质检完成时间', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'lastQaTime',
					renderer: function(v, p, record, rowIndex){
						return record.get('sampleTotal') > record.get('statusComplete') ? '' : formatDateTime(v);
					}
				}
			],
			stripeRows: true,
			height: 340,
			width: '100%',
			viewConfig: {forceFit:true}, 
			loadMask: true,

			bbar: new Ext.PagingToolbar({
                plugins: [new Ext.ui.plugins.ComboPageSize({ addToItem: false, prefixText: '每页', postfixText: '条'})],
				pageSize: pagesize,
				store: hisstore,
				displayInfo: true,
				displayMsg: '当前显示第 <font color="blue">{0}</font> 到 <font color="blue">{1}</font> 条记录， 共 <font color="blue">{2}</font> 条记录',
				emptyMsg: "无记录"
			})
		});
		
		hisgrid.on('rowclick', function(obj, rowIndex, rec) {
			if(obj.getSelectionModel().getCount() > 0) {
				rec = obj.getSelectionModel().getSelected();
				try{
					if(rec.get('sampleTotal') > rec.get('statusComplete')) {
						Ext.getCmp('btnRollback2').setDisabled(false);
					} else {
						Ext.getCmp('btnRollback2').setDisabled(true);
					}
				} catch (e) {
				}
			} else {
				try{
					Ext.getCmp('btnRollback2').setDisabled(true);
				} catch (e) {
				}
			}
		});

		hiswin = new Ext.Window({
			width: 800,
			height:380,
			closeAction:'hide',
			modal: true,
			plain: true,
			title: "执行历史",
			iconCls: "gridbtn",
			items: [hisgrid],
			buttons: [
			{
				id: 'btnRollback2',
				text: '回&nbsp;&nbsp;退',
				disabled: true,
				iconCls: 'rollbackbtn',
				handler: function(){
					var rec = hisgrid.getSelectionModel().getSelected();
					if(!rec) {
						Ext.Msg.alert('回退任务', '请选择要回退的任务！');
					} else {
						Ext.Msg.show({
							title:'回退任务?',
							msg: '请再次确实是否要回退已选中的任务? 已完成质检的记录无法回退！',
							buttons: Ext.Msg.YESNOCANCEL,
							fn: function(btn, text) {
								if(btn == "yes") {
									Ext.Ajax.request({
										url: window.webRoot + 'QASample/Task/' + rec.get('no') + '/Rollback/' + rec.get('executeLogId'),
										method: 'GET',
										success: function(response,options) {
											var respText = Ext.util.JSON.decode(response.responseText);
											if(respText.code != 'OK') {
												Ext.Msg.alert('回退失败', respText.message + "（" + respText.code + "）");
											} else {
												rec.set('executeStatus', 'Rollback');
												rec.set('sampleTotal', respText.data.sampleTotal);
												rec.set('statusComplete', respText.data.statusComplete);
												rec.set('statusUncomplete', respText.data.statusUncomplete);
												rec.set('completeRate', respText.data.completeRate);
												hisgrid.getStore().loadData(rec, true);
											}
										},
										failure: function(response,options) {
											Ext.Msg.alert('回退失败', '回退任务失败！');
										}
									});
								}
							},
							icon: Ext.MessageBox.QUESTION
						});
					}
				}
			},
			{
				text: '关&nbsp;&nbsp;闭',
				iconCls: 'closebtn',
				handler: function(){
					hiswin.hide();
				}
			}]
		});
		/** 执行历史 End */	  

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
