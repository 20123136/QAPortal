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
    <title>手动录音备份任务管理</title>
 
    <link rel="stylesheet" type="text/css" href="../css/ext-all-notheme.css" />
    <link rel="stylesheet" type="text/css" href="../css/xtheme-gray.css" />

    <link rel="stylesheet" type="text/css" href="../css/icon.css" />
    <link rel="stylesheet" type="text/css" href="../css/common.css" />
	<script >
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

	var fields = [
				   {name: 'id'},
				   {name: 'no'},
				   {name: 'desc'},
				   {name: 'createUserName'},
				   {name: 'createUserId'},
				   {name: 'displayExecuteTime'},
				   {name: 'displayCompleteTime'},
				   {name: 'displaySpentTime'},
				   {name: 'displayCreateTime'},
				   {name: 'executeResult'},
				   {name: 'executeStatus'},
				   {name: 'executeLogId'},
				   {name: 'lastResultId'},
				   {name: 'total'},
				   {name: 'completedCount'},
				   {name: 'skipedCount'},
				   {name: 'failedCount'},
				   {name: 'completedSize'},
				   {name: 'status'},
				   {name: 'completedRate'}
				];

	function showTotal(v, p, rec, rowIndex) {
		if(v > 0) {
			return '<a href=# onclick=\'doViewDetail("' + rec.get('no') + '","' + rec.get('executeLogId') + '","")\'>' + v + '</a>';
		} else {
			return v;
		}
	}

	function showSuccess(v, p, rec, rowIndex) {
		if(v > 0) {
			return '<a href=# onclick=\'doViewDetail("' + rec.get('no') + '","' + rec.get('executeLogId') + '","Success")\'>' + v + '</a>';
		} else {
			return v;
		}
	}

	function showFailed(v, p, rec, rowIndex) {
		if(v > 0) {
			return '<a href=# onclick=\'doViewDetail("' + rec.get('no') + '","' + rec.get('executeLogId') + '","Failed")\'>' + v + '</a>';
		} else {
			return v;
		}
	}

	function showSkipped(v, p, rec, rowIndex) {
		if(v > 0) {
			return '<a href=# onclick=\'doViewDetail("' + rec.get('no') + '","' + rec.get('executeLogId') + '","Skipped")\'>' + v + '</a>';
		} else {
			return v;
		}
	}

	function doViewDetail(taskNo, logId, status) {
		parent.tabs.add({
			title: '明细记录(' + taskNo + ')',
			iconCls: 'commentsbtn',
			margins:'0 0 0 0',
			autoScroll:true,
			autoWidth:true,
			closable:true,
			html:'<iframe src="backup-task-detail-list.jsp?taskNo=' + taskNo + '&logId=' + logId + '&status=' + status + '" border=0 width="100%" height="100%" frameborder="no" scrolling="auto"></iframe>'
		}).show();
	}

	function showStatus(v, p, rec, rowIndex) {
		if(rec.get('executeStatus') == 'Begin') {
			return '初始化中';
		} else if(rec.get('executeStatus') == 'doQuery') {
			return '查询中';
		} else if(rec.get('executeStatus') == 'doBackup') {
			return '备份中';
		} else if(rec.get('executeStatus') == 'doRuning') {
			return '备份中';
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


	function showCompleteRate(v, p, rec, rowIndex) {
		return v + '%';
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
				url: window.webRoot + 'QABackup/Tasks/MANUAL'
			})
		});
    
		store.setDefaultSort('displayCreateTime', 'desc');

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
		
		/** Start 查看任务详情 */
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnViewInfo',
				text: '任务详情',
				disabled: true,
				iconCls: 'commentbtn',
				listeners: {
					'click': function(obj, e) {
						win.setTitle("任务详情");
						win.setIconClass("commentbtn");
						win.show(this);
					}
				}
			})
		);
		toolbar.addSeparator();
		/** End 查看任务详情 */
		
		/** Start 查看明细详情 */
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnViewDetail',
				text: '明细详情',
				disabled: true,
				iconCls: 'commentbtn',
			//	disabled: true,
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						//alert(rec.get('executeLogId'));
						var taskNo=rec.get('no');
						var  logId=rec.get('executeLogId');
						
						parent.tabs.add({
							title: '查看备份明细',
							iconCls: 'commentsbtn',
							margins:'0 0 0 0',
							autoScroll:true,
							autoWidth:true,
							html:'<iframe src="backup-task-detail-list.jsp?taskNo=' + taskNo + '&logId=' + logId + '" border=0 width="100%" height="100%" frameborder="no" scrolling="auto"></iframe>'
						}).show();
						
					}
				}
			})
		);
		toolbar.addSeparator();
		/** End 查看明细详情 */
		
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
											url: window.webRoot + 'QABackup/Task/delete',
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
		

		var sm = new Ext.grid.CheckboxSelectionModel();

		/** Start 汇总标题 */
		var groupColsObj =  [
			{header: '&nbsp;', colspan: 1, align: 'center'},
			{header: '任务描述', colspan: 3, align: 'center'},
			{header: '执行情况', colspan: 3, align: 'center'},
			{header: '备份统计', colspan: 6, align: 'center'}
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
					header   : '编号', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'no'
				},
				{
					header   : '说明', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'desc'
				},
				{
					header   : '创建人', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'createUserName'
				},
				{
					header   : '执行开始时间', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'displayExecuteTime'
				},
				{
					header   : '耗时', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'displaySpentTime'
				},
				{
					header   : '执行结果', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'executeStatus',
					renderer : showStatus
				},
				{
					header   : '总记录数', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'total',
					renderer : showTotal
				},
				{
					header   : '成功量', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'completedCount',
					renderer : showSuccess
				},
				{
					header   : '失败量', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'failedCount',
					renderer : showFailed
				},
				{
					header   : '忽略量', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'skipedCount',
					renderer : showSkipped
				},
				{
					header   : '完成率', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'completedRate',
					renderer : showCompleteRate
				},
				{
					header   : '总文件大小', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'completedSize',
					renderer: function(v, p, record, rowIndex){
						return v + 'M';
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

		grid.addListener('rowcontextmenu', function(client, rowIndex, e) {
			e.preventDefault();
            rightClick.showAt(e.getXY());
		});
		/** 列表右键点击菜单 End */	  
		
 		grid.getSelectionModel().on('rowselect', function(obj, rowIndex, rec) {
			if(obj.getCount() > 0) {
				try{
					Ext.getCmp('btnViewInfo').setDisabled(false);
					Ext.getCmp('btnViewDetail').setDisabled(false);
					Ext.getCmp('btnDelete').setDisabled(false);
				} catch (e) {
				}
			} else {
				try{
					Ext.getCmp('btnViewInfo').setDisabled(true);
					Ext.getCmp('btnViewDetail').setDisabled(true);
					Ext.getCmp('btnDelete').setDisabled(true);
				} catch (e) {
				}
			}
		}); 
		
		grid.getSelectionModel().on('rowdeselect', function(obj, rowIndex, rec) {
			if(obj.getCount() > 0) {
				try{
					Ext.getCmp('btnViewInfo').setDisabled(false);
					Ext.getCmp('btnViewDetail').setDisabled(false);
					Ext.getCmp('btnDelete').setDisabled(false);
				} catch (e) {
				}
			} else {
				try{
					Ext.getCmp('btnViewInfo').setDisabled(true);
					Ext.getCmp('btnViewDetail').setDisabled(true);
					Ext.getCmp('btnDelete').setDisabled(true);
				} catch (e) {
				}
			}
		});
		
		store.load({params:{start:0, limit:pagesize}});

		/** 任务详情 Start */

		var fieldSets = new Array();

		fieldSets.push(
			new Ext.form.FieldSet({
				title: '录音条件',
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
							   '</table>'
					}
				]
			})
		);

		fieldSets.push(
			new Ext.form.FieldSet({
				title: '备份方式',
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
								'<td width=100 align=left>目标文件服务器: </td>' +
								'<td width=500 align=left><span id=spanFileServer style="color:blue;"></span></td>' +
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
			height:230,
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
				url: window.webRoot + 'QABackup/Task/' + rec.get('no') + '/Info',
				success: function(res) {
					var respText = Ext.decode(res.responseText);   
					if(respText.code == 'OK') {
						Ext.getDom('spanTimeRange').innerHTML = respText.data.dateRange;
						Ext.getDom('spanFileServer').innerHTML = respText.data.fileServer;
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
