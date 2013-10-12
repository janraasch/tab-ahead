/*jslint node: true*/
// Karma configuration
module.exports = function (config) {
    'use strict';

    config.set({

        // base path, that will be used to resolve files and exclude
        basePath: '',


        // frameworks to use
        frameworks: ['jasmine'],


        // list of files / patterns to load in the browser
        files: [
            // external deps.
            'app/bower_components/fuzzy-search/lib/fuzzy.js',
            'app/bower_components/jquery/jquery.js',
            'app/bower_components/flatstrap/assets/js/bootstrap-typeahead.js',

            // devDep
            'app/bower_components/jasmine-jquery/lib/jasmine-jquery.js',

            // mocking
            {pattern: 'test/fixtures/*.html'},
            {pattern: 'test/fixtures/*.json', included: false},

            // setting the **HTML** stage
            'test/mocks/*.js',

            // SUT
            'app/scripts/*.js',

            // Test
            'test/*.js'
        ],

        preprocessors: {
            //'**/*.coffee': ['coffee'],
            '**/*.html': ['html2js']
        },


        // test results reporter to use
        // possible values: 'dots', 'progress', 'junit', 'growl', 'coverage'
        reporters: ['dots'],


        // web server port
        port: 9876,


        // enable / disable colors in the output (reporters and logs)
        colors: true,


        // level of logging
        // possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
        logLevel: config.LOG_INFO,


        // enable / disable watching file and executing tests whenever any file changes
        autoWatch: false,


        // Start these browsers, currently available:
        // - Chrome
        // - ChromeCanary
        // - Firefox
        // - Opera
        // - Safari (only Mac)
        // - PhantomJS
        // - IE (only Windows)
        browsers: ['PhantomJS'],


        // If browser does not capture in given timeout [ms], kill it
        captureTimeout: 60000,


        // Continuous Integration mode
        // if true, it capture browsers, run tests and exit
        singleRun: true
    });
};
