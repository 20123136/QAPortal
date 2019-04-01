/**
 * @class Ext.app.avp.StatPie
 * @extends Ext.ux.HighChart
 * 饼状图。
 */
Ext.ns('Ext.app.avp');
Ext.app.avp.StatChart = Ext.extend(Ext.ux.HighChart, {
	chartConfig: {
		chart: {
			defaultSeriesType : 'bar',
			margin: [10, 10, 20, 50]
		},
		title: {
			text: false
		},
		xAxis: {
			categories: ['金普线', '白金线', 'VIP专线', '积分专线']
		},
		yAxis: {
			min: 0
		},
		legend: {
			backgroundColor: '#FFFFFF',
			reversed: true
		},
		plotOptions: {
			series: {
				stacking: 'normal'
			}
		}
	},
	series: [{
		name: '正常进线',
		data: [0, 0, 0, 0]
	}, {
		name: '会议IVR',
		data: [0, 0, 0, 0]
	}, {
		name: '转接IVR',
		data: [0, 0, 0, 0]
	}, {
		name: '满意度',
		data: [0, 0, 0, 0]
	}, {
		name: '语音留言',
		data: [0, 0, 0, 0]
	}, {
		name: '语音留言RTT',
		data: [0, 0, 0, 0]
	}],
   
	constructor: function(config){
		Ext.app.avp.StatChart.superclass.constructor.call(this, config);
        Ext.apply(this, config);
    },

	initComponent : function(){
		var me = this;

		Ext.app.avp.StatChart.superclass.initComponent.call(this);
	}
});
