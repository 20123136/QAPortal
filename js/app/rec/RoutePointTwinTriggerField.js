/**
 * @class Ext.app.rec.RoutePointTwinTriggerField
 * @extends Ext.app.common.TwinTriggerField
 * 列表。
 */
Ext.ns('Ext.app.rec');
Ext.app.rec.RoutePointTwinTriggerField = Ext.extend(Ext.app.common.TwinTriggerField, {
	width: 530,
	fieldLabel: '路由点',
	onTrigger1Click : function(){this.setValue('');this.val = new Array();this.rawval = new Array(); this.triggers[0].hide();},
	onTrigger2Click : function() {
		this.selectWin.reset();
		this.selectWin.show();
	},
	
	initComponent : function(){

		var me = this;

		this.val = new Array();
		this.rawval = new Array();

		this.selectWin = new Ext.app.mgr.RoutePointSelectorWindow({
			name: 'groupWin',
			width: 720,
			height:435
		});

		this.selectWin.on('hide', function(obj) {
			var val = obj.getVal();
			var rawval = obj.getRawVal();

			if(val && val.length > 0) {
				me.val.push(val);
				me.rawval.push(rawval);
				me.setValue(me.rawval);
			}

			if(me.val && me.val.length > 0) {
				me.triggers[0].show();
			} else {
				me.triggers[0].hide();
			}
		});

		Ext.app.rec.RoutePointTwinTriggerField.superclass.initComponent.call(this);
	},

	getKey: function() {
		return this.name ? this.name : 'skillNo';
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
		return 'RoutePointTwinTriggerField';
	}
});
