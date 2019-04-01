/**
 * @class Ext.app.qa.QASelectorWindow
 * @extends Ext.app.common.Window
 * 列表。
 */
Ext.ns('Ext.app.qa');
Ext.app.qa.QASelectorWindow = Ext.extend(Ext.app.common.Window, {
	name: 'qaSelectWin',
	closeAction:'close',
	title: '质检评分',
	iconCls: 'qualitybtn',
	isQuery: false,
	readOnly: true,
	showmode: '',
	recData: new Array(),
	buttonAlign: 'left',

	initComponent : function(){

		this.recData = this.ownerObj.getStore().getById(this.recData.id);

		var me = this;

		var btns = new Array();
		
		//console.log(this.recData.data.callType);
		
/*		Ext.each(this.types, function(obj) {
			var iconCls = obj.value == me.groupTypeId ? 'bluebtn' : 'blackbtn';
			
			btns.push(new Ext.Button({
				text: obj.name,
				iconCls: iconCls,
				isGroupType: true,
				groupTypeId: obj.value,
				handler: function(btn) {

					Ext.each(btns, function(obj2) {
						if(obj2.isGroupType) {
							obj2.setIconClass('blackbtn');
						}
					});
					btn.setIconClass('bluebtn');

					me.items.items[0].qaGroupType = btn.groupTypeId;
					me.items.items[0].store.load();

				}
			}));
		});*/
		if(this.recData.data.callType == 'in'){
			
			btns.push(new Ext.Button({
				text: '受理组',
				iconCls: 'blackbtn',
				isGroupType: true,
				groupTypeId: 'd3d30b60-101d-45a0-833d-cafc4089eee7',//受理组
				handler: function(btn) {

					Ext.each(btns, function(obj2) {
						if(obj2.isGroupType) {
							obj2.setIconClass('blackbtn');
						}
					});
					btn.setIconClass('bluebtn');

					me.items.items[0].qaGroupType = btn.groupTypeId;
					me.items.items[0].store.load();

				}
			}));
		}else if(this.recData.data.callType == 'out'){
			btns.push(new Ext.Button({
				text: '回访组',
				iconCls: 'blackbtn',
				isGroupType: true,
				groupTypeId: '06a6d5f9-140f-4d39-acc6-818cfbd1067d',//回访组
				handler: function(btn) {

					Ext.each(btns, function(obj2) {
						if(obj2.isGroupType) {
							obj2.setIconClass('blackbtn');
						}
					});
					btn.setIconClass('bluebtn');

					me.items.items[0].qaGroupType = btn.groupTypeId;
					me.items.items[0].store.load();

				}
			}));
		}else{
			Ext.each(this.types, function(obj) {
				var iconCls = obj.value == me.groupTypeId ? 'bluebtn' : 'blackbtn';
				
				btns.push(new Ext.Button({
					text: obj.name,
					iconCls: iconCls,
					isGroupType: true,
					groupTypeId: obj.value,
					handler: function(btn) {

						Ext.each(btns, function(obj2) {
							if(obj2.isGroupType) {
								obj2.setIconClass('blackbtn');
							}
						});
						btn.setIconClass('bluebtn');

						me.items.items[0].qaGroupType = btn.groupTypeId;
						me.items.items[0].store.load();

					}
				}));
			});
		}
		

		btns.push(new Ext.Toolbar.Fill());

		btns.push(new Ext.Button({
			text: '返回调听页面',
			iconCls: 'finishbtn',
			handler: function() {
				if(playwin && playwin.isVisible()) {
					playwin.toFront();
				}
			}
		}));

		btns.push(new Ext.Button({
			text: '确&nbsp;定',
			iconCls: 'enablebtn',
			handler: function() {
				var win = this.ownerCt.ownerCt;
				if(win.isQuery) {
					win.close();
					return;
				}

				if(win.readOnly) {
					win.close();
					return;
				}

				var grid = win.find('name', 'qaSelector')[0];
				var vals = grid.getVal();
				var keys = grid.getKey();

				//检查输入
				var itemTotal = grid.getStore().getCount();
				var itemSelected = vals[2].length;
				if(itemSelected < itemTotal) {
					Ext.Msg.alert('保存失败', '还有未评分的质检项！');
					return;
				}

				var paramStr = "";
				paramStr += 'recId=' + win.recData.get('recId');
				Ext.each(vals[2], function(item) {
					paramStr += '&items=' + item;
				});
				paramStr += '&comment=' + vals[3];
				paramStr += '&checkComment=' + vals[4];
				paramStr += '&qaGroupTypeId=' + grid.qaGroupType;
				
				var url = '';
				if(win.showmode != 'Check') {
					url = window.webRoot + 'QARecord';
				} else {
					url = window.webRoot + 'QARecord/Check';
				}

				Ext.Ajax.request({
					url: url,
					method: 'POST',
					params: paramStr,
					success: function(response,options) {
						var respText = Ext.util.JSON.decode(response.responseText);
						if(respText.code != 'OK') {
							Ext.Msg.alert('保存失败', respText.message + "（" + respText.code + "）");
						} else {
							Ext.Msg.alert('保存成功', "质检记录保存成功");
							win.loadQARecord();
							win.close();
						}
					},
					failure: function(response,options) {
						Ext.Msg.alert('保存失败', '保存质检记录失败！');
					}
				});
			}
		}));

		btns.push(new Ext.Button({
			text: '取&nbsp;消',
			iconCls: 'disablebtn',
			handler: function() {
				this.ownerCt.ownerCt.reset();
				this.ownerCt.ownerCt.close();
			}
		}));

		this.buttons = btns;

		this.items = [
			new Ext.app.qa.QASelectorGrid({
				types: this.types,
				readOnly: this.readOnly,
				isQuery: this.isQuery,
				qaGroupType: this.groupTypeId,
				recData: this.recData,
				showmode: this.showmode
			})
		];
		Ext.app.qa.QASelectorWindow.superclass.initComponent.call(this);
	},
		
	loadQARecord: function () {
		//获取当前录音记录对应的质检记录
		//优先按质检ID查找质检记录。
		//如果没有质检ID，则按照录音记录ID查找
		var qaId = this.recData.get('qaRecordId');
		var recId = this.recData.get('recId')
		
		var win = this;

		var url = '';
		if(qaId) {
			url = window.webRoot + 'QARecord/' + qaId;
		} else {
			url = window.webRoot + 'QARecord/GetByRecord/' + recId;
		}
		if(recId) {
			Ext.Ajax.request({
				url: url,
				success: function(res) {
					var respText = Ext.decode(res.responseText);   
					if(respText.code == 'OK') {
						win.recData.set('qaRecordId', respText.data.id);
						win.recData.set('qaUserId', respText.data.userId);
						win.recData.set('qaUserName', respText.data.userName);
						win.recData.set('qaStatus', respText.data.status);
						if(respText.data.status == 'CHECKED') {
							win.recData.set('qaScore', respText.data.checkScore);
						} else {
							win.recData.set('qaScore', respText.data.score);
						}
						win.recData.set('qaTime', respText.data.qaTime);
						win.recData.set('qaTime', respText.data.qaTime);
						win.recData.set('qaItems', respText.data.items);
						win.recData.set('qaComment', respText.data.comment);
						win.recData.set('qaCheckItems', respText.data.checkItems);
						win.recData.set('qaCheckComment', respText.data.checkComment);
						win.recData.set('qaCheckScore', respText.data.checkScore);
						win.recData.set('qaCheckUserId', respText.data.checkUserId);
						win.recData.set('qaCheckUserName', respText.data.checkUserName);
						win.recData.set('qaGroupType', respText.data.qaGroupTypeId);

						var idx = win.ownerObj.getStore().indexOf(win.recData);

						var pgbar = win.ownerObj.getBottomToolbar();
						var activePage = Math.ceil((pgbar.cursor + pgbar.pageSize) / pgbar.pageSize);
						var start = (activePage - 1) * pgbar.pageSize;
						win.ownerObj.getStore().load({params:{start:start, limit:pagesize}});

						win.ownerObj.getStore().on('load', function(obj) {
							var r = obj.getById(win.recData.id);
							if(!r) {
								win.close();
								playwin.close();
							}

							var arr = new Array();
							arr.push(win.recData);
							win.ownerObj.getSelectionModel().selectRecords(arr);
							if(win.ownerObj) {
							//	win.ownerObj.getStore().loadData(win.recData, true);
								//更新按钮状态
								updateButton(win.recData);
							}
						});
					}
				},
				failure: function(res) {
				},
				method: 'GET', 
				timeout: 3000
			});
		}
	},

	reset: function() {
		try {
			this.find('name', 'qaSelector')[0].reset();
		} catch (e) {
		}
	},
	
	clearData: function() {
		this.find('name', 'qaSelector')[0].clearData();
	},

	getKey: function() {
		return this.name ? this.name : 'qaWin';
	},

	getVal: function() {
		return this.find('name', 'qaSelector')[0].getVal();
	},

	setVal: function(data) {
		this.find('name', 'qaSelector')[0].setVal(data);
	},

	getRawVal: function() {
		return this.find('name', 'qaSelector')[0].getRawVal();;
	},

	getTxt: function() {
		return this.title;
	},

	getUXType: function() {
		return 'qaSelectorWindow';
	}
});
