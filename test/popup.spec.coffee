describe 'Tab Ahead. Popup', ->
    # --> Constants shared with `options.coffee`
    QUERY =
        ALL: 'all'
        CURRENT: 'current'

    PREF_QUERY = 'pref/query'
    # Constants shared with `options.coffee` <--

    # Mocking birds
    window.chrome =
        windows:
            update: (windowId, updateInfo, callback) ->
                callback?()
            WINDOW_ID_CURRENT: 271
        tabs:
            query: (queryInfo, callback) ->
                if queryInfo.currentWindow
                    $.getJSON 'base/test/fixtures/currentwindow.json', (data) ->
                        callback data
                else
                    $.getJSON 'base/test/fixtures/allwindows.json', (data) ->
                        callback data
            update: (tabId, updateProperties, callback) ->
                callback()

    beforeEach ->
        setFixtures window.__html__['test/fixtures/form.html']
        window.localStorage[PREF_QUERY] = undefined
        window.tabahead window.jQuery,
            window.fuzzy,
            window.chrome,
            window.setTimeout,
            window.localStorage

    describe 'loaded without exploding', ->
        it 'is available', ->
            (expect window.tabahead).toBeDefined()
            (expect window.tabahead).toEqual jasmine.any Function

    describe 'expects the chrome environment', ->
        it 'expects to find a form.navbar-search', ->
            (expect $ 'body').toContain 'form.navbar-search'

        it 'expects to find an input#typeahead', ->
            (expect $ 'form.navbar-search').toContain 'input#typeahead'

    describe 'Initially the input', ->
        it 'should be focused', ->
            (expect $ 'input#typeahead').toBeFocused()

    describe 'Typing some text into the input field', ->
        queryTabsSpy = {}

        beforeEach ->
            queryTabsSpy = (spyOn window.chrome.tabs, 'query').andCallThrough()

            $('#typeahead')
                .val('jan')
                .trigger('keyup')

        it 'should ask chrome API `tabs.query', ->
            (expect queryTabsSpy).toHaveBeenCalled()

        it 'should query the current window by default', ->
            (expect queryTabsSpy.calls[0].args[0].currentWindow).toBe true

        it 'should show suggestions', ->
            waitsFor ->
                ($ 'ul').length > 0

            runs ->
                (expect $ 'ul').toHaveLength(1)

                # Add `\n` due to `new line at the end of the fixture.
                (expect ($ 'ul').html() + '\n').toBe window.__html__['test/fixtures/suggestions.html']

    describe 'Typing with colon-prefix into the input field', ->
        queryTabsSpy = {}

        it 'should search only in URL', ->
            $('#typeahead')
                .val(':google')
                .trigger('keyup')

            waitsFor ->
                ($ 'ul').length > 0

            runs ->
                (expect $ 'ul').toHaveLength(1)

                # Add `\n` due to `new line at the end of the fixture.
                (expect ($ 'ul').html() + '\n').toBe window.__html__['test/fixtures/suggestions2.html']

    describe 'with the `pref/query` set to `all`', ->
        queryTabsSpy = {}

        beforeEach ->
            window.localStorage[PREF_QUERY] = QUERY.ALL

        beforeEach ->
            queryTabsSpy = (spyOn window.chrome.tabs, 'query').andCallThrough()

            $('#typeahead')
                .val('jan')
                .trigger('keyup')

        it 'should query all windows', ->
            (expect queryTabsSpy.calls[0].args[0]).toEqual({})

    describe 'Selecting a suggestion', ->
        closeSpy = {}
        updateSpy = {}
        item = {}
        li = {}

        beforeEach ->
            updateSpy = (spyOn window.chrome.tabs, 'update').andCallThrough()
            closeSpy = spyOn window, 'close'

        describe 'inside the current window', ->
            beforeEach ->
                $('#typeahead')
                    .val('jan')
                    .trigger('keyup')

                waitsFor ->
                    ($ 'ul').length > 0

            describe 'by hitting return', ->
                beforeEach ->
                    li = $ 'li:nth-child(1)'
                    item = li.data 'value'

                    jasmine.Clock.useMock()

                    $('input').trigger($.Event 'keyup', keyCode: 13)

                    jasmine.Clock.tick 100

                it 'should update the tab and close the popup', ->
                    (expect updateSpy).toHaveBeenCalled()
                    (expect updateSpy.mostRecentCall.args[0]).toBe item.original.id
                    (expect updateSpy.mostRecentCall.args[1]).toEqual active:true
                    (expect updateSpy.mostRecentCall.args[2]).toEqual jasmine.any Function
                    (expect closeSpy).toHaveBeenCalled()


            describe 'by click', ->
                beforeEach ->
                    li = $ 'li:nth-child(2)'
                    item = li.data 'value'

                    jasmine.Clock.useMock()

                    ($ li).trigger 'mouseenter'
                    ($ li).trigger 'click'

                    jasmine.Clock.tick 200

                it 'should update the tab and close the popup', ->
                    (expect updateSpy).toHaveBeenCalled()
                    (expect updateSpy.mostRecentCall.args[0]).toBe item.original.id
                    (expect updateSpy.mostRecentCall.args[1]).toEqual active:true
                    (expect updateSpy.mostRecentCall.args[2]).toEqual jasmine.any Function
                    (expect closeSpy).toHaveBeenCalled()

        describe 'inside a different window', ->
            updateWindowSpy = {}
            beforeEach ->
                updateWindowSpy = (spyOn window.chrome.windows, 'update').andCallThrough()
                window.localStorage[PREF_QUERY] = QUERY.ALL

            beforeEach ->
                $('#typeahead')
                    .val('jan')
                    .trigger('keyup')

                waitsFor ->
                    ($ 'ul').length > 0

            describe 'by click', ->
                beforeEach ->
                    li = $ 'li:nth-child(2)'
                    item = li.data 'value'

                    jasmine.Clock.useMock()

                    ($ li).trigger 'mouseenter'
                    ($ li).trigger 'click'

                    jasmine.Clock.tick 200

                it 'should update the tab and focus the other window, plus close the popup', ->
                    (expect updateSpy).toHaveBeenCalled()
                    (expect updateSpy.mostRecentCall.args[0]).toBe item.original.id
                    (expect updateSpy.mostRecentCall.args[1]).toEqual active: true
                    (expect updateSpy.mostRecentCall.args[2]).toEqual jasmine.any Function
                    (expect updateWindowSpy).toHaveBeenCalled()
                    (expect updateWindowSpy.mostRecentCall.args[0]).toBe item.original.windowId
                    (expect updateWindowSpy.mostRecentCall.args[1]).toEqual focused: true
                    (expect closeSpy).toHaveBeenCalled()

    describe 'If there is no match', ->
        updateSpy = {}

        beforeEach ->
            updateSpy = spyOn window.chrome.tabs, 'update'

            $('#typeahead')
                .val('jan')
                .trigger('keyup')

            waitsFor ->
                ($ 'ul').length > 0

        describe 'hitting enter', ->
            beforeEach ->
                $('#typeahead')
                    .val('janjanjanjanjanjanjanjan')
                    .trigger('keyup')

                waitsFor ->
                    ($ 'ul').is(':hidden')
                runs ->
                    jasmine.Clock.useMock()
                    ($ '#typeahead').trigger($.Event 'keyup', keyCode: 13)
                    jasmine.Clock.tick 100

            it 'should not update the tab', ->
                (expect updateSpy).not.toHaveBeenCalled()

            it 'should clear the input', ->
                ($ '#typeahead').trigger('submit')
                (expect ($ '#typeahead').val()).toBe ''



