# Karma configuration
# Generated on Fri Nov 21 2014 09:16:13 GMT-0600 (CST)
module.exports = (config) ->
  config.set

    # base path that will be used to resolve all patterns (eg. files, exclude)
    basePath: ""

    # frameworks to use
    # available frameworks: https://npmjs.org/browse/keyword/karma-adapter
    frameworks: [
      "jasmine"
      "requirejs"
    ]

    # list of files / patterns to load in the browser
    files: [
      # dependencies
      { pattern: "app/bower_components/jquery/dist/jquery.js", watched: false, served: true, included: true }
      { pattern: "app/bower_components/jasmine-jquery/lib/jasmine-jquery.js", watched: false, served: true, included: true }
      { pattern: "app/bower_components/jasmine-flight/lib/jasmine-flight.js", watched: false, served: true, included: true }

      # fixtures
      { pattern: "test/spec/fixtures/**", watched: true, served: true, included: false }

      # loaded with require
      { pattern: "app/coffeescript/**/*.coffee", included: false }
      { pattern: "test/spec/**/*_spec.coffee", included: false }
      { pattern: "app/bower_components/flight/**/*.js", included: false }
      { pattern: 'app/bower_components/moment/moment.js', included: false},
      { pattern: 'app/bower_components/moment-timezone/builds/moment-timezone-with-data-2010-2020.js', included: false}
      { pattern: 'app/bower_components/strftime/strftime.js', included: false},

      "test/test-main.coffee"
    ]

    # list of files to exclude
    exclude: [
      "**/*.swp"
      ".tmp/app/js/demo/**"
    ]

    # preprocess matching files before serving them to the browser
    # available preprocessors: https://npmjs.org/browse/keyword/karma-preprocessor
    preprocessors:
      "**/*.coffee": ["coffee"]
      "*/.html": []


    # test results reporter to use
    # possible values: 'dots', 'progress'
    # available reporters: https://npmjs.org/browse/keyword/karma-reporter
    reporters: ["progress"]

    # web server port
    port: 9876

    #browserNoActivityTimeout: 30000,

    # enable / disable colors in the output (reporters and logs)
    colors: true

    # level of logging
    # possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
    logLevel: config.LOG_INFO

    #logLevel: config.LOG_DEBUG,

    # enable / disable watching file and executing tests whenever any file changes
    autoWatch: true

    # start these browsers
    # available browser launchers: https://npmjs.org/browse/keyword/karma-launcher
    browsers: ["Chrome"]
    #browsers: ['Safari'],
    #browsers: ['Firefox'],

    # Continuous Integration mode
    # if true, Karma captures browsers, runs the tests and exits
    singleRun: false

  return
