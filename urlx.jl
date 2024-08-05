include("src/args.jl")
include("src/URL.jl")

DATA = String[]                                  # used for other other parts of url
PARAMS = String[]                                # used for --keys to print query parameters
VALS = String[]                                  # used for --values to print query parameters values
KEYPAIRS = String[]                              # used for --keypairs to print query keypairs
FORMAT_DATA = String[]                           # used for --format
JSON_DATA = Vector{OrderedDict{String, Any}}()   # used for --json

# called when --format passed
function Format(urls::Vector{String}, format::String)
	Threads.@threads for u in urls
		try
			url = URL(u)
			push!(
				FORMAT_DATA,
				replace(
					format,
					"%sc" => url.scheme,
					"%SC" => url._scheme,
					"%un" => url.username,
					"%pw" => url.password,
					"%au" => url._auth,
					"%ho" => url.host,
					"%HO" => url._host,
					"%sd" => url.subdomain,
					"%do" => url.domain,
					"%tl" => url.tld,
					"%po" => url.port,
					"%PO" => url._port,
					"%pa" => url.path,
					"%PA" => url._path,
					"%di" => url.directory,
					"%fi" => url.file,
					"%fn" => url.file_name,
					"%fe" => url.file_ext,
					"%qu" => url.query,
					"%QU" => url._query,
					"%fr" => url.fragment,
					"%FR" => url._fragment,
					"%pr" => join(url.query_params, " "),
					"%PR" => join(url.query_params, "\n"),
					"%va" => join(url.query_values, " "),
					"%VA" => join(url.query_values, "\n"),
				),
			)
		catch
			@error "something wrong in processing below url 😕 but I did the rest 😉\nurl = $(u)"
			continue
		end
	end
end


function PARTS(urls::Vector{String}, switch::String)
	Threads.@threads for u in urls
		try
			global urle = URL(u)
			eval(Meta.parse("!isempty(urle.$switch) && push!(DATA, urle.$switch)"))
		catch
			@error "something wrong in processing below url 😕 but I did the rest 😉\nurl = $(u)"
			continue
		end
	end
end

# called when --keys passed
function KEYS(urls::Vector{String})
	Threads.@threads for u in urls
		try
			url = URL(u)
			append!(PARAMS, url.query_params)
		catch
			@error "something wrong in processing below url 😕 but I did the rest 😉\nurl = $(u)"
			continue
		end
	end
end

# called when --values passed
function VALUES(urls::Vector{String})
	Threads.@threads for u in urls
		try
			url = URL(u)
			append!(VALS, url.query_values)
		catch
			@error "something wrong in processing below url 😕 but I did the rest 😉\nurl = $(u)"
			continue
		end
	end
end

# called when --keypairs passed
function keypairs(urls::Vector{String})
	Threads.@threads for u in urls
		try
			# extract wanted url sections
			url = URL(u)
			for (key, value) in url.query_paires
				println(key, "=", value)
			end
		catch
			@error "something wrong in processing below url 😕 but I did the rest 😉\nurl = $(u)"
			continue
		end
	end
end

# Count & sort url items
function COUNT(list::Vector{String}, number::Bool)
	data = Dict{String, Int32}()

	# count url items
	for item in list
		haskey(data, item) ? (data[item] += 1) : (data[item] = 1)
	end

	# sort descending url items 
	for (key, value) in sort(data, byvalue = true, rev = true)
		println(number ? "$key: $value" : key)               # if number was true show number of items
	end
end


function main()
	args = ARGUMENTS()             # passed user cli args

	count::Bool = args["c"]
	countNumber::Bool = args["cn"]

	if !isnothing(args["url"])     # in order not to interfere with the switches -u / -U
		urls::Vector{String} = [args["url"]]
	elseif !isnothing(args["urls"])
		try
			urls = readlines(args["urls"])
		catch err
			@error "there is no file: $(args["urls"])"
			exit(0)
		end
	elseif args["stdin"]
		urls = unique(readlines(stdin))
	end

	urls = filter(!isempty, urls)       # remove empty lines

	switches = filter(item -> args[item],
		[
			"scheme",
			"username",
			"password",
			"auth",
			"host",
			"domain",
			"subdomain",
			"tld",
			"port",
			"path",
			"directory",
			"file",
			"file_name",
			"file_ext",
			"query",
			"fragment",
		],
	)

	if !isempty(switches)
		PARTS(urls, switches[1])
		if countNumber
			COUNT(DATA, true)
		elseif count
			COUNT(DATA, false)
		else
			print(join(DATA, "\n"))
		end
	end

	# manage --keys
	if args["keys"]
		KEYS(urls)
		if countNumber
			COUNT(PARAMS, true)
		elseif count
			COUNT(PARAMS, false)
		else
			print(join(unique(PARAMS), "\n"))
		end
	end

	# manage --values
	if args["values"]
		VALUES(urls)
		if countNumber
			COUNT(VALS, true)
		elseif count
			COUNT(VALS, false)
		else
			print(join(unique(VALS), "\n"))
		end
	end

	# manage --keypairs
	if args["keypairs"]
		keypairs(urls)
		if countNumber
			COUNT(KEYPAIRS, true)
		elseif count
			COUNT(KEYPAIRS, false)
		else
			print(join(unique(KEYPAIRS), "\n"))
		end
	end

	# manage --format
	if !isempty(args["format"])
		Format(urls, args["format"])
		if countNumber
			COUNT(FORMAT_DATA, true)
		elseif count
			COUNT(FORMAT_DATA, false)
		else
			print(join(FORMAT_DATA, "\n"))
		end
	end

	# manage --json
	if args["json"]
		for u in urls
			try
				url = URL(u)
				Json(url)
			catch
				@error "something wrong in processing below url 😕\nurl = $(u)"
				exit(0)
			end
		end
		JSON.print(JSON_DATA, 4)
	end

	# manage --decode
	if args["decode"]
		for url in urls
			println(url |> URL_Decode |> HTML_Decode)
		end
	end

end

main()
