module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    coffee: {
      compile: {
        options: {
          sourceMap: true
        },
        files: {
          'build/<%= pkg.name %>.js': ['src/*.coffee']
        }
      },
      test: {
        files: {
          'test/<%= pkg.name %>.spec.js': ['test/*.spec.coffee']
        }
      }
    },
    docco: {
      main: {
        src: ['src/**/*.coffee'],
        options: {
          output: 'docs/'
        }
      },
      test: {
        src: ['test/**/*.js'],
        options: {
          output: 'docs/'
        }
      }
    },
    watch: {
      main: {
        files: 'src/**/*.coffee',
        tasks: ['default'],
        options: {
          spawn: true
        }
      },
      test: {
        files: 'test/**/*.coffee',
        tasks: ['test', 'docco:test'],
        options: {
          spawn: true
        }
      }
    },
    simplemocha: {
      options: {
        timeout: 3000,
        ignoreLeaks: false,
        ui: 'bdd',
        reporter: 'spec'
      },
      all: { src: 'test/**/*.js' }
    },
    uglify: {
      options: {
        banner: '/*! <%= pkg.name %> <%= pkg.version %> <%= grunt.template.today("yyyy-mm-dd")%> */\n',
        report: 'min',
        preserveComments: 'some'
      },
      build: {
        options: {
          sourceMapIn: 'build/<%= pkg.name %>.map',
          sourceMap: 'build/<%= pkg.name %>.min.map'
        },
        files: {
          'build/<%= pkg.name %>.min.js': 'build/<%= pkg.name %>.js'
        }
      }
    }
  });

  grunt.loadNpmTasks('grunt-docco');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-simple-mocha');

  grunt.registerTask('default', ['test', 'coffee', 'uglify', 'docco']);
  grunt.registerTask('test', ['coffee:test', 'simplemocha']);

};
