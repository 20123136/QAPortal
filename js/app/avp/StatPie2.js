/**
 * @class Ext.app.avp.StatPie
 * @extends Ext.chart.PieChart
 * 饼状图。
 */
Ext.ns('Ext.app.avp');
Ext.app.avp.StatPie2 = Ext.extend(Ext.chart.PieChart, {
	dataField: 'value',
	categoryField: 'key',
	extraStyle:
	{
		legend:
		{
			display: 'bottom',
			padding: 5,
			font:
			{
				family: 'Tahoma',
				size: 13
			}
		}
	},
   
	constructor: function(config){
		Ext.app.avp.StatPie2.superclass.constructor.call(this, config);
        Ext.apply(this, config);
    },

	initComponent : function(){
		var me = this;

		Ext.app.avp.StatPie2.superclass.initComponent.call(this);
	}
});
