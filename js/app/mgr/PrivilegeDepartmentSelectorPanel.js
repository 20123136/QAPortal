/**
 * @class Ext.app.mgr.PrivilegeDepartmentSelectorPanel
 * @extends Ext.app.common.Grid
 * 菜单列表（只支持两级菜单）。
 */
Ext.ns('Ext.app.mgr');

Ext.app.mgr.PrivilegeDepartmentSelectorPanel = Ext.extend(Ext.Panel, {
	layout: 'border',
	title: '部门数据',
	iconCls: 'deptbtn',
	border: false,
   
	showPaging: false,
   
	constructor: function(config){
		Ext.app.mgr.PrivilegeDepartmentSelectorPanel.superclass.constructor.call(this, config);
        Ext.apply(this, config);
    },

	initComponent : function(){
		var me = this;

		this.items = [
			new Ext.form.FormPanel({
				region:'north',
				border	: false,
				height: 65,

				bodyStyle: 'padding: 10px',
				defaults: {
					anchor: '0'
				},
				items : [
					{
						xtype: 'radiogroup',
						id: 'deptSelector',
						hideLabel: true,
						boxMaxWidth: 180,
						items : [
							{
								xtype: 'radio',
								id: 'deptAll',
								boxLabel: '所有部门',
								name: 'dept',
								value: 'all',
								listeners: {
									'check' : function(radio, checked) {
									}
								}
							},
							{
								xtype: 'radio',
								id: 'deptSpecial',
								boxLabel: '指定部门',
								name: 'dept',
								value: 'special',
								listeners: {
									'check' : function(radio, checked) {
										if(checked) {
											Ext.getCmp('deptUser').show();
											Ext.getCmp('treeDeptSelector').show();
										} else {
											Ext.getCmp('deptUser').hide();
											Ext.getCmp('treeDeptSelector').hide();
										}
									}
								}
							}
						]
					},
					{
						xtype: 'checkbox',
						id: 'deptUser',
						boxLabel: '所属部门',
						hideLabel: true,
						hidden: true,
						name: 'user-dept'
					}
				]
			}),
			
			new Ext.app.mgr.DepartmentSelectorTreePanel({
				id: 'treeDeptSelector',
				region: 'center',
				hidden: true,
				hideHeaders: true,
				height: 325,
				width: '80%'
			})	
		];

		Ext.app.mgr.PrivilegeDepartmentSelectorPanel.superclass.initComponent.call(this);
	},

	reset: function() {
		Ext.getCmp('deptUser').setValue(false);
		Ext.getCmp('deptSelector').reset();
		Ext.getCmp('treeDeptSelector').getRootNode().cascade(function(node){
			node.getUI().toggleCheck(false);
		});
	},

	getKey: function() {
		return this.name ? this.name : 'dept';
	},

	setVal: function(data) {
		Ext.each(data, function(pri){
			if(pri.privilegeTypeId == 'DATA' && pri.privilegeKey == 'DATA_DEPT') {
				if(pri.privilegeValue == '0') {
					Ext.getCmp('deptSelector').onSetValue('deptAll', true);
				} else {
					Ext.getCmp('deptSelector').onSetValue('deptSpecial', true);
					if(pri.privilegeValue == '-1') {
						Ext.getCmp('deptUser').setValue(true);
					} else {
						Ext.getCmp('treeDeptSelector').getRootNode().cascade(function(node){  
							if(node.id == pri.privilegeValue){  
								node.getUI().toggleCheck(true);
							}  
						}); 
					}
				}
			}
		});
	},
	
	getVal: function() {
		var ids = new Array();
		if(Ext.getCmp('deptAll').getValue()) {
			ids.push('0');
		} else {
			if(Ext.getCmp('deptUser').getValue()) {
				ids.push('-1');
			}
			if(Ext.getCmp('deptSpecial').getValue()) {
				var pids1 = Ext.getCmp('treeDeptSelector').getChecked('id');
				if(pids1) {
					for(var i=0; i<pids1.length;i++) {
						ids.push(pids1[i]);
					}
				}
			}
		}
		return ids;
	},
	
	getRawVal: function() {
		return this.getRawValue();
	},
	
	getTxt: function() {
		return this.fieldLabel;
	},

	getUXType: function() {
		return 'PrivilegeDepartmentSelectorPanel';
	}
});
