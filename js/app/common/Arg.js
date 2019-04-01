/**
 * @class Ext.app.common.Arg
 * 创建参数对象（没有显示内容，只能作为参数传递）。
 */
Ext.ns('Ext.app.common');
Ext.app.common.Arg = function(key, val){
	this.key = key;
	this.val = val;
	this.isArg = true;

	this.getKey = function() {
		return this.key;
	};
	
	this.getVal = function() {
		return this.val;
	};

	this.getRawVal = function() {
		return this.val;
	};

	this.getTxt = function() {
		return '';
	};

	this.getUXType = function() {
		return 'Arg';
	};
	
};
