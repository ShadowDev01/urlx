include("src/args.jl")
include("src/URL.jl")


function Format(urls::Vector{String}, format::String)
    Threads.@threads for u in urls
        try
            url = URL(u)
            println(replace(
                format,
                "%sc" => url.scheme,
                "%SC" => url._scheme,
                "%un" => url.username,
                "%UN" => url._username,
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

function keypairs(urls::Vector{String})
    Threads.@threads for u in urls
        try
            url = URL(u)
            p = url.parameters
            v = url.parameters_value
            diff_pv = abs(url.parameters_count - url.parameters_value_count)
            if url.parameters_count > url.parameters_value_count
                for i = 1:diff_pv
                    push!(v, "")
                end
            elseif url.parameters_value_count > url.parameters_count
                for i = 1:diff_pv
                    push!(p, "")
                end
            end
            for (param, value) in Iterators.zip(p, v)
                println(param, "=", value)
            end
        catch
            @error "can't process this url 😕 but I did the rest 😉" u
            continue
        end
    end
end

function main()
    arguments = ARGUMENTS()

    if !isnothing(arguments["url"])   # in order not to interfere with the switches -u / -U
        urls::Vector{String} = [arguments["url"]]
    elseif !isnothing(arguments["urls"])
        urls = readlines(arguments["urls"])
    elseif arguments["stdin"]
        urls = unique(readlines(stdin))
    end

    arguments["keypairs"] && keypairs(urls)
    !isempty(arguments["format"]) && Format(urls, arguments["format"])

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
    end

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

end

main()