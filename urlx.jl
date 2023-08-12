include("src/args.jl")
include("src/URL.jl")



function main()
    # arguments = ARGUMENTS()

    # if !isnothing(arguments["url"])   # in order not to interfere with the switches -u / -U
    #     urls::Vector{String} = [arguments["url"]]
    # elseif !isnothing(arguments["urls"])
    #     urls = readlines(arguments["urls"])
    # end
    # format::String = arguments["format"]

    format::String = "file = %fi\nfile_name = %fn\nfile_ext = %fe"
    urls = [
        "https://miti:1234@login.auth.my-admin.seeu.co.com:443/dir1/dir3/file.js?name=ali&id=63#noone@smsm",
        "https://login.auth.my-admin.seeu.co.com",
        "https://miti@login.auth.my-admin.seeu.co.com:443/dir1/dir3/admin.php?name=ali&id=63#noone",
        "www.login.auth.my-admin.seeu.co.com"
    ]

    Threads.@threads for u in urls
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
        ))
    end
end

main()