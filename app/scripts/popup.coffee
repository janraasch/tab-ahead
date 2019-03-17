window.tabahead = ($, Fuse, chrome, setTimeout, storage) ->
    # --> Constants shared with `options.coffee`
    QUERY =
        ALL: 'all'
        CURRENT: 'current'

    PREF_QUERY = 'pref/query'

    MAX_RESULTS_DEFAULT = 10

    PREF_MAX_RESULTS = 'pref/max_results'
    # Constants shared with `options.coffee` <--

    string_separator = ':::::'

    all_colons = /:/g

    relevant = (matches) ->
        ret = []
        $.each(matches, (i, pair) ->
            ret.push pair if pair[1] > pair[0]
        )
        if ret.length is 0 then matches else ret

    highlight_matches = (matches, text) ->
        relevant_matches = relevant(matches)
        pair = relevant_matches.shift()
        result = []
        Array.from(text).forEach (_val, i) ->
            char = text.charAt(i)
            result.push('<strong class="text-info">') if (pair and i is pair[0])
            result.push(char)
            if (pair and i is pair[1])
                result.push('</strong>')
                pair = relevant_matches.shift()
        result.join ''

    filter = (query, tabs) ->
        new Fuse(tabs,
            keys: ['title', 'url'],
            include: ['score', 'matches']
            maxPatternLength: query.length
        ).search(query)

    source = (query, process) ->
        queryInfo = currentWindow: true
        queryInfo = {} if storage[PREF_QUERY] is QUERY.ALL

        chrome.tabs.query queryInfo, (tabs) ->
            results = filter query, tabs
            process results

    matcher = ->
        true

    sorter = (items) ->
        items

    highlighter = (result) ->
        item = result.item
        highlighted = {
            title: item.title,
            url: item.url
        }
        result.matches.forEach((match) ->
            highlighted[match.key] = highlight_matches(match.indices, item[match.key])
        )

        "<div class=\"title\">#{highlighted.title}</div><small class=\"muted url\">#{highlighted.url}</small>"

    # Quick and dirty monkey patch
    # Implemented $.fn.data instead of
    # $.fn.attr('data-value')
    # to be able to handle item objects
    # instead of simple strings.
    $.fn.typeahead.Constructor::render = (items) ->
        items = ($ items).map (i, item) =>
            i = ($ @options.item).data 'value', item
            (i.find 'a').html @highlighter item
            i[0]

        items.first().addClass 'active'
        @$menu.html(items)

        this

    # Workaround
    # Fixes some weird timing issue, which
    # prevented the popup from being closed,
    # during tab switching. Popup disappeared,
    # but was still visible as a separate window,
    # when showing all Chrome windows.
    $.fn.typeahead.Constructor::select = ->
        result = (@$menu.find '.active').data 'value'
        setTimeout (->
            chrome.tabs.update result.item.id, active: true, ->
                if result.item.windowId isnt chrome.windows.WINDOW_ID_CURRENT
                    chrome.windows.update result.item.windowId, focused: true
                window.close()
        ), 1

        # @hide() suddenly caused the popup to stay open.
        return

    # Init typeahead.
    items = if storage[PREF_MAX_RESULTS] > 0 then storage[PREF_MAX_RESULTS] else MAX_RESULTS_DEFAULT
    ($ '#typeahead').typeahead(
        source: source
        matcher: matcher
        sorter: sorter
        highlighter: highlighter
        items: items
    ).focus()

    # Do not submit form,
    # but reset input to empty string.
    ($ 'form').on 'submit', (event) ->
        ($ '#typeahead').val ''
        event.stopPropagation()
        event.preventDefault()

# Go go go, unless we're unit testing this thing.
unless window.__karma__?
    window.tabahead window.jQuery, window.Fuse, window.chrome, window.setTimeout, window.localStorage
