using JSON
using OrderedCollections

struct URL
    scheme::String
    username::String
    password::String
    host::String
    subdomain::String
    domain::String
    tld::String
    port::String
    path::String
    directory::String
    file::String
    file_name::String
    file_extension::String
    query::String
    fragment::String
    parameters::Vector{String}
    parameters_count::Int32
    parameters_value::Vector{String}
    parameters_value_count::Int32
    all::Vector{AbstractString}

    _scheme::String
    _username::String
    _password::String
    _host::String
    _port::String
    _path::String
    _query::String
    _fragment::String
end

function Decode(st::AbstractString)
    decode = Dict{String,String}(
        "&quot;" => "\"",
        "amp;" => "",
        "&lt;" => "<",
        "&gt;" => ">",
        "&#39;" => "'"
    )
    return replace(replace(st, decode...), "&&" => "&")
end

function extract(host::String)
    tlds = Set()
    for line in eachline("src/tlds.txt")
        occursin(Regex("\\b$line\\b\\Z"), host) && push!(tlds, line)
    end
    tld = argmax(length, tlds)
    rest = rsplit(replace(host, tld => ""), ".", limit=2)
    if length(rest) > 1
        subdomain, domain = rest
    else
        subdomain = ""
        domain = rest[1]
    end
    return (subdomain, domain, strip(tld, '.'))
end

function file_apart(file::String)
    file_name::String, file_extension::String = occursin(".", file) ? split(file, ".", limit=2, keepempty=true) : split(file * ".", ".", limit=2, keepempty=true)
    return file_name, file_extension
end

function _parameters(query::AbstractString)
    res = String[]
    reg = r"[\?\&\;]([\w\-\~\+\%]+)"
    for param in eachmatch(reg, query)
        append!(res, param.captures)
    end
    return unique(res)
end

function _subs(url::URL)
    subdomain::String = url.subdomain
    unique(vcat([subdomain], split(subdomain, r"[\.\-]"), split(subdomain, ".")))
end

function _parameters_value(query::AbstractString; count::Bool=false)
    res = String[]
    reg = r"\=([\w\-\%\.\:\~\,\"\'\<\>\=\(\)\`\{\}\$\+\/\;]+)?"
    for param in eachmatch(reg, query)
        append!(res, param.captures)
    end
    if count
        return length(res)
    end
    return unique(filter(!isnothing, res))
end

function Json(url::URL, indent::Bool=false)
    parts = OrderedDict{String,Any}(
        "scheme" => url.scheme,
        "username" => url.username,
        "password" => url.password,
        "authenticate" => url.username * ":" * url.password,
        "host" => url.host,
        "subdomain" => url.subdomain,
        "subdomain_combination" => _subs(url),
        "domain" => url.domain,
        "tld" => url.tld,
        "port" => url.port,
        "path" => url.path,
        "directory" => url.directory,
        "file" => url.file,
        "file_name" => url.file_name,
        "file_ext" => url.file_extension,
        "query" => url.query,
        "fragment" => url.fragment,
        "parameters" => url.parameters,
        "parameters_count" => url.parameters_count,
        "parameters_value" => url.parameters_value,
        "parameters_value_count" => url.parameters_value_count,
    )
    println(indent ? JSON.print(parts, 4) : JSON.print(parts))
end

function SHOW(url::URL)
    items = """
    * scheme: $(url.scheme)
    * username: $(url.username)
    * password: $(url.password)
    * host: $(url.host)
    * subdomain: $(url.subdomain)
    * domain: $(url.domain)
    * tld: $(url.tld)
    * port: $(url.port)
    * path: $(url.path)
    * directory: $(url.directory)
    * file: $(url.file)
    * file_name: $(url.file_name)
    * file_extension: $(url.file_extension)
    * query: $(url.query)
    * fragment: $(url.fragment)
    """
    println(items)
end


function URL(url::AbstractString)
    url::String = chopprefix(url, "*.")
    parts = match(r"^((?<scheme>\w+):\/\/)?((?<username>[\w\-]+)\:?(?<password>.*?)\@)?(?<host>[\w\-\.]+):?(?<port>\d+)?(?<path>[\/\w\-\.\%\,]+)?(?<query>\?[^\#]*)?(?<fragment>\#.*)?$", url)

    scheme::String = !isnothing(parts["scheme"]) ? parts["scheme"] : ""
    username::String = !isnothing(parts["username"]) ? parts["username"] : ""
    password::String = !isnothing(parts["password"]) ? parts["password"] : ""
    host::String = !isnothing(parts["host"]) ? replace(parts["host"], "www." => "") : ""
    subdomain::String, domain::String, tld::String = extract(host)
    port::String = !isnothing(parts["port"]) ? parts["port"] : ""
    path::String = !isnothing(parts["path"]) ? parts["path"] : ""
    directory::String = dirname(path)
    file::String = basename(path)
    file_name::String, file_extension::String = file_apart(file)
    query::String = !isnothing(parts["query"]) ? Decode(parts["query"]) : ""
    fragment::String = !isnothing(parts["fragment"]) ? parts["fragment"] : ""
    parameters::Vector{String} = _parameters(query)
    parameters_count::Int32 = length(parameters)
    parameters_value::Vector{String} = _parameters_value(query)
    parameters_value_count::Int32 = _parameters_value(query, count=true)
    all::Vector{AbstractString} = [scheme, username, password, host, subdomain, domain, tld, port, path, directory, file, query, fragment]

    _scheme::String = match(r"(^\w+:\/\/)?", url).match
    _username::String = match(r"^((\w+:\/\/)?(([\w\-]+)[\:\@]))?", url).match
    _password::String = match(r"^(((\w+):\/\/)?(([\w\-]+)\:?(.*?)\@)?)?", url).match
    _host::String = match(r"^((\w+):\/\/)?(([\w\-]+)\:?(.*?)\@)?([\w\-\.]+)", url).match
    _port::String = match(r"^((\w+):\/\/)?(([\w\-]+)\:?(.*?)\@)?([\w\-\.]+):?(\d+)?", url).match
    _path::String = match(r"^((\w+):\/\/)?(([\w\-]+)\:?(.*?)\@)?([\w\-\.]+):?(\d+)?([\/\w\-\.\%\,]+)?", url).match
    _query::String = match(r"^((\w+):\/\/)?(([\w\-]+)\:?(.*?)\@)?([\w\-\.]+):?(\d+)?([\/\w\-\.\%\,]+)?(\?[^\#]*)?", url).match
    _fragment::String = match(r"^((\w+):\/\/)?(([\w\-]+)\:?(.*?)\@)?([\w\-\.]+):?(\d+)?([\/\w\-\.\%\,]+)?(\?[^\#]*)?(\#.*)?", url).match

    return URL(scheme, username, password, host, subdomain, domain, tld, port, path, directory, file, file_name, file_extension, query, fragment, parameters, parameters_count, parameters_value, parameters_value_count, all, _scheme, _username, _password, _host, _port, _path, _query, _fragment)
end