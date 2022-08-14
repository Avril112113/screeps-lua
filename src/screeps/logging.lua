local original_print = print
Logging = {
	original_print = original_print,
	Logging_source = debug.getinfo(1).source,
	colors = {
		pop = "</span>",
		debug = "<span style='color:#8BF868'>",
		error = "<span style='color:#FF6F6B'>",
		warn = "<span style='color:#F58724'>",
		info = "<span style='color:#0F63D4'>",
	},
	---@type table<string, fun(value:any?):string>
	contexts = {},
	---@type table<string, any?>
	setContexts = {},
}
function Logging.get_source()
	local i = 0
	while true do
		local data = debug.getinfo(i)
		if data == nil then
			break
		elseif data.source ~= Logging.Logging_source and data.source ~= "=[C]" then
			break
		end
		i = i + 1
	end
	return debug.getinfo(i).source:gsub("^@?%.?/?", ""):gsub("/init", ""):gsub(".lua", ""):gsub("/", ".")
end

---@param name string
---@param handler fun(value:any?):string
function Logging.registerContext(name, handler)
	Logging.contexts[name] = handler
end

function Logging.setContext(name, value)
	Logging.setContexts[name] = value
end

---@param log_type string
---@param s string
---@vararg string
function Logging._log(log_type, s, ...)
	local source = Logging.get_source()
	local prefix = "[" .. log_type .. "]\t" .. source
	local contextPrefixes = {}
	for context, value in pairs(Logging.setContexts) do
		local contextHandler = Logging.contexts[context]
		if contextHandler ~= nil then
			local contextStr = contextHandler(value)
			if #contextStr > 0 then
				table.insert(contextPrefixes, s)
			end
		end
	end
	if #contextPrefixes > 0 then
		prefix = prefix .. " " .. table.concat(contextPrefixes, ", ")
	end
	prefix = prefix .. ": "
	local msg = {tostring(s)}
	for _, v in ipairs({...}) do
		table.insert(msg, "\t")
		table.insert(msg, tostring(v))
	end
	local msgStr = table.concat(msg):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
	local str = (prefix .. msgStr):gsub("(\r?\n\r?)", "%1" .. prefix:gsub("[^\t]", " "))
	original_print(str)
	if Logging.sock ~= nil then
		Logging.sock:send(str .. "\n")
	end
end

---@param s any?
---@vararg any?
function Logging.print(s, ...)
	Logging._log(Logging.colors.debug .. "DEBUG" .. Logging.colors.pop, s, ...)
end
print = Logging.print

---@param s any?
---@vararg any?
function Logging.print_info(s, ...)
	Logging._log(Logging.colors.info .. "INFO" .. Logging.colors.pop, s, ...)
end
---@diagnostic disable-next-line: lowercase-global
print_info = Logging.print_info

---@param s any?
---@vararg any?
function Logging.print_warn(s, ...)
	Logging._log(Logging.colors.warn .. "WARN" .. Logging.colors.pop, s, ...)
end
---@diagnostic disable-next-line: lowercase-global
print_warn = Logging.print_warn

---@param s any?
---@vararg any?
function Logging.print_error(s, ...)
	Logging._log(Logging.colors.error .. "ERROR" .. Logging.colors.pop, s, ...)
end
---@diagnostic disable-next-line: lowercase-global
print_error = Logging.print_error

return Logging
