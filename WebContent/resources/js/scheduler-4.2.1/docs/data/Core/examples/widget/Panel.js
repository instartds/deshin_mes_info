const panel = new Panel({
    appendTo : targetElement,
    height   : '20em',
    width    : '40em',
    header   : 'Panel header',
    tools    : [
        {
            cls     : 'b-fa b-fa-times',
            handler : () => panel.destroy()
        }
    ],
    tbar : [
        {
            icon : 'b-fa-save'
        },
        {
            icon : 'b-fa-trash'
        },
        {
            icon : 'b-fa-arrow-left',

            onClick() {
                const
                    tbar = this.up('toolbar'),
                    dock = { t : 'left', r : 'top', b : 'right', l : 'bottom' }[tbar.dock[0]];

                tbar.dock = dock;
                this.icon = `b-fa-arrow-${dock === 'bottom' ? 'right' : 'left'}`;
            }
        }
    ],
    bbar : [
        {
            text : 'Button in bottom toolbar'
        }
    ],
    html : `Bacon ipsum dolor amet flank ribeye ham hock rump, 
        alcatra pork belly pancetta leberkas bacon shoulder 
        meatloaf ball tip pig. Tongue jerky meatloaf pancetta 
        pork sirloin. Hamburger corned beef ball tip cupim 
        sirloin frankfurter tri-tip. Swine kevin ham hock, 
        drumstick flank pig shoulder shankle. Tri-tip pork 
        chop fatback turducken pork salami. Tongue boudin 
        salami flank bacon sirloin`
});
