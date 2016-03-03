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
            window.Fuse,
            window.chrome,
            window.setTimeout,
            window.localStorage

    describe 'loaded without exploding', ->
        it 'is available', ->
            (expect window.tabahead).toBeDefined()
            (expect window.tabahead).toEqual jasmine.any Function

    describe 'expects the chrome environment', ->
        it 'expects to find a form.navbar-search', ->
            (expect $ 'body').toContainElement 'form.navbar-search'

        it 'expects to find an input#typeahead', ->
            (expect $ 'form.navbar-search').toContainElement 'input#typeahead'

    describe 'Initially the input', ->
        it 'should be focused', ->
            (expect $ 'input#typeahead').toBeFocused()

    describe 'Typing some text into the input field', ->
        queryTabsSpy = {}

        beforeEach ->
            queryTabsSpy = (spyOn window.chrome.tabs, 'query').and.callThrough()

            $('#typeahead')
                .val('jan')
                .trigger('keyup')

        it 'should ask chrome API `tabs.query', ->
            (expect queryTabsSpy).toHaveBeenCalled()

        it 'should query the current window by default', ->
            (expect queryTabsSpy.calls.all()[0].args[0].currentWindow).toBe true

        it 'should show suggestions', (done) ->
            interval = setInterval ->
                if ($ 'ul').length > 0
                    clearInterval interval
                    (expect $ 'ul').toHaveLength(1)

                    # Add `\n` due to `new line at the end of the fixture.
                    (expect ($ 'ul').html() + '\n').toBe window.__html__['test/fixtures/suggestions.html']
                    done()
            , 1

    describe 'with the `pref/query` set to `all`', ->
        queryTabsSpy = {}

        beforeEach ->
            window.localStorage[PREF_QUERY] = QUERY.ALL

        beforeEach ->
            queryTabsSpy = (spyOn window.chrome.tabs, 'query').and.callThrough()

            $('#typeahead')
                .val('jan')
                .trigger('keyup')

        it 'should query all windows', ->
            (expect queryTabsSpy.calls.all()[0].args[0]).toEqual({})

    describe 'Selecting a suggestion', ->
        closeSpy = {}
        updateSpy = {}
        result = {}
        li = {}

        beforeEach ->
            updateSpy = (spyOn window.chrome.tabs, 'update').and.callThrough()
            closeSpy = spyOn window, 'close'

        describe 'inside the current window', ->
            beforeEach (done) ->
                $('#typeahead')
                    .val('jan')
                    .trigger('keyup')

                interval = setInterval ->
                    if ($ 'ul').length > 0
                        clearInterval interval
                        done()
                , 1


            describe 'by hitting return', ->
                beforeEach ->
                    li = $ 'li:nth-child(1)'
                    result = li.data 'value'

                    $('input').trigger($.Event 'keyup', keyCode: 13)

                it 'should update the tab and close the popup', (done) ->
                    interval = setInterval ->
                        if updateSpy.calls.count()
                            clearInterval interval
                            (expect updateSpy).toHaveBeenCalled()
                            (expect updateSpy.calls.mostRecent().args[0]).toBe result.item.id
                            (expect updateSpy.calls.mostRecent().args[1]).toEqual active: true
                            (expect updateSpy.calls.mostRecent().args[2]).toEqual jasmine.any Function
                            (expect closeSpy).toHaveBeenCalled()
                            done()
                    , 1

            describe 'by click', ->
                beforeEach ->
                    li = $ 'li:nth-child(2)'
                    result = li.data 'value'

                    ($ li).trigger 'mouseenter'
                    ($ li).trigger 'click'

                it 'should update the tab and close the popup', (done) ->
                    interval = setInterval ->
                        if updateSpy.calls.count()
                            clearInterval interval
                            (expect updateSpy).toHaveBeenCalled()
                            (expect updateSpy.calls.mostRecent().args[0]).toBe result.item.id
                            (expect updateSpy.calls.mostRecent().args[1]).toEqual active: true
                            (expect updateSpy.calls.mostRecent().args[2]).toEqual jasmine.any Function
                            (expect closeSpy).toHaveBeenCalled()
                            done()
                    , 1

        describe 'inside a different window', ->
            updateWindowSpy = {}
            beforeEach ->
                updateWindowSpy = (spyOn window.chrome.windows, 'update').and.callThrough()
                window.localStorage[PREF_QUERY] = QUERY.ALL

            beforeEach (done) ->
                $('#typeahead')
                    .val('jan')
                    .trigger('keyup')

                interval = setInterval ->
                    if ($ 'ul').length > 0
                        clearInterval interval
                        done()
                , 1

            describe 'by click', ->
                beforeEach ->
                    li = $ 'li:nth-child(2)'
                    result = li.data 'value'

                    ($ li).trigger 'mouseenter'
                    ($ li).trigger 'click'

                it 'should update the tab and focus the other window, plus close the popup', (done) ->
                    interval = setInterval ->
                        if updateSpy.calls.count()
                            clearInterval interval
                            (expect updateSpy).toHaveBeenCalled()
                            (expect updateSpy.calls.mostRecent().args[0]).toBe result.item.id
                            (expect updateSpy.calls.mostRecent().args[1]).toEqual active: true
                            (expect updateSpy.calls.mostRecent().args[2]).toEqual jasmine.any Function
                            (expect updateWindowSpy).toHaveBeenCalled()
                            (expect updateWindowSpy.calls.mostRecent().args[0]).toBe result.item.windowId
                            (expect updateWindowSpy.calls.mostRecent().args[1]).toEqual focused: true
                            (expect closeSpy).toHaveBeenCalled()
                            done()
                    , 1

    describe 'If there is no match', ->
        updateSpy = {}

        beforeEach (done) ->
            updateSpy = spyOn window.chrome.tabs, 'update'

            $('#typeahead')
                .val('jan')
                .trigger('keyup')

            interval = setInterval ->
                if ($ 'ul').length > 0
                    clearInterval interval
                    done()
            , 1

        describe 'hitting enter', ->
            beforeEach (done) ->
                $('#typeahead')
                    .val('janjanjanjanjanjanjanjan')
                    .trigger('keyup')

                interval = setInterval ->
                    if ($ 'ul').length > 0
                        clearInterval interval
                        jasmine.clock().install()
                        ($ '#typeahead').trigger($.Event 'keyup', keyCode: 13)
                        jasmine.clock().tick 100
                        done()
                , 1

            afterEach ->
                jasmine.clock().uninstall()

            it 'should not update the tab', ->
                (expect updateSpy).not.toHaveBeenCalled()

            it 'should clear the input', ->
                ($ '#typeahead').trigger('submit')
                (expect ($ '#typeahead').val()).toBe ''
