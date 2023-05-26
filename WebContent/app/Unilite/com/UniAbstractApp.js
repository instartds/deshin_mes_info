//@charset UTF-8
/**
 * 
 */
 Ext.define('Unilite.com.UniAbstractApp', {
	extend: 'Ext.Viewport',
    //defaults: {padding: '5 5 5 5'},
    //defaults: {padding: 0},  // 검색조건에 padding값 0 되는 현상 제거 목표 2014.07.09
    layout : {	type: 'vbox', pack: 'start', align: 'stretch' },
	params:{},
	items: [],
	buttons:{},
    requires: [
	    'Ext.ux.DataTip',
	    'Unilite.com.UniAppManager'
	],
    // abstract
	beforeClose:Ext.emptyFn,
	toolBar : {},    
    comPanelToolbar : {
			xtype : 'panel',
			//id : 'comPanelToolbar',
			flex : 0,
			border : 0,
			margin : '0 0 0 0 ',
			dockedItems : [ ]
	},
	
	onQueryButtonDown: Ext.emptyFn


}); // define