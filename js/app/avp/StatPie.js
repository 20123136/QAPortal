/**
 * @class Ext.app.avp.StatPie
 * @extends Ext.ux.HighChart
 * 饼状图。
 */
Ext.ns('Ext.app.avp');
Ext.app.avp.StatPie = Ext.extend(Ext.ux.HighChart, {
	chartConfig: {
        chart: {
            plotBackgroundColor: null,
            plotBorderWidth: null,
            plotShadow: false
        },
        title: {
            text: 'Browser market shares at a specific website, 2010'
        },
		tooltip: {
			pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
		},
		plotOptions: {
			pie: {
				allowPointSelect: true,
				cursor: 'pointer',
				dataLabels: {
					enabled: true,
					color: '#000000',
					connectorColor: '#000000',
					format: '<b>{point.name}</b>: {point.percentage:.1f} %'
				}
			}
		}
	},
	series: [{
		type: 'pie',
		name: 'Browser share',
		data: [
			['Firefox',   45.0],
			['IE',       26.8],
			{
				name: 'Chrome',
				y: 12.8,
				sliced: true,
				selected: true
			},
			['Safari',    8.5],
			['Opera',     6.2],
			['Others',   0.7]
		]
	}],
   
	constructor: function(config){
		Ext.app.avp.StatPie.superclass.constructor.call(this, config);
        Ext.apply(this, config);
    },

	initComponent : function(){
		var me = this;

		Ext.app.avp.StatPie.superclass.initComponent.call(this);
	}
});
