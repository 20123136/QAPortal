/**
 * @class Ext.app.qa.QATwinTriggerField
 * @extends Ext.app.common.TwinTriggerField
 * 列表。
 */
Ext.ns('Ext.app.qa');
Ext.app.qa.QATwinTriggerField = Ext.extend(Ext.app.common.TwinTriggerField, {
	width: 530,
	fieldLabel: '评分项',
	isQuery: true,
	onTrigger1Click : function(){this.setValue('');this.val = new Array();this.rawval = new Array(); this.triggers[0].hide();},
	onTrigger2Click : function() {
		var me = this;
		var selectWin = new Ext.app.qa.QASelectorWindow({
			name: 'qaSelectWin',
			width: 720,
			height:435,
			title: '选择评分项',
			closeAction:'close',
			groupTypeId: 'QUALITY',
			readOnly: false,
			isQuery: true,
			iconCls: "qualitybtn"
		});

		selectWin.on('close', function(obj) {
			var val = obj.getVal();
			var rawval = obj.getRawVal();

			if(val[2] && val[2].length > 0) {
				for(var i=0; i<val[2].length;i++) {
					me.val.push(val[2][i]);
				}
				me.rawval.push(rawval);
				me.setValue(me.rawval);
			}
			if(me.val && me.val.length > 0) {
				me.triggers[0].show();
			} else {
				me.triggers[0].hide();
			}
		});

		selectWin.show();
	},
	
	initComponent : function(){

		var me = this;

		this.val = new Array();
		this.rawval = new Array();

		Ext.app.qa.QATwinTriggerField.superclass.initComponent.call(this);
	},

	getKey: function() {
		return this.name ? this.name : 'qaItem';
	},

	getVal: function() {
		return this.val;
	},

	setVal: function(data) {
		this.val = data;
		this.setValue(data);
		this.selectWin.setVal(data);
	},

	getRawVal: function() {
		return this.rawval;;
	},

	getTxt: function() {
		return this.title;
	},

	getUXType: function() {
		return 'QATwinTriggerField';
	}
});
