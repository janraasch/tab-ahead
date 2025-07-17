module.exports = (grunt) ->

    # Configurable paths.
    yeomanConfig =
        app: 'app'
        dist: 'dist'
        test: 'test'
        coverage: 'coverage'
        tmp: '.tmp'

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
            jsonlint:
                files: [
                    '*.json'
                    '.*rc'
                    '<%= yeoman.app %>/*.json'
                    '<%= yeoman.test %>/fixtures/*.json'
                ]
                tasks: [
                    'jsonlint'
                    'karma:watch:run'
                ]
            csslint:
                files: ['<%= yeoman.app %>/styles/*.css']
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
            coverage: ['<%= yeoman.coverage %>']
            tmp: ['<%= yeoman.tmp %>']
            compress: ['zip/TabAhead.zip']
            coffee:
                src: ['<%= yeoman.app %>/scripts/*{.js,.js.map}']

        coffeelint:
            options:
                configFile: 'coffeelint.json'
            all: [
                '*.coffee',
                '<%= yeoman.test %>/*.coffee'
                '<%= yeoman.app %>/scripts/*.coffee'
            ]

        jsonlint:
            all: [
                '*.json'
                '.bower_rc'
                '.coffeelintrc'
                '<%= yeoman.app %>/*.json'
                '<%= yeoman.test %>/fixtures/*.json'
            ]

        csslint:
            options:
                csslintrc: '.csslintrc'
            all: ['<%= yeoman.app %>/styles/*.css']

        coffee:
            options:
                sourceMap: true
                transpile:
                    presets: ['env']
            compile:
                expand: true
                flatten: true
                cwd: '<%= yeoman.app %>/scripts'
                src: ['*.coffee']
                dest: '<%= yeoman.app %>/scripts'
                ext: '.js'

        karma:
            options:
                configFile: 'karma.conf.coffee'
            e2e: {}
            watch:
                browsers: ['Chrome']
                autoWatch: false
                background: true
                singleRun: false

        useminPrepare:
            options:
                dest: '<%= yeoman.dist %>'
            html: [
                '<%= yeoman.app %>/popup.html'
                '<%= yeoman.app %>/options.html'
            ]

        usemin:
            options:
                dirs: ['<%= yeoman.dist %>']
                staging: '<%= yeoman.tmp %>'
            html: ['<%= yeoman.dist %>/{,*/}*.html']
            css: ['<%= yeoman.dist %>/styles/{,*/}*.css']

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
            images:
                files: [
                    expand: true
                    cwd: '<%= yeoman.app %>/images'
                    src: '{,*/}*.{png,jpg,jpeg,svg}'
                    dest: '<%= yeoman.dist %>/images'
                ]

        purifycss:
            popup:
                src: [
                    '<%= yeoman.app %>/popup.html'
                    '<%= yeoman.tmp %>/concat/scripts/popup.js'
                ],
                css: ['<%= yeoman.tmp %>/concat/styles/main.css']
                dest: '<%= yeoman.tmp %>/concat/styles/main.css'
            options_page:
                src: [
                    '<%= yeoman.app %>/options.html'
                    '<%= yeoman.tmp %>/concat/scripts/options.js'
                ],
                css: ['<%= yeoman.tmp %>/concat/styles/options.css']
                dest: '<%= yeoman.tmp %>/concat/styles/options.css'

        concurrent:
            test: [
                'coffeelint'
                'jsonlint'
                'csslint'
                'karma:e2e'
            ]
            dist: [
                'copy:images'
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
            all: [
                '<%= yeoman.app %>/manifest.json'
                'package.json'
                'bower.json'
            ]

        shell:
            coveralls:
                command: 'cat <%= yeoman.coverage %>/*/lcov.info | ./node_modules/coveralls/bin/coveralls.js'

    grunt.registerMultiTask 'updateVersion',
        'Update the version key of .json files.', ->

            versionnumber = grunt.option 'versionnumber'
            error = 'Use --versionnumber flag to specify the new version number.'

            grunt.log.error(error) unless versionnumber?

            @filesSrc.forEach (filepath) ->
                manifest = grunt.file.readJSON filepath
                manifest.version = versionnumber
                grunt.file.write filepath, JSON.stringify manifest, null, 2

    grunt.registerTask 'test', [
        'concurrent:test'
    ]

    grunt.registerTask 'build', [
        'test'
        'coffee'
        'clean:dist'
        'useminPrepare'
        'concurrent:dist'
        'concat'
        'purifycss'
        'cssmin'
        'uglify'
        'copy'
        'usemin'
        'clean:compress'
        'compress'
    ]

    grunt.registerTask 'default', [
        'build'
        'karma:watch'
        'watch'
    ]
