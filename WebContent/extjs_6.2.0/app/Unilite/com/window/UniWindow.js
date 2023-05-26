//@charset UTF-8
/**
 * 상세팝업용 윈도 모듈
 * 
 */
Ext.define('Unilite.com.window.UniWindow', {
    extend: 'Ext.window.Window',
    header: {
        titlePosition: 0,
        titleAlign: 'left'
    },
        
    closable: false,
    closeAction: 'hide',
    /**
     * 최초 오픈시 창의 크기 및 위치
     * 
     * lt: leftTop ( default )
     * rt: rightTop
     * center : 화면 중앙
     * maxmized: 꽉찬 윈도우
     * 
     * @type String
     */
    basePosition:'lt',	
    modal: true,
    resizable: true,
    layout: {
        type: 'fit'
    },
    dockedItems: [],
    
    text: {
        btnQuery: UniUtils.getLabel('system.label.commonJS.window.btnQuery','조회'),
        btnReset: UniUtils.getLabel('system.label.commonJS.window.btnReset','신규'),
        btnNewData: UniUtils.getLabel('system.label.commonJS.window.btnNewData','추가'),
        btnDelete: UniUtils.getLabel('system.label.commonJS.window.btnDelete','삭제'),
        btnSave: UniUtils.getLabel('system.label.commonJS.window.btnSave','저장'),
        btnDeleteAll: UniUtils.getLabel('system.label.commonJS.window.btnDeleteAll','전체삭제'),
        btnExcel: UniUtils.getLabel('system.label.commonJS.window.btnExcel','다운로드'),
        btnPrev: UniUtils.getLabel('system.label.commonJS.window.btnPrev','이전'),
        btnNext: UniUtils.getLabel('system.label.commonJS.window.btnNext','이후'),
        btnDetail: UniUtils.getLabel('system.label.commonJS.window.btnDetail','추가검색'),
        btnPrint: UniUtils.getLabel('system.label.commonJS.window.btnPrint','인쇄'),
        btnClose: UniUtils.getLabel('system.label.commonJS.window.btnClose','닫기'),
        btnSaveClose:UniUtils.getLabel('system.label.commonJS.window.btnSaveClose','저장 후 닫기')
    },
    
    /**
     * extend init props
     */
   initComponent: function () {
        var me = this;
        this.on('move', me._checkPosition);
        me.on('render', me._onRender);
        me.callParent(arguments);
    },
    /**
     * @private
     * @param {} btnName
     * @param {} state
     */
    _setToolbarButton: function(btnName, state) {
        var obj =  this.getTopToolbar();
        if(obj) {
	        var btn = obj.getComponent(btnName);
	        if(btn) {
	            (state) ? btn.enable():btn.disable();
	        }
        }
    },
    getTopToolbar : function() {
        return this.toolbar;
    },
    _checkPosition: function( win, x, y, eOpts ) {
        if(x < 0 ) {
            win.setX(0);
        }
        if(y < 0 ) {
            win.setY(0);
        }
    },
    onShow: function() {
        var me = this;
        var mySize = me.getSize();
        var pSize = Ext.getBody().getSize();
        
        if(mySize.height > pSize.height) {
            me.setSize({
                    width: mySize.width,
                    height : pSize.height
            });   
        }
        var posX = pSize.width - mySize.width;
        me.x = 0;//(posX < 0) ? 0 : posX;
        me.y = 0;
        //me.setXY(me.);
        
    	// basePosition, lt,lr,center,maximized
        switch( this.basePosition ) {
        	case 'lt':
	        	 me.x = 0;
	        	 me.y = 0;
        		break;
    		case 'maximized' :
    			 me.x = 0;
	        	 me.y = 0;
	        	 me.setSize({
                    width: pSize.width,
                    height : pSize.height
            	}); 
//            	me.maximize();
        }
        
        me.callParent(arguments);
    },
    _doPositioning: function() {
    	// basePosition
    },
    /**
     * @private
     * @param {} btnName
     * @param {} state
     */
    _setToolbarButton: function(btnName, state) {
        var obj =  this.getTopToolbar();
        if(obj) {
	        var btn = obj.getComponent(btnName);
	        if(btn) {
	            (state) ? btn.enable():btn.disable();
	        }
        }
    },
    setToolbarButtons: function(btnNames, state) {
            var me = this;
            if(Ext.isArray(btnNames) ) {
                for(i =0, len = btnNames.length; i < len; i ++) {
                    var element = btnNames[i];
                    me._setToolbarButton(element, state);
                }
            } else {
                me._setToolbarButton(btnNames, state);
            }
    },
	_onRender: function()	{
		var me = this;
		me.getEl().on('keydown',	function(event){
			
			if(event.getKey() == Ext.EventObjectImpl.ESC)	{
				event.stopEvent();
				return false;
			}
			
		})
	}
});

