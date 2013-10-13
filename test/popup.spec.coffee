describe 'Tab Ahead. Popup', ->

    describe 'expects the chrome environment', ->
        it 'expects to find a form.navbar-search', ->
            (expect $ 'body').toContain 'form.navbar-search'

        it 'expects to find an input#typeahead', ->
            (expect $ 'form.navbar-search').toContain 'input#typeahead'

    describe 'Typing some text into the input field', ->
        getCurrentWindowSpy = {}

        beforeEach ->
            getCurrentWindowSpy = (spyOn window.chrome.windows, 'getCurrent').andCallThrough()

            $('#typeahead')
                .val('jan')
                .trigger('keyup')

        it 'should ask chrome API for current window', ->
            (expect getCurrentWindowSpy).toHaveBeenCalled()

        it 'should show suggestions', ->
            waitsFor ->
                ($ 'ul').length > 0

            runs ->
                (expect $ 'ul').toHaveLength(1)

                # Add `\n` due to `new line at the end of the fixture.
                (expect ($ 'ul').html() + '\n').toBe window.__html__['test/fixtures/suggestions.html']

    describe 'Selecting a suggestion', ->
        updateSpy = {}
        item = {}
        li = {}

        beforeEach ->
            updateSpy = spyOn window.chrome.tabs, 'update'

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

                $('input')
                    .trigger('keyup')
                    .trigger($.Event 'keyup', keyCode: 13)

                jasmine.Clock.tick 200

            it 'should update the tab', ->
                (expect updateSpy).toHaveBeenCalled()
                (expect updateSpy).toHaveBeenCalledWith item.original.id, active: true

        describe 'by click', ->
            beforeEach ->
                li = $ 'li:nth-child(2)'
                item = li.data 'value'

                jasmine.Clock.useMock()

                ($ li).trigger 'mouseenter'
                ($ li).trigger 'click'

                jasmine.Clock.tick 200

            it 'should update the tab', ->
                (expect updateSpy).toHaveBeenCalled()
                (expect updateSpy).toHaveBeenCalledWith item.original.id, active: true
