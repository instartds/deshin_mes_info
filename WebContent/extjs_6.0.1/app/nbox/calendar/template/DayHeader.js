/*!
 * nbox 1.5.2
 * Copyright(c) 2010-2013 nbox, LLC
 * licensing@ext.ensible.com
 * http://ext.ensible.com
 */
/**
 * @class nbox.calendar.template.DayHeader
 * @extends Ext.XTemplate
 * <p>This is the template used to render the all-day event container used in {@link nbox.calendar.view.Day DayView} and 
 * {@link nbox.calendar.view.Week WeekView}. Internally the majority of the layout logic is deferred to an instance of
 * {@link nbox.calendar.template.BoxLayout}.</p> 
 * <p>This template is automatically bound to the underlying event store by the 
 * calendar components and expects records of type {@link nbox.calendar.data.EventModel}.</p>
 * <p>Note that this template would not normally be used directly. Instead you would use the {@link nbox.calendar.view.DayTemplate}
 * that internally creates an instance of this template along with a {@link nbox.calendar.template.DayBody}.</p>
 * @constructor
 * @param {Object} config The config object
 */
Ext.define('nbox.calendar.template.DayHeader', {
    extend: 'Ext.XTemplate',
    
    requires: ['nbox.calendar.template.BoxLayout'],
    
    // private
    constructor: function(config){
        
        Ext.apply(this, config);
    
        this.allDayTpl = Ext.create('nbox.calendar.template.BoxLayout', config);
        this.allDayTpl.compile();
        
        nbox.calendar.template.DayHeader.superclass.constructor.call(this,
            '<div class="ext-cal-hd-ct">',
                '<table class="ext-cal-hd-days-tbl" cellspacing="0" cellpadding="0">',
                    '<tbody>',
                        '<tr>',
                            '<td class="ext-cal-gutter"></td>',
                            '<td class="ext-cal-hd-days-td"><div class="ext-cal-hd-ad-inner">{allDayTpl}</div></td>',
                            '<td class="ext-cal-gutter-rt"></td>',
                        '</tr>',
                    '</tbody>',
                '</table>',
            '</div>'
        );
    },
    
    // private
    applyTemplate : function(o){
        var templateConfig = {
            allDayTpl: this.allDayTpl.apply(o)
        };
         
        if (Ext.getVersion().isLessThan('4.1')) {
            return nbox.calendar.template.DayHeader.superclass.applyTemplate.call(this, templateConfig);
        }
        else {
            return this.applyOut(templateConfig, []).join('');
        }
    }
}, 
function() {
    this.createAlias('apply', 'applyTemplate');
});