window.tabaheadOptions = (storage) ->
    # --> Constants shared with popup.coffee
    QUERY =
        ALL: 'all'
        CURRENT: 'current'

    PREF_QUERY = 'pref/query'

    MAX_RESULTS_DEFAULT = 10

    PREF_MAX_RESULTS = 'pref/max_results'
    # Constants shared with popup.coffee <--

    CLASSES =
        ACTIVE: 'active'

    # UI
    ui =
        all: document.getElementById 'all'
        current: document.getElementById 'current'
        max_results: document.getElementById 'max_results'
        activateAll: ->
            ui.current.checked = false
            ui.all.checked = true
        activateCurrent: ->
            ui.all.checked = false
            ui.current.checked = true
        setMaxResults: (value) ->
            ui.max_results.value = value
        updateQuery: ->
            query = storage[PREF_QUERY]
            switch query
                when QUERY.ALL then ui.activateAll()
                when QUERY.CURRENT then ui.activateCurrent()
                else
                # Something went wrong. Let's reset.
                    storage[PREF_QUERY] = QUERY.CURRENT
                    ui.updateQuery()
        updateMaxResults: ->
            max_results = storage[PREF_MAX_RESULTS]
            ui.setMaxResults(max_results)

    # Events
    ui.all.addEventListener 'click', ->
        storage[PREF_QUERY] = QUERY.ALL
        ui.updateQuery()
        false
    ui.current.addEventListener 'click', ->
        storage[PREF_QUERY] = QUERY.CURRENT
        ui.updateQuery()
        false
    ui.max_results.addEventListener 'keyup', ->
        if ui.max_results.value > 0
            storage[PREF_MAX_RESULTS] = ui.max_results.value
        else
            storage[PREF_MAX_RESULTS] = MAX_RESULTS_DEFAULT
        ui.updateMaxResults()
        false

    # Init defaults
    storage[PREF_QUERY] = QUERY.CURRENT unless storage[PREF_QUERY]
    storage[PREF_MAX_RESULTS] = MAX_RESULTS_DEFAULT unless storage[PREF_MAX_RESULTS]

    # Init UI state
    ui.updateQuery()
    ui.updateMaxResults()

# Go go go, unless we're unit testing this thing.
window.tabaheadOptions window.localStorage unless window.__karma__?
