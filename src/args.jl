using ArgParse

function ARGUMENTS()
    cyan::String = "\u001b[36m"
    yellow::String = "\u001b[33m"
    nc::String = "\033[0m"

    settings = ArgParseSettings(
        prog="urlx",
        description="""
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n
        **** extract url items ***
        \n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        """,
        epilog="""
            $(yellow)--format dirctives:$(nc)\n

            $(cyan)%sc$(nc)  =>  url scheme\n
            $(cyan)%SC$(nc)  =>  from the beginning of url to the scheme\n
            $(cyan)%un$(nc)  =>  url username\n
            $(cyan)%pw$(nc)  =>  url password\n
            $(cyan)%au$(nc)  =>  from the beginning of url to the authenticate\n
            $(cyan)%ho$(nc)  =>  url host\n
            $(cyan)%HO$(nc)  =>  from the beginning of url to the host\n
            $(cyan)%sd$(nc)  =>  url subdomain\n
            $(cyan)%do$(nc)  =>  url domain\n
            $(cyan)%tl$(nc)  =>  url tld\n
            $(cyan)%po$(nc)  =>  url port\n
            $(cyan)%PO$(nc)  =>  from the beginning of url to the port\n
            $(cyan)%pa$(nc)  =>  url path\n
            $(cyan)%PA$(nc)  =>  from the beginning of url to the path\n
            $(cyan)%di$(nc)  =>  url directory\n
            $(cyan)%fi$(nc)  =>  url file\n
            $(cyan)%fn$(nc)  =>  url file_name\n
            $(cyan)%fe$(nc)  =>  url file_extension\n
            $(cyan)%qu$(nc)  =>  url query\n
            $(cyan)%QU$(nc)  =>  from the beginning of url to the query\n
            $(cyan)%fr$(nc)  =>  url fragment\n
            $(cyan)%FR$(nc)  =>  from the beginning of url to the fragment\n
            $(cyan)%pr$(nc)  =>  url parameters in space separated\n
            $(cyan)%PR$(nc)  =>  url parameters in new line\n
            $(cyan)%va$(nc)  =>  url values of parameters in space separated\n
            $(cyan)%VA$(nc)  =>  url values of parameters in new line
        """
    )
    @add_arg_table settings begin
        "-u", "--url"
        help = "single url"

        "-U", "--urls"
        help = "multiple urls in file"

        "--stdin"
        help = "read url(s) from stdin"
        action = :store_true

        "--keys"
        help = "print all keys in query in unique"
        action = :store_true

        "--values"
        help = "print all values in query in unique"
        action = :store_true

        "--keypairs"
        help = "key=value pairs from the query string (one per line)"
        action = :store_true

        "--format"
        help = "Specify a custom format"
        arg_type = String
        default = ""

        "--json"
        help = "JSON encoded url/format objects"
        action = :store_true

        "--show"
        help = "show url objects in texts"
        action = :store_true

        "--decode"
        help = "simple url & html decode"
        action = :store_true

        "-c"
        help = "count and sort descending"
        action = :store_true

        "--cn"
        help = "count and sort descending with numbers"
        action = :store_true
        
        "-o", "--output"
        help = "save output in file"
    end
    parsed_args = parse_args(ARGS, settings)
    return parsed_args
end