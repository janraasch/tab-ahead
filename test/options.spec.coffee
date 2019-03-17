describe 'Tab Ahead. Options', ->
    # --> Constants shared with `popup.coffee`
    QUERY =
        ALL: 'all'
        CURRENT: 'current'

    PREF_QUERY = 'pref/query'

    MAX_RESULTS_DEFAULT = 10

    PREF_MAX_RESULTS = 'pref/max_results'
    # Constants shared with `popup.coffee` <--

    beforeEach ->
        setFixtures window.__html__['test/fixtures/options.html']
        window.localStorage[PREF_QUERY] = undefined

    describe 'loaded without exploding', ->
        it 'is available', ->
            (expect window.tabaheadOptions).toBeDefined()
            (expect window.tabaheadOptions).toEqual jasmine.any Function

    describe 'expects the chrome options html', ->
        it 'expects to find the two options', ->
            (expect $ 'body').toContainElement '#current'
            (expect $ 'body').toContainElement '#all'

    describe 'Initially the option', ->
        beforeEach ->
            window.localStorage[PREF_QUERY] = undefined
            window.tabaheadOptions window.localStorage

        it 'will be set to `current`', ->
            (expect $('#current').is(':checked')).toBe true
            (expect $('#all').is(':checked')).toBe false
            (expect window.localStorage[PREF_QUERY]).toBe QUERY.CURRENT

    describe 'Clicking `#all`', ->
        beforeEach ->
            window.tabaheadOptions window.localStorage

            # Simply using `$.trigger` won't work in `PhantomJS`.
            event = document.createEvent 'MouseEvents'
            event.initMouseEvent 'click'

            (($ '#all').get 0).dispatchEvent event

        it 'should set the option to `all`', ->
            (expect $('#all').is(':checked')).toBe true
            (expect $('#current').is(':checked')).toBe false
            (expect window.localStorage[PREF_QUERY]).toBe QUERY.ALL

    describe 'Clicking `#current`', ->
        beforeEach ->
            window.tabaheadOptions window.localStorage

            # Simply using `$.trigger` won't work in `PhantomJS`.
            event = document.createEvent 'MouseEvents'
            event.initMouseEvent 'click'

            (($ '#current').get 0).dispatchEvent event

        it 'should set the option to `current`', ->
            (expect $('#current').is(':checked')).toBe true
            (expect $('#all').is(':checked')).toBe false
            (expect window.localStorage[PREF_QUERY]).toBe QUERY.CURRENT
