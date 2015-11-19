if Meteor.isClient
  LEVELS =
    debug: 'debug'
    info: 'log'
    warn: 'warn'
    error: 'error'
else
  LEVELS =
    debug: 'log'
    info: 'log'
    warn: 'warn'
    error: 'error'

@log = {}
log[level] = console[method].bind(console) for level, method of LEVELS

if Meteor.isClient
	log.error = (args...) ->
    # Try to extract an error message to display from one of the arguments.
    FlashMessages.sendError(args[1]?.message ? args[0]?.message ? args)
    console.error(args...)

### TODO(orlade): Enable once ready for production.

  # Global server logger instance.
@log = Winston

# Log `debug` to console, but set Papertrail to `info`.
#
# TODO(orlade): Explicitly set the console transport to `debug`.
Winston.level = 'debug'

log.add Winston_Papertrail,
  level: 'info'
  levels:
    info: 1
    warn: 2
    error: 3
    auth: 4
  colors:
    info: 'green'
    warn: 'red'
    error: 'red'
    auth: 'red'

  host: "logs3.papertrailapp.com"
  port: 54891
  handleExceptions: true
  json: true
  colorize: true

  logFormat: (level, message) -> "[#{level}]: #{message}"
###

log.debug "Logging initialised"
