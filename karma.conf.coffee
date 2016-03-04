fs = require 'fs'

# Karma configuration
module.exports = (config) ->
    # Use ENV vars on Travis and sauce.json locally to get credentials
    useSauce = true
    unless process.env.SAUCE_USERNAME
        unless fs.existsSync '.sauce.json'
            console.log 'If you like to run tests on Sauce Labs locally'
            console.log 'create a .sauce.json file with your credentials.'
        else
            username = require('./.sauce').username
            accessKey = require('./.sauce').accessKey
            process.env.SAUCE_USERNAME = username if username?
            process.env.SAUCE_ACCESS_KEY = accessKey if accessKey?

    tags = []
    tags.push "pr-#{process.env.TRAVIS_PULL_REQUEST}" if process.env.TRAVIS_PULL_REQUEST
    tags.push "branch-#{process.env.TRAVIS_BRANCH}" if process.env.TRAVIS_BRANCH

    unless process.env.SAUCE_USERNAME? and process.env.SAUCE_ACCESS_KEY?
        console.warn 'env.SAUCE_USERNAME and env.SAUCE_ACCESS_KEY are undefined'
        console.warn 'Falling back to using local browsers instead of Sauce Labs'
        useSauce = false

    customLaunchers = require './customLaunchers.json'
    reporters = ['dots']
    reporters.push 'saucelabs' if useSauce
    reporters.push 'coverage'

    config.set
        basePath: ''

        frameworks: ['jasmine']

        files: [
            'app/bower_components/array.from/array-from.js'

            # External dependencies.
            'app/bower_components/fuse.js/src/fuse.min.js'
            'app/bower_components/jquery/dist/jquery.js'
            'app/bower_components/flatstrap/assets/js/bootstrap-typeahead.js'

            # Dev dependencies.
            'app/bower_components/jasmine-jquery/lib/jasmine-jquery.js'

            # Fixtures
            {pattern: 'test/fixtures/*.html'}
            {pattern: 'test/fixtures/*.json', included: false}

            # SUT
            'app/scripts/*.coffee'

            # Test
            'test/*.spec.coffee'
        ]

        preprocessors:
            # **Caveat**. `.coffee` files processed by `coverage`
            # should not be processed by `coffee`.
            # https://github.com/karma-runner/karma-coverage/pull/19#issuecomment-29186243
            'app/scripts/*.coffee': ['coverage']
            'test/*.spec.coffee': ['coffee']
            'test/fixtures/*.html': ['html2js']

        # possible values: 'dots', 'progress', 'junit', 'growl', 'coverage'
        reporters: reporters

        # configure the reporter
        coverageReporter:
            instrumenters:
                ibrik: require('ibrik')
            instrumenter:
                '**/*.coffee': 'ibrik'
            reporters: [{
                    type: 'text-summary'
                    dir: 'coverage/'
                },
                {
                    type: 'lcovonly'
                    dir: 'coverage/'
                }
            ]

        port: 9876

        colors: true

        # possible values: config.LOG_DISABLE || config.LOG_ERROR ||
        # config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
        logLevel: config.LOG_INFO

        # enable / disable watching file and executing tests whenever any file changes
        autoWatch: false

        # Continuous Integration mode
        # if true, it capture browsers, run tests and exit
        singleRun: true

        # SauceLabs
        browsers: if useSauce then Object.keys(customLaunchers) else ['PhantomJS']
        customLaunchers: if useSauce then customLaunchers else {}
        sauceLabs: testName: 'Tab Ahead'
        tags: tags
        # sometimes Windows seems to be quiet slow...
        captureTimeout: 2 * 120000
