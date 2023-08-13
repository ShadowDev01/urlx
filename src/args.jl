using ArgParse

function ARGUMENTS()
    settings = ArgParseSettings(
        prog="urlx",
        description="""
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n
        **** extract url items ***
        \n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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

        "--host"
        help = "the hostname (e.g. sub.example.com)"
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