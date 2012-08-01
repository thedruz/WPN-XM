[Zend]
zend_extension_ts = "%PHP_EXT_DIR%php_xdebug.dll"

[XDebug]
; remote debugging
xdebug.remote_enable = 1
xdebug.remote_host = localhost
xdebug.remote_port = 9002
xdebug.remote_handler = dbgp
;xdebug.remote_log = "%TEMP_DIR%\xdebug.log"
;xdebug.remote_autostart = 1
; tracer
xdebug.auto_trace = Off
xdebug.collect_params = Off
xdebug.collect_return = Off
xdebug.trace_output_dir = "%TEMP_DIR%"
; profiler
xdebug.profiler_enable = Off
xdebug.profiler_output_dir = "%TEMP_DIR%"