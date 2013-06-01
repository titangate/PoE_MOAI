Logger = {}

local realprint = print

function Logger._log(level,msg,...)
	Logger._target = Logger._target or realprint
	msg = string.format(msg,...)
	msg = string.format("[%s:%s] %s",
		debug.getinfo(3 + level or 0, "Sl").short_src,
		debug.getinfo(3 + level or 0, "Sl").currentline,
		msg)
	Logger._target(msg)
end

function Logger.log(...)
	Logger._log(0,...)
end

function Logger.logWarning(msg,...)
	Logger._target = Logger._target or realprint
	msg = "Warning: "..string.format(msg,...)
	Logger._log(0,msg)
end

function Logger.logWarningLevel(level,msg,...)
	Logger._target = Logger._target or realprint
	msg = "Warning: "..string.format(msg,...)
	Logger._log(level,msg)
end

function Logger.logError(msg,...)
	Logger._target = Logger._target or realprint
	msg = "Error: "..string.format(msg,...)
	Logger._log(0,msg)
end

function Logger.setTarget(target)
	Logger._target = target
end

print = Logger.log