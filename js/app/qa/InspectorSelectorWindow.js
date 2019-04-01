/**
 * @class Ext.app.qa.InspectorSelectorWindow
 * @extends Ext.app.common.Window
 * 列表。
 */
Ext.ns('Ext.app.qa');
Ext.app.qa.InspectorSelectorWindow = Ext.extend(Ext.app.common.Window, {
	name: 'inspectorWin',
	closeAction:'hide',
	title: '选择质检员',
	iconCls: 'agentbtn',
	privilegeKey: '',
	showmode: 'Select',
	sampleCount: 0,
	buttons: [
		{
			text: '确&nbsp;定',
			handler: function() {
				//计算已分配数量
				var tmp;
				var assignedTotal = 0;
				var val = this.ownerCt.ownerCt.getVal();
				var sampleCount = this.ownerCt.ownerCt.sampleCount;
				Ext.each(val, function(t){
					tmp = t.split(':');
					assignedTotal += parseInt(tmp[1]);
				});

				var thisbtn = this;
				if(assignedTotal > sampleCount) {
					Ext.Msg.alert('指定失败', '已分配的数量大于可以分配的数量，请重新分配！');
				} else if(assignedTotal < sampleCount) {
					Ext.Msg.show({
						title:'确认分配?',
						msg: '还有未分配的记录，请确认分配结果?',
						buttons: Ext.Msg.YESNOCANCEL,
						fn: function(btn, text) {
							if(btn == "yes") {
								thisbtn.ownerCt.ownerCt.hide();
							}
						},
						icon: Ext.MessageBox.QUESTION
					});						
				} else {
					this.ownerCt.ownerCt.hide();
				}
			}
		},{
			text: '取&nbsp;消',
			handler: function() {
				var win = this.ownerCt.ownerCt;
				win.justClose = true;
				win.hide();
			}
		}
	],
	
	initComponent : function(){
		if(this.showmode == 'AssignEdit' || this.showmode == 'AssignView') {
			this.items = [new Ext.app.qa.InspectorSelectorEditorGrid({
				showmode: this.showmode,
				privilegeKey: this.privilegeKey
			})];
		} else {
			this.items = [new Ext.app.qa.InspectorSelectorGrid({
				showmode: this.showmode,
				privilegeKey: this.privilegeKey
			})];
		}
		Ext.app.qa.InspectorSelectorWindow.superclass.initComponent.call(this);
	},
	
	reset: function() {
		this.find('name', 'inspectorSelector')[0].reset();
	},
	
	clearData: function() {
		this.find('name', 'inspectorSelector')[0].clearData();
	},

	getKey: function() {
		return this.name ? this.name : 'inspectorWin';
	},

	getVal: function() {
		return this.find('name', 'inspectorSelector')[0].getVal();
	},

	setVal: function(data) {
		this.find('name', 'inspectorSelector')[0].setVal(data);
	},

	setSampleCount: function(sampleCount) {
		this.sampleCount = sampleCount;
		this.find('name', 'inspectorSelector')[0].setSampleCount(sampleCount);
	},

	getRawVal: function() {
		return this.find('name', 'inspectorSelector')[0].getRawVal();;
	},

	getTxt: function() {
		return this.title;
	},

	getUXType: function() {
		return 'InspectorSelectorWindow';
	}
});
