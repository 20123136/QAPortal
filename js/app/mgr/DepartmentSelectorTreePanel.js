/**
 * @class Ext.app.mgr.DepartmentSelectorTreePanel
 * @extends Ext.app.common.TreePanel
 * 组织架构列表。
 */
Ext.ns('Ext.app.mgr');

Ext.app.mgr.DepartmentSelectorTreePanel = Ext.extend(Ext.app.common.TreePanel, {
	title: '部门列表',
	iconCls: 'deptbtn',
	region:'center',
	
	loader: new Ext.tree.TreeLoader({
		dataUrl:webRoot + '/Dept/TreeView/Checkable/0'
	}),
	
	constructor: function(config){
		Ext.app.mgr.DepartmentSelectorTreePanel.superclass.constructor.call(this, config);
        Ext.apply(this, config);
    },

	initComponent : function(){
		var me = this;
		Ext.apply(this, {
			root: new Ext.tree.AsyncTreeNode()
		});

		this.on('click', function(node, e) {
			if(node.getUI().isChecked()) {
				node.getUI().toggleCheck(false);
			} else {
				node.getUI().toggleCheck(true);
			}
		});

		Ext.app.mgr.DepartmentSelectorTreePanel.superclass.initComponent.call(this);
	},

	groupSelected: function() {
	},

	reset: function() {
		this.getRootNode().cascade(function(node){
			node.getUI().toggleCheck(false);
		});
	},

	getKey: function() {
		return this.name;
	},
	
	getVal: function() {
		return this.getChecked('id');
	},
	
	setVal: function(data) {
		var me = this;
		Ext.each(data, function(val){
			me.getRootNode().cascade(function(node){  
				if(node.id == val){  
					node.getUI().toggleCheck(true);
				}  
			}); 
		});
	},
	
	getRawVal: function() {
		return this.getChecked('text');
	},
	
	getTxt: function() {
		return this.fieldLabel;
	},

	getUXType: function() {
		return 'DepartmentSelectorTreePanel';
	}
});

