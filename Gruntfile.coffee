module.exports = (grunt) ->

    # Configurable paths.
    yeomanConfig =
        app: 'app'
        dist: 'dist'
        test: 'test'

    # Show elapsed time at the end.
    if grunt.option 'timing'
        (require 'time-grunt') grunt

    # Load all grunt tasks.
    (require 'load-grunt-tasks') grunt

    grunt.initConfig

        yeoman: yeomanConfig

        watch:
            options:
                spawn: false
            coffeelint:
                files: [
                    '*.coffee'
                    '<%= yeoman.test %>/*.coffee'
                    '<%= yeoman.app %>/scripts/*.coffee'
                ]
                tasks: [
                    'coffee'
                    'coffeelint'
                    'karma:watch:run'
                ]
            jshint:
                files: [
                    '<%= yeoman.app %>/*.json'
                    '<%= yeoman.test %>/fixtures/*.json'
                    '*.js'
                ]
                tasks: [
                    'jshint'
                    'karma:watch:run'
                ]
            csslint:
                files: ['<%= yeoman.app %>/styles/{,*/}*.css']
                tasks: ['csslint']

        clean:
            dist:
                files: [
                    dot: true
                    src: [
                        '<%= yeoman.dist %>/*'
                        '!<%= yeoman.dist %>/.git*'
                    ]
                ]

        coffeelint:
            # `grunt-coffeelint` does not support this natively
            # [yet](https://github.com/vojtajina/grunt-coffeelint/pull/23).
            options: grunt.file.readJSON('.coffeelintrc')
            all: [
                '*.coffee',
                '<%= yeoman.test %>/*.coffee'
                '<%= yeoman.app %>/scripts/*.coffee'
            ]

        jshint:
            options:
                jshintrc: '.jshintrc'
            all: [
                '*.js'
                '<%= yeoman.app %>/*.json'
                '<%= yeoman.test %>/fixtures/*.json'
            ]

        csslint:
            options:
                gradients: false
            all: ['<%= yeoman.app %>/styles/*.css']

        coffee:
            options:
                sourceMap: true
            compile:
                files:
                    '<%= yeoman.app %>/scripts/popup.js': [
                        '<%= yeoman.app %>/scripts/popup.coffee'
                    ]

        karma:
            options:
                configFile: 'karma.conf.js'
            e2e: {}
            watch:
                browsers: ['Chrome', 'PhantomJS']
                autoWatch: false
                background: true
                singleRun: false

        useminPrepare:
            options:
                dest: '<%= yeoman.dist %>'
            html: ['<%= yeoman.app %>/popup.html']

        usemin:
            options:
                dirs: ['<%= yeoman.dist %>']
            html: ['<%= yeoman.dist %>/{,*/}*.html']
            css: ['<%= yeoman.dist %>/styles/{,*/}*.css']

        imagemin:
            dist:
                files: [
                    expand: true
                    cwd: '<%= yeoman.app %>/images'
                    src: '{,*/}*.{png,jpg,jpeg}'
                    dest: '<%= yeoman.dist %>/images'
                ]

        htmlmin:
            dist:
                options:
                    # https://github.com/yeoman/grunt-usemin/issues/44
                    # collapseWhitespace: true
                    collapseBooleanAttributes: true
                    useShortDoctype: true
                    removeEmptyAttributes: true
                files: [
                    expand: true
                    cwd: '<%= yeoman.app %>'
                    src: '*.html'
                    dest: '<%= yeoman.dist %>'
                ]

        # Put files not handled in other tasks here
        copy:
            dist:
                files:
                    '<%= yeoman.dist %>/LICENSE': [
                        'LICENSE'
                    ]
                    '<%= yeoman.dist %>/manifest.json': [
                        '<%= yeoman.app %>/manifest.json'
                    ]

        concurrent:
            test: [
                'coffeelint'
                'jshint'
                'csslint'
                'karma:e2e'
            ]
            dist: [
                'coffee'
                'imagemin'
                'htmlmin'
            ]

        compress:
            dist:
                options:
                    archive: 'zip/TabAhead.zip'
                files: [
                    expand: true
                    cwd: 'dist/'
                    src: ['**']
                    dest: ''
                ]

        updateVersion:
            manifest: ['<%= yeoman.app %>/manifest.json']

    grunt.registerMultiTask 'updateVersion',
        'Update the version key of .json files.', ->

            versionnumber = grunt.option 'versionnumber'
            error = 'Use --versionnumber flag to specify the new version number.'

            grunt.log.error(error) unless versionnumber?

            @filesSrc.forEach (filepath) ->
                manifest = grunt.file.readJSON filepath
                manifest.version = versionnumber
                grunt.file.write filepath, JSON.stringify manifest, null, 4

    grunt.registerTask 'test', [
        'concurrent:test'
    ]

    grunt.registerTask 'build', [
        'test'
        'clean:dist'
        'useminPrepare'
        'concurrent:dist'
        'concat'
        'cssmin'
        'uglify'
        'copy'
        'usemin'
        'compress'
    ]

    grunt.registerTask 'default', [
        'build'
        'karma:watch'
        'watch'
    ]
