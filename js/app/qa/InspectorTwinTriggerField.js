/**
 * @class Ext.app.qa.InspectorTwinTriggerField
 * @extends Ext.app.common.TwinTriggerField
 * 质检员列表。
 */
Ext.ns('Ext.app.qa');
Ext.app.qa.InspectorTwinTriggerField = Ext.extend(Ext.app.common.TwinTriggerField, {
	width: 530,
	fieldLabel: '质检员',
	privilegeKey: 'QA_GRADE',
	onTrigger1Click : function(){this.setValue('');this.val = new Array();this.rawval = new Array(); this.triggers[0].hide();},
	onTrigger2Click : function() {
		this.selectWin.reset();
		this.selectWin.show();
	},
	
	showmode: 'Select',

	sampleCount: 0,

	initComponent : function(){

		var me = this;

		this.val = new Array();
		this.rawval = new Array();

		this.selectWin = new Ext.app.qa.InspectorSelectorWindow({
			name: 'inspectorWin',
			privilegeKey: me.privilegeKey,
			showmode: this.showmode,
			width: 720,
			height:432
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
			obj.setSampleCount(me.sampleCount);
		});

		Ext.app.qa.InspectorTwinTriggerField.superclass.initComponent.call(this);
	},

	getKey: function() {
		return this.name ? this.name : 'inspector';
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
		return 'InspectorTwinTriggerField';
	}
});
