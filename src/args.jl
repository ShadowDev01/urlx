using ArgParse

function ARGUMENTS()
    settings = ArgParseSettings(
        prog="urlx",
        description="""
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n
        **** extract url items ***
        \n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        """,
        epilog="""
            --format dirctives:\n
            %sc  =>  url scheme\n
            %SC  =>  from the beginning of url to the scheme\n
            %un  =>  url username\n
            %UN  =>  from the beginning of url to the username\n
            %ho  =>  url host\n
            %HO  =>  from the beginning of url to the host\n
            %sd  =>  url subdomain\n
            %do  =>  url domain\n
            %tl  =>  url tld\n
            %po  =>  url port\n
            %PO  =>  from the beginning of url to the port\n
            %pa  =>  url path\n
            %PA  =>  from the beginning of url to the path\n
            %di  =>  url directory\n
            %fi  =>  url file\n
            %fn  =>  url file_name\n
            %fe  =>  url file_extension\n
            %qu  =>  url query\n
            %QU  =>  from the beginning of url to the query\n
            %fr  =>  url fragment\n
            %FR  =>  from the beginning of url to the fragment\n
            %pr  =>  url parameters in space separated\n
            %PR  =>  url parameters in new line\n
            %va  =>  url values of parameters in space separated\n
            %VA  =>  url values of parameters in new line
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

        "-o", "--output"
        help = "save output in file"
    end
    parsed_args = parse_args(ARGS, settings)
    return parsed_args
end