/**
 * @class Ext.app.rec.AgentTwinTriggerField
 * @extends Ext.app.common.TwinTriggerField
 * 列表。
 */
Ext.ns('Ext.app.rec');
Ext.app.rec.WechatTempTwinTriggerField = Ext.extend(Ext.app.common.TwinTriggerField, {
	width: 530,
	fieldLabel: '模版',
	editable:true,
	onTrigger1Click : function(){this.setValue('');this.val = new Array();this.rawval = new Array(); this.triggers[0].hide();},
	onTrigger2Click : function() {
		this.selectWin.reset();
		this.selectWin.show();
	},
	
	initComponent : function(){

		var me = this;

		this.val = new Array();
		this.rawval = new Array();

		this.selectWin = new Ext.app.mgr.WechatTempSelectorWindow({
			name: 'wechatTempWin',
			width: 720,
			height:400
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

		Ext.app.rec.WechatTempTwinTriggerField.superclass.initComponent.call(this);
	},

	getKey: function() {
		return this.name ? this.name : 'name ';
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
		return 'WechatTempTwinTriggerField';
	}
});
