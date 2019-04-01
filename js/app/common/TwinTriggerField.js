/**
 * @class Ext.app.common.TwinTriggerField
 * @extends Ext.form.TwinTriggerField
 * 列表。
 */
Ext.ns('Ext.app.common');
Ext.app.common.TwinTriggerField = Ext.extend(Ext.form.TwinTriggerField, {
	editable: false,
	trigger1Class:'x-form-clear-trigger',
	trigger2Class:'x-form-search-trigger',
	
	initComponent : function(){
		Ext.app.common.TwinTriggerField.superclass.initComponent.call(this);
	}
});
