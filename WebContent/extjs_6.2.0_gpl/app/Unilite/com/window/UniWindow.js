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
        btnQuery: '조회',
        btnReset: '신규',
        btnNewData: '추가',
        btnDelete: '삭제',
        btnSave: '저장',
        btnDeleteAll: '전체삭제',
        btnExcel: '다운로드',
        btnPrev: '이전',
        btnNext: '이후',
        btnDetail: '추가검색',
        btnPrint: '인쇄',
        btnClose: '닫기'
    },
    
    /**
     * extend init props
     */
   initComponent: function () {
        var me = this;
        this.on('move', me._checkPosition);
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
    }
});

