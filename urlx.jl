include("src/args.jl")
include("src/URL.jl")

DATA = String[]                                 # used for other other parts of url
PARAMS = String[]                               # used for --keys to print query parameters
VALS = String[]                                 # used for --values to print query parameters values
KEYPAIRR = String[]                             # used for --keypairs to print query keypairs
FORMAT_DATA = String[]                          # used for --format
JSON_DATA = Vector{OrderedDict{String,Any}}()   # used for --json

# called when --format passed
function Format(urls::Vector{String}, format::String)
    Threads.@threads for u in urls
        try
            url = URL(u)
            push!(format_data, replace(
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
                "%fe" => url.file_extension,
                "%qu" => url.query,
                "%QU" => url._query,
                "%fr" => url.fragment,
                "%FR" => url._fragment,
                "%pr" => join(url.parameters, " "),
                "%PR" => join(url.parameters, "\n"),
                "%va" => join(url.parameters_value, " "),
                "%VA" => join(url.parameters_value, "\n"),
            ))
        catch
            @error "can't process this url 😕 but I did the rest 😉" u
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
            @error "can't process this url 😕 but I did the rest 😉" u
            continue
        end
    end
end

# called when --keys passed
function KEYS(urls::Vector{String})
    Threads.@threads for u in urls
        try
            url = URL(u)
            append!(PARAMS, url.parameters)
        catch
            @error "can't process this url 😕 but I did the rest 😉" u
            continue
        end
    end
end

# called when --values passed
function VALUES(urls::Vector{String})
    Threads.@threads for u in urls
        try
            url = URL(u)
            append!(VALS, url.parameters_value)
        catch
            @error "can't process this url 😕 but I did the rest 😉" u
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
            params = url.parameters
            values = url.parameters_value
            diff = abs(url.parameters_count - url.parameters_value_count)

            # parameters with no value will pair with ""
            if url.parameters_count > url.parameters_value_count
                for i = 1:diff
                    push!(values, "")
                end
            end

            # make pair parameters with their values with =
            for (param, value) in Iterators.zip(params, values)
                push!(KEYPAIRR, "$param=$value")
            end
        catch
            @error "can't process this url 😕 but I did the rest 😉" u
            continue
        end
    end
end

# Count & sort url items
function COUNT(list::Vector{String}, number::Bool)
    data = Dict{String,Int32}()

    # count url items
    for item in list
        haskey(data, item) ? (data[item] += 1) : (data[item] = 1)
    end

    # sort descending url items 
    for (key, value) in sort(data, byvalue=true, rev=true)
        println(number ? "$key: $value" : key)               # if number was true show number of items
    end
end


function main()
    arguments = ARGUMENTS()             # passed user cli arguments

    count::Bool = arguments["c"]
    countNumber::Bool = arguments["cn"]

    if !isnothing(arguments["url"])     # in order not to interfere with the switches -u / -U
        urls::Vector{String} = [arguments["url"]]
    elseif !isnothing(arguments["urls"])
        try
            urls = readlines(arguments["urls"])
        catch err
            @error "there is no file: $(arguments["urls"])"
            exit(0)
        end
    elseif arguments["stdin"]
        urls = unique(readlines(stdin))
    end

    urls = filter(!isempty, urls)       # remove empty lines

    switches = filter(item -> arguments[item], ["scheme", "username", "password", "authenticate", "host", "domain", "subdomain", "tld", "port", "path", "directory", "file", "file_name", "file_extension", "query", "fragment"])

    if !isempty(switches)
        PARTS(urls, switches[1])
        if countNumber
            COUNT(DATA, true)
        elseif count
            COUNT(DATA, false)
        else
            println(join(DATA, "\n"))
        end
    end

    # manage --keys
    if arguments["keys"]
        KEYS(urls)
        if countNumber
            COUNT(PARAMS, true)
        elseif count
            COUNT(PARAMS, false)
        else
            println(join(unique(PARAMS), "\n"))
        end
    end

    # manage --values
    if arguments["values"]
        VALUES(urls)
        if countNumber
            COUNT(VALS, true)
        elseif count
            COUNT(VALS, false)
        else
            println(join(unique(VALS), "\n"))
        end
    end

    # manage --keypairs
    if arguments["keypairs"]
        keypairs(urls)
        if countNumber
            COUNT(KEYPAIRR, true)
        elseif count
            COUNT(KEYPAIRR, false)
        else
            println(join(unique(KEYPAIRR), "\n"))
        end
    end

    # manage --format
    if !isempty(arguments["format"])
        Format(urls, arguments["format"])
        if countNumber
            COUNT(FORMAT_DATA, true)
        elseif count
            COUNT(FORMAT_DATA, false)
        else
            println(join(FORMAT_DATA, "\n"))
        end
    end

    # manage --json
    if arguments["json"]
        for u in urls
            try
                url = URL(u)
                Json(url)
            catch
                @error "can't process this url 😕 but I did the rest 😉" u
                continue
            end
        end
        JSON.print(JSON_DATA, 4)
    end

    # manage --show
    if arguments["show"]
        for u in urls
            try
                url = URL(u)
                SHOW(url)
            catch
                @error "can't process this url 😕 but I did the rest 😉" u
                continue
            end
        end
    end

    # manage --decode
    if arguments["decode"]
        for url in urls
            println(url |> URL_Decode |> HTML_Decode)
        end
    end

end

main()