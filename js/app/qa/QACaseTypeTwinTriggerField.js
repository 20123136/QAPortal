/**
 * @class Ext.app.qa.QACaseTypeTwinTriggerField
 * @extends Ext.app.common.TwinTriggerField
 * 案例属性列表。
 */
Ext.ns('Ext.app.qa');
Ext.app.qa.QACaseTypeTwinTriggerField = Ext.extend(Ext.app.common.TwinTriggerField, {
	width: 530,
	fieldLabel: '案例类型',
	onTrigger1Click : function(){this.setValue('');this.val = new Array();this.rawval = new Array(); this.triggers[0].hide();},
	onTrigger2Click : function() {
		this.selectWin.reset();
		this.selectWin.show();
	},
	
	initComponent : function(){

		var me = this;

		this.val = new Array();
		this.rawval = new Array();

		this.selectWin = new Ext.app.qa.QACaseTypeSelectorWindow({
			name: 'qaCaseTypeWin',
			width: 720,
			height:435
		});

		this.selectWin.on('hide', function(obj) {
			if(obj.justClose) {
				obj.justClose = false;
				return;
			}
			var val = obj.getVal();
			var rawval = obj.getRawVal();
			if(val && val.length > 0) {
				me.val = val;
				me.rawval = rawval;
				me.setValue(me.rawval);
			} else {
				me.val = new Array();
				me.rawval = '';
				me.setValue(me.rawval);
			}

			if(me.val && me.val.length > 0) {
				me.triggers[0].show();
			} else {
				me.triggers[0].hide();
			}
		});

		this.selectWin.on('show', function(obj) {
			obj.setVal(me.val);
		});

		Ext.app.qa.QACaseTypeTwinTriggerField.superclass.initComponent.call(this);
	},

	setGroupTypeId: function(groupTypeId) {
		this.selectWin.setGroupTypeId(groupTypeId);
	},

	getKey: function() {
		return this.name ? this.name : 'qaCaseType';
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
		return this.rawval;
	},

	getTxt: function() {
		return this.title;
	},

	getUXType: function() {
		return 'QACaseTypeTwinTriggerField';
	}
});
