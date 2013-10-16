window.tabahead = ($, fuzzy, chrome, setTimeout) ->

    string_separator = ':::::'

    all_colons = /:/g

    fuzzy_options =
        pre: '<strong class="text-info">'
        post: '</strong>'
        extract: (el) ->
            "#{el.title}#{string_separator}#{el.url}"

    source = (query, process) ->
        chrome.windows.getCurrent populate: true, (current_window) ->
            results = fuzzy.filter query.replace(all_colons, ''), current_window.tabs, fuzzy_options
            process results

    matcher = ->
        true

    sorter = (items) ->
        items

    highlighter = (item) ->
        matches = item.string.split string_separator
        [title_highlighted, url_highlighted] = matches

        "<div class=\"title\">#{title_highlighted}</div><small class=\"muted url\">#{url_highlighted}</small>"

    # Quick and dirty monkey patch
    # Implemented `$.fn.data` instead of
    # `$.fn.attr('data-value')`
    # to be able to handle `item` objects
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
        item = (@$menu.find '.active').data 'value'

        setTimeout ->
            chrome.tabs.update item.original.id, active: true, ->
                window.close()
        , 1

        # `@hide()` suddenly caused the popup to stay open.
        return

    # Init `typeahead`.
    ($ '#typeahead')
        .typeahead
            source: source
            matcher: matcher
            sorter: sorter
            highlighter: highlighter
            items: 10
        .focus()

    # Do not `submit` form,
    # but reset input to empty string.
    ($ 'form').on 'submit', (event) ->
        ($ '#typeahead').val ''
        event.stopPropagation()

# Go go go, unless we're unit testing this thing.
window.tabahead window.jQuery, window.fuzzy, window.chrome, window.setTimeout unless window.__karma__?
