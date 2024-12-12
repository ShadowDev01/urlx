
function single_pass(param::String)
	idx = findfirst(==(param), ARGS) + 1
	if isassigned(ARGS, idx) && !startswith(ARGS[idx], "-")
		return ARGS[idx]
	else
		return ""
	end
end

function ARGUMENTS()
	("-h" ∈ ARGS) && (println(help), exit(0))

	args = Dict{String, Any}(
		"u" => "",
		"ul" => "",
		"o" => "",
		"format" => "",
		"stdin" => false,
		"scheme" => false,
		"username" => false,
		"password" => false,
		"auth" => false,
		"host" => false,
		"domain" => false,
		"subdomain" => false,
		"tld" => false,
		"port" => false,
		"path" => false,
		"directory" => false,
		"file" => false,
		"file_name" => false,
		"file_ext" => false,
		"query" => false,
		"keys" => false,
		"values" => false,
		"keypairs" => false,
		"fragment" => false,
		"json" => false,
		"decode" => false,
		"c" => false,
		"cn" => false,
	)

	("-stdin" ∈ ARGS) && (args["stdin"] = true)
	("-scheme" ∈ ARGS) && (args["scheme"] = true)
	("-username" ∈ ARGS) && (args["username"] = true)
	("-password" ∈ ARGS) && (args["password"] = true)
	("-auth" ∈ ARGS) && (args["auth"] = true)
	("-host" ∈ ARGS) && (args["host"] = true)
	("-domain" ∈ ARGS) && (args["domain"] = true)
	("-subdomain" ∈ ARGS) && (args["subdomain"] = true)
	("-tld" ∈ ARGS) && (args["tld"] = true)
	("-port" ∈ ARGS) && (args["port"] = true)
	("-path" ∈ ARGS) && (args["path"] = true)
	("-directory" ∈ ARGS) && (args["directory"] = true)
	("-file" ∈ ARGS) && (args["file"] = true)
	("-file_name" ∈ ARGS) && (args["file_name"] = true)
	("-file_ext" ∈ ARGS) && (args["file_ext"] = true)
	("-query" ∈ ARGS) && (args["query"] = true)
	("-keys" ∈ ARGS) && (args["keys"] = true)
	("-values" ∈ ARGS) && (args["values"] = true)
	("-keypairs" ∈ ARGS) && (args["keypairs"] = true)
	("-fragment" ∈ ARGS) && (args["fragment"] = true)
	("-json" ∈ ARGS) && (args["json"] = true)
	("-decode" ∈ ARGS) && (args["decode"] = true)
	("-c" ∈ ARGS) && (args["c"] = true)
	("-cn" ∈ ARGS) && (args["cn"] = true)

	for itm in ("-u", "-ul", "-format", "-o")
		if itm ∈ ARGS
			res = single_pass(itm)
			!isempty(res) && (args[chopprefix(itm, "-")] = res)
		end
	end

	args
end

const help = """
	 _   _ ____  _    __  __
	| | | |  _ \\| |   \\ \\/ /
	| | | | |_) | |    \\  / 
	| |_| |  _ <| |___ /  \\ 
	 \\___/|_| \\_\\_____/_/\\_\\  


optional arguments:
  -u     			  single url
  -ul     			  multiple urls in file
  -stdin              read url(s) from stdin
  -scheme             print url scheme
  -username           print url username
  -password           print url password
  -auth               print url auth
  -host               print url host
  -domain             print url domain
  -subdomain          print url subdomain
  -tld                print url tld
  -port               print url port
  -path               print url path
  -directory          print url directory
  -file               print url file
  -file_name          print url file name
  -file_ext           print url ext
  -query              print url query
  -keys               print all keys in query in unique
  -values             print all values in query in unique
  -keypairs           key=value pairs from the query string (one per line)
  -fragment           print url fragment
  -format FORMAT      Specify a custom format (default: "")
  -json               JSON encoded url/format objects
  -decode             simple url & html decode
  -c                  count and sort descending
  -cn                 count and sort descending with numbers
  -o, -output OUTPUT  save output in file
  -h, -help           show this help message and exit

-format dirctives:
%sc  =>  url scheme
%SC  =>  from the beginning of url to the scheme
%un  =>  url username
%pw  =>  url password
%au  =>  from the beginning of url to the authenticate
%ho  =>  url host
%HO  =>  from the beginning of url to the host
%sd  =>  url subdomain
%do  =>  url domain
%tl  =>  url tld
%po  =>  url port
%PO  =>  from the beginning of url to the port
%pa  =>  url path
%PA  =>  from the beginning of url to the path
%di  =>  url directory
%fi  =>  url file
%fn  =>  url file_name
%fe  =>  url file_extension
%qu  =>  url query
%QU  =>  from the beginning of url to the query
%fr  =>  url fragment
%FR  =>  from the beginning of url to the fragment
%pr  =>  url parameters in space separated
%PR  =>  url parameters in new line
%va  =>  url values of parameters in space separated
%VA  =>  url values of parameters in new line
"""
