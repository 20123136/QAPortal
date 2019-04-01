<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
    <script type="text/javascript" src="../js/ext-base-debug.js"></script>
    <script type="text/javascript" src="../js/ext-all-debug.js"></script>
    <script type="text/javascript" src="../js/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../js/ext-ui-combo-pagesize.js"></script>
    <script type="text/javascript" src="../ux/ColumnHeaderGroup.js"></script>
    <script type="text/javascript" src="../ux/ExportExcel.js"></script>
	<script type="text/javascript" src="../js/func.js"></script>
<script type="text/javascript">
Ext.chart.Chart.CHART_URL = '../js/charts.swf';

Ext.onReady(function(){
	var store = new Ext.data.JsonStore({
        fields:['name', 'visits', 'views'],
        data: [
            {name:'Jul 07', visits: 245000, views: 3000000},
            {name:'Aug 07', visits: 240000, views: 3500000},
            {name:'Sep 07', visits: 355000, views: 4000000},
            {name:'Oct 07', visits: 375000, views: 4200000},
            {name:'Nov 07', visits: 490000, views: 4500000},
            {name:'Dec 07', visits: 495000, views: 5800000},
            {name:'Jan 08', visits: 520000, views: 6000000},
            {name:'Feb 08', visits: 620000, views: 7500000}
        ]
    });

    // extra extra simple
    new Ext.Panel({
        title: '坐席折线图',
        renderTo: Ext.getBody(),
        width:500,
        height:300,
        layout:'fit',
        items: {
            xtype: 'linechart',
            store: store,
            xField: 'name',
            yField: 'visits',
            listeners: {
                itemclick: function(o){
                    var rec = store.getAt(o.index);
                    Ext.example.msg('Item Selected', 'You chose {0}.', rec.get('name'));
                }
            }
        }
    });
});
</script>
<html>