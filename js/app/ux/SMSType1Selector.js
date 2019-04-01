/**
 * @class Ext.app.ux.NumberSelector
 * @extends Ext.form.ComboBox
 * 创建数据选择框。
 */
Ext.ns('Ext.app.ux');
Ext.app.ux.SMSType1Selector = Ext.extend(Ext.form.ComboBox, {
	store: new Ext.data.ArrayStore({
				fields: ['val'],
				data : [['forced'],['requested'],['system'],['none']]
			}),
	displayField:'val',
	valueField:'val',
	typeAhead: true,
	forceSelection: true,
	mode: 'local',
	editable: false,
	triggerAction: 'all',
	selectOnFocus:true
});
