/*jslint node: true*/

// Generated on 2013-09-08 using generator-chrome-extension 0.2.4

// # Globbing
// for performance reasons we're only matching one level down:
// 'test/spec/{,*/}*.js'
// use this if you want to recursively match all subfolders:
// 'test/spec/**/*.js'

module.exports = function (grunt) {
    'use strict';

    // Configurable paths.
    var yeomanConfig = {
        app: 'app',
        dist: 'dist'
    };

    // Show elapsed time at the end.
    if (grunt.option('timing') === true) {
        require('time-grunt')(grunt);
    }
    // Load all grunt tasks.
    require('load-grunt-tasks')(grunt);

    grunt.initConfig({

        yeoman: yeomanConfig,

        watch: {
            options: {
                spawn: false
            },
            jslint: {
                files: ['<%= yeoman.app %>/scripts/{,*/}*.js', 'Gruntfile.js', '<%= yeoman.app %>/*.json'],
                tasks: ['jslint']
            },
            csslint: {
                files: ['<%= yeoman.app %>/styles/{,*/}*.css'],
                tasks: ['csslint']
            }
        },

        clean: {
            dist: {
                files: [{
                    dot: true,
                    src: [
                        '<%= yeoman.dist %>/*',
                        '!<%= yeoman.dist %>/.git*'
                    ]
                }]
            }
        },

        jslint: {
            all: [
                'Gruntfile.js',
                '<%= yeoman.app %>/scripts/{,*/}*.js',
                '<%= yeoman.app %>/*.json'            ]
        },

        csslint: {
            options: {
                'gradients': false
            },
            all: ['<%= yeoman.app %>/styles/{,*/}*.css']
        },

        useminPrepare: {
            options: {
                dest: '<%= yeoman.dist %>'
            },
            html: [
                '<%= yeoman.app %>/popup.html'
            ]
        },

        usemin: {
            options: {
                dirs: ['<%= yeoman.dist %>']
            },
            html: ['<%= yeoman.dist %>/{,*/}*.html'],
            css: ['<%= yeoman.dist %>/styles/{,*/}*.css']
        },

        imagemin: {
            dist: {
                files: [{
                    expand: true,
                    cwd: '<%= yeoman.app %>/images',
                    src: '{,*/}*.{png,jpg,jpeg}',
                    dest: '<%= yeoman.dist %>/images'
                }]
            }
        },

        htmlmin: {
            dist: {
                options: {
                    // https://github.com/yeoman/grunt-usemin/issues/44
                    //collapseWhitespace: true,
                    collapseBooleanAttributes: true,
                    useShortDoctype: true,
                    removeEmptyAttributes: true
                },
                files: [{
                    expand: true,
                    cwd: '<%= yeoman.app %>',
                    src: '*.html',
                    dest: '<%= yeoman.dist %>'
                }]
            }
        },

        // Put files not handled in other tasks here
        copy: {
            dist: {
                files: {
                    '<%= yeoman.dist %>/LICENSE': ['LICENSE'],
                    '<%= yeoman.dist %>/manifest.json': ['<%= yeoman.app %>/manifest.json']
                }
            }
        },

        concurrent: {
            lint: [
                'jslint',
                'csslint'
            ],
            dist: [
                'imagemin',
                'htmlmin'
            ]
        },

        compress: {
            dist: {
                options: {
                    archive: 'package/Tab Ahead.zip'
                },
                files: [{
                    expand: true,
                    cwd: 'dist/',
                    src: ['**'],
                    dest: ''
                }]
            }
        },

        updateVersion: {
            manifest: ['<%= yeoman.app %>/manifest.json']
        }
    });

    grunt.registerMultiTask('updateVersion', 'Update the version key of .json files.', function () {

        var versionnumber = grunt.option('versionnumber');

        if (!versionnumber) {
            grunt.log.error('Use --versionnumber flag to specify the new version number.');
            return;
        }

        this.filesSrc.forEach(function (filepath) {

            var manifest = grunt.file.readJSON(filepath);

            manifest.version = versionnumber;
            grunt.file.write(filepath, JSON.stringify(manifest, null, 4));

        });

    });

    grunt.registerTask('test', [
        'concurrent:lint'
    ]);

    grunt.registerTask('build', [
        'clean:dist',
        'useminPrepare',
        'concurrent:dist',
        'concat',
        'cssmin',
        'uglify',
        'copy',
        'usemin',
        'compress'
    ]);

    grunt.registerTask('default', [
        'test',
        'build'
    ]);
};
