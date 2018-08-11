window.tabaheadOptions = (storage) ->
    # --> Constants shared with popup.coffee
    QUERY =
        ALL: 'all'
        CURRENT: 'current'

    PREF_QUERY = 'pref/query'
    # Constants shared with popup.coffee <--

    CLASSES =
        ACTIVE: 'active'

    # UI
    ui =
        all: document.getElementById 'all'
        current: document.getElementById 'current'
        activateAll: ->
            ui.current.classList.remove CLASSES.ACTIVE
            ui.all.classList.add CLASSES.ACTIVE
        activateCurrent: ->
            ui.all.classList.remove CLASSES.ACTIVE
            ui.current.classList.add CLASSES.ACTIVE
        update: ->
            query = storage[PREF_QUERY]
            switch query
                when QUERY.ALL then ui.activateAll()
                when QUERY.CURRENT then ui.activateCurrent()
                else
                # Something went wrong. Let's reset.
                    storage[PREF_QUERY] = QUERY.CURRENT
                    ui.update()

    # Events
    ui.all.addEventListener 'click', ->
        storage[PREF_QUERY] = QUERY.ALL
        ui.update()
        false
    ui.current.addEventListener 'click', ->
        storage[PREF_QUERY] = QUERY.CURRENT
        ui.update()
        false

    # Init default pref
    storage[PREF_QUERY] = QUERY.CURRENT unless storage[PREF_QUERY]

    # Init UI state
    ui.update()

# Go go go, unless we're unit testing this thing.
window.tabaheadOptions window.localStorage unless window.__karma__?
