using ArgParse

function ARGUMENTS()
    settings = ArgParseSettings(
        prog="BackupX",
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

        "--format"
        help = "Specify a custom format"
        arg_type = String

        # "-s"
        # help = "extract scheme of url"
        # action = :store_true

        # "-S"
        # help = "gives the URL from the beginning to the scheme"
        # action = :store_true

        # "-"
        # help = "gives the URL from the beginning to the scheme"
        # action = :store_true

        # "-S"
        # help = "gives the URL from the beginning to the scheme"
        # action = :store_true

        "-o", "--output"
        help = "save output in file"
    end
    parsed_args = parse_args(ARGS, settings)
    return parsed_args
end