/**
 * @class Ext.ux.JXDepartmentField
 * @extends Ext.form.ComboBox
 * 创建部门选择框。
 */
Ext.ns('Ext.app.ux');
Ext.app.ux.DepartmentSelector = Ext.extend(Ext.form.ComboBox, {
	fieldLabel: '部门',
	name: 'deptid',
	valueField: 'id',
	displayField: 'name',
	typeAhead: true,
	forceSelection: true, 
	editable: false,
	mode: 'local',
	triggerAction: 'all',
	selectOnFocus:true,
	
	setDefaultValue: function() {
		if(!this.defaultValue) {
			if(this.store.getCount() > 0) {
				var rec = this.store.getAt(0);
				this.setValue(rec.data.value);
			}
		} else {
			this.setValue(defaultValue);
		}
	},

	initComponent : function(){
		var me = this;
		
		this.tpl = '<div style="height:200px;width:300px"><div id="jxDeptTree'+this.id+'"></div></div>',

		this.on('expand', function(){
			this.tree.render('jxDeptTree'+me.id);   
			this.tree.getRootNode().expand();
		}); 

		this.tree = new Ext.tree.TreePanel({   
			border:false,   
			width: 300,
			dataUrl: window.webRoot + 'Dept/TreeView/0',
			root: new Ext.tree.AsyncTreeNode({text: '选择部门',id:'0'}),
			listeners: {
				'click': function(node){
					me.setValue(node.id);   
					me.collapse(); 
				}
			}
		}),
		
		this.store = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			idProperty: 'value',
			remoteSort: false,

			fields: [
					{name: 'id'},
					{name: 'name'}
					],
			
			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'Depts'
			})
		}),

		this.store.load();
		Ext.app.ux.DepartmentSelector.superclass.initComponent.call(this);
	},
		
	getKey: function() {
		return this.name;
	},
	
	getVal: function() {
		return this.getValue();
	},
	
	getRawVal: function() {
		return this.getRawValue();
	},
	
	getTxt: function() {
		return this.fieldLabel;
	},

	getUXType: function() {
		return 'DepartmentSelector';
	}
});
